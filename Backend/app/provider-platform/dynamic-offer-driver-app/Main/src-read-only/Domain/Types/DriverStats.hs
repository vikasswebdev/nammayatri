{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module Domain.Types.DriverStats where

import Data.Aeson
import qualified Domain.Types.Person
import Kernel.Prelude
import qualified Kernel.Types.Common
import qualified Kernel.Types.Id
import qualified Tools.Beam.UtilsTH

data DriverStats = DriverStats
  { bonusEarned :: Kernel.Types.Common.HighPrecMoney,
    coinCovertedToCashLeft :: Kernel.Types.Common.HighPrecMoney,
    currency :: Kernel.Types.Common.Currency,
    distanceUnit :: Kernel.Types.Common.DistanceUnit,
    driverId :: Kernel.Types.Id.Id Domain.Types.Person.Driver,
    earningsMissed :: Kernel.Types.Common.HighPrecMoney,
    favRiderCount :: Kernel.Prelude.Int,
    idleSince :: Kernel.Prelude.UTCTime,
    isValidRating :: Kernel.Prelude.Maybe Kernel.Prelude.Bool,
    lateNightTrips :: Kernel.Prelude.Int,
    rating :: Kernel.Prelude.Maybe Kernel.Types.Common.Centesimal,
    ridesCancelled :: Kernel.Prelude.Maybe Kernel.Prelude.Int,
    totalCoinsConvertedCash :: Kernel.Types.Common.HighPrecMoney,
    totalDistance :: Kernel.Types.Common.Meters,
    totalEarnings :: Kernel.Types.Common.HighPrecMoney,
    totalPayoutAmountPaid :: Kernel.Prelude.Maybe Kernel.Types.Common.HighPrecMoney,
    totalPayoutEarnings :: Kernel.Types.Common.HighPrecMoney,
    totalRatingScore :: Kernel.Prelude.Maybe Kernel.Prelude.Int,
    totalRatings :: Kernel.Prelude.Maybe Kernel.Prelude.Int,
    totalReferralCounts :: Kernel.Prelude.Int,
    totalRides :: Kernel.Prelude.Int,
    totalRidesAssigned :: Kernel.Prelude.Maybe Kernel.Prelude.Int,
    totalValidActivatedRides :: Kernel.Prelude.Int,
    updatedAt :: Kernel.Prelude.UTCTime
  }
  deriving (Generic, Show, ToJSON, FromJSON, ToSchema)
