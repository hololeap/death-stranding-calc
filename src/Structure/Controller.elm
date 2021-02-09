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
updateStructure mainMsg model =
    case mainMsg of
        ChiralCrystalsMsg msg ->
            { model
            | chiralCrystals =
                updateResource chiralCrystalsResource msg model.chiralCrystals
            }
        ResinsMsg msg ->
            { model
            | resins = updateResource resinsResource msg model.resins
            }
        MetalMsg msg ->
            { model
            | metal = updateResource metalResource msg model.metal
            }
        CeramicsMsg msg ->
            { model
            | ceramics = updateResource ceramicsResource msg model.ceramics
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
