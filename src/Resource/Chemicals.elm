module Resource.Chemicals exposing (..)

import Enum exposing (fromIntIterator)

import Resource.Types exposing (Packages, Resource, Weight(..))

type Chemicals
    = Chemicals30
    | Chemicals60
    | Chemicals120
    | Chemicals240
    | Chemicals360
    | Chemicals480
    | Chemicals600

chemicalsPackages : Packages Chemicals
chemicalsPackages =
    fromIntIterator
        (\r -> case r of
            Chemicals600 -> (30, Chemicals30)
            Chemicals30 -> (60, Chemicals60)
            Chemicals60 -> (120, Chemicals120)
            Chemicals120 -> (240, Chemicals240)
            Chemicals240 -> (360, Chemicals360)
            Chemicals360 -> (480, Chemicals480)
            Chemicals480 -> (600, Chemicals600)
        )
        Chemicals30

chemicalsResource : Resource Chemicals
chemicalsResource =
    { name = "Chemicals"
    , id = "chemicals"
    , packages = chemicalsPackages
    , minimum = Chemicals30
    , image = "chemicals-transparent.png"
    , weight = Weight 0.1
    }
