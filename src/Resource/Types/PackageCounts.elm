module Resource.Types.PackageCounts exposing (..)

import Serialize as S exposing (Codec)
import Dict.Count as CountDict exposing (CountDict)

import Resource.Types exposing (Resource, Value)

-- A minimum count of packages needed finish a structure, optimized toward
-- larger packages.
type alias PackageCounts r = CountDict Value r

init : Resource r -> PackageCounts r
init resource = CountDict.empty resource.packages.toInt

combine : PackageCounts r -> PackageCounts r -> PackageCounts r
combine = CountDict.union

combineMany : Resource r -> List (PackageCounts r) -> PackageCounts r
combineMany resource = CountDict.unions resource.packages.toInt

codec : Resource r -> Codec e (PackageCounts r)
codec resource =
    CountDict.codec
        resource.packages.toInt
        resource.packages.fromInt
        S.int
