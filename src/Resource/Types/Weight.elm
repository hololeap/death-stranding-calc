module Resource.Types.Weight exposing
    ( Weight
    , float
    , fromFloat
    , init
    , combine
    , combineMany
    , codec
    )

import Accessors exposing (Relation, makeOneToOne, get)
import Serialize as S exposing (Codec)

type Weight r = Weight Float

float : Relation Float reachable wrap
    -> Relation (Weight f) reachable wrap
float =
    makeOneToOne
        (\(Weight f) -> f)
        (\change (Weight f) -> Weight (change f))

fromFloat : Float -> Weight r
fromFloat = Weight

init : Weight r
init = Weight 0

combine : Weight r -> Weight r -> Weight r
combine (Weight f1) (Weight f2) = Weight (f1 + f2)

combineMany : List (Weight r) -> Weight r
combineMany = List.foldl combine init

codec : Codec e (Weight r)
codec =
    S.customType (\e -> e << get float)
        |> S.variant1 Weight S.float
        |> S.finishCustomType
