module Resources.SpecialAlloys

type alias SpecialAlloys = Int

type SpecialAlloysPkg
    = SpecialAlloys60
    | SpecialAlloys120
    | SpecialAlloys240
    | SpecialAlloys480
    | SpecialAlloys720
    | SpecialAlloys960
    | SpecialAlloys1200

metalAmt : SpecialAlloysPkg -> SpecialAlloys
metalAmt metal =
    case metal of
        SpecialAlloys40 -> 40
        SpecialAlloys80 -> 80
        SpecialAlloys160 -> 160
        SpecialAlloys320 -> 320
        SpecialAlloys480 -> 480
        SpecialAlloys640 -> 640
        SpecialAlloys800 -> 800

type alias SpecialAlloysPkgs = Dict SpecialAlloysPkg Int

