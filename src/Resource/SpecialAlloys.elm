module Resource.SpecialAlloys exposing (..)

import Enum exposing (fromIntIterator)

import Resource.Types exposing (Packages, Resource, Weight(..))

type SpecialAlloys
    = SpecialAlloys60
    | SpecialAlloys120
    | SpecialAlloys240
    | SpecialAlloys480
    | SpecialAlloys720
    | SpecialAlloys960
    | SpecialAlloys1200

specialAlloysPackages : Packages SpecialAlloys
specialAlloysPackages =
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

specialAlloysResource : Resource SpecialAlloys
specialAlloysResource =
    { name = "Special alloys"
    , id = "specialAlloys"
    , packages = specialAlloysPackages
    , minimum = SpecialAlloys60
    , image = "special-alloys-transparent.png"
    , weight = Weight 0.1
    }
