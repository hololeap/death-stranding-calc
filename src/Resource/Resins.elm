module Resource.Resins exposing (..)

import Enum exposing (fromIntIterator)
import Serialize as S exposing (Codec)

import Resource.Types exposing (Packages, Resource, Weight(..))

type Resins
    = Resins40
    | Resins80
    | Resins160
    | Resins320
    | Resins480
    | Resins640
    | Resins800

packages : Packages Resins
packages =
    fromIntIterator
        (\r -> case r of
            Resins800 -> (40, Resins40)
            Resins40 -> (80, Resins80)
            Resins80 -> (160, Resins160)
            Resins160 -> (320, Resins320)
            Resins320 -> (480, Resins480)
            Resins480 -> (640, Resins640)
            Resins640 -> (800, Resins800)
        )
        Resins40

resource : Resource Resins
resource =
    { name = "Resins"
    , id = "resins"
    , packages = packages
    , minimum = Resins40
    , image = "resins-transparent.png"
    , weight = Weight 0.1
    }

codec : Codec e Resins
codec =
    let f e40 e80 e160 e320 e480 e640 e800 v =
            case v of
                Resins40 -> e40
                Resins80 -> e80
                Resins160 -> e160
                Resins320 -> e320
                Resins480 -> e480
                Resins640 -> e640
                Resins800 -> e800
    in S.customType f
        |> S.variant0 Resins40
        |> S.variant0 Resins80
        |> S.variant0 Resins160
        |> S.variant0 Resins320
        |> S.variant0 Resins480
        |> S.variant0 Resins640
        |> S.variant0 Resins800
        |> S.finishCustomType
