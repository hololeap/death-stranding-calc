module Main exposing (..)

import Browser
import Element exposing (Element, el)
import Element.Background as Background

import Model exposing (Model)
import Controller exposing (update)
import View exposing (view)

import Palette.Colors as Colors
import Msg exposing (Msg)

body : Element Msg -> Element Msg
body = el
    [ Background.color Colors.black
    , Element.width Element.fill
    , Element.height Element.fill
    ]

main : Program () Model Msg
main = Browser.sandbox
    { init = Model.init
    , update = update
    , view = Element.layout [] << body << view }

