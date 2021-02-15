module Resource.MVC.Model exposing (..)

import Dict.Count as CountDict

import Resource.Types exposing
    ( ResourceNeededTotal(..)
    , ResourceGiven(..)
    , PackageCounts
    , Excess(..)
    , Resource
    , initPackageCounts)

-- The current information state about a given resource in a given structure
type alias ResourceModel r =
    { needed : ResourceNeededTotal
    , given : ResourceGiven
    , pkgs : PackageCounts r
    , excess : Excess
    }

initResourceModel : Resource r -> ResourceModel r
initResourceModel resource =
    { needed = ResourceNeededTotal 0
    , given = ResourceGiven 0
    , pkgs = initPackageCounts resource
    , excess = Excess 0
    }
