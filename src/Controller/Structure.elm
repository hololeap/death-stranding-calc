module Controller.Structure exposing (updateStructure)

import Dict.AutoInc as AutoIncDict

import Resource.ChiralCrystals as ChiralCrystals
import Resource.Resins as Resins
import Resource.Metal as Metal
import Resource.Ceramics as Ceramics
import Resource.Chemicals as Chemicals
import Resource.SpecialAlloys as SpecialAlloys
import Resource.Types exposing (..)
import Resource exposing (..)

import Controller.Resource exposing (updateResource)

import Model.Structure exposing (Structure)

import Msg.Structure exposing (StructureMsg(..))

updateStructure : StructureMsg -> Structure -> Structure
updateStructure mainMsg struct =
    let resources = struct.resources
        updateRes resource msg selector =
            updateResource resource msg (selector resources)
        updateStructRes r =
            { struct
            | resources = r
            }
    in
        case mainMsg of
            ChiralCrystalsMsg msg -> updateStructRes <|
                { resources
                | chiralCrystals =
                    updateRes ChiralCrystals.resource msg .chiralCrystals
                }
            ResinsMsg msg -> updateStructRes <|
                { resources
                | resins = updateRes Resins.resource msg .resins
                }
            MetalMsg msg -> updateStructRes <|
                { resources
                | metal = updateRes Metal.resource msg .metal
                }
            CeramicsMsg msg -> updateStructRes <|
                { resources
                | ceramics = updateRes Ceramics.resource msg .ceramics
                }
            ChemicalsMsg msg -> updateStructRes <|
                { resources
                | chemicals = updateRes Chemicals.resource msg .chemicals
                }
            SpecialAlloysMsg msg -> updateStructRes <|
                { resources
                | specialAlloys =
                    updateRes SpecialAlloys.resource msg .specialAlloys
                }
            InputsVisibleMsg bool ->
                { struct
                | inputsVisible = bool
                }
