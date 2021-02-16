module Model.Resource exposing (..)

import Serialize as S exposing (Codec)
import Dict.Count as CountDict

import Resource.Types exposing (Resource)
import Resource.Types.PackageCounts as PackageCounts exposing (PackageCounts)
import Resource.Types.Excess as Excess exposing (Excess)

import Resource.Types.Given as ResourceGiven exposing (ResourceGiven)
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

init : Resource r -> ResourceModel r
init resource =
    { needed = ResourceNeededTotal.init
    , given = ResourceGiven.init
    , pkgs = PackageCounts.init resource
    , excess = Excess.init
    }

codec : Resource r -> Codec e (ResourceModel r)
codec resource =
    let cons n g p e = {needed = n, given = g, pkgs = p, excess = e}
    in
        S.customType
            (\e c -> e c.needed c.given c.pkgs c.excess)
            |> S.variant4
                    cons
                    ResourceNeededTotal.codec
                    ResourceGiven.codec
                    (PackageCounts.codec resource)
                    Excess.codec
            |> S.finishCustomType
