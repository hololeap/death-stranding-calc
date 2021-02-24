module Widget exposing
    ( button
    , columnHelper
    )

import Element exposing (Element, Attribute, el)
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

columnHelper
    :  List (Element.Attribute msg) -- Extra attributes for header
    -> List (Element.Attribute msg) -- Extra attributes for column
    -> Element msg -- Heading
    -> List (Maybe (Element msg))
    -> Maybe (Element msg)
columnHelper headingAttrs columnAttrs heading list =
    if List.all isNothing list
        then Nothing
        else Just <|
            Element.column
                (    Element.spacing 30
                  :: Border.width 1
                  :: Border.rounded 10
                  :: Element.padding 10
                  :: Element.width Element.fill
                  :: columnAttrs
                )
                [ el
                    ( Element.paddingXY 0 0
                      :: headingAttrs
                    )
                    heading
                , Element.column
                    [ Element.paddingXY 15 10
                    , Element.moveRight 15
                    , Element.spacing 20
                    , Element.width Element.fill
                    ]
                    (List.map (Maybe.withDefault Element.none) list)
                ]

isNothing : Maybe a -> Bool
isNothing m = case m of
    Just _  -> False
    Nothing -> True
