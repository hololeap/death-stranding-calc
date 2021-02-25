module Msg exposing (..)

import Browser
import Url exposing (Url)

import Dict.AutoInc as AutoIncDict
import Msg.Structure exposing (StructureMsg)

type Msg
    = ResourceChange
        { structureKey : AutoIncDict.Key
        , structureMsg : StructureMsg }
    | AddStructure
    | RemoveStructure AutoIncDict.Key
    | UrlRequestMsg Browser.UrlRequest
    | UrlChangeMsg Url

fromStructureMsg : AutoIncDict.Key -> StructureMsg -> Msg
fromStructureMsg key msg =
    ResourceChange
        { structureKey = key
        , structureMsg = msg
        }
