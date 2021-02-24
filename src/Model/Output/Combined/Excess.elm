module Model.Output.Combined.Excess exposing
    ( CombinedExcess
    , excess
    , int
    , toString
    , generate
    )

import Accessors as A exposing (Relation, makeOneToOne)
import Resource.Types.Excess as Excess exposing (Excess)

type CombinedExcess r = CombinedExcess (Excess r)

excess : Relation (Excess r) reachable wrap
    -> Relation (CombinedExcess r) reachable wrap
excess =
    makeOneToOne
        (\(CombinedExcess e) -> e)
        (\change (CombinedExcess e) -> CombinedExcess (change e))

int : Relation Int reachable wrap
    -> Relation (CombinedExcess r) reachable wrap
int = excess << Excess.int

toString : CombinedExcess r -> String
toString = String.fromInt << A.get int

generate : List (Excess r) -> CombinedExcess r
generate = CombinedExcess << Excess.combineMany
