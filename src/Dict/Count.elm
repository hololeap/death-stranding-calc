module Dict.Count exposing (..)

import Dict.Any as Dict exposing (AnyDict)

type alias CountDict comparable k = AnyDict comparable k Int

-- Add an element 'k' to the 'CountDict', 'n' number of times
add : k -> Int -> CountDict comparable k -> CountDict comparable k
add k n dict = 
    let addN m = Just <| Maybe.withDefault n <| Maybe.map (\i -> i + n) m
    in Dict.update k addN dict

-- Combine two dicts, adding up any collisions
union
    :  CountDict comparable k
    -> CountDict comparable k
    -> CountDict comparable k
union dict1 dict2 =
    let addTuple (k,v) dict = add k v dict
    in List.foldl addTuple dict1 (Dict.toList dict2)

unions
    :  (k -> comparable)
    -> List (CountDict comparable k)
    -> CountDict comparable k
unions conv list = List.foldl union (empty conv) list
    
empty : (k -> comparable) -> CountDict comparable k
empty conv = Dict.empty conv

toList : CountDict comparable k -> List (k, Int)
toList dict = Dict.toList dict
