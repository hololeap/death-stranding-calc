module Structure.Controller exposing
    ( StructureMsg(..)
    , updateStructure
    )

import Resource.Ceramics exposing (..)
import Resource.Metal exposing (..)
import Resource.Types exposing (..)
import Resource exposing (..)

import Resource.MVC.Controller exposing (ResourceMsg, updateResource)

import Structure.Model exposing (Structure)

type StructureMsg
    = CeramicsMsg (ResourceMsg Ceramics)
    | MetalMsg (ResourceMsg Metal)

updateStructure : StructureMsg -> Structure -> Structure
updateStructure mainMsg model =
    case mainMsg of
        CeramicsMsg msg ->
            { model
            | ceramics = updateResource ceramicsResource msg model.ceramics
            }
        MetalMsg msg ->
            { model
            | metal = updateResource metalResource msg model.metal
            }
