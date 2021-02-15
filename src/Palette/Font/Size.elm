module Palette.Font.Size exposing
    ( xSmall
    , small
    , medium
    , large
    , xLarge
    )

import Element exposing (Attr)
import Element.Font as Font

scaled : Int -> Int
scaled = round << Element.modular 20 1.25

xSmall : Attr decorative msg
xSmall = Font.size (scaled (-2))

small : Attr decorative msg
small = Font.size (scaled (-1))

medium : Attr decorative msg
medium = Font.size (scaled 0)

large : Attr decorative msg
large = Font.size (scaled 1)

xLarge : Attr decorative msg
xLarge = Font.size (scaled 2)
