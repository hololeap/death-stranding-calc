module Widget.TotalList exposing (view)

-- Display the total amount of resources for all structures

import Accessors as A

import Dict.Count as CountDict

import Element exposing (Element, el)
import Element.Background as Background
import Element.Region as Region

import Resource exposing (resourceTotal)
import Resource.Types exposing (Resource)

import Resource.ChiralCrystals as ChiralCrystals
import Resource.Resins as Resins
import Resource.Metal as Metal
import Resource.Ceramics as Ceramics
import Resource.Chemicals as Chemicals
import Resource.SpecialAlloys as SpecialAlloys

import Model.Output.Combined.Counts as CombinedCounts exposing (CombinedCounts)
import Model.Output.Total.Counts exposing (TotalCounts)

import Msg exposing (Msg)

import Palette.Colors as Colors
import Widget exposing (columnHelper)

view : TotalCounts -> Maybe (Element Msg)
view counts =
    let
        resElems =
            [ single ChiralCrystals.resource counts.chiralCrystals
            , single Resins.resource counts.resins
            , single Metal.resource counts.metal
            , single Ceramics.resource counts.ceramics
            , single Chemicals.resource counts.chemicals
            , single SpecialAlloys.resource counts.specialAlloys
            ]
        heading = Element.text "Resources needed:"
    in columnHelper
        [Region.heading 3]
        [Background.color Colors.xDarkBlue]
        heading
        resElems

single : Resource r -> CombinedCounts r -> Maybe (Element Msg)
single resource combCounts =
    let
        counts = A.get CombinedCounts.packageCounts combCounts
    in
        if CountDict.isEmpty counts
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
                            (Element.text
                                <| String.fromInt
                                <| resourceTotal resource counts
                            )
                        )
                    ]
