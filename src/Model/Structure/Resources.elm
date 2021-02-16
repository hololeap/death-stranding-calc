module Model.Structure.Resources exposing (..)

import Serialize as S exposing (Codec)

import Resource.ChiralCrystals as ChiralCrystals exposing (ChiralCrystals)
import Resource.Resins as Resins exposing (Resins)
import Resource.Metal as Metal exposing (Metal)
import Resource.Ceramics as Ceramics exposing (Ceramics)
import Resource.Chemicals as Chemicals exposing (Chemicals)
import Resource.SpecialAlloys as SpecialAlloys exposing (SpecialAlloys)

import Resource.Types.PackageCounts.All exposing (PackageCountsAll)

import Model.Resource as ResourceModel exposing (ResourceModel)

type alias StructureResources =
    { chiralCrystals : ResourceModel ChiralCrystals
    , resins : ResourceModel Resins
    , metal : ResourceModel Metal
    , ceramics : ResourceModel Ceramics
    , chemicals : ResourceModel Chemicals
    , specialAlloys : ResourceModel SpecialAlloys
    }

toPackageCountsAll : StructureResources -> PackageCountsAll
toPackageCountsAll struct =
    { chiralCrystals = struct.chiralCrystals.pkgs
    , resins = struct.resins.pkgs
    , metal = struct.metal.pkgs
    , ceramics = struct.ceramics.pkgs
    , chemicals = struct.chemicals.pkgs
    , specialAlloys = struct.specialAlloys.pkgs
    }

init : StructureResources
init =
    { chiralCrystals = ResourceModel.init ChiralCrystals.resource
    , resins = ResourceModel.init Resins.resource
    , metal = ResourceModel.init Metal.resource
    , ceramics = ResourceModel.init Ceramics.resource
    , chemicals = ResourceModel.init Chemicals.resource
    , specialAlloys = ResourceModel.init SpecialAlloys.resource
    }

codec : Codec e StructureResources
codec =
    let cons chi res met cer che spe =
            { chiralCrystals = chi
            , resins = res
            , metal = met
            , ceramics = cer
            , chemicals = che
            , specialAlloys = spe
            }
    in
        S.customType
            (\e c -> e c.chiralCrystals
                        c.resins
                        c.metal
                        c.ceramics
                        c.chemicals
                        c.specialAlloys
            )
            |> S.variant6
                    cons
                    (ResourceModel.codec ChiralCrystals.resource)
                    (ResourceModel.codec Resins.resource)
                    (ResourceModel.codec Metal.resource)
                    (ResourceModel.codec Ceramics.resource)
                    (ResourceModel.codec Chemicals.resource)
                    (ResourceModel.codec SpecialAlloys.resource)
            |> S.finishCustomType
