module Structure.Model exposing
    ( ResourceModel
    , Structure
    , initStructure
    )
    
import Dict.Count as CountDict

import Resource.Ceramics exposing (..)
import Resource.Metal exposing (..)
import Resource.Types exposing (..)

type alias ResourceModel r =
    { needed : ResourceNeeded
    , given : ResourceGiven
    , pkgs : PackageCounts r
    , excess : Excess
    }

type alias Structure =
    { ceramics : ResourceModel Ceramics
    , metal : ResourceModel Metal
    }


initStructure : Structure
initStructure =
    { ceramics = initResource ceramicsResource
    , metal = initResource metalResource
    }
    
initResource : Resource r -> ResourceModel r
initResource resource =
    { needed = 0
    , given = 0
    , pkgs = CountDict.empty resource.packages.toInt
    , excess = 0
    }
