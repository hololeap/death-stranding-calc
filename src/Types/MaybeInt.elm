module Types.MaybeInt exposing 
    ( MaybeInt
    , toInt
    , fromInt
    , show
    , read
    , map
    , init
    )

type MaybeInt = MaybeInt (Maybe Int)

toInt : MaybeInt -> Int
toInt (MaybeInt mi) = case mi of
    Just i  -> i
    Nothing -> 0

fromInt : Int -> MaybeInt
fromInt = MaybeInt << Just

show : MaybeInt -> String
show (MaybeInt mi) = case mi of
    Just i  -> String.fromInt i
    Nothing -> ""

read : String -> MaybeInt
read = MaybeInt << String.toInt

map : (Int -> Int) -> MaybeInt -> MaybeInt
map f (MaybeInt mi) = MaybeInt (Maybe.map f mi)

init : MaybeInt
init = MaybeInt Nothing
