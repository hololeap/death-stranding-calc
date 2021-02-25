module Resource.Types.NeededTotal exposing
    ( ResourceNeededTotal
    , fromInt
    , toInt
    , fromString
    , toString
    , mapM
    , map
    , andThen
    , init
    , codec
    )

import Serialize as S exposing (Codec)
import Types.MaybeInt as MaybeInt exposing (MaybeInt)

-- Total amount of a resource needed
type ResourceNeededTotal = ResourceNeededTotal MaybeInt

fromInt : Int -> ResourceNeededTotal
fromInt = ResourceNeededTotal << MaybeInt.fromInt

toInt : ResourceNeededTotal -> Int
toInt (ResourceNeededTotal mi) = MaybeInt.toInt mi

fromString : String -> ResourceNeededTotal
fromString = ResourceNeededTotal << MaybeInt.fromString

toString : ResourceNeededTotal -> String
toString (ResourceNeededTotal mi) = MaybeInt.toString mi

mapM : (Maybe Int -> Maybe Int) -> ResourceNeededTotal -> ResourceNeededTotal
mapM f (ResourceNeededTotal mi) = ResourceNeededTotal (MaybeInt.mapM f mi)

map : (Int -> Int) -> ResourceNeededTotal -> ResourceNeededTotal
map = mapM << Maybe.map

andThen : (Int -> Maybe Int) -> ResourceNeededTotal -> ResourceNeededTotal
andThen = mapM << Maybe.andThen

init : ResourceNeededTotal
init = ResourceNeededTotal MaybeInt.init

codec : Codec e ResourceNeededTotal
codec =
    S.customType (\e (ResourceNeededTotal mi) -> e mi)
        |> S.variant1 ResourceNeededTotal MaybeInt.codec
        |> S.finishCustomType
