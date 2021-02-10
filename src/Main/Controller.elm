module Main.Controller exposing
    ( update
    )

import Dict.AutoInc as AutoIncDict exposing (AutoIncDict, Key)
import Dict.Count as CountDict exposing (CountDict)

import Resource.MVC.Model exposing (ResourceModel)
import Resource.Types exposing (Excess(..), getExcess)
import Structure.Model exposing (..)
import Structure.Controller exposing (..)

import Types.Msg exposing (Msg(..))

import Main.Model exposing (Model, TotalCounts, CombinedCounts, initTotalCounts)

appendResourceCounts 
    :  ResourceModel r
    -> CombinedCounts r
    -> CombinedCounts r
appendResourceCounts model counts =
    { pkgs = CountDict.union counts.pkgs model.pkgs
    , excess = Excess <| getExcess counts.excess + getExcess model.excess
    }

getTotalCounts : AutoIncDict Structure -> TotalCounts
getTotalCounts dict =
    let append struct total =
            { chiralCrystals = appendResourceCounts
                struct.chiralCrystals
                total.chiralCrystals                
            , resins = appendResourceCounts struct.resins total.resins
            , metal = appendResourceCounts struct.metal total.metal
            , ceramics = appendResourceCounts struct.ceramics total.ceramics            
            , chemicals = appendResourceCounts struct.chemicals total.chemicals
            , specialAlloys = appendResourceCounts
                struct.specialAlloys
                total.specialAlloys
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
