module Controller.Structure.Name exposing (..)

import Dict.AutoInc as AutoIncDict
import Msg.Structure.Name exposing (RenameStructureMsg(..))
import Model.Main exposing (Model)

import Model.Structure.Name exposing (StructureName(..))
import Model.Structure.Name.Old as OldStructureName
import Model.Structure.Name.New as NewStructureName

renameStructure : RenameStructureMsg -> StructureName -> StructureName
renameStructure msg structName =
    case msg of
        EditStructureName newName ->
            case structName of
                StructureName name ->
                    RenamingStructure
                        (OldStructureName.fromString name)
                        (NewStructureName.fromString "")
                RenamingStructure oldName _ ->
                    RenamingStructure oldName newName
        AcceptStructureName ->
            case structName of
                StructureName _ -> structName
                RenamingStructure _ newName ->
                    StructureName (NewStructureName.toString newName)
        CancelRenameStructure ->
            case structName of
                StructureName _ -> structName
                RenamingStructure oldName _ ->
                    StructureName (OldStructureName.toString oldName)

