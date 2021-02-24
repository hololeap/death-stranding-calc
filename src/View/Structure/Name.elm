module View.Structure.Name exposing (..)

import Accessors as A

import Element exposing (Element, el)
import Element.Background as Background
import Element.Events as Events
import Element.Input as Input
import Element.Font as Font
import Element.Region as Region

import Model.Input.Structure.Name exposing (StructureName(..))
import Model.Input.Structure.Name.New as NewStructureName

import Msg.Structure.Name exposing (RenameStructureMsg(..))

import Palette.Font.Size as FontSize
import Palette.Colors as Colors

structureNameElem : StructureName -> Element RenameStructureMsg
structureNameElem structName =
    case structName of
        StructureName name ->
            el
                [ Region.heading 2
                , Element.centerX
                , Font.underline
                , Events.onClick (EditStructureName name)
                ]
                (Element.text name)
        RenamingStructure _ newName ->
            let
                nameInput : Element RenameStructureMsg
                nameInput = Input.text
                    [ Element.width Element.fill
                    , Font.color Colors.xDarkBlue
                    ]
                    { onChange = EditStructureName
                    , text = A.get NewStructureName.string newName
                    , placeholder = Just <|
                        Input.placeholder
                            [ Font.italic
                            ]
                            (Element.text "Please enter a name")
                    , label = Input.labelHidden "New structure name"
                    }
                buttonAttrs =
                    [ Element.width (Element.px 40)
                    , Element.height (Element.px 30)
                    , Element.centerX
                    , Element.centerY
                    , FontSize.xLarge
                    ]
                buttonTextAttrs =
                    [ Font.color (Element.rgb255 230 230 230)
                    , Element.centerX
                    , Element.centerY
                    ]

                acceptButtonText = Element.text "✓"
                cancelButtonText = Element.text "✕"
                enabledAcceptButton : Element RenameStructureMsg
                enabledAcceptButton =
                    Input.button
                        ( Background.color (Element.rgb255 0 200 20)
                          :: buttonAttrs
                        )
                        { onPress = Just AcceptStructureName
                        , label = el
                            buttonTextAttrs
                            acceptButtonText
                        }
                disabledAcceptButton : Element RenameStructureMsg
                disabledAcceptButton =
                    Input.button
                        ( Background.color (Colors.grey)
                          :: buttonAttrs
                        )
                        { onPress = Nothing
                        , label = el
                            buttonTextAttrs
                            acceptButtonText
                        }
                acceptButton : Element RenameStructureMsg
                acceptButton =
                    if String.isEmpty (A.get NewStructureName.string newName)
                        then disabledAcceptButton
                        else enabledAcceptButton
                cancelButton : Element RenameStructureMsg
                cancelButton =
                    Input.button
                        ( Background.color (Colors.red)
                          :: buttonAttrs
                        )
                        { onPress = Just CancelRenameStructure
                        , label = el
                            buttonTextAttrs
                            cancelButtonText
                        }
            in
                Element.row
                    [ Element.width Element.fill
                    , Element.centerX
                    , Element.spacing 10
                    ]
                    [ nameInput
                    , acceptButton
                    , cancelButton
                    ]
