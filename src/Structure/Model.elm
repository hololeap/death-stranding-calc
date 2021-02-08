module Structure.Model exposing
    ( Structure
    , StructureName
    , initStructure
    )
    
import Dict.AutoInc as AutoIncDict
import Dict.Count as CountDict

import Resource.Ceramics exposing (..)
import Resource.Metal exposing (..)
import Resource.Types exposing (..)

import Resource.MVC.Model exposing (ResourceModel, initResourceModel)

type alias StructureName = String

type alias Structure =
    { name : StructureName
    , key : AutoIncDict.Key
    , ceramics : ResourceModel Ceramics
    , metal : ResourceModel Metal
    }
    
initStructure : Int -> AutoIncDict.Key -> Structure
initStructure inc key =
    { name = "Structure " ++ String.fromInt inc
    , key = key
    , ceramics = initResourceModel ceramicsResource
    , metal = initResourceModel metalResource
    }
