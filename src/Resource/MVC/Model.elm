module Resource.MVC.Model exposing (..)

import Dict.Count as CountDict

import Resource.Types exposing
    ( ResourceNeededTotal(..)
    , ResourceGiven(..)
    , PackageCounts
    , Excess(..)
    , Resource
    , initPackageCounts)

import Types.MaybeInt as MaybeInt

-- The current information state about a given resource in a given structure
type alias ResourceModel r =
    { needed : ResourceNeededTotal
    , given : ResourceGiven
    , pkgs : PackageCounts r
    , excess : Excess
    }

initResourceModel : Resource r -> ResourceModel r
initResourceModel resource =
    { needed = ResourceNeededTotal MaybeInt.init
    , given = ResourceGiven MaybeInt.init
    , pkgs = initPackageCounts resource
    , excess = Excess 0
    }
