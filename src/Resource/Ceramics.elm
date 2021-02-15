module Resource.Ceramics exposing (..)

import Enum exposing (fromIntIterator)

import Resource.Types exposing (Packages, Resource, Weight(..))

type Ceramics
    = Ceramics40
    | Ceramics80
    | Ceramics160
    | Ceramics320
    | Ceramics480
    | Ceramics640
    | Ceramics800

ceramicsPackages : Packages Ceramics
ceramicsPackages =
    fromIntIterator
        (\r -> case r of
            Ceramics800 -> (40, Ceramics40)
            Ceramics40 -> (80, Ceramics80)
            Ceramics80 -> (160, Ceramics160)
            Ceramics160 -> (320, Ceramics320)
            Ceramics320 -> (480, Ceramics480)
            Ceramics480 -> (640, Ceramics640)
            Ceramics640 -> (800, Ceramics800)
        )
        Ceramics40

ceramicsResource : Resource Ceramics
ceramicsResource =
    { name = "Ceramics"
    , id = "ceramics"
    , packages = ceramicsPackages
    , minimum = Ceramics40
    , image = "ceramics-transparent.png"
    , weight = Weight 0.1
    }
