module Main exposing (..)

import Browser
import Element

import Resource.Ceramics exposing (..)
import Resource.Metal exposing (..)
import Resource.Types exposing (..)
import Resource exposing (..)

import Main.Model exposing (..)
import Main.Controller exposing (..)
import Main.View exposing (..)

main = Browser.sandbox
    { init = init
    , update = update
    , view = Element.layout [] << view }

