module Main.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

import Dict.AutoInc as Dict exposing (AutoIncDict)

import Resource exposing (..)
import Resource.Ceramics exposing (..)
import Resource.Metal exposing (..)
import Resource.Types exposing (..)

import Structure.View exposing (..)

import Main.Model exposing (..)
import Main.Controller exposing (..)

view : Model -> Html Msg
view model =
    let
        conv label msg =
            { structureLabel = label
            , structureMsg = msg
            }
        mkDiv (label, struct) =
            div []
                [ structureView (conv label) label struct
                , hr [] []
                ]
        structDivs = List.map mkDiv <| Dict.toList model.structDict
        
        countDiv : Resource r -> ResourceCounts r -> Html Msg
        countDiv resource counts =
            div []
                [ h3 [] [ text resource.name ]
                , div [] [ text (printPackageCounts resource counts.pkgs) ]
                , div [] [ text (printExcess resource counts.excess) ]
                ]
    in
        main_ []
            [ h1 [] [ text "DeAtH sTrAnDiNg???" ]
            , div [] structDivs
            , div []
                [ countDiv ceramicsResource model.totalCounts.ceramics
                , countDiv metalResource model.totalCounts.metal
                ]
            ]
