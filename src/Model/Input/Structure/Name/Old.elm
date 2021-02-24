module Model.Input.Structure.Name.Old exposing
    ( OldStructureName
    , string
    , fromString
    , codec
    )

import Accessors exposing (Relation, makeOneToOne, get)
import Serialize as S exposing (Codec)

type OldStructureName = OldStructureName String

string : Relation String reachable wrap
    -> Relation OldStructureName reachable wrap
string =
    makeOneToOne
        (\(OldStructureName s) -> s)
        (\change (OldStructureName s) -> OldStructureName (change s))

fromString : String -> OldStructureName
fromString = OldStructureName

codec : Codec e OldStructureName
codec =
    S.customType
        (\e -> e << get string)
        |> S.variant1 fromString S.string
        |> S.finishCustomType
