module Main.Model exposing
    ( CombinedCounts
    , TotalCounts
    , Model
    , init
    , initTotalCounts
    )

import Dict.AutoInc as AutoIncDict exposing (AutoIncDict)
import Dict.Count as CountDict exposing (CountDict)

import Resource.ChiralCrystals exposing (ChiralCrystals, chiralCrystalsResource)
import Resource.Resins exposing (Resins, resinsResource)
import Resource.Metal exposing (Metal, metalResource)
import Resource.Ceramics exposing (Ceramics, ceramicsResource)
import Resource.Chemicals exposing (Chemicals, chemicalsResource)
import Resource.SpecialAlloys exposing (SpecialAlloys, specialAlloysResource)
import Resource.Types exposing (..)

import Structure.Model exposing (Structure, initStructure)

type alias CombinedCounts r =
    { pkgs : PackageCounts r
    , excess : Excess
    }

initCombinedCounts : Resource r -> CombinedCounts r
initCombinedCounts resource =
    { pkgs = CountDict.empty resource.packages.toInt
    , excess = 0
    }
    
type alias TotalCounts =
    { chiralCrystals : CombinedCounts ChiralCrystals
    , resins : CombinedCounts Resins    
    , metal : CombinedCounts Metal
    , ceramics : CombinedCounts Ceramics
    , chemicals : CombinedCounts Chemicals
    , specialAlloys : CombinedCounts SpecialAlloys
    }

initTotalCounts : TotalCounts
initTotalCounts =
    { chiralCrystals = initCombinedCounts chiralCrystalsResource
    , resins = initCombinedCounts resinsResource
    , metal = initCombinedCounts metalResource
    , ceramics = initCombinedCounts ceramicsResource    
    , chemicals = initCombinedCounts chemicalsResource
    , specialAlloys = initCombinedCounts specialAlloysResource
    }

type alias Model = 
    { structDict : AutoIncDict Structure
    , totalCounts : TotalCounts
    }

init : Model
init =
    { structDict = AutoIncDict.singletonNeedingKeyInc "structure" initStructure
    , totalCounts = initTotalCounts
    }
