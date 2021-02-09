module Resource.Types exposing
    ( Value
    , ResourceName
    , Packages
    , Resource
    , ResourceGiven
    , ResourceNeeded
    , Excess
    , PackageCounts
    , initPackageCounts
    )

import Dict.Count as CountDict exposing (CountDict)
import Enum exposing (EnumInt)

type alias Value = Int -- How much of a resource a package contains
type alias ResourceName = String -- Name of a resource

-- An enumeration from all packages to their individual values
type alias Packages r = EnumInt r

-- A Resource is actually just an underlying sum type of packages and different
-- values associated with them
type alias Resource r =
    { name : String -- Pretty name
    , id : String -- For use with HTML classes, ids, etc. Lowercase
    , packages : Packages r
    , minimum : r
    }

type alias ResourceGiven = Int   -- Amount of a resource present in a structure
type alias ResourceNeeded = Int  -- Total amount of a resource needed
type alias Excess = Int          -- Amount of a resource that will be wasted

-- A minimum count of packages needed finish a structure, optimized toward
-- larger packages.
type alias PackageCounts r = CountDict Value r

initPackageCounts : Resource r -> PackageCounts r
initPackageCounts resource = CountDict.empty resource.packages.toInt
