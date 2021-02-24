module Widget.TotalWeight exposing (view)

-- This displays the total weight for each resource in all structures.

import Element exposing (Element, el)
import Element.Background as Background
import Element.Region as Region

import Model.Output.Total.Weight as TotalWeight exposing (TotalWeight)

import Msg exposing (Msg)

import Palette.Colors as Colors
import Widget exposing (columnHelper)

view : TotalWeight -> Maybe (Element Msg)
view totalWeight =
    let
        weight = TotalWeight.toFloat totalWeight
        elem =
            if weight == 0
                then Nothing
                else Just
                    ( el [Element.alignRight]
                        (Element.text (String.fromFloat weight ++ " kilograms"))
                    )
        heading = Element.text "Total weight:"
    in columnHelper
            [Region.heading 3]
            [Background.color Colors.xDarkBlue]
            heading
            [elem]
