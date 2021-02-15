module Structure.Rename.View exposing (..)

import Element exposing (Element, el)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region

import Structure.Model exposing (Structure)
import Structure.Rename.Model exposing
    ( OldStructureName(..)
    , NewStructureName(..)
    , getNewStructureName
    , StructureName(..))
import Types.Msg exposing 
    ( Msg
    , RenameStructureMsg(..)
    , fromRenameStructureMsg
    )

import Palette.Font.Size as FontSize
import Palette.Colors as Colors
    
structureNameElem : Structure -> Element Msg
structureNameElem struct =
    case struct.name of
        StructureName name ->
            el 
                [ Region.heading 2
                , Element.centerX
                , Font.underline
                , Events.onClick
                    <| fromRenameStructureMsg struct.key
                    <| EditStructureName
                    <| NewStructureName name
                ] 
                (Element.text name)
        RenamingStructure oldName newName ->
            let
                nameInput : Element Msg
                nameInput = Input.text
                    [ Element.width Element.fill
                    , Font.color Colors.xDarkBlue
                    ]
                    { onChange = fromRenameStructureMsg struct.key
                        << EditStructureName
                        << NewStructureName
                    , text = getNewStructureName newName
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
                buttonText text =
                    el
                        
                acceptButtonText = Element.text "✓"
                cancelButtonText = Element.text "✕"
                enabledAcceptButton : Element Msg
                enabledAcceptButton =
                    Input.button
                        ( Background.color (Element.rgb255 0 200 20)
                          :: buttonAttrs
                        )
                        { onPress = Just 
                            <| fromRenameStructureMsg struct.key
                            <| AcceptStructureName
                        , label = el
                            buttonTextAttrs
                            acceptButtonText
                        }
                disabledAcceptButton : Element Msg
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
                acceptButton : Element Msg
                acceptButton =
                    if String.isEmpty (getNewStructureName newName)
                        then disabledAcceptButton
                        else enabledAcceptButton
                cancelButton : Element Msg
                cancelButton =
                    Input.button
                        ( Background.color (Colors.red)
                          :: buttonAttrs
                        )
                        { onPress = Just 
                            <| fromRenameStructureMsg struct.key
                            <| CancelRenameStructure
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
