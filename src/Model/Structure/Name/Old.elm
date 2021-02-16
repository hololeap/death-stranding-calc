module Model.Structure.Name.Old exposing
    ( OldStructureName
    , toString
    , fromString
    , codec
    )

import Serialize as S exposing (Codec)

type OldStructureName = OldStructureName String

toString : OldStructureName -> String
toString (OldStructureName s) = s

fromString : String -> OldStructureName
fromString = OldStructureName

codec : Codec e OldStructureName
codec =
    S.customType
        (\e -> e << toString)
        |> S.variant1 fromString S.string
        |> S.finishCustomType
