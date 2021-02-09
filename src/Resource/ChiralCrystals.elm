module Resource.ChiralCrystals exposing (..)

import Enum exposing (fromIntIterator)

import Resource.Types exposing (Packages, Resource)

type ChiralCrystals = ChiralCrystals

chiralCrystalsPackages : Packages ChiralCrystals
chiralCrystalsPackages =
    fromIntIterator
        (\r -> case r of
            ChiralCrystals -> (1, ChiralCrystals)
        )
        ChiralCrystals
        
chiralCrystalsResource : Resource ChiralCrystals
chiralCrystalsResource =
    { name = "Chiral crystals"
    , id = "chiralCrystals"
    , packages = chiralCrystalsPackages
    , minimum = ChiralCrystals
    }
