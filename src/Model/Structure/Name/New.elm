module Model.Structure.Name.New exposing
    ( NewStructureName
    , toString
    , fromString
    , codec
    )

import Serialize as S exposing (Codec)

type NewStructureName = NewStructureName String

toString : NewStructureName -> String
toString (NewStructureName s) = s

fromString : String -> NewStructureName
fromString = NewStructureName

codec : Codec e NewStructureName
codec =
    S.customType
        (\e -> e << toString)
        |> S.variant1 fromString S.string
        |> S.finishCustomType
