module Dict.AutoInc exposing (..)

import Dict exposing (Dict)

type alias AutoIncDict v = 
    { lastKey : Int
    , dict : Dict String v
    , prefix : String }

empty : String -> AutoIncDict v
empty prefix =
    { lastKey = 0
    , dict = Dict.empty
    , prefix = prefix }

singleton : String -> v -> AutoIncDict v
singleton prefix v = insert v <| empty prefix

insert : v -> AutoIncDict v -> AutoIncDict v
insert value dictData =
    let
        key = dictData.lastKey + 1
        label = dictData.prefix ++ " " ++ String.fromInt key
    in 
        { dictData
        | lastKey = key
        , dict = Dict.insert label value dictData.dict
        }

-- If the original label isn't there, just return the original dict
-- If the new label is taken, return Nothing
-- Otherwise, delete the old key and insert a new one with a new name and
-- unchanged value.
relabel : String -> String -> AutoIncDict v -> Maybe (AutoIncDict v)
relabel oldLabel newLabel dictData =
    case get oldLabel dictData of
        Nothing -> Just dictData
        Just value ->
            insertNoInc newLabel value
                <| remove oldLabel dictData

-- If the new label is taken, return Nothing
insertNoInc : String -> v -> AutoIncDict v -> Maybe (AutoIncDict v)
insertNoInc label value dictData =
    if Dict.member label dictData.dict
        then Nothing
        else Just
            { dictData
            | dict = Dict.insert label value dictData.dict
            }
        
update : String -> (Maybe v -> Maybe v) -> AutoIncDict v -> AutoIncDict v
update key func dictData =
    { dictData
    | dict = Dict.update key func dictData.dict
    }

toList : AutoIncDict v -> List (String, v)
toList dictData = Dict.toList dictData.dict

values : AutoIncDict v -> List v
values dictData = Dict.values dictData.dict

get : String -> AutoIncDict v -> Maybe v
get key dictData = Dict.get key dictData.dict

remove : String -> AutoIncDict v -> AutoIncDict v
remove key dictData =
    { dictData 
    | dict = Dict.remove key dictData.dict
    }
