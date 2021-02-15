module Structure.View exposing (structureView)

import Element exposing (Element, el, fill, table, column, centerX)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Keyed as Keyed
import Element.Region as Region

--import Html exposing (..)
--import Html.Attributes exposing (..)
--import Html.Events exposing (onInput)

import Resource.ChiralCrystals exposing (chiralCrystalsResource)
import Resource.Resins exposing (resinsResource)
import Resource.Metal exposing (metalResource)
import Resource.Ceramics exposing (ceramicsResource)
import Resource.Chemicals exposing (chemicalsResource)
import Resource.SpecialAlloys exposing (specialAlloysResource)
import Resource.Types exposing (..)
import Resource exposing (..)

import Structure.Model exposing (Structure)
import Structure.Rename.View exposing (structureNameElem)

import Resource.MVC.View exposing (ResourceRow, resourceRow)

import Types.Msg exposing (Msg, StructureMsg(..), fromStructureMsg)

import Palette.Colors as Colors
import Palette.Font.Size as FontSize

structureView : Structure -> Element Msg
structureView struct =
    let
        mkResRow resConv =
            resourceRow struct (fromStructureMsg struct.key << resConv)
        resRows = 
            [ mkResRow
                ChiralCrystalsMsg
                chiralCrystalsResource
                struct.chiralCrystals
            , mkResRow ResinsMsg resinsResource struct.resins                
            , mkResRow MetalMsg metalResource struct.metal
            , mkResRow CeramicsMsg ceramicsResource struct.ceramics
            , mkResRow ChemicalsMsg chemicalsResource struct.chemicals
            , mkResRow
                SpecialAlloysMsg
                specialAlloysResource
                struct.specialAlloys
            ]
        headerFont =
            [ Font.light
            , Font.variant Font.smallCaps
            , FontSize.xSmall
            ]
        headerElem text =
            el
                ( Element.centerX
                  :: headerFont
                )
                (Element.text text)
    in
        Keyed.column 
            [ Element.width Element.fill
            , Element.spacing 15
            ]
            [ ( struct.key ++ "-heading"
              , structureNameElem struct
              )
            , ( struct.key ++ "-table"
              , table 
                    [ Element.spacing 10
                    , Element.padding 15
                    , Border.width 1
                    , Border.rounded 10
                    , Background.color Colors.black
                    ]
                    { data = resRows
                    , columns =
                        [ { header = el [] (headerElem "Resource")
                          , width = fill
                          , view = .name
                          }
                        , { header = el [] (headerElem "Given")
                          , width = fill
                          , view = .given
                          }
                        , { header = el [] (headerElem "Needed")
                          , width = fill
                          , view = .needed
                          }
                        ]
                    }
                )
            ]
