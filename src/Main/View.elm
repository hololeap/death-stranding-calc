module Main.View exposing
    ( view
    )

import Element    
    
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
        conv key msg = ResourceChange
            { structureKey = key
            , structureMsg = msg
            }
        remButton key =
            div [] [ button 
                        [ onClick (RemoveStructure key) ]
                        [ text "Remove Structure" ] 
                    ]
        mkDiv struct =
            div []
                [ Element.layout [] (structureView (conv struct.key) struct)
                , remButton struct.key
                , hr [] []
                ]
        structDivs = List.map mkDiv <| Dict.values model.structDict
        
        countDiv : Resource r -> CombinedCounts r -> Html Msg
        countDiv resource counts =
            div []
                [ div [] [ text resource.name ]
                , div [] [ text (printPackageCounts resource counts.pkgs) ]
                , div [] [ text (printExcess resource counts.excess) ]
                ]
        
        totalDiv : Resource r -> CombinedCounts r -> Html Msg
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

