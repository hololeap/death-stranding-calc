module Model.Main.CombinedCounts exposing (..)

import Serialize as S exposing (Codec)

import Resource.Types exposing (Resource)
import Resource.Types.PackageCounts as PackageCounts exposing (PackageCounts)
import Resource.Types.Excess as Excess exposing (Excess)

type alias CombinedCounts r =
    { pkgs : PackageCounts r
    , excess : Excess
    }

init : Resource r -> CombinedCounts r
init resource =
    { pkgs = PackageCounts.init resource
    , excess = Excess.init
    }

codec : Resource r -> Codec e (CombinedCounts r)
codec resource =
    let cons p e = {pkgs = p, excess = e}
    in
        S.customType
            (\e c -> e c.pkgs c.excess)
            |> S.variant2 cons (PackageCounts.codec resource) Excess.codec
            |> S.finishCustomType
