module Main exposing (..)

import Browser
import Html exposing (Html, Attribute, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

import Resource.Ceramics exposing (..)
import Resource.Metal exposing (..)
import Resource.Types exposing (..)
import Resource exposing (..)

import Main.Model exposing (..)
import Main.Controller exposing (..)
import Main.View exposing (..)

main =
    Browser.sandbox { init = init, update = update, view = view }

