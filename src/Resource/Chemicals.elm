module Resource.Chemicals exposing (..)

import Enum exposing (fromIntIterator)
import Serialize as S exposing (Codec)

import Resource.Types exposing (Packages, Resource, Weight(..))

type Chemicals
    = Chemicals30
    | Chemicals60
    | Chemicals120
    | Chemicals240
    | Chemicals360
    | Chemicals480
    | Chemicals600

packages : Packages Chemicals
packages =
    fromIntIterator
        (\r -> case r of
            Chemicals600 -> (30, Chemicals30)
            Chemicals30 -> (60, Chemicals60)
            Chemicals60 -> (120, Chemicals120)
            Chemicals120 -> (240, Chemicals240)
            Chemicals240 -> (360, Chemicals360)
            Chemicals360 -> (480, Chemicals480)
            Chemicals480 -> (600, Chemicals600)
        )
        Chemicals30

resource : Resource Chemicals
resource =
    { name = "Chemicals"
    , id = "chemicals"
    , packages = packages
    , minimum = Chemicals30
    , image = "chemicals-transparent.png"
    , weight = Weight 0.1
    }

codec : Codec e Chemicals
codec =
    let f e30 e60 e120 e240 e360 e480 e600 v =
            case v of
                Chemicals30 -> e30
                Chemicals60 -> e60
                Chemicals120 -> e120
                Chemicals240 -> e240
                Chemicals360 -> e360
                Chemicals480 -> e480
                Chemicals600 -> e600
    in S.customType f
        |> S.variant0 Chemicals30
        |> S.variant0 Chemicals60
        |> S.variant0 Chemicals120
        |> S.variant0 Chemicals240
        |> S.variant0 Chemicals360
        |> S.variant0 Chemicals480
        |> S.variant0 Chemicals600
        |> S.finishCustomType
