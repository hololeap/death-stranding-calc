module Resource.MVC.Controller exposing (..)

import Resource exposing (packagesNeeded)
import Resource.Types exposing (Resource)
import Resource.MVC.Model exposing (ResourceModel)

-- Events for changing state on a ResourceModel
type ResourceMsg r
    = ChangeNeeded (Maybe Int)
    | ChangeGiven (Maybe Int)

updateResource
    : Resource r -> ResourceMsg r -> ResourceModel r -> ResourceModel r
updateResource resource msg model =
    let
        updateModel given needed =
            let (pkgs, excess) = packagesNeeded resource given needed
            in
                { given = given
                , needed = needed
                , pkgs = pkgs
                , excess = excess
                }            
        updateGiven given = updateModel given model.needed
        updateNeeded needed = updateModel model.given needed
        verifyNum maybeNum =
            let num = Maybe.withDefault 0 maybeNum
            in if num > 0 then num else 0
    in
        case msg of
            ChangeNeeded maybeNeeded ->
                updateNeeded <| verifyNum maybeNeeded
            ChangeGiven maybeGiven ->
                updateGiven <| verifyNum maybeGiven
