module Resource exposing
    ( PackageCountsAll
    , initPackageCountsAll
    , printPackage
    , resourceTotal
    , resourceWeight
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

resourceWeight : Resource r -> PackageCounts r -> Weight
resourceWeight resource dict =
    Weight <| toFloat (resourceTotal resource dict) * getWeight resource.weight

printResourceTotal : Resource r -> PackageCounts r -> String
printResourceTotal resource dict =
    resource.name ++ ": " ++ String.fromInt (resourceTotal resource dict)



packagesNeeded
    :  Resource r
    -> ResourceGiven
    -> ResourceNeededTotal
    -> (PackageCounts r, Excess)
packagesNeeded resource given neededTotal =
    let
        counts0 = initPackageCounts resource
        needed0 = ResourceNeeded
            (getResourceNeededTotal neededTotal - getResourceGiven given)
        pkgList = packagesByValueDesc resource

        maxPkg needed = find
            ((\i -> i <= getResourceNeeded needed) << second)
            pkgList
        addN n m =
            Just <| Maybe.withDefault n <| Maybe.map (\old -> (old + n)) m

        minValue = resource.packages.toInt resource.minimum

        -- For best results, we round modifiedRem up to the next whole multiple
        -- of the smallest package value.
        roundUpNeeded =
            if modBy minValue (getResourceNeeded needed0) == 0
                then needed0
                else ResourceNeeded <|
                    minValue * (getResourceNeeded needed0 // minValue + 1)

        loop : PackageCounts r -> ResourceNeeded -> PackageCounts r
        loop counts needed =
            case maxPkg needed of
                Just (pkg, value) ->
                    let
                        toAdd = getResourceNeeded needed // value
                        newNeeded = ResourceNeeded
                            (modBy value (getResourceNeeded needed))
                        newCounts = CountDict.add pkg toAdd counts
                    in loop newCounts newNeeded -- Continue recursion
                Nothing -> counts
    in
        if getResourceGiven given >= getResourceNeededTotal neededTotal
            then (counts0, Excess 0)
            else
                ( loop counts0 roundUpNeeded
                , Excess
                    ( getResourceNeeded roundUpNeeded
                    - getResourceNeeded needed0
                    )
                )

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
