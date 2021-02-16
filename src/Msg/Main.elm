module Msg.Main exposing 
    ( Msg(..)
    , FromResourceMsg
    , fromStructureMsg
    , fromRenameStructureMsg
    )

import Dict.AutoInc as AutoIncDict

import Msg.Resource exposing (ResourceMsg)
import Msg.Structure exposing (StructureMsg)
import Msg.Structure.Rename exposing (RenameStructureMsg)

type Msg
    = ResourceChange
        { structureKey : AutoIncDict.Key
        , structureMsg : StructureMsg }
    | AddStructure
    | RemoveStructure AutoIncDict.Key
    | RenameStructure AutoIncDict.Key RenameStructureMsg

type alias FromResourceMsg r = ResourceMsg r -> Msg

fromStructureMsg : AutoIncDict.Key -> StructureMsg -> Msg
fromStructureMsg key msg =
    ResourceChange
        { structureKey = key
        , structureMsg = msg
        }

fromRenameStructureMsg : AutoIncDict.Key -> RenameStructureMsg -> Msg
fromRenameStructureMsg = RenameStructure
