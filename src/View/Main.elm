module View.Main exposing (view)

import Element exposing (Element, el, column)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region

import Dict.AutoInc as AutoIncDict exposing (AutoIncDict)
import Dict.Count as CountDict

import Resource exposing (..)
import Resource.ChiralCrystals as ChiralCrystals
import Resource.Resins as Resins
import Resource.Metal as Metal
import Resource.Ceramics as Ceramics
import Resource.Chemicals as Chemicals
import Resource.SpecialAlloys as SpecialAlloys
import Resource.Types exposing (Resource, Weight(..), getWeight)
import Resource.Types.Excess as Excess exposing (Excess)
import Resource.Types.PackageCounts exposing (PackageCounts)
import Resource.Types.PackageCounts.All exposing (PackageCountsAll)

import Model.Structure exposing (Structure)
import Model.Structure.Resources as StructureResources
import View.Structure exposing (structureView)

import Model.Main exposing (Model)
import Model.Main.TotalCounts as TotalCounts exposing (TotalCounts)

--import Main.Controller exposing (..)

import Msg.Main exposing (Msg(..))

import Palette.Font
import Palette.Colors as Colors
import Palette.Font.Size as FontSize
import Widget
import Version exposing (currentVersion)

view : Model -> Element Msg
view model = column
    (  (Element.width <| Element.maximum 500 <| Element.fill)
    :: Element.centerX
    :: Element.spacing 20
    :: Background.color Colors.blueGrey
    :: Palette.Font.defaultFont
    )
    [ el [] Element.none
    , mainTitle
    , structsElement model.structDict
    , Maybe.withDefault Element.none
        <| Maybe.map
            ( el
                    [ Element.padding 20
                    , Element.width Element.fill
                    ]
            )
        <| totalsColumn model.totalCounts
    , el [] Element.none
    , footer
    , el [] Element.none
    ]

mainTitle : Element Msg
mainTitle =
    el
        [ Region.heading 1
        , Element.centerX
        , FontSize.xLarge
        ]
        (Element.text "Death Stranding Structure Calc")

footer : Element Msg
footer =
    let
        copyright = "Death Stranding is a trademark of Sony Interactive "
            ++ "Entertainment LLC."
    in column
        [ FontSize.xSmall
        , Element.width Element.fill
        ]
        [ el
            [Element.centerX]
            (Element.text ("v" ++ Version.toString currentVersion))
        , el
            [ Element.centerX
            , Font.italic
            ] (Element.text copyright)
        ]

totalsColumn : TotalCounts -> Maybe (Element Msg)
totalsColumn totalCounts =
    let
        heading = Element.text "Totals"
        pkgCounts = TotalCounts.toPackageCountsAll totalCounts
        totalPkgs = packageListElement pkgCounts
        totalRes = totalListElement pkgCounts
        wasted = wastedListElement totalCounts
        weight = totalWeightElement pkgCounts
    in columnHelper
        [ Region.heading 2
        , Font.underline
        ]
        [Element.padding 20
        , Background.color Colors.black
        ]
        heading
        [totalPkgs, totalRes, wasted, weight]

wastedListElement : TotalCounts -> Maybe (Element Msg)
wastedListElement totalCounts =
    let
        resElem resource selector =
            wastedListResElement resource (.excess (selector totalCounts))
        resElems =
            [ resElem ChiralCrystals.resource .chiralCrystals
            , resElem Resins.resource .resins
            , resElem Metal.resource .metal
            , resElem Ceramics.resource .ceramics
            , resElem Chemicals.resource .chemicals
            , resElem SpecialAlloys.resource .specialAlloys
            ]
        header = Element.text "Resources wasted:"
    in columnHelper
        [Region.heading 3]
        [Background.color Colors.xDarkBlue]
        header
        resElems

wastedListResElement : Resource r -> Excess -> Maybe (Element Msg)
wastedListResElement resource excess =
    if Excess.toInt excess == 0
        then Nothing
        else Just <|
            Element.row
                [ Element.width Element.fill
                ]
                [ el
                    [Element.width (Element.px 250)]
                    (Element.text (resource.name ++ ":"))
                , el
                    [Element.width Element.fill]
                    (el
                        [Element.alignRight]
                        (Element.text (Excess.toString excess))
                    )
                ]
totalListElement : PackageCountsAll -> Maybe (Element Msg)
totalListElement counts =
    let
        resElem resource selector =
            totalListResElement resource (selector counts)
        resElems =
            [ resElem ChiralCrystals.resource .chiralCrystals
            , resElem Resins.resource .resins
            , resElem Metal.resource .metal
            , resElem Ceramics.resource .ceramics
            , resElem Chemicals.resource .chemicals
            , resElem SpecialAlloys.resource .specialAlloys
            ]
        heading = Element.text "Resources needed:"
    in columnHelper
        [Region.heading 3]
        [Background.color Colors.xDarkBlue]
        heading
        resElems

totalListResElement : Resource r -> PackageCounts r -> Maybe (Element Msg)
totalListResElement resource counts =
    if CountDict.isEmpty counts
        then Nothing
        else Just <|
            Element.row
                [ Element.width Element.fill
                ]
                [ el
                    [Element.width (Element.px 250)]
                    (Element.text (resource.name ++ ":"))
                , el
                    [Element.width Element.fill]
                    (el
                        [Element.alignRight]
                        (Element.text
                            <| String.fromInt
                            <| resourceTotal resource counts
                        )
                    )
                ]

totalWeightElement : PackageCountsAll -> Maybe (Element Msg)
totalWeightElement countsAll =
    let
        resWeight resource selector =
            let counts = selector countsAll
            in if CountDict.isEmpty counts
                    then Nothing
                    else Just (resourceWeight resource counts)
        resWeights =
            [ resWeight ChiralCrystals.resource .chiralCrystals
            , resWeight Resins.resource .resins
            , resWeight Metal.resource .metal
            , resWeight Ceramics.resource .ceramics
            , resWeight Chemicals.resource .chemicals
            , resWeight SpecialAlloys.resource .specialAlloys
            ]
        heading = Element.text "Total weight:"
        addMaybe maybeWeight maybeTotalWeight =
            case maybeWeight of
                Nothing -> maybeTotalWeight
                Just w1 ->
                    case maybeTotalWeight of
                        Nothing -> Just w1
                        Just w2 -> Just (Weight (getWeight w1 + getWeight w2))
        elem (Weight w) =
            el [Element.alignRight]
                (Element.text (String.fromFloat w ++ " kilograms"))
    in columnHelper
            [Region.heading 3]
            [Background.color Colors.xDarkBlue]
            heading
            [Maybe.map elem (List.foldl addMaybe Nothing resWeights)]

packageListElement : PackageCountsAll -> Maybe (Element Msg)
packageListElement counts =
    let
        resElem resource selector =
            packageListResElement resource (selector counts)
        resElems =
            [ resElem ChiralCrystals.resource .chiralCrystals
            , resElem Resins.resource .resins
            , resElem Metal.resource .metal
            , resElem Ceramics.resource .ceramics
            , resElem Chemicals.resource .chemicals
            , resElem SpecialAlloys.resource .specialAlloys
            ]
        heading = Element.text "Packages needed:"
    in columnHelper
        [Region.heading 2]
        [Background.color Colors.xDarkBlue]
        heading
        resElems

packageListResElement : Resource r -> PackageCounts r -> Maybe (Element Msg)
packageListResElement resource counts =
    let
        pkgList =
            Resource.packagesNeededByValueDesc resource counts
        pkgElement (pkg, count) =
            Element.row
                [ Element.width Element.fill
                ]
                [ el
                    [ Element.alignLeft
                    , Element.width (Element.px 200)
                    ]
                    (Element.text (printPackage resource pkg))
                , el
                    [ Element.width (Element.px 20)
                    ]
                    (Element.text "✕")
                , el
                    [ Element.width Element.fill
                    ]
                    ( el
                        [ Element.alignRight
                        ]
                        (Element.text (String.fromInt count))
                    )
                ]
        heading =
            Element.row
                [Element.width Element.fill]
                [ el
                    [ Element.centerY
                    , Element.alignLeft
                    ]
                    ( Element.image
                        [Element.height (Element.px 25)]
                        { src = "/images/" ++ resource.image
                        , description = ""
                        }
                    )
                , el
                    [ Element.alignRight
                    , Font.variant Font.smallCaps
                    ]
                    ( Element.text resource.name )
                ]
    in columnHelper
        [ Region.heading 3
        , Element.width Element.fill
        , Element.padding 5
        , Border.widthEach
            { bottom = 1
            , left = 0
            , right = 0
            , top = 0
            }
        ]
        [ Background.color Colors.darkBlue
        ]
        heading
        (List.map (Just << pkgElement) pkgList)

columnHelper
    :  List (Element.Attribute Msg) -- Extra attributes for header
    -> List (Element.Attribute Msg) -- Extra attributes for column
    -> Element Msg -- Heading
    -> List (Maybe (Element Msg))
    -> Maybe (Element Msg)
columnHelper headingAttrs columnAttrs heading list =
    if List.all isNothing list
        then Nothing
        else Just <|
            column
                (    Element.spacing 30
                  :: Border.width 1
                  :: Border.rounded 10
                  :: Element.padding 10
                  :: Element.width Element.fill
                  :: columnAttrs
                )
                [ el
                    ( Element.paddingXY 0 0
                      :: headingAttrs
                    )
                    heading
                , column
                    [ Element.paddingXY 15 10
                    , Element.moveRight 15
                    , Element.spacing 20
                    , Element.width Element.fill
                    ]
                    (List.map (Maybe.withDefault Element.none) list)
                ]

structsElement : AutoIncDict Structure -> Element Msg
structsElement dict =
    column
        [Element.width Element.fill, Element.spacing 20]
        [ column structsElementAttrs (structList dict)
        , addButton
        ]

structsElementAttrs : List (Element.Attribute Msg)
structsElementAttrs =
    [ Element.spacing 10
    , Element.width Element.fill
    ]

structList : AutoIncDict Structure -> List (Element Msg)
structList = List.map structElem << AutoIncDict.values

structElem : Structure -> Element Msg
structElem struct =
    let list = packageListElement
            (StructureResources.toPackageCountsAll struct.resources)
    in
        column structAttrs
            [ el
                [ Element.centerX
                , Element.width Element.fill
                ]
                (structureView struct)
            , removeButton struct.key
            , el
                [ Element.width Element.fill
                ]
                (Maybe.withDefault Element.none list)
            ]

structAttrs : List (Element.Attribute Msg)
structAttrs =
    [ Element.spacing 10
    , Border.width 2
    , Border.color Colors.lightBlue
    , Border.rounded 20
    , Element.width Element.fill
    , Element.padding 20
    ]

addButton : Element Msg
addButton = Widget.button
    "Add structure"
    (Just AddStructure)
    [Element.alignRight]

removeButton : AutoIncDict.Key -> Element Msg
removeButton key = Widget.button
    "Remove structure"
    (Just (RemoveStructure key))
    [Element.alignRight]

isNothing : Maybe a -> Bool
isNothing m =
    case m of
        Just _ -> False
        Nothing -> True

