module Resource.Types exposing
    ( Value
    , ResourceName
    , Packages
    , Weight(..)
    , getWeight
    , Resource
    , ResourceGiven(..)
    , toResourceGiven
    , fromResourceGiven
    , showResourceGiven
    , readResourceGiven
    , ResourceNeededTotal(..)
    , toResourceNeededTotal
    , fromResourceNeededTotal
    , showResourceNeededTotal
    , readResourceNeededTotal
    , ResourceNeeded(..)
    , getResourceNeeded
--    , showResourceNeeded
    , Excess(..)
    , getExcess
    , showExcess
    , PackageCounts
    , initPackageCounts
    )

import Dict.Count as CountDict exposing (CountDict)
import Enum exposing (EnumInt)

import Types.MaybeInt as MaybeInt exposing (MaybeInt)

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
type ResourceGiven = ResourceGiven MaybeInt

toResourceGiven : Int -> ResourceGiven
toResourceGiven = ResourceGiven << MaybeInt.fromInt

fromResourceGiven : ResourceGiven -> Int
fromResourceGiven (ResourceGiven mi) = MaybeInt.toInt mi

showResourceGiven : ResourceGiven -> String
showResourceGiven (ResourceGiven mi) = MaybeInt.show mi

readResourceGiven : String -> ResourceGiven
readResourceGiven = ResourceGiven << MaybeInt.read

-- Total amount of a resource needed
type ResourceNeededTotal = ResourceNeededTotal MaybeInt

toResourceNeededTotal : Int -> ResourceNeededTotal
toResourceNeededTotal = ResourceNeededTotal << MaybeInt.fromInt

fromResourceNeededTotal : ResourceNeededTotal -> Int
fromResourceNeededTotal (ResourceNeededTotal mi) = MaybeInt.toInt mi

showResourceNeededTotal : ResourceNeededTotal -> String
showResourceNeededTotal (ResourceNeededTotal mi) = MaybeInt.show mi

readResourceNeededTotal : String -> ResourceNeededTotal
readResourceNeededTotal = ResourceNeededTotal << MaybeInt.read

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
