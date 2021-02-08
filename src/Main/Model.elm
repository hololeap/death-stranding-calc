module Main.Model exposing
    ( CombinedCounts
    , TotalCounts
    , Model
    , init
    , initTotalCounts
    )

import Dict.AutoInc as AutoIncDict exposing (AutoIncDict)
import Dict.Count as CountDict exposing (CountDict)

import Resource.Ceramics exposing (..)
import Resource.Metal exposing (..)
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
    { ceramics : CombinedCounts Ceramics
    , metal : CombinedCounts Metal
    }

initTotalCounts : TotalCounts
initTotalCounts =
    { ceramics = initCombinedCounts ceramicsResource
    , metal = initCombinedCounts metalResource
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
