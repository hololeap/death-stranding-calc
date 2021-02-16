module Controller.Main exposing (update)

import Dict.AutoInc as AutoIncDict exposing (AutoIncDict, Key)
import Dict.Count as CountDict exposing (CountDict)

import Model.Resource exposing (ResourceModel)
import Resource.Types.Excess as Excess exposing (Excess)
import Model.Structure as Structure exposing (Structure)
import Controller.Structure exposing (updateStructure)
import Controller.Structure.Name exposing (renameStructure)

import Msg.Main exposing (Msg(..))

import Model.Main exposing (Model)
import Model.Main.TotalCounts as TotalCounts exposing (TotalCounts)
import Model.Main.CombinedCounts exposing (CombinedCounts)

appendResourceCounts
    :  ResourceModel r
    -> CombinedCounts r
    -> CombinedCounts r
appendResourceCounts model counts =
    { pkgs = CountDict.union counts.pkgs model.pkgs
    , excess = Excess.fromInt
        <| Excess.toInt counts.excess + Excess.toInt model.excess
    }

getTotalCounts : AutoIncDict Structure -> TotalCounts
getTotalCounts dict =
    let append struct total =
            { chiralCrystals = appendResourceCounts
                struct.resources.chiralCrystals
                total.chiralCrystals
            , resins = appendResourceCounts
                struct.resources.resins
                total.resins
            , metal = appendResourceCounts
                struct.resources.metal
                total.metal
            , ceramics = appendResourceCounts
                struct.resources.ceramics
                total.ceramics
            , chemicals = appendResourceCounts
                struct.resources.chemicals
                total.chemicals
            , specialAlloys = appendResourceCounts
                struct.resources.specialAlloys
                total.specialAlloys
            }
    in
        List.foldl append TotalCounts.init <| AutoIncDict.values dict

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
            <| AutoIncDict.insertNeedingKeyInc Structure.init model.structDict
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
