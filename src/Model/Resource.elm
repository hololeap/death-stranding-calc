module Model.Resource exposing (..)

import Dict.Count as CountDict

import Resource.Types exposing
    ( PackageCounts
    , Excess(..)
    , Resource
    , initPackageCounts)

import Resource.Types.Given
    as ResourceGiven
    exposing (ResourceGiven)
import Resource.Types.NeededTotal
    as ResourceNeededTotal
    exposing (ResourceNeededTotal)

-- The current information state about a given resource in a given structure
type alias ResourceModel r =
    { needed : ResourceNeededTotal
    , given : ResourceGiven
    , pkgs : PackageCounts r
    , excess : Excess
    }

initResourceModel : Resource r -> ResourceModel r
initResourceModel resource =
    { needed = ResourceNeededTotal.init
    , given = ResourceGiven.init
    , pkgs = initPackageCounts resource
    , excess = Excess 0
    }
