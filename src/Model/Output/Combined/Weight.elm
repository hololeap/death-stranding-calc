module Model.Output.Combined.Weight exposing
    ( CombinedWeight
    , weight
    , float
    , generate
    )

import Accessors exposing (Relation, makeOneToOne)
import Resource.Types.Weight as Weight exposing (Weight)

type CombinedWeight r = CombinedWeight (Weight r)

weight : Relation (Weight r) reachable wrap
    -> Relation (CombinedWeight r) reachable wrap
weight =
    makeOneToOne
        (\(CombinedWeight w) -> w)
        (\change (CombinedWeight w) -> CombinedWeight (change w))

float : Relation Float reachable wrap
    -> Relation (CombinedWeight r) reachable wrap
float = weight << Weight.float

generate : List (Weight r) -> CombinedWeight r
generate = CombinedWeight << Weight.combineMany
