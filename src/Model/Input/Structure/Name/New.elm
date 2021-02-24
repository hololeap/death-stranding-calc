module Model.Input.Structure.Name.New exposing
    ( NewStructureName
    , string
    , fromString
    , codec
    )

import Accessors exposing (Relation, makeOneToOne, get)
import Serialize as S exposing (Codec)

type NewStructureName = NewStructureName String

string : Relation String reachable wrap
    -> Relation NewStructureName reachable wrap
string =
    makeOneToOne
        (\(NewStructureName s) -> s)
        (\change (NewStructureName s) -> NewStructureName (change s))

fromString : String -> NewStructureName
fromString = NewStructureName

codec : Codec e NewStructureName
codec =
    S.customType
        (\e -> e << get string)
        |> S.variant1 fromString S.string
        |> S.finishCustomType
