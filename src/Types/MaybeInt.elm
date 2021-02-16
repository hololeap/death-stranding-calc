module Types.MaybeInt exposing 
    ( MaybeInt
    , toInt
    , fromInt
    , toString
    , fromString
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

toString : MaybeInt -> String
toString (MaybeInt mi) = case mi of
    Just i  -> String.fromInt i
    Nothing -> ""

fromString : String -> MaybeInt
fromString = MaybeInt << String.toInt

map : (Int -> Int) -> MaybeInt -> MaybeInt
map f (MaybeInt mi) = MaybeInt (Maybe.map f mi)

init : MaybeInt
init = MaybeInt Nothing
