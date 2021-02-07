module Resources.Resins

type alias Resins = Int

type ResinsPkg
    = Resins40
    | Resins80
    | Resins160
    | Resins320
    | Resins480
    | Resins640
    | Resins800

metalAmt : ResinsPkg -> Resins
metalAmt metal =
    case metal of
        Resins40 -> 40
        Resins80 -> 80
        Resins160 -> 160
        Resins320 -> 320
        Resins480 -> 480
        Resins640 -> 640
        Resins800 -> 800

type alias ResinsPkgs = Dict ResinsPkg Int
