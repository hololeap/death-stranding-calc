module Msg.Resource exposing (ResourceMsg(..))

-- Events for changing state on a ResourceModel
type ResourceMsg r
    = ChangeNeeded String
    | ChangeGiven String
    | ResetNeeded
    | ResetGiven
