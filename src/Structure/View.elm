module Structure.View exposing (structureView)

import Element exposing (Element, el, fill, table, column, centerX)
import Element.Font as Font
import Element.Keyed as Keyed
import Element.Region as Region

--import Html exposing (..)
--import Html.Attributes exposing (..)
--import Html.Events exposing (onInput)

import Resource.Ceramics exposing (..)
import Resource.Metal exposing (..)
import Resource.Types exposing (..)
import Resource exposing (..)

import Structure.Model exposing (Structure)
--import Structure.Controller exposing (StructureMsg(..))

import Resource.MVC.View exposing (ResourceRow, resourceRow)

import Types.Msg exposing (Msg, StructureMsg(..), fromStructureMsg)

structureView : Structure -> Element Msg
structureView struct =
    let
        mkResRow resConv =
            resourceRow struct (fromStructureMsg struct.key << resConv)
        resRows = 
            [ mkResRow CeramicsMsg ceramicsResource struct.ceramics
            , mkResRow MetalMsg metalResource struct.metal
            ]
        headerFont =
            [ Font.light
            , Font.variant Font.smallCaps
            , Font.size 14
            ]
    in
        Keyed.column []
            [ ( struct.key ++ "-heading"
              , el [Region.heading 2, centerX, Font.underline] (Element.text struct.name)
              )
            , ( struct.key ++ "-table"
              , table [Element.spacing 10, Element.padding 15]
                    { data = resRows
                    , columns =
                        [ { header = el headerFont (Element.text "Resource")
                        , width = fill
                        , view = .name
                        }
                        , { header = el headerFont (Element.text "Given")
                        , width = fill
                        , view = .given
                        }
                        , { header = el headerFont (Element.text "Needed")
                        , width = fill
                        , view = .needed
                        }
                        ]
                    }
                )
            ]
