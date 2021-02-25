module Main exposing (..)

import Browser
import Element exposing (Element, el)
import Element.Background as Background

import Model exposing (Model)
import Controller exposing (update)
import View exposing (view)

import Palette.Colors as Colors
import Msg exposing (Msg(..))

body : Element Msg -> Element Msg
body = el
    [ Background.color Colors.black
    , Element.width Element.fill
    , Element.height Element.fill
    ]

document : Element Msg -> Browser.Document Msg
document myView =
    { title = "Death Stranding Structure Calc"
    , body = [Element.layout [] (body myView)]
    }

main : Program () Model Msg
main = Browser.application
    { init = Model.init
    , view = document << view
    , update = update
    , subscriptions = (\_ -> Sub.none)
    , onUrlRequest = UrlRequestMsg
    , onUrlChange = UrlChangeMsg
    }

