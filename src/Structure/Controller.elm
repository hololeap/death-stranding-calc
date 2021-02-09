module Structure.Controller exposing
    ( updateStructure
    )

import Dict.AutoInc as AutoIncDict    
   
import Resource.ChiralCrystals exposing (chiralCrystalsResource)
import Resource.Ceramics exposing (ceramicsResource)
import Resource.Metal exposing (metalResource)
import Resource.Resins exposing (resinsResource)
import Resource.Chemicals exposing (chemicalsResource)
import Resource.SpecialAlloys exposing (specialAlloysResource)
import Resource.Types exposing (..)
import Resource exposing (..)

import Resource.MVC.Controller exposing (updateResource)

import Structure.Model exposing (Structure)

import Types.Msg exposing (StructureMsg(..))

updateStructure : StructureMsg -> Structure -> Structure
updateStructure mainMsg model =
    case mainMsg of
        ChiralCrystalsMsg msg ->
            { model
            | chiralCrystals =
                updateResource chiralCrystalsResource msg model.chiralCrystals
            }
        CeramicsMsg msg ->
            { model
            | ceramics = updateResource ceramicsResource msg model.ceramics
            }
        MetalMsg msg ->
            { model
            | metal = updateResource metalResource msg model.metal
            }
        ResinsMsg msg ->
            { model
            | resins = updateResource resinsResource msg model.resins
            }
        ChemicalsMsg msg ->
            { model
            | chemicals = updateResource chemicalsResource msg model.chemicals
            }
        SpecialAlloysMsg msg ->
            { model
            | specialAlloys =
                updateResource specialAlloysResource msg model.specialAlloys
            }
