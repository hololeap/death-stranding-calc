module Controller exposing (update)

import Dict.AutoInc as AutoIncDict

import Model.Input.Structure as StructureInput
import Model.Input exposing (ModelInput)
import Model.Output as ModelOutput
import Model exposing (Model)
import Controller.Structure as StructureController

import Msg exposing (Msg(..))

updateInput : Msg -> ModelInput -> ModelInput
updateInput msg inputDict =
    case msg of
        ResourceChange change ->
            AutoIncDict.adjust
                change.structureKey
                (StructureController.update change.structureMsg)
                inputDict
        AddStructure ->
            AutoIncDict.insertNeedingInc StructureInput.init inputDict
        RemoveStructure key ->
            AutoIncDict.remove key inputDict

update : Msg -> Model -> Model
update msg model =
    let input = updateInput msg model.input
    in
        { input = input
        , output = ModelOutput.generate input
        }
