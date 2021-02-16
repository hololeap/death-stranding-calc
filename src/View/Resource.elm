module View.Resource exposing (ResourceRow, resourceRow)

import Dict.AutoInc as AutoIncDict

import Element exposing (Element, Attr, Attribute, el, htmlAttribute)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input

--import Html exposing (Attribute)
import Html.Attributes

import Model.Structure exposing (Structure)
import Model.Structure.Rename exposing
    (StructureName(..), getOldStructureName)

import Resource.Types exposing
    ( Resource
    )

import Resource.Types.Given as ResourceGiven
import Resource.Types.NeededTotal as ResourceNeededTotal

import Model.Resource exposing (ResourceModel)
--import Resource.MVC.Controller exposing (ResourceMsg(..))

import Msg.Main exposing (Msg, FromResourceMsg)
import Msg.Resource exposing (ResourceMsg(..))

import Palette.Colors as Colors
import Palette.Font.Size as FontSize

import Types.MaybeInt as MaybeInt

type alias ResourceRow =
    { name : Element Msg
    , given : Element Msg
    , needed : Element Msg
    }

resourceRow
    :  Structure
    -> FromResourceMsg r
    -> Resource r
    -> ResourceModel r
    -> ResourceRow
resourceRow struct conv resource model =
    let
        givenAttrs =
            (  Events.onClick (conv ResetGiven)
            :: inputAttributes struct.key resource "given"
            )
        neededAttrs =
            (  Events.onClick (conv ResetNeeded)
            :: inputAttributes struct.key resource "needed"
            )
        structName = case struct.name of
            RenamingStructure oldName _ -> getOldStructureName oldName
            StructureName str -> str
        label inputType =
            structName ++  " " ++ resource.name ++ " " ++ inputType
        resourceLabelFont =
            [ FontSize.small
            , Font.variant Font.smallCaps
            ]
        inputFontColor i =
            if i <= 0
                then Font.color Colors.lightBlue
                else Font.color Colors.lightGrey
        verifyNum num = if num > 0 then Just num else Nothing
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
                { onChange = conv
                    << ChangeGiven
                    << ResourceGiven.andThen verifyNum
                    << ResourceGiven.fromString
                , text = ResourceGiven.toString model.given
                , placeholder = Nothing
                , label = Input.labelHidden (label "given")
                }
            )
        , needed = el [inputFontColor (ResourceNeededTotal.toInt model.needed)]
            ( Input.text neededAttrs
                { onChange = conv
                    << ChangeNeeded
                    << ResourceNeededTotal.andThen verifyNum
                    << ResourceNeededTotal.fromString
                , text = ResourceNeededTotal.toString model.needed
                , placeholder = Nothing
                , label = Input.labelHidden (label "needed")
                }
            )
        }

inputAttributes
    : AutoIncDict.Key -> Resource r -> String -> List (Attribute Msg)
inputAttributes key resource inputType =
    let
        inputId = key ++ "-" ++ resource.id ++ "-" ++ inputType ++ "-input"
        inputClass = "structure-" ++ resource.id ++ "-" ++ inputType
    in
--        [ id inputId
--        , classList
--            [ ("structure-resource-input", True)
--            , (resource.id ++ "-input", True)
--            , (inputType ++ "-input", True)
--            ]
--        , placeholder "0"
        List.map htmlAttribute
            [ Html.Attributes.type_ "number"
            , Html.Attributes.size 4
            , Html.Attributes.min "0"
            , Html.Attributes.max "9999"
            ]
        ++ [ Background.color Colors.darkBlue ]
