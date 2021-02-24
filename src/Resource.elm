module Resource exposing
    ( printPackage
    , resourceTotal
    , resourceWeight
    , printResourceTotal
    , packagesNeeded
    , packagesNeededByValueDesc
    )

import Accessors exposing (get)
import Tuple exposing (first, second)

import Dict.Count as CountDict

import Resource.Types exposing 
    ( ResourceNeeded(..)
    , getResourceNeeded
    , Resource
    , Value
    )

import Resource.Types.Excess as Excess exposing (Excess)
import Resource.Types.Given as ResourceGiven exposing (ResourceGiven)
import Resource.Types.NeededTotal
    as ResourceNeededTotal
    exposing (ResourceNeededTotal)
import Resource.Types.PackageCounts as PackageCounts exposing (PackageCounts)
import Resource.Types.Weight as Weight exposing (Weight)

printPackage : Resource r -> r -> String
printPackage resource package =
    resource.name ++ " " ++ String.fromInt (resource.packages.toInt package)

resourceTotal : Resource r -> PackageCounts r -> Int
resourceTotal resource dict =
    let addValue (pkg, count) value =
            value + resource.packages.toInt pkg * count
    in List.foldl addValue 0 <| CountDict.toList dict

resourceWeight : Resource r -> PackageCounts r -> (Weight r)
resourceWeight resource dict =
    let
        weightFloat = get Weight.float resource.weight
        totalFloat = toFloat (resourceTotal resource dict)
    in Weight.fromFloat (weightFloat * totalFloat)

printResourceTotal : Resource r -> PackageCounts r -> String
printResourceTotal resource dict =
    resource.name ++ ": " ++ String.fromInt (resourceTotal resource dict)

packagesNeeded
    :  Resource r
    -> ResourceGiven
    -> ResourceNeededTotal
    -> (PackageCounts r, Excess r)
packagesNeeded resource given neededTotal =
    let
        counts0 = PackageCounts.init resource
        needed0 = ResourceNeeded
            (ResourceNeededTotal.toInt neededTotal - ResourceGiven.toInt given)
        pkgList = packagesByValueDesc resource

        maxPkg needed = find
            ((\i -> i <= getResourceNeeded needed) << second)
            pkgList

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
        if ResourceGiven.toInt given >= ResourceNeededTotal.toInt neededTotal
            then (counts0, Excess.init)
            else
                ( loop counts0 roundUpNeeded
                , Excess.fromInt
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
