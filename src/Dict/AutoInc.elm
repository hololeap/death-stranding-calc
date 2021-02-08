module Dict.AutoInc exposing
    ( Key
    , Prefix
    , AutoIncDict
    , empty
    , singleton
    , singletonWithKey
    , singletonNeedingKey
    , singletonNeedingKeyInc
    , insert
    , insertWithKey
    , insertNeedingKey
    , insertNeedingKeyInc
    , update
    , toList
    , values
    , get
    , remove
    )

import Dict exposing (Dict)
import Tuple exposing (first, second)

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

singletonNeedingKey : Prefix -> (Key -> v) -> AutoIncDict v
singletonNeedingKey prefix func = insertNeedingKey func <| empty prefix

singletonNeedingKeyInc : Prefix -> (Int -> Key -> v) -> AutoIncDict v
singletonNeedingKeyInc prefix func = insertNeedingKeyInc func <| empty prefix

insert : v -> AutoIncDict v -> AutoIncDict v
insert value = first << insertWithKey value

insertNeedingKey : (Key -> v) -> AutoIncDict v -> AutoIncDict v
insertNeedingKey func = insertNeedingKeyInc (\_ key -> func key)

insertNeedingKeyInc : (Int -> Key -> v) -> AutoIncDict v -> AutoIncDict v
insertNeedingKeyInc func dictData =
    let
        inc = dictData.lastInc + 1
        key = keyFromInc dictData.prefix inc
    in
        { dictData
        | lastInc = inc
        , dict = Dict.insert key (func inc key) dictData.dict
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
  
update : Key -> (Maybe v -> Maybe v) -> AutoIncDict v -> AutoIncDict v
update key func dictData =
    { dictData
    | dict = Dict.update key func dictData.dict
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
