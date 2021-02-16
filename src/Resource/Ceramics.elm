module Resource.Ceramics exposing (..)

import Enum exposing (fromIntIterator)
import Serialize as S exposing (Codec)

import Resource.Types exposing (Packages, Resource, Weight(..))

type Ceramics
    = Ceramics40
    | Ceramics80
    | Ceramics160
    | Ceramics320
    | Ceramics480
    | Ceramics640
    | Ceramics800

packages : Packages Ceramics
packages =
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

resource : Resource Ceramics
resource =
    { name = "Ceramics"
    , id = "ceramics"
    , packages = packages
    , minimum = Ceramics40
    , image = "ceramics-transparent.png"
    , weight = Weight 0.1
    }

codec : Codec e Ceramics
codec =
    let f e40 e80 e160 e320 e480 e640 e800 v =
            case v of
                Ceramics40 -> e40
                Ceramics80 -> e80
                Ceramics160 -> e160
                Ceramics320 -> e320
                Ceramics480 -> e480
                Ceramics640 -> e640
                Ceramics800 -> e800
    in S.customType f
        |> S.variant0 Ceramics40
        |> S.variant0 Ceramics80
        |> S.variant0 Ceramics160
        |> S.variant0 Ceramics320
        |> S.variant0 Ceramics480
        |> S.variant0 Ceramics640
        |> S.variant0 Ceramics800
        |> S.finishCustomType
