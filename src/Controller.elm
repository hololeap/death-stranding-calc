module Controller exposing (update)

import Dict.AutoInc as AutoIncDict

import Model.Input.Structure as StructureInput
import Model.Input as ModelInput exposing (ModelInput)
import Model.Output as ModelOutput
import Model exposing (Model)
import Controller.Structure as StructureController

import Msg exposing (Msg(..))

-- Return Nothing if there is no change
updateInput : Msg -> ModelInput -> Maybe ModelInput
updateInput msg modelInput =
    case msg of
        ResourceChange change -> Just <|
            AutoIncDict.adjust
                change.structureKey
                (StructureController.update change.structureMsg)
                modelInput
        AddStructure -> Just <|
            AutoIncDict.insertNeedingInc StructureInput.init modelInput
        RemoveStructure key -> Just <|
            AutoIncDict.remove key modelInput
        UrlRequestMsg _ -> Nothing -- No links to handle currently

        -- Don't notify on URL change; this creates an infinite loop with
        -- 'Browser.Notification.replaceUrl'. The user will have to hit "Enter"
        -- if they want to replace the URL.
        UrlChangeMsg _ -> Nothing

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case updateInput msg model.input of
        Nothing -> (model, Cmd.none)
        Just input ->
            ( { model
              | input = input
              , output = ModelOutput.generate input
              }
            , ModelInput.updateUrl model.navKey input
            )
