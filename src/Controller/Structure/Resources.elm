module Controller.Structure.Resources exposing (..)

import Resource.Types (Resource)
import Resource.ChiralCrystals as ChiralCrystals
import Resource.Resins as Resins
import Resource.Metal as Metal
import Resource.Ceramics as Ceramics
import Resource.Chemicals as Chemicals
import Resource.SpecialAlloys as SpecialAlloys

import Model.Structure.Resources exposing (StructureResources)
import Msg.Structure exposing (StructureMsg(..))
import Msg.Resource exposing (ResourceMsg)

updateStructureResources : 
