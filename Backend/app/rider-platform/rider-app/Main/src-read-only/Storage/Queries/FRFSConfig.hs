{-# OPTIONS_GHC -Wno-dodgy-exports #-}
{-# OPTIONS_GHC -Wno-orphans #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module Storage.Queries.FRFSConfig where

import qualified Domain.Types.FRFSConfig
import qualified Domain.Types.MerchantOperatingCity
import Kernel.Beam.Functions
import Kernel.External.Encryption
import Kernel.Prelude hiding (sequence)
import Kernel.Types.Error
import qualified Kernel.Types.Id
import Kernel.Utils.Common (CacheFlow, EsqDBFlow, MonadFlow, fromMaybeM, getCurrentTime)
import qualified Sequelize as Se
import qualified Storage.Beam.FRFSConfig as Beam

create :: (EsqDBFlow m r, MonadFlow m, CacheFlow m r) => (Domain.Types.FRFSConfig.FRFSConfig -> m ())
create = createWithKV

createMany :: (EsqDBFlow m r, MonadFlow m, CacheFlow m r) => ([Domain.Types.FRFSConfig.FRFSConfig] -> m ())
createMany = traverse_ create

findByMerchantOperatingCityId ::
  (EsqDBFlow m r, MonadFlow m, CacheFlow m r) =>
  (Kernel.Types.Id.Id Domain.Types.MerchantOperatingCity.MerchantOperatingCity -> m (Maybe Domain.Types.FRFSConfig.FRFSConfig))
findByMerchantOperatingCityId merchantOperatingCityId = do findOneWithKV [Se.Is Beam.merchantOperatingCityId $ Se.Eq (Kernel.Types.Id.getId merchantOperatingCityId)]

findByPrimaryKey :: (EsqDBFlow m r, MonadFlow m, CacheFlow m r) => (Kernel.Types.Id.Id Domain.Types.MerchantOperatingCity.MerchantOperatingCity -> m (Maybe Domain.Types.FRFSConfig.FRFSConfig))
findByPrimaryKey merchantOperatingCityId = do findOneWithKV [Se.And [Se.Is Beam.merchantOperatingCityId $ Se.Eq (Kernel.Types.Id.getId merchantOperatingCityId)]]

updateByPrimaryKey :: (EsqDBFlow m r, MonadFlow m, CacheFlow m r) => (Domain.Types.FRFSConfig.FRFSConfig -> m ())
updateByPrimaryKey (Domain.Types.FRFSConfig.FRFSConfig {..}) = do
  _now <- getCurrentTime
  updateWithKV
    [ Se.Set Beam.bookingEndTime bookingEndTime,
      Se.Set Beam.bookingStartTime bookingStartTime,
      Se.Set Beam.cancellationReasonId cancellationReasonId,
      Se.Set Beam.customDates customDates,
      Se.Set Beam.customEndTime customEndTime,
      Se.Set Beam.discount discount,
      Se.Set Beam.freeTicketInterval freeTicketInterval,
      Se.Set Beam.isEventOngoing isEventOngoing,
      Se.Set Beam.maxFreeTicketCashback maxFreeTicketCashback,
      Se.Set Beam.merchantId (Kernel.Types.Id.getId merchantId),
      Se.Set Beam.metroStationTtl metroStationTtl,
      Se.Set Beam.oneWayTicketLimit oneWayTicketLimit,
      Se.Set Beam.roundTripTicketLimit roundTripTicketLimit,
      Se.Set Beam.createdAt createdAt,
      Se.Set Beam.updatedAt _now
    ]
    [Se.And [Se.Is Beam.merchantOperatingCityId $ Se.Eq (Kernel.Types.Id.getId merchantOperatingCityId)]]

instance FromTType' Beam.FRFSConfig Domain.Types.FRFSConfig.FRFSConfig where
  fromTType' (Beam.FRFSConfigT {..}) = do
    pure $
      Just
        Domain.Types.FRFSConfig.FRFSConfig
          { bookingEndTime = bookingEndTime,
            bookingStartTime = bookingStartTime,
            cancellationReasonId = cancellationReasonId,
            customDates = customDates,
            customEndTime = customEndTime,
            discount = discount,
            freeTicketInterval = freeTicketInterval,
            isEventOngoing = isEventOngoing,
            maxFreeTicketCashback = maxFreeTicketCashback,
            merchantId = Kernel.Types.Id.Id merchantId,
            merchantOperatingCityId = Kernel.Types.Id.Id merchantOperatingCityId,
            metroStationTtl = metroStationTtl,
            oneWayTicketLimit = oneWayTicketLimit,
            roundTripTicketLimit = roundTripTicketLimit,
            createdAt = createdAt,
            updatedAt = updatedAt
          }

instance ToTType' Beam.FRFSConfig Domain.Types.FRFSConfig.FRFSConfig where
  toTType' (Domain.Types.FRFSConfig.FRFSConfig {..}) = do
    Beam.FRFSConfigT
      { Beam.bookingEndTime = bookingEndTime,
        Beam.bookingStartTime = bookingStartTime,
        Beam.cancellationReasonId = cancellationReasonId,
        Beam.customDates = customDates,
        Beam.customEndTime = customEndTime,
        Beam.discount = discount,
        Beam.freeTicketInterval = freeTicketInterval,
        Beam.isEventOngoing = isEventOngoing,
        Beam.maxFreeTicketCashback = maxFreeTicketCashback,
        Beam.merchantId = Kernel.Types.Id.getId merchantId,
        Beam.merchantOperatingCityId = Kernel.Types.Id.getId merchantOperatingCityId,
        Beam.metroStationTtl = metroStationTtl,
        Beam.oneWayTicketLimit = oneWayTicketLimit,
        Beam.roundTripTicketLimit = roundTripTicketLimit,
        Beam.createdAt = createdAt,
        Beam.updatedAt = updatedAt
      }
