module Model.Input.Structure.Name exposing (..)

import Accessors exposing (Relation, makeOneToN)
import Serialize as S exposing (Codec)

import Model.Input.Structure.Name.Old
    as OldStructureName
    exposing (OldStructureName)

import Model.Input.Structure.Name.New
    as NewStructureName
    exposing (NewStructureName)

type StructureName
    = RenamingStructure OldStructureName NewStructureName
    | StructureName String

oldName : Relation OldStructureName reachable wrap
    -> Relation StructureName reachable (Maybe wrap)
oldName =
    makeOneToN
        (\f s -> case s of
            RenamingStructure o _ -> Just (f o)
            StructureName _ -> Nothing
        )
        (\f st -> case st of
            RenamingStructure o n -> RenamingStructure (f o) n
            StructureName s -> StructureName s
        )

newName : Relation NewStructureName reachable wrap
    -> Relation StructureName reachable (Maybe wrap)
newName =
    makeOneToN
        (\f st -> case st of
            RenamingStructure _ n -> Just (f n)
            StructureName _ -> Nothing
        )
        (\f st -> case st of
            RenamingStructure o n -> RenamingStructure o (f n)
            StructureName s -> StructureName s
        )

name : Relation String reachable wrap
    -> Relation StructureName reachable (Maybe wrap)
name =
    makeOneToN
        (\f st -> case st of
            RenamingStructure _ _ -> Nothing
            StructureName s -> Just (f s)
        )
        (\f st -> case st of
            RenamingStructure o n -> RenamingStructure o n
            StructureName s -> StructureName (f s)
        )

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
