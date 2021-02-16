module Main exposing (..)

import Browser
import Element exposing (Element, el)
import Element.Background as Background

import Resource.Ceramics exposing (..)
import Resource.Metal exposing (..)
import Resource.Types exposing (..)
import Resource exposing (..)

import Model.Main as Model
import Controller.Main exposing (..)
import View.Main exposing (..)

import Palette.Colors as Colors
import Msg.Main exposing (Msg)

body : Element Msg -> Element Msg
body = el
    [ Background.color Colors.black
    , Element.width Element.fill
    , Element.height Element.fill
    ]

main = Browser.sandbox
    { init = Model.init
    , update = update
    , view = Element.layout [] << body << view }

