module Structure.Model exposing
    ( Structure
    , StructureName
    , initStructure
    )
    
import Dict.AutoInc as AutoIncDict
import Dict.Count as CountDict

import Resource.ChiralCrystals exposing (ChiralCrystals, chiralCrystalsResource)
import Resource.Resins exposing (Resins, resinsResource)
import Resource.Metal exposing (Metal, metalResource)
import Resource.Ceramics exposing (Ceramics, ceramicsResource)
import Resource.Chemicals exposing (Chemicals, chemicalsResource)
import Resource.SpecialAlloys exposing (SpecialAlloys, specialAlloysResource)
import Resource.Types exposing (..)

import Resource.MVC.Model exposing (ResourceModel, initResourceModel)

type alias StructureName = String

type alias Structure =
    { name : StructureName
    , key : AutoIncDict.Key
    , chiralCrystals : ResourceModel ChiralCrystals
    , resins : ResourceModel Resins
    , metal : ResourceModel Metal
    , ceramics : ResourceModel Ceramics
    , chemicals : ResourceModel Chemicals
    , specialAlloys : ResourceModel SpecialAlloys
    }
    
initStructure : Int -> AutoIncDict.Key -> Structure
initStructure inc key =
    { name = "Structure " ++ String.fromInt inc
    , key = key
    , chiralCrystals = initResourceModel chiralCrystalsResource
    , resins = initResourceModel resinsResource
    , metal = initResourceModel metalResource
    , ceramics = initResourceModel ceramicsResource    
    , chemicals = initResourceModel chemicalsResource
    , specialAlloys = initResourceModel specialAlloysResource
    }
