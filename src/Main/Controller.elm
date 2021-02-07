module Main.Controller exposing
    ( Msg
    , update
    )

import Dict.AutoInc as AutoIncDict exposing (AutoIncDict)
import Dict.Count as CountDict exposing (CountDict)

import Structure.Model exposing (..)
import Structure.Controller exposing (..)

import Main.Model exposing (..)

type alias Msg =
    { structureLabel : String
    , structureMsg : StructureMsg }

appendResourceCounts 
    :  ResourceModel r
    -> ResourceCounts r
    -> ResourceCounts r
appendResourceCounts model counts =
    { pkgs = CountDict.union counts.pkgs model.pkgs
    , excess = counts.excess + model.excess
    }

getTotalCounts : AutoIncDict Structure -> TotalCounts
getTotalCounts dict =
    let append struct total =
            { ceramics = appendResourceCounts struct.ceramics total.ceramics
            , metal = appendResourceCounts struct.metal total.metal
            }
    in
        List.foldl append initTotalCounts <| AutoIncDict.values dict
        
update : Msg -> Model -> Model
update msg model =
    let
        newDict =
            AutoIncDict.update
                msg.structureLabel
                (\maybeStruct ->
                    Maybe.map
                        (\struct -> updateStructure msg.structureMsg struct)
                        maybeStruct
                )
                model.structDict
        newCounts = getTotalCounts newDict
    in
        { structDict = newDict
        , totalCounts = newCounts
        }
