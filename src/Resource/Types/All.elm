module Resource.Types.All exposing (..)

import Resource.ChiralCrystals as ChiralCrystals exposing (ChiralCrystals)
import Resource.Resins as Resins exposing (Resins)
import Resource.Metal as Metal exposing (Metal)
import Resource.Ceramics as Ceramics exposing (Ceramics)
import Resource.Chemicals as Chemicals exposing (Chemicals)
import Resource.SpecialAlloys as SpecialAlloys exposing (SpecialAlloys)
import Resource.Types exposing (Resource)

import Resource.Types.PackageCounts exposing (PackageCounts)
import Resource.Types.Excess exposing (Excess)
import Resource.Types.Weight exposing (Weight)

import Serialize as S exposing (Codec)
import Accessors exposing (Relation, makeOneToOne)

type alias WithAllResources a b c d e f t =
    { t | chiralCrystals : a
        , resins : b
        , metal : c
        , ceramics : d
        , chemicals : e
        , specialAlloys : f
    }

type alias AllResources a b c d e f = WithAllResources a b c d e f {}

-- Default types

type alias PackageCountsAll =
    AllResources
        (PackageCounts ChiralCrystals)
        (PackageCounts Resins)
        (PackageCounts Metal)
        (PackageCounts Ceramics)
        (PackageCounts Chemicals)
        (PackageCounts SpecialAlloys)

type alias ExcessAll =
    AllResources
        (Excess ChiralCrystals)
        (Excess Resins)
        (Excess Metal)
        (Excess Ceramics)
        (Excess Chemicals)
        (Excess SpecialAlloys)

type alias WeightAll =
    AllResources
        (Weight ChiralCrystals)
        (Weight Resins)
        (Weight Metal)
        (Weight Ceramics)
        (Weight Chemicals)
        (Weight SpecialAlloys)

-- Map

map :  (a1 -> a2)
    -> (b1 -> b2)
    -> (c1 -> c2)
    -> (d1 -> d2)
    -> (e1 -> e2)
    -> (f1 -> f2)
    -> AllResources a1 b1 c1 d1 e1 f1
    -> AllResources a2 b2 c2 d2 e2 f2
map fa fb fc fd fe ff =
    mapWithResource
        (\_ -> fa)
        (\_ -> fb)
        (\_ -> fc)
        (\_ -> fd)
        (\_ -> fe)
        (\_ -> ff)

mapWithResource
    :  (Resource ChiralCrystals -> a1 -> a2)
    -> (Resource Resins -> b1 -> b2)
    -> (Resource Metal -> c1 -> c2)
    -> (Resource Ceramics -> d1 -> d2)
    -> (Resource Chemicals -> e1 -> e2)
    -> (Resource SpecialAlloys -> f1 -> f2)
    -> AllResources a1 b1 c1 d1 e1 f1
    -> AllResources a2 b2 c2 d2 e2 f2
mapWithResource fa fb fc fd fe ff allRes =
    { chiralCrystals = fa ChiralCrystals.resource allRes.chiralCrystals
    , resins = fb Resins.resource allRes.resins
    , metal = fc Metal.resource allRes.metal
    , ceramics = fd Ceramics.resource allRes.ceramics
    , chemicals = fe Chemicals.resource allRes.chemicals
    , specialAlloys = ff SpecialAlloys.resource allRes.specialAlloys
    }

-- Applicative

type alias Ap a1 a2 b1 b2 c1 c2 d1 d2 e1 e2 f1 f2 =
    AllResources
        (a1 -> a2)
        (b1 -> b2)
        (c1 -> c2)
        (d1 -> d2)
        (e1 -> e2)
        (f1 -> f2)

ap :   AllResources a1 b1 c1 d1 e1 f1
    -> Ap a1 a2 b1 b2 c1 c2 d1 d2 e1 e2 f1 f2
    -> AllResources a2 b2 c2 d2 e2 f2
ap r = map
    ((|>) r.chiralCrystals)
    ((|>) r.resins)
    ((|>) r.metal)
    ((|>) r.ceramics)
    ((|>) r.chemicals)
    ((|>) r.specialAlloys)

type alias LiftA2 a1 a2 a3 b1 b2 b3 c1 c2 c3 d1 d2 d3 e1 e2 e3 f1 f2 f3 =
    AllResources
        (a1 -> a2 -> a3)
        (b1 -> b2 -> b3)
        (c1 -> c2 -> c3)
        (d1 -> d2 -> d3)
        (e1 -> e2 -> e3)
        (f1 -> f2 -> f3)

liftA2 : LiftA2 a1 a2 a3 b1 b2 b3 c1 c2 c3 d1 d2 d3 e1 e2 e3 f1 f2 f3
    -> AllResources a1 b1 c1 d1 e1 f1
    -> AllResources a2 b2 c2 d2 e2 f2
    -> AllResources a3 b3 c3 d3 e3 f3
liftA2 l r1 r2 = ap r1 l |> ap r2

-- Combine

type alias Combine a b c d e f =
    LiftA2 a a a b b b c c c d d d e e e f f f

combine
    :  Combine a b c d e f
    -> AllResources a b c d e f
    -> AllResources a b c d e f
    -> AllResources a b c d e f
combine = liftA2

combineMany
    :  Combine a b c d e f
    -> AllResources a b c d e f
    -> List (AllResources a b c d e f)
    -> AllResources a b c d e f
combineMany = List.foldl << combine

combineManyWithResource
    :  Combine a b c d e f
    -> InitWithResource a b c d e f
    -> List (AllResources a b c d e f)
    -> AllResources a b c d e f
combineManyWithResource c = List.foldl (combine c) << initWithResource

-- Fold

fold : (a -> b -> b)
    -> b
    -> AllResources a a a a a a
    -> b
fold f b r =
    f r.chiralCrystals b
    |> f r.resins
    |> f r.metal
    |> f r.ceramics
    |> f r.chemicals
    |> f r.specialAlloys

fold1 : (a -> a -> a)
    -> AllResources a a a a a a
    -> a
fold1 f r =
    f r.chiralCrystals r.resins
    |> f r.metal
    |> f r.ceramics
    |> f r.chemicals
    |> f r.specialAlloys

-- Traversable

traverse : (AllResources a1 b1 c1 d1 e1 f1 -> AllResources a2 b2 c2 d2 e2 f2)
    -> List (AllResources a1 b1 c1 d1 e1 f1)
    -> AllResources (List a2) (List b2) (List c2) (List d2) (List e2) (List f2)
traverse f =
    let comb r rl =
            { chiralCrystals = (f r).chiralCrystals :: rl.chiralCrystals
            , resins = (f r).resins :: rl.resins
            , metal = (f r).metal :: rl.metal
            , ceramics = (f r).ceramics :: rl.ceramics
            , chemicals = (f r).chemicals :: rl.chemicals
            , specialAlloys = (f r).specialAlloys :: rl.specialAlloys
            }
    in List.foldr comb (cons [] [] [] [] [] [])

sequence
    :  List (AllResources a b c d e f)
    -> AllResources (List a) (List b) (List c) (List d) (List e) (List f)
sequence = let id x = x in traverse id

-- Init

type alias InitWithResource a b c d e f =
    AllResources
        (Resource ChiralCrystals -> a)
        (Resource Resins -> b)
        (Resource Metal -> c)
        (Resource Ceramics -> d)
        (Resource Chemicals -> e)
        (Resource SpecialAlloys -> f)

initWithResource : InitWithResource a b c d e f -> AllResources a b c d e f
initWithResource = ap resources

-- Resources

resources :
    AllResources
        (Resource ChiralCrystals)
        (Resource Resins)
        (Resource Metal)
        (Resource Ceramics)
        (Resource Chemicals)
        (Resource SpecialAlloys)
resources =
    { chiralCrystals = ChiralCrystals.resource
    , resins = Resins.resource
    , metal = Metal.resource
    , ceramics = Ceramics.resource
    , chemicals = Chemicals.resource
    , specialAlloys = SpecialAlloys.resource
    }

-- Serialize

cons : a -> b -> c -> d -> e -> f -> AllResources a b c d e f
cons a b c d e f =
    { chiralCrystals = a
    , resins = b
    , metal = c
    , ceramics = d
    , chemicals = e
    , specialAlloys = f
    }

codec
    :  Codec er a
    -> Codec er b
    -> Codec er c
    -> Codec er d
    -> Codec er e
    -> Codec er f
    -> Codec er (AllResources a b c d e f)
codec ca cb cc cd ce cf =
    S.customType
        (\e r -> e
            r.chiralCrystals
            r.resins
            r.metal
            r.ceramics
            r.chemicals
            r.specialAlloys
        )
        |> S.variant6 cons ca cb cc cd ce cf
        |> S.finishCustomType

-- Accessors

chiralCrystals
    :  Relation a reachable wrap
    -> Relation (WithAllResources a b c d e f t) reachable wrap
chiralCrystals =
    makeOneToOne
        .chiralCrystals
        (\change rec -> {rec | chiralCrystals = change rec.chiralCrystals })

resins
    :  Relation b reachable wrap
    -> Relation (WithAllResources a b c d e f t) reachable wrap
resins =
    makeOneToOne
        .resins
        (\change rec -> {rec | resins = change rec.resins })

metal
    :  Relation c reachable wrap
    -> Relation (WithAllResources a b c d e f t) reachable wrap
metal =
    makeOneToOne
    .metal
    (\change rec -> { rec | metal = change rec.metal })

ceramics
    :  Relation d reachable wrap
    -> Relation (WithAllResources a b c d e f t) reachable wrap
ceramics =
    makeOneToOne
    .ceramics
    (\change rec -> { rec | ceramics = change rec.ceramics })

chemicals
    :  Relation e reachable wrap
    -> Relation (WithAllResources a b c d e f t) reachable wrap
chemicals =
    makeOneToOne
    .chemicals
    (\change rec -> { rec | chemicals = change rec.chemicals })

specialAlloys
    :  Relation f reachable wrap
    -> Relation (WithAllResources a b c d e f t) reachable wrap
specialAlloys =
    makeOneToOne
    .specialAlloys
    (\change rec -> { rec | specialAlloys = change rec.specialAlloys })
