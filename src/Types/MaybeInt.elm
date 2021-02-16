module Types.MaybeInt exposing 
    ( MaybeInt
    , toInt
    , fromInt
    , toString
    , fromString
    , mapM
    , map
    , andThen
    , init
    )

type MaybeInt = MaybeInt (Maybe Int)

toInt : MaybeInt -> Int
toInt (MaybeInt mi) = case mi of
    Just i  -> i
    Nothing -> 0

fromInt : Int -> MaybeInt
fromInt = MaybeInt << Just

toString : MaybeInt -> String
toString (MaybeInt mi) = case mi of
    Just i  -> String.fromInt i
    Nothing -> ""

fromString : String -> MaybeInt
fromString = MaybeInt << String.toInt

mapM : (Maybe Int -> Maybe Int) -> MaybeInt -> MaybeInt
mapM f (MaybeInt mi) = MaybeInt (f mi)

map : (Int -> Int) -> MaybeInt -> MaybeInt
map = mapM << Maybe.map

andThen : (Int -> Maybe Int) -> MaybeInt -> MaybeInt
andThen = mapM << Maybe.andThen

init : MaybeInt
init = MaybeInt Nothing
