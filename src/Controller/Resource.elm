module Controller.Resource exposing (..)

import Accessors as A
import Model.Input.Resource as ResourceInput exposing (ResourceInput)

import Msg.Resource exposing (ResourceMsg(..))
import Resource.Types.Given as ResourceGiven
import Resource.Types.NeededTotal as ResourceNeededTotal

update : ResourceMsg r -> ResourceInput r -> ResourceInput r
update msg =
    case msg of
        ChangeNeeded needed ->
            A.set ResourceInput.needed (ResourceNeededTotal.fromString needed)
        ChangeGiven given ->
            A.set ResourceInput.given (ResourceGiven.fromString given)
        ResetNeeded -> A.set ResourceInput.needed ResourceNeededTotal.init
        ResetGiven -> A.set ResourceInput.given ResourceGiven.init
