module Model.Output.Resource exposing (..)

import Accessors exposing (Relation, makeOneToOne, get)

import Resource.Types exposing (Resource)
import Resource.Types.PackageCounts exposing (PackageCounts)
import Resource.Types.Excess exposing (Excess)

import Model.Input.Resource as ResourceInput exposing (ResourceInput)

import Resource exposing (packagesNeeded, resourceWeight)
import Resource.Types exposing (Resource)
import Resource.Types.Weight exposing (Weight)

type alias ResourceOutput r =
    { packages : PackageCounts r
    , excess : Excess r
    , weight : Weight r
    }

packages : Relation (PackageCounts r) reachable wrap
    -> Relation (ResourceOutput r) reachable wrap
packages =
    makeOneToOne
        .packages
        (\change rec -> { rec | packages = change rec.packages })

excess : Relation (Excess r) reachable wrap
    -> Relation (ResourceOutput r) reachable wrap
excess =
    makeOneToOne
        .excess
        (\change rec -> { rec | excess = change rec.excess })

weight : Relation (Weight r) reachable wrap
    -> Relation (ResourceOutput r) reachable wrap
weight =
    makeOneToOne
        .weight
        (\change rec -> { rec | weight = change rec.weight })

cons : PackageCounts r -> Excess r -> Weight r -> ResourceOutput r
cons p e w = { packages = p, excess = e, weight = w}

generate : Resource r -> ResourceInput r -> ResourceOutput r
generate resource input =
    let (p, e) =
            packagesNeeded
                resource
                (get ResourceInput.given input)
                (get ResourceInput.needed input)
    in cons p e (resourceWeight resource p)
