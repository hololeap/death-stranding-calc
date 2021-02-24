module Model.Input.Structure.Resources exposing (..)

import Serialize exposing (Codec)

import Resource.ChiralCrystals exposing (ChiralCrystals)
import Resource.Resins exposing (Resins)
import Resource.Metal exposing (Metal)
import Resource.Ceramics exposing (Ceramics)
import Resource.Chemicals exposing (Chemicals)
import Resource.SpecialAlloys exposing (SpecialAlloys)

import Resource.Types.All as AllResources exposing (AllResources)
import Model.Input.Resource as ResourceInput exposing (ResourceInput)

type alias StructureResources =
    AllResources
        (ResourceInput ChiralCrystals)
        (ResourceInput Resins)
        (ResourceInput Metal)
        (ResourceInput Ceramics)
        (ResourceInput Chemicals)
        (ResourceInput SpecialAlloys)

init : StructureResources
init =
    { chiralCrystals = ResourceInput.init
    , resins = ResourceInput.init
    , metal = ResourceInput.init
    , ceramics = ResourceInput.init
    , chemicals = ResourceInput.init
    , specialAlloys = ResourceInput.init
    }

codec : Codec e StructureResources
codec = AllResources.codec
    (ResourceInput.codec)
    (ResourceInput.codec)
    (ResourceInput.codec)
    (ResourceInput.codec)
    (ResourceInput.codec)
    (ResourceInput.codec)
