module Resource.MVC.View exposing (ResourceRow, resourceRow)

import Dict.AutoInc as AutoIncDict

import Element exposing (Element, Attribute, el, htmlAttribute)
import Element.Input as Input

--import Html exposing (Attribute)
import Html.Attributes exposing (..)

import Structure.Model exposing (Structure)

import Resource.Types exposing (Resource)
import Resource.MVC.Model exposing (ResourceModel)
--import Resource.MVC.Controller exposing (ResourceMsg(..))

import Types.Msg exposing (Msg, ResourceMsg(..), FromResourceMsg)

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
        givenAttrs = inputAttributes struct.key resource "given"
        neededAttrs = inputAttributes struct.key resource "needed"
        label inputType =
            struct.name ++  " " ++ resource.name ++ " " ++ inputType
    in
        { name = el [Element.centerY] (Element.text resource.name)
        , given = el [] ( Input.text givenAttrs
            { onChange = conv << ChangeGiven << String.toInt
            , text = String.fromInt model.given
            , placeholder = Nothing
            , label = Input.labelHidden (label "given")
            } )
        , needed = el [] ( Input.text neededAttrs
            { onChange = conv << ChangeNeeded << String.toInt
            , text = String.fromInt model.needed
            , placeholder = Nothing
            , label = Input.labelHidden (label "needed")
            } )
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
            [ type_ "number"
            , size 4
            , Html.Attributes.min "0"
            , Html.Attributes.max "9999"
            ]
