module Resource.MVC.Model exposing (..) 

import Dict.Count as CountDict

import Resource.Types exposing
    ( ResourceNeeded
    , ResourceGiven
    , PackageCounts
    , Excess
    , Resource
    , initPackageCounts)

-- The current information state about a given resource in a given structure
type alias ResourceModel r =
    { needed : ResourceNeeded
    , given : ResourceGiven
    , pkgs : PackageCounts r
    , excess : Excess
    }

initResourceModel : Resource r -> ResourceModel r
initResourceModel resource =
    { needed = 0
    , given = 0
    , pkgs = initPackageCounts resource
    , excess = 0
    }
