module Model.Main.TotalCounts exposing (..)

import Serialize as S exposing (Codec)

import Dict.Count as CountDict exposing (CountDict)

import Resource.ChiralCrystals as ChiralCrystals exposing (ChiralCrystals)
import Resource.Resins as Resins exposing (Resins)
import Resource.Metal as Metal exposing (Metal)
import Resource.Ceramics as Ceramics exposing (Ceramics)
import Resource.Chemicals as Chemicals exposing (Chemicals)
import Resource.SpecialAlloys as SpecialAlloys exposing (SpecialAlloys)

import Resource.Types.PackageCounts.All exposing (PackageCountsAll)
import Model.Main.CombinedCounts as CombinedCounts exposing (CombinedCounts)

type alias TotalCounts =
    { chiralCrystals : CombinedCounts ChiralCrystals
    , resins : CombinedCounts Resins
    , metal : CombinedCounts Metal
    , ceramics : CombinedCounts Ceramics
    , chemicals : CombinedCounts Chemicals
    , specialAlloys : CombinedCounts SpecialAlloys
    }

init : TotalCounts
init =
    { chiralCrystals = CombinedCounts.init ChiralCrystals.resource
    , resins = CombinedCounts.init Resins.resource
    , metal = CombinedCounts.init Metal.resource
    , ceramics = CombinedCounts.init Ceramics.resource
    , chemicals = CombinedCounts.init Chemicals.resource
    , specialAlloys = CombinedCounts.init SpecialAlloys.resource
    }

toPackageCountsAll : TotalCounts -> PackageCountsAll
toPackageCountsAll totalCounts =
    { chiralCrystals = totalCounts.chiralCrystals.pkgs
    , resins = totalCounts.resins.pkgs
    , metal = totalCounts.metal.pkgs
    , ceramics = totalCounts.ceramics.pkgs
    , chemicals = totalCounts.chemicals.pkgs
    , specialAlloys = totalCounts.specialAlloys.pkgs
    }

codec : Codec e TotalCounts
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
                    (CombinedCounts.codec ChiralCrystals.resource)
                    (CombinedCounts.codec Resins.resource)
                    (CombinedCounts.codec Metal.resource)
                    (CombinedCounts.codec Ceramics.resource)
                    (CombinedCounts.codec Chemicals.resource)
                    (CombinedCounts.codec SpecialAlloys.resource)
            |> S.finishCustomType
