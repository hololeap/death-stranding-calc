module Msg.Structure exposing (..)

import Msg.Resource exposing (ResourceMsg)

import Resource.ChiralCrystals exposing (ChiralCrystals)
import Resource.Resins exposing (Resins)
import Resource.Metal exposing (Metal)
import Resource.Ceramics exposing (Ceramics)
import Resource.Chemicals exposing (Chemicals)
import Resource.SpecialAlloys exposing (SpecialAlloys)

type StructureMsg
    = ChiralCrystalsMsg (ResourceMsg ChiralCrystals)
    | ResinsMsg (ResourceMsg Resins)
    | MetalMsg (ResourceMsg Metal)
    | CeramicsMsg (ResourceMsg Ceramics)
    | ChemicalsMsg (ResourceMsg Chemicals)
    | SpecialAlloysMsg (ResourceMsg SpecialAlloys)
    | InputsVisibleMsg Bool
