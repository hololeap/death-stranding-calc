module Types.Msg exposing
    ( Msg(..)
    , StructureMsg(..)
    , fromStructureMsg
    , ResourceMsg(..)
    , FromResourceMsg
    ) 

import Dict.AutoInc as AutoIncDict

import Resource.Ceramics exposing (Ceramics)
import Resource.Metal exposing (Metal)

type Msg
    = ResourceChange
        { structureKey : AutoIncDict.Key
        , structureMsg : StructureMsg }
    | AddStructure
    | RemoveStructure AutoIncDict.Key

type StructureMsg
    = CeramicsMsg (ResourceMsg Ceramics)
    | MetalMsg (ResourceMsg Metal) 

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
