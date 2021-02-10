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

structureNameElem : Structure -> Element Msg
structureNameElem struct =
    case struct.name of
        StructureName name ->
            el 
                [ Region.heading 2
                , Element.centerX
                , Font.underline
                , Element.padding 20
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
                    [ Element.width (Element.px 20)
                    , Element.height (Element.px 20)
                    , Element.centerX
                    , Element.centerY
                    ]
                buttonTextAttrs =
                    [ Font.color (Element.rgb255 230 230 230)
                    , Element.centerX
                    , Element.centerY
                    ]
                buttonText text =
                    el
                        
                acceptButtonText = Element.text "✓"
                cancelButtonText = Element.text "🗙"
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
                        ( Background.color (Element.rgb255 128 128 128)
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
                        ( Background.color (Element.rgb255 230 0 10)
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
                    , Element.spacing 5
                    , Element.padding 10
                    ]
                    [ nameInput
                    , acceptButton
                    , cancelButton
                    ]
