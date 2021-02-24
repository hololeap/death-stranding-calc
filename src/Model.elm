module Model exposing (..)

import Model.Input as ModelInput exposing (ModelInput)
import Model.Output as ModelOutput exposing (ModelOutput)

type alias Model =
    { input : ModelInput
    , output : ModelOutput
    }

init : Model
init =
    let input = ModelInput.init
    in
        { input = input
        , output = ModelOutput.generate input
        }
