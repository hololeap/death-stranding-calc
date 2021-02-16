module Model.Structure exposing (..)

import Serialize as S exposing (Codec)

import Dict.AutoInc as AutoIncDict
import Dict.Count as CountDict

import Model.Structure.Resources
    as StructureResources
    exposing (StructureResources)
import Model.Structure.Name as StructureName exposing (StructureName)

type alias Structure =
    { name : StructureName
    , key : AutoIncDict.Key
    , resources : StructureResources
    , inputsVisible : Bool
    }

init : Int -> AutoIncDict.Key -> Structure
init inc key =
    { name = StructureName.fromString ("Structure " ++ String.fromInt inc)
    , key = key
    , resources = StructureResources.init
    , inputsVisible = True
    }

codec : Codec e Structure
codec =
    let cons n k r i = {name = n, key = k, resources = r, inputsVisible = i}
    in
        S.customType
            (\e c -> e c.name c.key c.resources c.inputsVisible)
            |> S.variant4
                    cons
                    StructureName.codec
                    S.string
                    StructureResources.codec
                    S.bool
            |> S.finishCustomType
