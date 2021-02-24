module Model.Output.Total.Weight exposing (..)

import Accessors exposing (get)

import Resource.ChiralCrystals exposing (ChiralCrystals)
import Resource.Resins exposing (Resins)
import Resource.Metal exposing (Metal)
import Resource.Ceramics exposing (Ceramics)
import Resource.Chemicals exposing (Chemicals)
import Resource.SpecialAlloys exposing (SpecialAlloys)

import Resource.Types.All as AllResources exposing (AllResources)
import Resource.Types.Weight as Weight exposing (Weight)

import Model.Output.Structure as StructureOutput exposing (StructureOutput)
import Model.Output.Combined.Weight as CombinedWeight exposing (CombinedWeight)

type alias TotalWeight =
    AllResources
        (CombinedWeight ChiralCrystals)
        (CombinedWeight Resins)
        (CombinedWeight Metal)
        (CombinedWeight Ceramics)
        (CombinedWeight Chemicals)
        (CombinedWeight SpecialAlloys)

toWeight : TotalWeight -> Weight ()
toWeight = toFloat >> Weight.fromFloat

toFloat : TotalWeight -> Float
toFloat =
    let getF = get CombinedWeight.float
    in AllResources.map getF getF getF getF getF getF
        >> AllResources.fold1 (+)

generate : List StructureOutput -> TotalWeight
generate =
    let gen = CombinedWeight.generate
    in AllResources.traverse StructureOutput.toWeight
        >> AllResources.map gen gen gen gen gen gen
