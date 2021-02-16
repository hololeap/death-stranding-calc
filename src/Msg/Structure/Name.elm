module Msg.Structure.Name exposing (RenameStructureMsg(..))

import Model.Structure.Name.New exposing (NewStructureName)

type RenameStructureMsg
    = EditStructureName NewStructureName
    | AcceptStructureName
    | CancelRenameStructure
