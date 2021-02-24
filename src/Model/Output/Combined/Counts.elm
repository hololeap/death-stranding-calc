module Model.Output.Combined.Counts exposing
    ( CombinedCounts
    , packageCounts
    , generate
    )

import Accessors exposing (Relation, makeOneToOne)
import Resource.Types exposing (Resource)
import Resource.Types.PackageCounts as PackageCounts exposing (PackageCounts)

type CombinedCounts r = CombinedCounts (PackageCounts r)

packageCounts : Relation (PackageCounts r) reachable wrap
    -> Relation (CombinedCounts r) reachable wrap
packageCounts =
    makeOneToOne
        (\(CombinedCounts p) -> p)
        (\change (CombinedCounts p) -> CombinedCounts (change p))

generate : Resource r -> List (PackageCounts r) -> CombinedCounts r
generate resource =
    CombinedCounts << PackageCounts.combineMany resource
