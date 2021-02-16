module Model.Structure.Rename exposing (..)

type OldStructureName = OldStructureName String

getOldStructureName : OldStructureName -> String
getOldStructureName (OldStructureName s) = s

type NewStructureName = NewStructureName String

getNewStructureName : NewStructureName -> String
getNewStructureName (NewStructureName s) = s

type StructureName
    = RenamingStructure OldStructureName NewStructureName
    | StructureName String

isRenaming : StructureName -> Bool
isRenaming struct = case struct of
    RenamingStructure _ _ -> True
    StructureName _ -> False
