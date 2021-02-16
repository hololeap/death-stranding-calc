module Resource.Metal exposing (..)

import Enum exposing (fromIntIterator)
import Serialize as S exposing (Codec)

import Resource.Types exposing (Packages, Resource, Weight(..))

type Metal
    = Metal50
    | Metal100
    | Metal200
    | Metal400
    | Metal600
    | Metal800
    | Metal1000

packages : Packages Metal
packages =
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

resource : Resource Metal
resource =
    { name = "Metals"
    , id = "metals"
    , packages = packages
    , minimum = Metal50
    , image = "metals-transparent.png"
    , weight = Weight 0.1
    }

codec : Codec e Metal
codec =
    let f e50 e100 e200 e400 e600 e800 e1000 v =
            case v of
                Metal50 -> e50
                Metal100 -> e100
                Metal200 -> e200
                Metal400 -> e400
                Metal600 -> e600
                Metal800 -> e800
                Metal1000 -> e1000
    in S.customType f
        |> S.variant0 Metal50
        |> S.variant0 Metal100
        |> S.variant0 Metal200
        |> S.variant0 Metal400
        |> S.variant0 Metal600
        |> S.variant0 Metal800
        |> S.variant0 Metal1000
        |> S.finishCustomType
