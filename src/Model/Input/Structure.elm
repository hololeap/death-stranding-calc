module Model.Input.Structure exposing (..)

import Serialize as S exposing (Codec)
import Accessors exposing (Relation, makeOneToOne)

import Model.Input.Structure.Resources
    as StructureResources
    exposing (StructureResources)
import Model.Input.Structure.Name as StructureName exposing (StructureName)

type alias StructureInput =
    { name : StructureName
    , resources : StructureResources
    , inputsVisible : Bool
    }

name : Relation StructureName reachable wrap
    -> Relation StructureInput reachable wrap
name =
    makeOneToOne
        .name
        (\change rec -> { rec | name = change rec.name })

resources : Relation StructureResources reachable wrap
    -> Relation StructureInput reachable wrap
resources =
    makeOneToOne
        .resources
        (\change rec -> { rec | resources = change rec.resources })

inputsVisible : Relation Bool reachable wrap
    -> Relation StructureInput reachable wrap
inputsVisible =
    makeOneToOne
        .inputsVisible
        (\change rec -> { rec | inputsVisible = change rec.inputsVisible })

init : Int -> StructureInput
init inc =
    { name = StructureName.fromString ("Structure " ++ String.fromInt inc)
    , resources = StructureResources.init
    , inputsVisible = True
    }

cons : StructureName -> StructureResources -> Bool -> StructureInput
cons n r i = { name = n, resources = r, inputsVisible = i }

codec : Codec e StructureInput
codec =
    S.customType
        (\e c -> e c.name c.resources c.inputsVisible)
        |> S.variant3
                cons
                StructureName.codec
                StructureResources.codec
                S.bool
        |> S.finishCustomType
