module Resource exposing
    ( printPackage
    , printPackageCounts
    , printExcess
    , packagesNeeded
    )

import Tuple exposing (first, second)

import Enum exposing (Enum, fromIterator)
import Dict.Count as Dict

import Resource.Ceramics exposing (Ceramics, ceramicsResource)
import Resource.Metal exposing (Metal, metalResource)
import Resource.Types exposing (..)

type ResourceType
    = Ceramics
    | Metal

resourceEnum : Enum ResourceType
resourceEnum =
    fromIterator
        (\r -> case r of
            Metal -> (ceramicsResource.name, Ceramics)
            Ceramics -> (metalResource.name, Metal)
        )
        Ceramics

printPackage : Resource r -> r -> String
printPackage resource package =
    resource.name ++ " " ++ String.fromInt (resource.packages.toInt package)

printPackageCounts : Resource r -> PackageCounts r -> String
printPackageCounts resource dict =
    let
        packages = sortByValueDesc resource <| Dict.toList dict
        mkString (pkg,count) =
            printPackage resource pkg ++ " × " ++ String.fromInt count
    in
        Debug.toString <| List.map mkString packages

printExcess : Resource r -> Excess -> String
printExcess resource excess =
    resource.name ++ " wasted: " ++ String.fromInt excess
        
packagesNeeded
    : Resource r -> ResourceGiven -> ResourceNeeded -> (PackageCounts r, Excess)
packagesNeeded resource given0 needed0 =
    let
        counts0 = Dict.empty resource.packages.toInt
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
                        newCounts = Dict.add pkg toAdd counts
                    in loop newCounts newRem -- Continue recursion            
                Nothing ->
                    if rem == 0
                        then (counts, rem)
                        else 
                            let
                                min = resource.minimum
                                minVal = resource.packages.toInt min
                                excess = minVal - rem
                                newCounts = Dict.add min 1 counts
                            in (newCounts, excess)
    in
        if given0 >= needed0
            then (counts0, 0)
            else loop counts0 rem0
    
packagesByValueDesc : Resource r -> List (r, Value)
packagesByValueDesc resource =
    List.map flip <| List.reverse <| List.sortBy first resource.packages.list

-- Given a list of (package, a) tuples, sort them in reverse order according to
-- each package's value.
sortByValueDesc : Resource r -> List (r, a) -> List (r, a)
sortByValueDesc resource list =
    List.sortBy (resource.packages.toInt << first) list    
    
find : (a -> Bool) -> List a -> Maybe a
find pred list = List.head <| List.filter pred list

flip : (a,b) -> (b,a)
flip (a,b) = (b,a)
