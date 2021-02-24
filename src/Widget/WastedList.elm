module Widget.WastedList exposing (view)

-- Display the list of wasted resources for all structures.

import Accessors as A

import Element exposing (Element, el)
import Element.Background as Background
import Element.Region as Region

import Resource.Types exposing (Resource)

import Resource.ChiralCrystals as ChiralCrystals
import Resource.Resins as Resins
import Resource.Metal as Metal
import Resource.Ceramics as Ceramics
import Resource.Chemicals as Chemicals
import Resource.SpecialAlloys as SpecialAlloys

import Model.Output.Total.Excess exposing (TotalExcess)
import Model.Output.Combined.Excess as CombinedExcess exposing (CombinedExcess)

import Msg exposing (Msg)

import Palette.Colors as Colors
import Widget exposing (columnHelper)

view : TotalExcess -> Maybe (Element Msg)
view totalExcess =
    let
        resElems =
            [ single ChiralCrystals.resource totalExcess.chiralCrystals
            , single Resins.resource totalExcess.resins
            , single Metal.resource totalExcess.metal
            , single Ceramics.resource totalExcess.ceramics
            , single Chemicals.resource totalExcess.chemicals
            , single SpecialAlloys.resource totalExcess.specialAlloys
            ]
        header = Element.text "Resources wasted:"
    in columnHelper
        [Region.heading 3]
        [Background.color Colors.xDarkBlue]
        header
        resElems

single : Resource r -> CombinedExcess r -> Maybe (Element Msg)
single resource excess =
    if (A.get CombinedExcess.int excess) == 0
        then Nothing
        else Just <|
            Element.row
                [ Element.width Element.fill
                ]
                [ el
                    [Element.width (Element.px 250)]
                    (Element.text (resource.name ++ ":"))
                , el
                    [Element.width Element.fill]
                    (el
                        [Element.alignRight]
                        (Element.text (CombinedExcess.toString excess))
                    )
                ]
