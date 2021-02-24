module Resource.ChiralCrystals exposing (..)

import Enum exposing (fromIntIterator)
import Serialize as S exposing (Codec)

import Resource.Types exposing (Packages, Resource)
import Resource.Types.Weight as Weight

type ChiralCrystals = ChiralCrystals

packages : Packages ChiralCrystals
packages =
    fromIntIterator
        (\r -> case r of
            ChiralCrystals -> (1, ChiralCrystals)
        )
        ChiralCrystals

resource : Resource ChiralCrystals
resource =
    { name = "Chiral crystals"
    , id = "chiralCrystals"
    , packages = packages
    , minimum = ChiralCrystals
    , image = "chiral-crystals-transparent.png"
    , weight = Weight.fromFloat 0
    }

codec : Codec e ChiralCrystals
codec =
    S.customType (\e ChiralCrystals -> e)
        |> S.variant0 ChiralCrystals
        |> S.finishCustomType
