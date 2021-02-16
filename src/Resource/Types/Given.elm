module Resource.Types.Given exposing
    ( ResourceGiven
    , fromInt
    , toInt
    , fromString
    , toString
    , mapM
    , map
    , andThen
    , init
    )

import Types.MaybeInt as MaybeInt exposing (MaybeInt)

-- Amount of a resource present in a structure
type ResourceGiven = ResourceGiven MaybeInt

fromInt : Int -> ResourceGiven
fromInt = ResourceGiven << MaybeInt.fromInt

toInt : ResourceGiven -> Int
toInt (ResourceGiven mi) = MaybeInt.toInt mi

fromString : String -> ResourceGiven
fromString = ResourceGiven << MaybeInt.fromString

toString : ResourceGiven -> String
toString (ResourceGiven mi) = MaybeInt.toString mi

mapM : (Maybe Int -> Maybe Int) -> ResourceGiven -> ResourceGiven
mapM f (ResourceGiven mi) = ResourceGiven (MaybeInt.mapM f mi)

map : (Int -> Int) -> ResourceGiven -> ResourceGiven
map = mapM << Maybe.map

andThen : (Int -> Maybe Int) -> ResourceGiven -> ResourceGiven
andThen = mapM << Maybe.andThen

init : ResourceGiven
init = ResourceGiven MaybeInt.init
