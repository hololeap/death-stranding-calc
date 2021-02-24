module Model.Input.Resource exposing
    ( ResourceInput(..)
    , needed
    , given
    , init
    , cons
    , codec
    )

import Serialize as S exposing (Codec)
import Accessors exposing (Relation, makeOneToOne, get)

import Resource.Types.Given as ResourceGiven exposing (ResourceGiven)
import Resource.Types.NeededTotal
    as ResourceNeededTotal
    exposing (ResourceNeededTotal)

type ResourceInput r =
    ResourceInput
        { needed : ResourceNeededTotal
        , given : ResourceGiven
        }

needed : Relation ResourceNeededTotal reachable wrap
    -> Relation (ResourceInput r) reachable wrap
needed =
    makeOneToOne
        (\(ResourceInput rec) -> rec.needed)
        ( \change (ResourceInput rec) ->
            ResourceInput {rec | needed = change rec.needed}
        )

given : Relation ResourceGiven reachable wrap
    -> Relation (ResourceInput r) reachable wrap
given =
    makeOneToOne
        (\(ResourceInput rec) -> rec.given)
        ( \change (ResourceInput rec) ->
            ResourceInput {rec | given = change rec.given}
        )

init : ResourceInput r
init =
    ResourceInput <|
        { needed = ResourceNeededTotal.init
        , given = ResourceGiven.init
        }

cons : ResourceNeededTotal -> ResourceGiven -> ResourceInput r
cons n g = ResourceInput { needed = n, given = g }

codec : Codec e (ResourceInput r)
codec =
    S.customType
        (\e r -> e (get needed r) (get given r))
        |> S.variant2
                cons
                ResourceNeededTotal.codec
                ResourceGiven.codec
        |> S.finishCustomType
