module Model.Output exposing (..)

import Accessors exposing (Relation, makeOneToOne)

import Dict.AutoInc as AutoIncDict exposing (AutoIncDict)
import Model.Output.Structure as StructureOutput exposing (StructureOutput)
import Model.Output.Total.Counts as TotalCounts exposing (TotalCounts)
import Model.Output.Total.Excess as TotalExcess exposing (TotalExcess)
import Model.Output.Total.Weight as TotalWeight exposing (TotalWeight)

import Model.Input exposing (ModelInput)

type alias ModelOutput =
    { structures : AutoIncDict StructureOutput
    , packages : TotalCounts
    , excess : TotalExcess
    , weight : TotalWeight
    }

structures : Relation (AutoIncDict StructureOutput) reachable wrap
    -> Relation ModelOutput reachable wrap
structures =
    makeOneToOne
        .structures
        (\change rec -> { rec | structures = change rec.structures })

packages : Relation TotalCounts reachable wrap
    -> Relation ModelOutput reachable wrap
packages =
    makeOneToOne
        .packages
        (\change rec -> { rec | packages = change rec.packages })

excess : Relation TotalExcess reachable wrap
    -> Relation ModelOutput reachable wrap
excess =
    makeOneToOne
        .excess
        (\change rec -> { rec | excess = change rec.excess })

weight : Relation TotalWeight reachable wrap
    -> Relation ModelOutput reachable wrap
weight =
    makeOneToOne
        .weight
        (\change rec -> { rec | weight = change rec.weight })

cons : (AutoIncDict StructureOutput)
    -> TotalCounts
    -> TotalExcess
    -> TotalWeight
    -> ModelOutput
cons s p e w = {structures = s, packages = p, excess = e, weight = w}

generate : ModelInput -> ModelOutput
generate inputDict =
    let
        structDict = AutoIncDict.map (\_ -> StructureOutput.generate) inputDict
        structs = AutoIncDict.values structDict
    in
        { structures = structDict
        , packages = TotalCounts.generate structs
        , excess = TotalExcess.generate structs
        , weight = TotalWeight.generate structs
        }
