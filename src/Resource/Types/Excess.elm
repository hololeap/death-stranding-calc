module Resource.Types.Excess exposing
    ( Excess
    , toInt
    , fromInt
    , toString
    , fromString
    , init
    , codec
    )

import Serialize as S exposing (Codec)

-- Amount of a resource that will be wasted
type Excess = Excess Int

toInt : Excess -> Int
toInt (Excess i) = i

fromInt : Int -> Excess
fromInt = Excess

toString : Excess -> String
toString = String.fromInt << toInt

fromString : String -> Maybe Excess
fromString = Maybe.map fromInt << String.toInt

init : Excess
init = fromInt 0

codec : Codec e Excess
codec =
    S.customType (\e -> e << toInt)
        |> S.variant1 fromInt S.int
        |> S.finishCustomType
