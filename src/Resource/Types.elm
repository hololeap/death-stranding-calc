module Resource.Types exposing
    ( Value
    , ResourceName
    , Packages
    , Weight(..)
    , getWeight
    , Resource
    , ResourceGiven(..)
    , getResourceGiven
    , showResourceGiven
    , ResourceNeededTotal(..)
    , getResourceNeededTotal
    , showResourceNeededTotal    
    , ResourceNeeded(..)
    , getResourceNeeded
    , showResourceNeeded    
    , Excess(..)
    , getExcess
    , showExcess    
    , PackageCounts
    , initPackageCounts
    )

import Dict.Count as CountDict exposing (CountDict)
import Enum exposing (EnumInt)

type alias Value = Int -- How much of a resource a package contains
type alias ResourceName = String -- Name of a resource

-- An enumeration from all packages to their individual values
type alias Packages r = EnumInt r

type Weight = Weight Float

getWeight : Weight -> Float
getWeight (Weight f) = f

-- A Resource is actually just an underlying sum type of packages and different
-- values associated with them
type alias Resource r =
    { name : String -- Pretty name
    , id : String -- For use with HTML classes, ids, etc. Lowercase
    , packages : Packages r
    , minimum : r
    , image : String
    , weight : Weight
    }

-- Amount of a resource present in a structure
type ResourceGiven = ResourceGiven Int

getResourceGiven : ResourceGiven -> Int
getResourceGiven (ResourceGiven i) = i

showResourceGiven : ResourceGiven -> String
showResourceGiven = String.fromInt << getResourceGiven

-- Total amount of a resource needed
type ResourceNeededTotal = ResourceNeededTotal Int

getResourceNeededTotal : ResourceNeededTotal -> Int
getResourceNeededTotal (ResourceNeededTotal i) = i

showResourceNeededTotal : ResourceNeededTotal -> String
showResourceNeededTotal = String.fromInt << getResourceNeededTotal

-- Amount of resource needed to finish structure
type ResourceNeeded = ResourceNeeded Int

getResourceNeeded : ResourceNeeded -> Int
getResourceNeeded (ResourceNeeded i) = i

showResourceNeeded : ResourceNeeded -> String
showResourceNeeded = String.fromInt << getResourceNeeded

-- Amount of a resource that will be wasted
type Excess = Excess Int

getExcess : Excess -> Int
getExcess (Excess i) = i

showExcess : Excess -> String
showExcess = String.fromInt << getExcess

-- A minimum count of packages needed finish a structure, optimized toward
-- larger packages.
type alias PackageCounts r = CountDict Value r

initPackageCounts : Resource r -> PackageCounts r
initPackageCounts resource = CountDict.empty resource.packages.toInt
