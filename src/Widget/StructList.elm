module Widget.StructList exposing (view)

-- Display the list of all structures.

import Element exposing (Element, el)
import Element.Border as Border

import Dict.AutoInc as AutoIncDict exposing (AutoIncDict)

import Model.Input.Structure exposing (StructureInput)
import Model.Output.Structure as StructureOutput exposing (StructureOutput)

import View.Structure as StructureView

import Msg exposing (Msg(..))

import Palette.Colors as Colors
import Widget
import Widget.PackageList as PackageList

view : AutoIncDict StructureInput
    -> AutoIncDict StructureOutput
    -> Element Msg
view structInputs structOutputs =
    let
        structElemList =
            List.map2 (\(k,i) o -> structElem k i o)
                (AutoIncDict.toList structInputs)
                (AutoIncDict.values structOutputs)
    in
        Element.column
            [Element.width Element.fill, Element.spacing 20]
            [ Element.column structsAttrs structElemList
            , addButton
            ]

structsAttrs : List (Element.Attribute Msg)
structsAttrs =
    [ Element.spacing 10
    , Element.width Element.fill
    ]

-- This needs to be outside of the StructureView scope, since that does not
-- have access to the 'remove' operation.
structElem : AutoIncDict.Key -> StructureInput -> StructureOutput -> Element Msg
structElem key structInput structOutput =
    let
        pkgList = PackageList.view (StructureOutput.toPackages structOutput)
        conv msg =
            ResourceChange
                { structureKey = key
                , structureMsg = msg
                }
    in
        Element.column structColumnAttrs
            [ el
                [ Element.centerX
                , Element.width Element.fill
                ]
                (Element.map conv (StructureView.view key structInput))
            , removeButton key
            , el
                [ Element.width Element.fill
                ]
                (Maybe.withDefault Element.none pkgList)
            ]

structColumnAttrs : List (Element.Attribute Msg)
structColumnAttrs =
    [ Element.spacing 10
    , Border.width 2
    , Border.color Colors.lightBlue
    , Border.rounded 20
    , Element.width Element.fill
    , Element.padding 20
    ]

addButton : Element Msg
addButton = Widget.button
    "Add structure"
    (Just AddStructure)
    [Element.alignRight]

removeButton : AutoIncDict.Key -> Element Msg
removeButton key = Widget.button
    "Remove structure"
    (Just (RemoveStructure key))
    [Element.alignRight]

