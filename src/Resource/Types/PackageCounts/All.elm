module Resource.Types.PackageCounts.All exposing
    ( PackageCountsAll
    , init
    , codec
    )

import Serialize as S exposing (Codec)

import Dict.Count as CountDict

import Resource.Types.PackageCounts as PackageCounts exposing (PackageCounts)

import Resource.ChiralCrystals as ChiralCrystals exposing (ChiralCrystals)
import Resource.Resins as Resins exposing (Resins)
import Resource.Metal as Metal exposing (Metal)
import Resource.Ceramics as Ceramics exposing (Ceramics)
import Resource.Chemicals as Chemicals exposing (Chemicals)
import Resource.SpecialAlloys as SpecialAlloys exposing (SpecialAlloys)

type alias PackageCountsAll =
    { chiralCrystals : PackageCounts ChiralCrystals
    , resins : PackageCounts Resins
    , metal : PackageCounts Metal
    , ceramics : PackageCounts Ceramics
    , chemicals : PackageCounts Chemicals
    , specialAlloys : PackageCounts SpecialAlloys
    }

init : PackageCountsAll
init =
    { chiralCrystals = PackageCounts.init ChiralCrystals.resource
    , resins = PackageCounts.init Resins.resource
    , metal = PackageCounts.init Metal.resource
    , ceramics = PackageCounts.init Ceramics.resource
    , chemicals = PackageCounts.init Chemicals.resource
    , specialAlloys = PackageCounts.init SpecialAlloys.resource
    }

codec : Codec e PackageCountsAll
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
                    (PackageCounts.codec ChiralCrystals.resource)
                    (PackageCounts.codec Resins.resource)
                    (PackageCounts.codec Metal.resource)
                    (PackageCounts.codec Ceramics.resource)
                    (PackageCounts.codec Chemicals.resource)
                    (PackageCounts.codec SpecialAlloys.resource)
            |> S.finishCustomType
