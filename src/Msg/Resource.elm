module Msg.Resource exposing (ResourceMsg(..))

import Resource.Types.NeededTotal exposing (ResourceNeededTotal)
import Resource.Types.Given exposing (ResourceGiven)

-- Events for changing state on a ResourceModel
type ResourceMsg r
    = ChangeNeeded (ResourceNeededTotal)
    | ChangeGiven (ResourceGiven)
    | ResetNeeded
    | ResetGiven
