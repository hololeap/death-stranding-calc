module Structure.View exposing (structureView)

import Element exposing (Element, el, fill, table)

--import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

import Resource.Ceramics exposing (..)
import Resource.Metal exposing (..)
import Resource.Types exposing (..)
import Resource exposing (..)

import Structure.Model exposing (Structure)
import Structure.Controller exposing (StructureMsg(..))

import Resource.MVC.View exposing (ResourceRow, resourceRow)

import Main.Controller exposing (Msg)

structureView : (StructureMsg -> Msg) -> Structure -> Element Msg
structureView conv struct =
    let
        mkResRow resConv resource resModel =
            resourceRow struct (conv << resConv) resource resModel
        resRows = 
            [ mkResRow CeramicsMsg ceramicsResource struct.ceramics
            , mkResRow MetalMsg metalResource struct.metal
            ]
    in
        el []
            ( table []
                { data = resRows
                , columns =
                    [ { header = Element.text "Resource"
                      , width = fill
                      , view = .name
                      }
                    , { header = Element.text "Given"
                      , width = fill
                      , view = .given
                      }
                    , { header = Element.text "Needed"
                      , width = fill
                      , view = .needed
                      }
                    ]
                }
            )
