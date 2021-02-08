module Main.Controller exposing
    ( Msg(..)
    , update
    )

import Dict.AutoInc as AutoIncDict exposing (AutoIncDict, Key)
import Dict.Count as CountDict exposing (CountDict)

import Resource.MVC.Model exposing (ResourceModel)
import Structure.Model exposing (..)
import Structure.Controller exposing (..)

import Main.Model exposing (Model, TotalCounts, CombinedCounts, initTotalCounts)

type Msg
    = ResourceChange
        { structureKey : Key
        , structureMsg : StructureMsg }
    | AddStructure
    | RemoveStructure Key

appendResourceCounts 
    :  ResourceModel r
    -> CombinedCounts r
    -> CombinedCounts r
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
        updateCounts dict =
            { structDict = dict
            , totalCounts = getTotalCounts dict
            }
        onResourceChange change =
            AutoIncDict.update
                change.structureKey
                (Maybe.map (updateStructure change.structureMsg))
                model.structDict
        onAddStructure =
            AutoIncDict.insertNeedingKeyInc initStructure model.structDict
        onRemoveStructure label =
            AutoIncDict.remove label model.structDict
    in updateCounts (
            case msg of
                ResourceChange change -> onResourceChange change
                AddStructure -> onAddStructure
                RemoveStructure label -> onRemoveStructure label
        )
