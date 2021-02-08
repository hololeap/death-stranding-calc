module Resource.Metal exposing (..)

import Dict exposing (Dict)
import Enum exposing (fromIntIterator)

import Resource.Types exposing (Packages, Resource)

type Metal
    = Metal50
    | Metal100
    | Metal200
    | Metal400
    | Metal600
    | Metal800
    | Metal1000
    
metalPackages : Packages Metal
metalPackages =
    fromIntIterator
        (\r -> case r of
            Metal1000 -> (50, Metal50)
            Metal50 -> (100, Metal100)
            Metal100 -> (200, Metal200)
            Metal200 -> (400, Metal400)
            Metal400 -> (600, Metal600)
            Metal600 -> (800, Metal800)
            Metal800 -> (1000, Metal1000)
        )
        Metal50

metalResource : Resource Metal
metalResource =
    { name = "Metal"
    , id = "metal"
    , packages = metalPackages
    , minimum = Metal50
    }
