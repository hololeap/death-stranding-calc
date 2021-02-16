module Msg.Structure.Rename exposing (RenameStructureMsg(..))

import Model.Structure.Rename exposing (NewStructureName)

type RenameStructureMsg
    = EditStructureName NewStructureName
    | AcceptStructureName
    | CancelRenameStructure
