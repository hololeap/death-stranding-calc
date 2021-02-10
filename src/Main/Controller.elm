module Main.Controller exposing
    ( update
    )

import Dict.AutoInc as AutoIncDict exposing (AutoIncDict, Key)
import Dict.Count as CountDict exposing (CountDict)

import Resource.MVC.Model exposing (ResourceModel)
import Resource.Types exposing (Excess(..), getExcess)
import Structure.Model exposing (..)
import Structure.Controller exposing (..)
import Structure.Rename.Controller exposing (renameStructure)

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
            updateCounts
            <| AutoIncDict.update
                change.structureKey
                (Maybe.map (updateStructure change.structureMsg))
                model.structDict
        onAddStructure = 
            updateCounts
            <| AutoIncDict.insertNeedingKeyInc initStructure model.structDict
        onRemoveStructure key = 
            updateCounts
            <| AutoIncDict.remove key model.structDict
        doRename renameMsg struct =
            { struct
            | name = renameStructure renameMsg struct.name
            }
        onRenameStructure key renameMsg = 
            { model
            | structDict = 
                AutoIncDict.update
                    key
                    (Maybe.map (doRename renameMsg))
                    model.structDict
            }
    in 
        case msg of
            ResourceChange change -> onResourceChange change
            AddStructure -> onAddStructure
            RemoveStructure key -> onRemoveStructure key
            RenameStructure key renameMsg -> onRenameStructure key renameMsg
