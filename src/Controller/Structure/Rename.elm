module Controller.Structure.Rename exposing (..)

import Dict.AutoInc as AutoIncDict
import Msg.Structure.Rename exposing (RenameStructureMsg(..))
import Model.Main exposing (Model)

import Model.Structure.Rename exposing
    ( OldStructureName(..)
    , NewStructureName(..)
    , getOldStructureName
    , getNewStructureName
    , StructureName(..)
    )

renameStructure : RenameStructureMsg -> StructureName -> StructureName
renameStructure msg structName =
    case msg of
        EditStructureName newName ->
            case structName of
                StructureName name ->
                    RenamingStructure
                        (OldStructureName name)
                        (NewStructureName "")
                RenamingStructure oldName _ ->
                    RenamingStructure oldName newName
        AcceptStructureName ->
            case structName of
                StructureName _ -> structName
                RenamingStructure _ newName ->
                    StructureName (getNewStructureName newName)
        CancelRenameStructure ->
            case structName of
                StructureName _ -> structName
                RenamingStructure oldName _ ->
                    StructureName (getOldStructureName oldName)

