module Palette.Font exposing (..)

import Element exposing (Attribute)
import Element.Font as Font
import Palette.Colors as Colors
import Palette.Font.Size as FontSize

defaultFont : List (Attribute msg)
defaultFont =
    [ FontSize.medium
    , Font.color Colors.lightGrey
    , Font.family [Font.sansSerif]
    ]
