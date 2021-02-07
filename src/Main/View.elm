module Main.View exposing
    ( view
    )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)

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
        conv label msg = ResourceChange
            { structureLabel = label
            , structureMsg = msg
            }
        remButton label =
            div [] [ button 
                        [ onClick (RemoveStructure label) ]
                        [ text "Remove Structure" ] 
                    ]
        mkDiv (label, struct) =
            div []
                [ structureView (conv label) label struct
                , remButton label
                , hr [] []
                ]
        structDivs = List.map mkDiv <| Dict.toList model.structDict
        
        countDiv : Resource r -> ResourceCounts r -> Html Msg
        countDiv resource counts =
            div []
                [ div [] [ text resource.name ]
                , div [] [ text (printPackageCounts resource counts.pkgs) ]
                , div [] [ text (printExcess resource counts.excess) ]
                ]
        
        totalDiv : Resource r -> ResourceCounts r -> Html Msg
        totalDiv resource counts =
            div [] [ text (printResourceTotal resource counts.pkgs) ]
    in
        main_ []
            [ h1 [] [ text "DeAtH sTrAnDiNg???" ]
            , div [] structDivs
            , div [] [ button [ onClick AddStructure ] [ text "Add Structure" ] ]
            , div []
                [ div [] [ text "Packages needed:" ]
                , countDiv ceramicsResource model.totalCounts.ceramics
                , countDiv metalResource model.totalCounts.metal
                ]
            , div []
                [ p [] [ text "Total resources needed:" ]
                , totalDiv ceramicsResource model.totalCounts.ceramics
                , totalDiv metalResource model.totalCounts.metal
                ]
            ]

