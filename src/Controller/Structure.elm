module Controller.Structure exposing (update)

import Accessors as A

import Resource.Types.All as AllResources

import Controller.Resource as ResourceController
import Controller.Structure.Name as StructureNameController
import Model.Input.Structure as StructureInput exposing (StructureInput)
import Msg.Structure exposing (StructureMsg(..))
import Msg.Structure.Name exposing (RenameStructureMsg(..))

update : StructureMsg -> StructureInput -> StructureInput
update structMsg =
    let
        updateRes accessor msg =
            A.over
                (StructureInput.resources << accessor)
                (ResourceController.update msg)
        updateName msg =
            A.over
                StructureInput.name
                (StructureNameController.update msg)
    in
        case structMsg of
            ChiralCrystalsMsg msg -> updateRes AllResources.chiralCrystals msg
            ResinsMsg msg -> updateRes AllResources.resins msg
            MetalMsg msg -> updateRes AllResources.metal msg
            CeramicsMsg msg -> updateRes AllResources.ceramics msg
            ChemicalsMsg msg -> updateRes AllResources.chemicals msg
            SpecialAlloysMsg msg -> updateRes AllResources.specialAlloys msg
            InputsVisibleMsg bool -> A.set StructureInput.inputsVisible bool
            RenameStructure msg -> updateName msg
