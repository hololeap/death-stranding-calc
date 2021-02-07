module Structure.Controller exposing
    ( ResourceMsg(..)
    , StructureMsg(..)
    , updateStructure
    )

import Resource.Ceramics exposing (..)
import Resource.Metal exposing (..)
import Resource.Types exposing (..)
import Resource exposing (..)

import Structure.Model exposing (Structure, ResourceModel)

type ResourceMsg r
    = ChangeNeeded (Maybe Int)
    | ChangeGiven (Maybe Int)

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
    
updateResource
    : Resource r -> ResourceMsg r -> ResourceModel r -> ResourceModel r
updateResource resource msg model =
    let
        getPkgs given needed =
            packagesNeeded resource given needed
        updateModel given needed =
            let (pkgs, excess) = getPkgs given needed
            in
                { model
                | given = given
                , pkgs = pkgs
                , excess = excess
                }            
        updateGiven given = updateModel given model.needed
        updateNeeded needed = updateModel model.given needed
    in
        case msg of
            ChangeNeeded (Just needed) ->
                if needed > 0
                    then updateNeeded needed
                    else updateNeeded 0
            ChangeNeeded Nothing -> updateNeeded 0
            ChangeGiven (Just given) ->
                if given > 0
                    then updateGiven given
                    else updateGiven 0
            ChangeGiven Nothing -> updateGiven 0

