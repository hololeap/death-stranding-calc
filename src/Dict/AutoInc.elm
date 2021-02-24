module Dict.AutoInc exposing
    ( Key
    , Prefix
    , AutoIncDict
    , empty
    , singleton
    , singletonWithKey
    , singletonNeedingInc
    , insert
    , insertWithKey
    , insertNeedingInc
    , adjust
    , update
    , map
    , toList
    , values
    , get
    , remove
    , codec
    , onOne
    , onEach
    )

import Dict exposing (Dict)
import Tuple exposing (first)
import Serialize as S exposing (Codec)
import Accessors exposing (Relation, makeOneToOne, makeOneToN)

type alias Key = String
type alias Prefix = String

type alias AutoIncDict v =
    { lastInc : Int
    , dict : Dict Key v
    , prefix : Prefix
    }

empty : Prefix -> AutoIncDict v
empty prefix =
    { lastInc = 0
    , dict = Dict.empty
    , prefix = prefix
    }

singleton : Prefix -> v -> AutoIncDict v
singleton prefix = first << singletonWithKey prefix

singletonWithKey : Prefix -> v -> (AutoIncDict v, Key)
singletonWithKey prefix value = insertWithKey value <| empty prefix

singletonNeedingInc : Prefix -> (Int -> v) -> AutoIncDict v
singletonNeedingInc prefix func = insertNeedingInc func <| empty prefix

insert : v -> AutoIncDict v -> AutoIncDict v
insert value = first << insertWithKey value

insertNeedingInc : (Int -> v) -> AutoIncDict v -> AutoIncDict v
insertNeedingInc func dictData =
    let
        inc = dictData.lastInc + 1
        key = keyFromInc dictData.prefix inc
    in
        { dictData
        | lastInc = inc
        , dict = Dict.insert key (func inc) dictData.dict
        }

insertWithKey : v -> AutoIncDict v -> (AutoIncDict v, Key)
insertWithKey value dictData =
    let
        inc = dictData.lastInc + 1
        key = keyFromInc dictData.prefix inc
        newData =
            { dictData
            | lastInc = inc
            , dict = Dict.insert key value dictData.dict
            }
    in (newData, key)

adjust : Key -> (v -> v) -> AutoIncDict v -> AutoIncDict v
adjust key = update key << Maybe.map

update : Key -> (Maybe v -> Maybe v) -> AutoIncDict v -> AutoIncDict v
update key func dictData =
    { dictData
    | dict = Dict.update key func dictData.dict
    }

map : (Key -> a -> b) -> AutoIncDict a -> AutoIncDict b
map f dictData =
    { lastInc = dictData.lastInc
    , dict = Dict.map f dictData.dict
    , prefix = dictData.prefix
    }

toList : AutoIncDict v -> List (Key, v)
toList = Dict.toList << .dict

values : AutoIncDict v -> List v
values = Dict.values << .dict

get : Key -> AutoIncDict v -> Maybe v
get key = Dict.get key << .dict

remove : Key -> AutoIncDict v -> AutoIncDict v
remove key dictData =
    { dictData
    | dict = Dict.remove key dictData.dict
    }

keyFromInc : Prefix -> Int -> Key
keyFromInc prefix inc = prefix ++ String.fromInt inc

codec : Codec e v -> Codec e (AutoIncDict v)
codec valCodec =
    let cons li d p = { lastInc = li, dict = d, prefix = p }
    in S.customType
            (\e dict -> e dict.lastInc dict.dict dict.prefix)
            |> S.variant3 cons S.int (S.dict S.string valCodec) S.string
            |> S.finishCustomType

onOne : Key -> Relation (Maybe v) reachable wrap
    -> Relation (AutoIncDict v) reachable wrap
onOne key =
    makeOneToOne
        (get key)
        (update key)

onEach : Relation v reachable subWrap
    -> Relation (AutoIncDict v) reachable (AutoIncDict subWrap)
onEach =
    makeOneToN
        (\f -> map (\_ -> f))
        (\f -> map (\_ -> f))
