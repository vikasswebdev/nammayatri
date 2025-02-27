{-
 Copyright 2022-23, Juspay India Pvt Ltd

 This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License

 as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program

 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY

 or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details. You should have received a copy of

 the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
-}

module API.Beckn.FRFS.OnConfirm where

import qualified Beckn.ACL.FRFS.OnConfirm as ACL
import qualified BecknV2.FRFS.APIs as Spec
import qualified BecknV2.FRFS.Enums as Spec
import qualified BecknV2.FRFS.Types as Spec
import qualified BecknV2.FRFS.Utils as Utils
import qualified BecknV2.OnDemand.Enums as OnDemandEnums
import qualified Domain.Action.Beckn.FRFS.OnConfirm as DACFOC
import qualified Domain.Action.Beckn.FRFS.OnConfirm as DOnConfirm
import qualified Domain.Types.FRFSTicketBooking as DFRFSTicketBooking
import qualified Domain.Types.FRFSTicketBookingPayment as DFRFSTicketBookingPayment
import Environment
import Kernel.Prelude
import qualified Kernel.Storage.Hedis as Redis
import Kernel.Types.Error
import Kernel.Types.Id
import Kernel.Utils.Common
import Kernel.Utils.Servant.SignatureAuth
import Storage.Beam.SystemConfigs ()
import qualified Storage.CachedQueries.FRFSConfig as CQFRFSConfig
import qualified Storage.Queries.BecknConfig as QBC
import qualified Storage.Queries.FRFSTicketBokingPayment as QFRFSTicketBookingPayment
import qualified Storage.Queries.FRFSTicketBooking as QFRFSTicketBooking
import qualified Tools.Metrics as Metrics

type API = Spec.OnConfirmAPI

handler :: SignatureAuthResult -> FlowServer API
handler = onConfirm

onConfirm ::
  SignatureAuthResult ->
  Spec.OnConfirmReq ->
  FlowHandler Spec.AckResponse
onConfirm _ req = withFlowHandlerAPI $ do
  transaction_id <- req.onConfirmReqContext.contextTransactionId & fromMaybeM (InvalidRequest "TransactionId not found")
  bookingId <- req.onConfirmReqContext.contextMessageId & fromMaybeM (InvalidRequest "MessageId not found")
  ticketBooking <- QFRFSTicketBooking.findById (Id bookingId) >>= fromMaybeM (InvalidRequest "Invalid booking id")
  bapConfig <- QBC.findByMerchantIdDomainAndVehicle (Just ticketBooking.merchantId) (show Spec.FRFS) OnDemandEnums.METRO >>= fromMaybeM (InternalError "Beckn Config not found")
  logDebug $ "Received OnConfirm request" <> encodeToText req
  withTransactionIdLogTag' transaction_id $ do
    dOnConfirmReq <- ACL.buildOnConfirmReq req
    if isJust dOnConfirmReq
      then do
        let onConfirmReq = fromJust dOnConfirmReq
        (merchant, booking) <- DOnConfirm.validateRequest onConfirmReq
        Metrics.finishMetrics Metrics.CONFIRM_FRFS merchant.name transaction_id booking.merchantOperatingCityId.getId
        fork "onConfirm request processing" $
          Redis.whenWithLockRedis (onConfirmProcessingLockKey onConfirmReq.bppOrderId) 60 $
            DOnConfirm.onConfirm merchant booking onConfirmReq
      else do
        frfsConfig <-
          CQFRFSConfig.findByMerchantOperatingCityId ticketBooking.merchantOperatingCityId
            >>= fromMaybeM (InternalError $ "FRFS config not found for merchant operating city Id " <> show ticketBooking.merchantOperatingCityId)
        void $ QFRFSTicketBooking.updateStatusById DFRFSTicketBooking.FAILED (Id bookingId)
        void $ QFRFSTicketBookingPayment.updateStatusByTicketBookingId DFRFSTicketBookingPayment.REFUND_PENDING (Id bookingId)
        void $ DACFOC.callBPPCancel ticketBooking bapConfig frfsConfig Spec.CONFIRM_CANCEL ticketBooking.merchantId

  pure Utils.ack

onConfirmLockKey :: Text -> Text
onConfirmLockKey id = "FRFS:OnConfirm:bppOrderId-" <> id

onConfirmProcessingLockKey :: Text -> Text
onConfirmProcessingLockKey id = "FRFS:OnConfirm:Processing:bppOrderId-" <> id
