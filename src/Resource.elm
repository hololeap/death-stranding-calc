module Resource exposing
    ( PackageCountsAll
    , initPackageCountsAll
    , printPackage
    , resourceTotal
    , printResourceTotal
    , packagesNeeded
    , packagesNeededByValueDesc
    )

import Tuple exposing (first, second)

import Enum exposing (Enum, fromIterator)
import Dict.Count as CountDict

import Resource.ChiralCrystals exposing (ChiralCrystals, chiralCrystalsResource)
import Resource.Resins exposing (Resins, resinsResource)
import Resource.Metal exposing (Metal, metalResource)
import Resource.Ceramics exposing (Ceramics, ceramicsResource)
import Resource.Chemicals exposing (Chemicals, chemicalsResource)
import Resource.SpecialAlloys exposing (SpecialAlloys, specialAlloysResource)
import Resource.Types exposing (..)

type alias PackageCountsAll =
    { chiralCrystals : PackageCounts ChiralCrystals
    , resins : PackageCounts Resins
    , metal : PackageCounts Metal
    , ceramics : PackageCounts Ceramics
    , chemicals : PackageCounts Chemicals
    , specialAlloys : PackageCounts SpecialAlloys
    }

initPackageCountsAll : PackageCountsAll
initPackageCountsAll =
    { chiralCrystals = initPackageCounts chiralCrystalsResource
    , resins = initPackageCounts resinsResource
    , metal = initPackageCounts metalResource
    , ceramics = initPackageCounts ceramicsResource
    , chemicals = initPackageCounts chemicalsResource
    , specialAlloys = initPackageCounts specialAlloysResource
    }

printPackage : Resource r -> r -> String
printPackage resource package =
    resource.name ++ " " ++ String.fromInt (resource.packages.toInt package)

resourceTotal : Resource r -> PackageCounts r -> Int
resourceTotal resource dict =
    let addValue (pkg, count) value =
            value + resource.packages.toInt pkg * count
    in List.foldl addValue 0 <| CountDict.toList dict
    
printResourceTotal : Resource r -> PackageCounts r -> String
printResourceTotal resource dict =
    resource.name ++ ": " ++ String.fromInt (resourceTotal resource dict)

packagesNeeded
    : Resource r -> ResourceGiven -> ResourceNeeded -> (PackageCounts r, Excess)
packagesNeeded resource given0 needed0 =
    let
        counts0 = CountDict.empty resource.packages.toInt
        rem0 = needed0 - given0
        pkgList = packagesByValueDesc resource

        maxPkg rem = find ((\i -> i <= rem) << second) pkgList
        addN n m =
            Just <| Maybe.withDefault n <| Maybe.map (\old -> (old + n)) m
        
        loop : PackageCounts r -> Excess -> (PackageCounts r, Excess)
        loop counts rem =
            case maxPkg rem of
                Just (pkg, value) ->
                    let
                        toAdd = rem // value
                        newRem = modBy value rem
                        newCounts = CountDict.add pkg toAdd counts
                    in loop newCounts newRem -- Continue recursion            
                Nothing ->
                    if rem == 0
                        then (counts, rem)
                        else 
                            let
                                min = resource.minimum
                                minVal = resource.packages.toInt min
                                excess = minVal - rem
                                newCounts = CountDict.add min 1 counts
                            in (newCounts, excess)
    in
        if given0 >= needed0
            then (counts0, 0)
            else loop counts0 rem0

packagesNeededByValueDesc : Resource r -> PackageCounts r -> List (r, Int)
packagesNeededByValueDesc resource =
    sortByValueDesc resource << CountDict.toList
            
packagesByValueDesc : Resource r -> List (r, Value)
packagesByValueDesc resource =
    List.map flip <| List.reverse <| List.sortBy first resource.packages.list

-- Given a list of (package, a) tuples, sort them in reverse order according to
-- each package's value.
sortByValueDesc : Resource r -> List (r, a) -> List (r, a)
sortByValueDesc resource list =
    List.reverse <| List.sortBy (resource.packages.toInt << first) list    
    
find : (a -> Bool) -> List a -> Maybe a
find pred list = List.head <| List.filter pred list

flip : (a,b) -> (b,a)
flip (a,b) = (b,a)
