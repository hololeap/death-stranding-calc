module Resource.Types exposing
    ( Value
    , ResourceName
    , Packages
    , Resource
    , ResourceNeeded(..)
    , getResourceNeeded
    )

import Enum exposing (EnumInt)
import Resource.Types.Weight exposing (Weight)

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
    , image : String
    , weight : Weight r
    }

-- Amount of resource needed to finish structure
type ResourceNeeded = ResourceNeeded Int

getResourceNeeded : ResourceNeeded -> Int
getResourceNeeded (ResourceNeeded i) = i
