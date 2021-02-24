module Msg.Structure.Name exposing (RenameStructureMsg(..))

type RenameStructureMsg
    = EditStructureName String
    | AcceptStructureName
    | CancelRenameStructure
