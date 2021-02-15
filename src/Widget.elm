module Widget exposing
    ( button
    )

import Element exposing (Element, Attribute)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input

import Palette.Colors as Colors
import Palette.Font.Size as FontSize

button 
    :  String
    -> Maybe msg
    -> List (Attribute msg)
    -> Element msg
button text msg attrs = 
    Input.button 
        (  Border.width 1
        :: Border.rounded 5
        :: Element.padding 5
        :: Background.color Colors.darkOrange
        :: FontSize.small
        :: attrs
        )
        { onPress = msg
        , label = Element.text text
        } 
