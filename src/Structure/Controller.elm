module Structure.Controller exposing
    ( updateStructure
    )

import Dict.AutoInc as AutoIncDict

import Resource.ChiralCrystals exposing (chiralCrystalsResource)
import Resource.Resins exposing (resinsResource)
import Resource.Metal exposing (metalResource)
import Resource.Ceramics exposing (ceramicsResource)
import Resource.Chemicals exposing (chemicalsResource)
import Resource.SpecialAlloys exposing (specialAlloysResource)
import Resource.Types exposing (..)
import Resource exposing (..)

import Resource.MVC.Controller exposing (updateResource)

import Structure.Model exposing (Structure)

import Types.Msg exposing (StructureMsg(..))

updateStructure : StructureMsg -> Structure -> Structure
updateStructure mainMsg struct =
    let updateRes resource msg selector =
            updateResource resource msg (selector struct)
    in
        case mainMsg of
            ChiralCrystalsMsg msg ->
                { struct
                | chiralCrystals =
                    updateRes chiralCrystalsResource msg .chiralCrystals
                }
            ResinsMsg msg ->
                { struct
                | resins = updateRes resinsResource msg .resins
                }
            MetalMsg msg ->
                { struct
                | metal = updateRes metalResource msg .metal
                }
            CeramicsMsg msg ->
                { struct
                | ceramics = updateRes ceramicsResource msg .ceramics
                }
            ChemicalsMsg msg ->
                { struct
                | chemicals = updateRes chemicalsResource msg .chemicals
                }
            SpecialAlloysMsg msg ->
                { struct
                | specialAlloys =
                    updateRes specialAlloysResource msg .specialAlloys
                }
            InputsVisibleMsg bool ->
                { struct
                | inputsVisible = bool
                }
