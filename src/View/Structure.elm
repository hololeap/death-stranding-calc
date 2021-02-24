module View.Structure exposing (view)

import Accessors as A
import Dict.AutoInc as AutoIncDict

import Element exposing (Element, el, fill, table)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Keyed as Keyed

import Resource.ChiralCrystals as ChiralCrystals
import Resource.Resins as Resins
import Resource.Metal as Metal
import Resource.Ceramics as Ceramics
import Resource.Chemicals as Chemicals
import Resource.SpecialAlloys as SpecialAlloys
import Resource.Types.All as AllResources
import Resource.Types exposing (..)
import Resource exposing (..)

import Model.Input.Structure as StructureInput exposing (StructureInput)
import View.Structure.Name exposing (structureNameElem)

import View.Resource as ResourceRow exposing (resourceRow)

import Msg.Structure exposing (StructureMsg(..))

import Palette.Colors as Colors
import Palette.Font.Size as FontSize

import Widget



view : AutoIncDict.Key -> StructureInput -> Element StructureMsg
view key struct =
    let
        mkResRow conv resource accessor =
            A.get (StructureInput.resources << accessor) struct
                |> resourceRow resource
                |> ResourceRow.map conv
        resRows =
            [ mkResRow
                ChiralCrystalsMsg
                ChiralCrystals.resource
                AllResources.chiralCrystals
            , mkResRow
                ResinsMsg
                Resins.resource
                AllResources.resins
            , mkResRow
                MetalMsg
                Metal.resource
                AllResources.metal
            , mkResRow
                CeramicsMsg
                Ceramics.resource
                AllResources.ceramics
            , mkResRow
                ChemicalsMsg
                Chemicals.resource
                AllResources.chemicals
            , mkResRow
                SpecialAlloysMsg
                SpecialAlloys.resource
                AllResources.specialAlloys
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
        inputTable = table
            [ Element.spacing 10
            , Element.padding 15
            , Border.width 1
            , Border.rounded 10
            , Background.color Colors.black
            , Element.below hideInputsButton
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
        toggleShowInputsButton attrs text bool =
            el
                [Element.width Element.fill]
                ( Widget.button
                    text
                    (Just (InputsVisibleMsg bool))
                    (FontSize.xSmall :: attrs)
                )
        showInputsButton = toggleShowInputsButton
            [ Element.alignLeft
            ]
            "Show inputs"
            True
        hideInputsButton = toggleShowInputsButton
            [ Element.moveRight 20
            , Border.widthEach
                { bottom = 1
                , left = 1
                , right = 1
                , top = 0
                }
            , Border.roundEach
                { topLeft = 0
                , topRight = 0
                , bottomLeft = 5
                , bottomRight = 5
                }
            ]
            "Hide inputs"
            False
    in
        Keyed.column
            [ Element.width Element.fill
            , Element.spacing 15
            ]
            [ ( key ++ "-heading"
              , Element.map RenameStructure (structureNameElem struct.name)
              )
            , ( key ++ "-table"
              , if struct.inputsVisible
                    then inputTable
                    else showInputsButton
              )
            ]
