module Structure.Controller exposing
    ( updateStructure
    )

import Dict.AutoInc as AutoIncDict    
    
import Resource.Ceramics exposing (..)
import Resource.Metal exposing (..)
import Resource.Types exposing (..)
import Resource exposing (..)

import Resource.MVC.Controller exposing (updateResource)

import Structure.Model exposing (Structure)

import Types.Msg exposing (StructureMsg(..))

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
