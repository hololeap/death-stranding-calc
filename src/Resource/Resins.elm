module Resource.Resins exposing (..)

import Enum exposing (fromIntIterator)

import Resource.Types exposing (Packages, Resource)

type Resins
    = Resins40
    | Resins80
    | Resins160
    | Resins320
    | Resins480
    | Resins640
    | Resins800

resinsPackages : Packages Resins
resinsPackages =
    fromIntIterator
        (\r -> case r of
            Resins800 -> (40, Resins40)
            Resins40 -> (80, Resins80)
            Resins80 -> (160, Resins160)
            Resins160 -> (320, Resins320)
            Resins320 -> (480, Resins480)
            Resins480 -> (640, Resins640)
            Resins640 -> (800, Resins800)
        )
        Resins40

resinsResource : Resource Resins
resinsResource =
    { name = "Resins"
    , id = "resins"
    , packages = resinsPackages
    , minimum = Resins40
    }
