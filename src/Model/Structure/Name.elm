module Model.Structure.Name exposing (..)

import Serialize as S exposing (Codec)

import Model.Structure.Name.Old
    as OldStructureName
    exposing (OldStructureName)

import Model.Structure.Name.New
    as NewStructureName
    exposing (NewStructureName)

type StructureName
    = RenamingStructure OldStructureName NewStructureName
    | StructureName String

fromString : String -> StructureName
fromString = StructureName

codec : Codec e StructureName
codec =
    S.customType
        (\eRename eName val ->
            case val of
                RenamingStructure old new -> eRename old new
                StructureName s -> eName s
        )
        |> S.variant2
                RenamingStructure
                OldStructureName.codec
                NewStructureName.codec
        |> S.variant1 StructureName S.string
        |> S.finishCustomType
