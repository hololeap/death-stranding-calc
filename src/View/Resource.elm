module View.Resource exposing (ResourceRow, map, resourceRow)

import Element exposing (Element, Attribute, el, htmlAttribute)
import Element.Background as Background
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input

import Html.Attributes

import Model.Input.Structure.Name exposing(StructureName(..))

import Resource.Types exposing (Resource)

import Resource.Types.Given as ResourceGiven
import Resource.Types.NeededTotal as ResourceNeededTotal

import Model.Input.Resource exposing (ResourceInput(..))

import Msg.Resource exposing (ResourceMsg(..))

import Palette.Colors as Colors
import Palette.Font.Size as FontSize

type alias ResourceRow msg =
    { name : Element msg
    , given : Element msg
    , needed : Element msg
    }

map : (msg1 -> msg2) -> ResourceRow msg1 -> ResourceRow msg2
map f r =
    { name = Element.map f r.name
    , given = Element.map f r.given
    , needed = Element.map f r.needed
    }

resourceRow
    :  Resource r
    -> ResourceInput r
    -> ResourceRow (ResourceMsg r)
resourceRow resource (ResourceInput model) =
    let
        givenAttrs =
            ( Events.onClick ResetGiven :: inputAttributes )
        neededAttrs =
            ( Events.onClick ResetNeeded :: inputAttributes )
        label inputType = resource.name ++ " " ++ inputType
        resourceLabelFont =
            [ FontSize.small
            , Font.variant Font.smallCaps
            ]
        inputFontColor i =
            if i <= 0
                then Font.color Colors.lightBlue
                else Font.color Colors.lightGrey
    in
        { name =
            Element.row
                [ Element.width Element.fill
                , Element.centerY
                ]
                [ el
                    [ Element.padding 10
                    ]
                    ( Element.image
                        [Element.height (Element.px 25)]
                        { src = "/images/" ++ resource.image
                        , description = ""
                        }
                    )
                , el
                    ( Element.alignRight
                    :: Element.width Element.fill
                    :: resourceLabelFont
                    )
                    (el [Element.alignRight] (Element.text resource.name))
                ]
        , given = el [inputFontColor (ResourceGiven.toInt model.given)]
            ( Input.text givenAttrs
                { onChange = ChangeGiven
                , text = ResourceGiven.toString model.given
                , placeholder = Nothing
                , label = Input.labelHidden (label "given")
                }
            )
        , needed = el [inputFontColor (ResourceNeededTotal.toInt model.needed)]
            ( Input.text neededAttrs
                { onChange = ChangeNeeded
                , text = ResourceNeededTotal.toString model.needed
                , placeholder = Nothing
                , label = Input.labelHidden (label "needed")
                }
            )
        }

inputAttributes : List (Attribute (ResourceMsg r))
inputAttributes =
    Background.color Colors.darkBlue
    :: List.map htmlAttribute
            [ Html.Attributes.type_ "number"
            , Html.Attributes.size 4
            , Html.Attributes.min "0"
            , Html.Attributes.max "9999"
            ]
