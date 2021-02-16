module Types.Msg exposing
    ( Msg(..)
    , RenameStructureMsg(..)
    , fromRenameStructureMsg
    , StructureMsg(..)
    , fromStructureMsg
    , ResourceMsg(..)
    , FromResourceMsg
    )

import Dict.AutoInc as AutoIncDict

import Resource.ChiralCrystals exposing (ChiralCrystals)
import Resource.Resins exposing (Resins)
import Resource.Metal exposing (Metal)
import Resource.Ceramics exposing (Ceramics)
import Resource.Chemicals exposing (Chemicals)
import Resource.SpecialAlloys exposing (SpecialAlloys)

import Resource.Types.NeededTotal exposing (ResourceNeededTotal)
import Resource.Types.Given exposing (ResourceGiven)

import Structure.Rename.Model exposing
    (OldStructureName, NewStructureName)

type Msg
    = ResourceChange
        { structureKey : AutoIncDict.Key
        , structureMsg : StructureMsg }
    | AddStructure
    | RemoveStructure AutoIncDict.Key
    | RenameStructure AutoIncDict.Key RenameStructureMsg

type RenameStructureMsg
    = EditStructureName NewStructureName
    | AcceptStructureName
    | CancelRenameStructure

fromRenameStructureMsg : AutoIncDict.Key -> RenameStructureMsg -> Msg
fromRenameStructureMsg = RenameStructure

type StructureMsg
    = ChiralCrystalsMsg (ResourceMsg ChiralCrystals)
    | ResinsMsg (ResourceMsg Resins)
    | MetalMsg (ResourceMsg Metal)
    | CeramicsMsg (ResourceMsg Ceramics)
    | ChemicalsMsg (ResourceMsg Chemicals)
    | SpecialAlloysMsg (ResourceMsg SpecialAlloys)
    | InputsVisibleMsg Bool

fromStructureMsg : AutoIncDict.Key -> StructureMsg -> Msg
fromStructureMsg key msg =
    ResourceChange
        { structureKey = key
        , structureMsg = msg
        }

-- Events for changing state on a ResourceModel
type ResourceMsg r
    = ChangeNeeded (ResourceNeededTotal)
    | ChangeGiven (ResourceGiven)
    | ResetNeeded
    | ResetGiven

type alias FromResourceMsg r = ResourceMsg r -> Msg
