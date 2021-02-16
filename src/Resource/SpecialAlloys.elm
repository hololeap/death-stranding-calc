module Resource.SpecialAlloys exposing (..)

import Enum exposing (fromIntIterator)
import Serialize as S exposing (Codec)

import Resource.Types exposing (Packages, Resource, Weight(..))

type SpecialAlloys
    = SpecialAlloys60
    | SpecialAlloys120
    | SpecialAlloys240
    | SpecialAlloys480
    | SpecialAlloys720
    | SpecialAlloys960
    | SpecialAlloys1200

packages : Packages SpecialAlloys
packages =
    fromIntIterator
        (\r -> case r of
            SpecialAlloys1200 -> (60, SpecialAlloys60)
            SpecialAlloys60 -> (120, SpecialAlloys120)
            SpecialAlloys120 -> (240, SpecialAlloys240)
            SpecialAlloys240 -> (480, SpecialAlloys480)
            SpecialAlloys480 -> (720, SpecialAlloys720)
            SpecialAlloys720 -> (960, SpecialAlloys960)
            SpecialAlloys960 -> (1200, SpecialAlloys1200)
        )
        SpecialAlloys60

resource : Resource SpecialAlloys
resource =
    { name = "Special alloys"
    , id = "specialAlloys"
    , packages = packages
    , minimum = SpecialAlloys60
    , image = "special-alloys-transparent.png"
    , weight = Weight 0.1
    }

codec : Codec e SpecialAlloys
codec =
    let f e60 e120 e240 e480 e720 e960 e1200 v =
            case v of
                SpecialAlloys60 -> e60
                SpecialAlloys120 -> e120
                SpecialAlloys240 -> e240
                SpecialAlloys480 -> e480
                SpecialAlloys720 -> e720
                SpecialAlloys960 -> e960
                SpecialAlloys1200 -> e1200
    in S.customType f
        |> S.variant0 SpecialAlloys60
        |> S.variant0 SpecialAlloys120
        |> S.variant0 SpecialAlloys240
        |> S.variant0 SpecialAlloys480
        |> S.variant0 SpecialAlloys720
        |> S.variant0 SpecialAlloys960
        |> S.variant0 SpecialAlloys1200
        |> S.finishCustomType
