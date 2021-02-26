module Model exposing (Model, init)

import Browser.Navigation as Nav
import Url exposing (Url)

import Model.Input as ModelInput exposing (ModelInput)
import Model.Output as ModelOutput exposing (ModelOutput)

import Msg exposing (Msg)

type alias Model =
    { input : ModelInput
    , output : ModelOutput
    , navKey : Nav.Key
    }

init : flags -> Url -> Nav.Key -> (Model, Cmd Msg)
init _ url navKey =
    let
        input =
            case ModelInput.decodeUrl url of
                Nothing -> ModelInput.init
                Just modelInput -> modelInput
        model =
            { input = input
            , output = ModelOutput.generate input
            , navKey = navKey
            }
    in (model, ModelInput.updateUrl navKey input)
