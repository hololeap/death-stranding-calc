module Model.Output.Structure exposing (..)

import Accessors as A

import Resource.ChiralCrystals exposing (ChiralCrystals)
import Resource.Resins exposing (Resins)
import Resource.Metal exposing (Metal)
import Resource.Ceramics exposing (Ceramics)
import Resource.Chemicals exposing (Chemicals)
import Resource.SpecialAlloys exposing (SpecialAlloys)

import Resource.Types.All
    as AllResources
    exposing (AllResources, PackageCountsAll, ExcessAll, WeightAll)

import Model.Output.Resource as ResourceOutput exposing (ResourceOutput)
import Model.Input.Structure as StructureInput exposing (StructureInput)

type alias StructureOutput =
    AllResources
        (ResourceOutput ChiralCrystals)
        (ResourceOutput Resins)
        (ResourceOutput Metal)
        (ResourceOutput Ceramics)
        (ResourceOutput Chemicals)
        (ResourceOutput SpecialAlloys)

toPackages : StructureOutput -> PackageCountsAll
toPackages =
    let get = A.get ResourceOutput.packages
    in AllResources.map get get get get get get

toExcess : StructureOutput -> ExcessAll
toExcess =
    let get = A.get ResourceOutput.excess
    in AllResources.map get get get get get get

toWeight : StructureOutput -> WeightAll
toWeight =
    let get = A.get ResourceOutput.weight
    in AllResources.map get get get get get get

generate : StructureInput -> StructureOutput
generate =
    let gen = ResourceOutput.generate
    in A.get StructureInput.resources
        >> AllResources.mapWithResource gen gen gen gen gen gen
