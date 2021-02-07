module Structure.View exposing (structureView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

import Resource.Ceramics exposing (..)
import Resource.Metal exposing (..)
import Resource.Types exposing (..)
import Resource exposing (..)

import Structure.Model exposing (Structure, ResourceModel)
import Structure.Controller exposing (StructureMsg(..), ResourceMsg(..))

import Main.Controller exposing (Msg)

structureView :
    (StructureMsg -> Msg) -> String -> Structure -> Html Msg
structureView conv label struct =
    table []
        [ caption [] [ text label ]
        , tr []
            [ th [ scope "col" ] [ text "Resource" ]
            , th [ scope "col" ] [ text "Given" ]
            , th [ scope "col" ] [ text "Needed" ]
            ]
        , resourceView (conv << CeramicsMsg) ceramicsResource struct.ceramics
        , resourceView (conv << MetalMsg) metalResource struct.metal
        ]

resourceView 
    :  (ResourceMsg r -> Msg)
    -> Resource r
    -> ResourceModel r
    -> Html Msg
resourceView conv resource model =
    let
        givenInput =
            [ placeholder (resource.name ++ " Given")
            , onInput (conv << ChangeGiven << String.toInt)
            ]
        neededInput =
            [ placeholder (resource.name ++ " Needed")
            , onInput (conv << ChangeNeeded << String.toInt)
            ]
    in 
        tr []
            [ th [ scope "row" ] [ text resource.name ]
            , td [] [ input givenInput [] ]
            , td [] [ input neededInput [] ]
            ]

