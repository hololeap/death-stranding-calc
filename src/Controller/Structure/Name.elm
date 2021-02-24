module Controller.Structure.Name exposing (..)

import Accessors as A
import Msg.Structure.Name exposing (RenameStructureMsg(..))

import Model.Input.Structure.Name exposing (StructureName(..))
import Model.Input.Structure.Name.Old as OldStructureName
import Model.Input.Structure.Name.New as NewStructureName

update : RenameStructureMsg -> StructureName -> StructureName
update msg structName =
    case msg of
        EditStructureName newName ->
            case structName of
                StructureName name ->
                    RenamingStructure
                        (OldStructureName.fromString name)
                        (NewStructureName.fromString "")
                RenamingStructure oldName _ ->
                    RenamingStructure
                        oldName
                        (NewStructureName.fromString newName)
        AcceptStructureName ->
            case structName of
                StructureName s -> StructureName s
                RenamingStructure _ newName ->
                    StructureName (A.get NewStructureName.string newName)
        CancelRenameStructure ->
            case structName of
                StructureName s -> StructureName s
                RenamingStructure oldName _ ->
                    StructureName (A.get OldStructureName.string oldName)
