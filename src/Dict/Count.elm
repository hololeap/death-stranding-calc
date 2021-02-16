module Dict.Count exposing (..)

import Dict as Dict exposing (Dict)
import Dict.Any as AnyDict exposing (AnyDict)
import Serialize as S exposing (Codec)

type alias CountDict comparable k = AnyDict comparable k Int

-- Add an element 'k' to the 'CountDict', 'n' number of times
add : k -> Int -> CountDict comparable k -> CountDict comparable k
add k n dict =
    let addN = Just << Maybe.withDefault n << Maybe.map ((+) n)
    in AnyDict.update k addN dict

-- Combine two dicts, adding up any collisions
union
    :  CountDict comparable k
    -> CountDict comparable k
    -> CountDict comparable k
union dict1 dict2 =
    let addTuple (k,v) dict = add k v dict
    in List.foldl addTuple dict1 (AnyDict.toList dict2)

unions
    :  (k -> comparable)
    -> List (CountDict comparable k)
    -> CountDict comparable k
unions = List.foldl union << empty

empty : (k -> comparable) -> CountDict comparable k
empty = AnyDict.empty

toList : CountDict comparable k -> List (k, Int)
toList = AnyDict.toList

keys : CountDict comparable k -> List k
keys = AnyDict.keys

isEmpty : CountDict comparable k -> Bool
isEmpty = AnyDict.isEmpty

toDict : CountDict comparable k -> Dict comparable Int
toDict = AnyDict.toDict

fromDict
    :  (k -> comparable)
    -> (comparable -> Maybe k)
    -> Dict comparable Int
    -> CountDict comparable k
fromDict toComp fromComp =
    let addElem (c,i) d =
            Maybe.withDefault d
            <| Maybe.map (\k -> add k i d)
            <| fromComp c
    in List.foldl addElem (empty toComp) << Dict.toList

codec
    :  (k -> comparable)
    -> (comparable -> Maybe k)
    -> Codec e comparable
    -> Codec e (CountDict comparable k)
codec toComp fromComp compCodec =
    S.customType
        (\e -> e << toDict)
        |> S.variant1 (fromDict toComp fromComp) (S.dict compCodec S.int)
        |> S.finishCustomType
