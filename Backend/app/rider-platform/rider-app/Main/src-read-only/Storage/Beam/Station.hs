{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module Storage.Beam.Station where

import qualified Database.Beam as B
import Domain.Types.Common ()
import qualified Domain.Types.Station
import Kernel.External.Encryption
import Kernel.Prelude hiding (sequence)
import qualified Kernel.Prelude
import Tools.Beam.UtilsTH

data StationT f = StationT
  { address :: B.C f (Kernel.Prelude.Maybe Kernel.Prelude.Text),
    code :: B.C f Kernel.Prelude.Text,
    id :: B.C f Kernel.Prelude.Text,
    lat :: B.C f (Kernel.Prelude.Maybe Kernel.Prelude.Double),
    lon :: B.C f (Kernel.Prelude.Maybe Kernel.Prelude.Double),
    merchantId :: B.C f Kernel.Prelude.Text,
    merchantOperatingCityId :: B.C f Kernel.Prelude.Text,
    name :: B.C f Kernel.Prelude.Text,
    vehicleType :: B.C f Domain.Types.Station.FRFSVehicleType,
    createdAt :: B.C f Kernel.Prelude.UTCTime,
    updatedAt :: B.C f Kernel.Prelude.UTCTime
  }
  deriving (Generic, B.Beamable)

instance B.Table StationT where
  data PrimaryKey StationT f = StationId (B.C f Kernel.Prelude.Text) deriving (Generic, B.Beamable)
  primaryKey = StationId . id

type Station = StationT Identity

$(enableKVPG ''StationT ['id] [['code]])

$(mkTableInstances ''StationT "station")
