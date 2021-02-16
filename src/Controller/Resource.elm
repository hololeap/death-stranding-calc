module Controller.Resource exposing (..)

import Resource exposing (packagesNeeded)
import Resource.Types exposing (Resource)
import Model.Resource exposing (ResourceModel)

import Msg.Resource exposing (ResourceMsg(..))
import Resource.Types.Given as ResourceGiven
import Resource.Types.NeededTotal as ResourceNeededTotal

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
    in
        case msg of
            ChangeNeeded needed -> updateNeeded needed
            ChangeGiven given -> updateGiven given
            ResetNeeded -> updateNeeded ResourceNeededTotal.init
            ResetGiven -> updateGiven ResourceGiven.init
