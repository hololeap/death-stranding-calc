module Model.Output.Total.Excess exposing (..)

import Resource.ChiralCrystals exposing (ChiralCrystals)
import Resource.Resins exposing (Resins)
import Resource.Metal exposing (Metal)
import Resource.Ceramics exposing (Ceramics)
import Resource.Chemicals exposing (Chemicals)
import Resource.SpecialAlloys exposing (SpecialAlloys)

import Resource.Types.All as AllResources
    exposing (AllResources)

--import Model.Output.Resource as ResourceOutput
import Model.Output.Structure as StructureOutput exposing (StructureOutput)
import Model.Output.Combined.Excess as CombinedExcess exposing (CombinedExcess)

type alias TotalExcess =
    AllResources
        (CombinedExcess ChiralCrystals)
        (CombinedExcess Resins)
        (CombinedExcess Metal)
        (CombinedExcess Ceramics)
        (CombinedExcess Chemicals)
        (CombinedExcess SpecialAlloys)

generate : List StructureOutput -> TotalExcess
generate =
    let gen = CombinedExcess.generate
    in AllResources.traverse StructureOutput.toExcess
        >> AllResources.map gen gen gen gen gen gen
