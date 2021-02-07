module Main.Controller exposing
    ( Msg(..)
    , update
    )

import Dict.AutoInc as AutoIncDict exposing (AutoIncDict)
import Dict.Count as CountDict exposing (CountDict)

import Structure.Model exposing (..)
import Structure.Controller exposing (..)

import Main.Model exposing (..)

type Msg
    = ResourceChange
        { structureLabel : String
        , structureMsg : StructureMsg }
    | AddStructure
    | RemoveStructure String

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
    case (Debug.log "msg" msg) of
        ResourceChange change ->
            let
                newDict =
                    Debug.log "newDict"
                        (AutoIncDict.update
                            change.structureLabel
                            (\maybeStruct ->
                                Maybe.map
                                    (\struct ->
                                        updateStructure change.structureMsg struct
                                    )
                                    maybeStruct
                            )
                            model.structDict
                        )
                newCounts = getTotalCounts newDict
            in
                { structDict = newDict
                , totalCounts = newCounts
                }
        AddStructure ->
            { model
            | structDict = AutoIncDict.insert initStructure model.structDict
            }
        RemoveStructure label ->
            { model
            | structDict = AutoIncDict.remove label model.structDict
            }
