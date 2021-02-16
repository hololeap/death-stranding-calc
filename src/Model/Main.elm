module Model.Main exposing (..)

import Serialize as S exposing (Codec)
import Dict.AutoInc as AutoIncDict exposing (AutoIncDict)

import Model.Structure as Structure exposing (Structure)
import Model.Main.TotalCounts as TotalCounts exposing (TotalCounts)

type alias Model =
    { structDict : AutoIncDict Structure
    , totalCounts : TotalCounts
    }

init : Model
init =
    { structDict = AutoIncDict.singletonNeedingKeyInc "structure" Structure.init
    , totalCounts = TotalCounts.init
    }

codec : Codec e Model
codec =
    let cons s t = {structDict = s, totalCounts = t}
    in
        S.customType
            (\e c -> e c.structDict c.totalCounts)
            |> S.variant2
                cons
                (AutoIncDict.codec Structure.codec)
                TotalCounts.codec
            |> S.finishCustomType
