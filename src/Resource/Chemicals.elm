module Resources.Chemicals

type alias Chemicals = Int

type ChemicalsPkg
    = Chemicals30
    | Chemicals60
    | Chemicals120
    | Chemicals240
    | Chemicals360
    | Chemicals480
    | Chemicals600

metalAmt : ChemicalsPkg -> Chemicals
metalAmt metal =
    case metal of
        Chemicals30 -> 30
        Chemicals60 -> 60
        Chemicals120 -> 120
        Chemicals240 -> 240
        Chemicals360 -> 360
        Chemicals480 -> 480
        Chemicals600 -> 600

type alias ChemicalsPkgs = Dict ChemicalsPkg Int
 
