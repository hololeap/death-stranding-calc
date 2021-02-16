module Model.Structure exposing
    ( Structure
    , initStructure
    , structurePackageCounts
    )

import Dict.AutoInc as AutoIncDict
import Dict.Count as CountDict

import Resource exposing (PackageCountsAll)
import Resource.ChiralCrystals exposing (ChiralCrystals, chiralCrystalsResource)
import Resource.Resins exposing (Resins, resinsResource)
import Resource.Metal exposing (Metal, metalResource)
import Resource.Ceramics exposing (Ceramics, ceramicsResource)
import Resource.Chemicals exposing (Chemicals, chemicalsResource)
import Resource.SpecialAlloys exposing (SpecialAlloys, specialAlloysResource)
import Resource.Types exposing (..)

import Model.Resource exposing (ResourceModel, initResourceModel)

import Model.Structure.Rename exposing (StructureName(..))

type alias Structure =
    { name : StructureName
    , key : AutoIncDict.Key
    , chiralCrystals : ResourceModel ChiralCrystals
    , resins : ResourceModel Resins
    , metal : ResourceModel Metal
    , ceramics : ResourceModel Ceramics
    , chemicals : ResourceModel Chemicals
    , specialAlloys : ResourceModel SpecialAlloys
    , inputsVisible : Bool
    }

initStructure : Int -> AutoIncDict.Key -> Structure
initStructure inc key =
    { name = StructureName ("Structure " ++ String.fromInt inc)
    , key = key
    , chiralCrystals = initResourceModel chiralCrystalsResource
    , resins = initResourceModel resinsResource
    , metal = initResourceModel metalResource
    , ceramics = initResourceModel ceramicsResource
    , chemicals = initResourceModel chemicalsResource
    , specialAlloys = initResourceModel specialAlloysResource
    , inputsVisible = True
    }

structurePackageCounts : Structure -> PackageCountsAll
structurePackageCounts struct =
    { chiralCrystals = struct.chiralCrystals.pkgs
    , resins = struct.resins.pkgs
    , metal = struct.metal.pkgs
    , ceramics = struct.ceramics.pkgs
    , chemicals = struct.chemicals.pkgs
    , specialAlloys = struct.specialAlloys.pkgs
    }
