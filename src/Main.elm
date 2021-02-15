module Main exposing (..)

import Browser
import Element exposing (Element, el)
import Element.Background as Background

import Resource.Ceramics exposing (..)
import Resource.Metal exposing (..)
import Resource.Types exposing (..)
import Resource exposing (..)

import Main.Model exposing (..)
import Main.Controller exposing (..)
import Main.View exposing (..)

import Palette.Colors as Colors
import Types.Msg exposing (Msg)

body : Element Msg -> Element Msg
body = el
    [ Background.color Colors.black
    , Element.width Element.fill
    , Element.height Element.fill
    ]

main = Browser.sandbox
    { init = init
    , update = update
    , view = Element.layout [] << body << view }

