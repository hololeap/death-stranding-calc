-- Based off Death Stranding's color palette
-- kcoloredit file found at `death-stranding.colors`

module Palette.Colors exposing
    ( xDarkBlue
    , darkBlue
    , blue
    , lightBlue
    , blueGrey
    , black
    , grey
    , lightGrey
    , red
    , orange
    , darkOrange
    , darkGold
    , gold
    , lightGold
    )

import Element exposing (Color, rgb255)

xDarkBlue : Color
xDarkBlue = rgb255 0 37 76

darkBlue : Color
darkBlue = rgb255 2 63 124

blue : Color
blue = rgb255 0 91 172

lightBlue : Color
lightBlue = rgb255 0 149 173

blueGrey : Color
blueGrey = rgb255 0 76 104

black : Color
black = rgb255 1 2 4

grey : Color
grey = rgb255 58 80 80

lightGrey : Color
lightGrey = rgb255 164 224 231

red : Color
red = rgb255 227 10 41

orange : Color
orange = rgb255 226 91 27

darkOrange : Color
darkOrange = rgb255 164 81 4

darkGold : Color
darkGold = rgb255 175 134 7

gold : Color
gold = rgb255 220 178 48

lightGold : Color
lightGold = rgb255 234 211 104
