{-# OPTIONS_GHC -Wno-orphans #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module API.Types.UI.EstimateBP where

import Data.OpenApi (ToSchema)
import qualified Data.Text
import EulerHS.Prelude hiding (id)
import qualified Kernel.Types.Price
import Servant
import Tools.Auth

data EstimateBreakup = EstimateBreakup {price :: API.Types.UI.EstimateBP.EstimateBreakupPrice, title :: Data.Text.Text}
  deriving stock (Generic)
  deriving anyclass (ToJSON, FromJSON, ToSchema)

data EstimateBreakupPrice = EstimateBreakupPrice {value :: Kernel.Types.Price.PriceAPIEntity}
  deriving stock (Generic)
  deriving anyclass (ToJSON, FromJSON, ToSchema)

data EstimateDetailsRes = EstimateDetailsRes {estimateBreakup :: [API.Types.UI.EstimateBP.EstimateBreakup]}
  deriving stock (Generic)
  deriving anyclass (ToJSON, FromJSON, ToSchema)
