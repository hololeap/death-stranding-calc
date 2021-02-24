module Resource.Types.Excess exposing
    ( Excess
    , int
    , fromInt
    , toString
    , fromString
    , init
    , combine
    , combineMany
    , codec
    )

import Accessors exposing (Relation, makeOneToOne, get)
import Serialize as S exposing (Codec)

-- Amount of a resource that will be wasted
type Excess r = Excess Int

int : Relation Int reachable wrap
    -> Relation (Excess r) reachable wrap
int =
    makeOneToOne
        (\(Excess i) -> i)
        (\change (Excess i) -> Excess (change i))

fromInt : Int -> Excess r
fromInt = Excess

toString : Excess r -> String
toString = String.fromInt << get int

fromString : String -> Maybe (Excess r)
fromString = Maybe.map fromInt << String.toInt

init : (Excess r)
init = fromInt 0

combine : Excess r -> Excess r -> Excess r
combine (Excess i1) (Excess i2) = Excess (i1 + i2)

combineMany : List (Excess r) -> Excess r
combineMany = List.foldl combine init

codec : Codec e (Excess r)
codec =
    S.customType (\e -> e << get int)
        |> S.variant1 fromInt S.int
        |> S.finishCustomType
