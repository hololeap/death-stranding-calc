module Main.Model exposing
    ( ResourceCounts
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

type alias ResourceCounts r =
    { pkgs : PackageCounts r
    , excess : Excess
    }

initResourceCounts : Resource r -> ResourceCounts r
initResourceCounts resource =
    { pkgs = CountDict.empty resource.packages.toInt
    , excess = 0
    }
    
type alias TotalCounts =
    { ceramics : ResourceCounts Ceramics
    , metal : ResourceCounts Metal
    }

initTotalCounts : TotalCounts
initTotalCounts =
    { ceramics = initResourceCounts ceramicsResource
    , metal = initResourceCounts metalResource
    }

type alias Model = 
    { structDict : AutoIncDict Structure
    , totalCounts : TotalCounts
    }

init : Model
init = 
    let
        dict = AutoIncDict.insert initStructure
            <| AutoIncDict.insert initStructure
            <| AutoIncDict.empty "Structure"
    in 
        { structDict = dict
        , totalCounts = initTotalCounts
        }
