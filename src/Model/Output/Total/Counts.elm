module Model.Output.Total.Counts exposing (..)

import Accessors as A

import Resource.ChiralCrystals exposing (ChiralCrystals)
import Resource.Resins exposing (Resins)
import Resource.Metal exposing (Metal)
import Resource.Ceramics exposing (Ceramics)
import Resource.Chemicals exposing (Chemicals)
import Resource.SpecialAlloys exposing (SpecialAlloys)

import Resource.Types.All as AllResources
    exposing (AllResources, PackageCountsAll)
--import Resource.Types.PackageCounts as PackageCounts

--import Model.Output.Resource as ResourceOutput
import Model.Output.Structure as StructureOutput exposing (StructureOutput)
import Model.Output.Combined.Counts
    as CombinedCounts
    exposing (CombinedCounts)

type alias TotalCounts =
    AllResources
        (CombinedCounts ChiralCrystals)
        (CombinedCounts Resins)
        (CombinedCounts Metal)
        (CombinedCounts Ceramics)
        (CombinedCounts Chemicals)
        (CombinedCounts SpecialAlloys)

toPackageCountsAll : TotalCounts -> PackageCountsAll
toPackageCountsAll =
    let pc = A.get CombinedCounts.packageCounts
    in AllResources.map pc pc pc pc pc pc

generate : List StructureOutput -> TotalCounts
generate =
    let gen = CombinedCounts.generate
    in AllResources.traverse StructureOutput.toPackages
        >> AllResources.mapWithResource gen gen gen gen gen gen
