module Model exposing (Model, init)

import Browser.Navigation as Nav
import Url exposing (Url)
import Url.Parser as Parser
import Url.Parser.Query as QueryP

import Model.Input as ModelInput exposing (ModelInput)
import Model.Output as ModelOutput exposing (ModelOutput)

type alias Model =
    { input : ModelInput
    , output : ModelOutput
    , navKey : Nav.Key
    }

init : flags -> Url -> Nav.Key -> (Model, Cmd msg)
init _ url navKey =
    let
        input = ModelInput.decodeUrl url
            |> Maybe.withDefault ModelInput.init
        model =
            { input = input
            , output = ModelOutput.generate input
            , navKey = navKey
            }
    in (model, Cmd.none)
