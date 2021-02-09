module Types.Msg exposing
    ( Msg(..)
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

type Msg
    = ResourceChange
        { structureKey : AutoIncDict.Key
        , structureMsg : StructureMsg }
    | AddStructure
    | RemoveStructure AutoIncDict.Key

type StructureMsg
    = ChiralCrystalsMsg (ResourceMsg ChiralCrystals)
    | ResinsMsg (ResourceMsg Resins)    
    | MetalMsg (ResourceMsg Metal)
    | CeramicsMsg (ResourceMsg Ceramics)
    | ChemicalsMsg (ResourceMsg Chemicals)
    | SpecialAlloysMsg (ResourceMsg SpecialAlloys)
    
fromStructureMsg : AutoIncDict.Key -> StructureMsg -> Msg
fromStructureMsg key msg =
    ResourceChange
        { structureKey = key
        , structureMsg = msg
        }
        
-- Events for changing state on a ResourceModel
type ResourceMsg r
    = ChangeNeeded (Maybe Int)
    | ChangeGiven (Maybe Int)

type alias FromResourceMsg r = ResourceMsg r -> Msg
