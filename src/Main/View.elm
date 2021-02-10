module Main.View exposing
    ( view
    )
    
import Element exposing (Element, el, column)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region

import Dict.AutoInc as AutoIncDict exposing (AutoIncDict)
import Dict.Count as CountDict

import Resource exposing (..)
import Resource.ChiralCrystals exposing (chiralCrystalsResource)
import Resource.Resins exposing (resinsResource)
import Resource.Metal exposing (metalResource)
import Resource.Ceramics exposing (ceramicsResource)
import Resource.Chemicals exposing (chemicalsResource)
import Resource.SpecialAlloys exposing (specialAlloysResource)
import Resource.Types exposing (..)

import Structure.Model exposing (Structure, structurePackageCounts)
import Structure.View exposing (structureView)

import Main.Model exposing
    ( Model
    , CombinedCounts
    , TotalCounts
    , totalCountsPackageCounts
    )
--import Main.Controller exposing (..)

import Types.Msg exposing (Msg(..))

view : Model -> Element Msg
view model = column
    [ Element.width <| Element.maximum 500 <| Element.fill
    , Element.centerX
    , Font.size 20
    , Element.spacing 20
    ]
    [ mainTitle
    , structsElement model.structDict
    , el 
        [ Element.padding 20
        , Element.width Element.fill
        , Background.color (Element.rgb255 230 230 230)
        ] 
        (Maybe.withDefault Element.none (totalsColumn model.totalCounts))
    ]
    
mainTitle : Element Msg
mainTitle =
    el
        [ Region.heading 1
        , Element.centerX
        ]
        (Element.text "Death Stranding Structure Calc")

totalsColumn : TotalCounts -> Maybe (Element Msg)
totalsColumn totalCounts =
    let
        heading = Element.text "Totals"
        pkgCounts = totalCountsPackageCounts totalCounts
        totalPkgs = packageListElement pkgCounts
        totalRes = totalListElement pkgCounts
        wasted = wastedListElement totalCounts
    in columnHelper
        [ Region.heading 2
        , Font.underline
        ]    
        [Element.spacing 20] 
        heading 
        [totalPkgs, totalRes, wasted]

wastedListElement : TotalCounts -> Maybe (Element Msg)
wastedListElement totalCounts =
    let
        resElem resource selector =
            wastedListResElement resource (.excess (selector totalCounts))
        resElems =
            [ resElem chiralCrystalsResource .chiralCrystals
            , resElem resinsResource .resins
            , resElem metalResource .metal
            , resElem ceramicsResource .ceramics
            , resElem chemicalsResource .chemicals
            , resElem specialAlloysResource .specialAlloys
            ]
        header = Element.text "Resources wasted:"
    in columnHelper [Region.heading 3] [] header resElems        
        
wastedListResElement : Resource r -> Excess -> Maybe (Element Msg)
wastedListResElement resource excess =
    if getExcess excess == 0
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
                        (Element.text (showExcess excess))
                    )
                ]
totalListElement : PackageCountsAll -> Maybe (Element Msg)
totalListElement counts =
    let
        resElem resource selector =
            totalListResElement resource (selector counts)
        resElems =
            [ resElem chiralCrystalsResource .chiralCrystals
            , resElem resinsResource .resins            
            , resElem metalResource .metal
            , resElem ceramicsResource .ceramics
            , resElem chemicalsResource .chemicals
            , resElem specialAlloysResource .specialAlloys
            ]
        header = Element.text "Resources needed:"
    in columnHelper [Region.heading 3] [] header resElems

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
        
packageListElement : PackageCountsAll -> Maybe (Element Msg)
packageListElement counts =
    let
        resElem resource selector = 
            packageListResElement resource (selector counts)
        resElems = 
            [ resElem chiralCrystalsResource .chiralCrystals
            , resElem resinsResource .resins            
            , resElem metalResource .metal
            , resElem ceramicsResource .ceramics            
            , resElem chemicalsResource .chemicals
            , resElem specialAlloysResource .specialAlloys
            ]
        heading = Element.text "Packages needed:"
    in columnHelper 
        [Region.heading 2]
        [] 
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
        heading = Element.text resource.name
    in columnHelper 
        [ Region.heading 3 ]
        [] 
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
                (    Element.spacing 10
                  :: Element.padding 10
                  :: Element.width Element.fill
                  :: columnAttrs
                )
                [ el 
                    ( Element.padding 5
                      :: headingAttrs
                    )
                    heading
                , column
                    [ Element.paddingXY 10 0
                    , Element.moveRight 15
                    , Element.spacing 10
                    , Element.width Element.fill
                    , Element.centerX
                    , Element.centerY
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
    let list = packageListElement (structurePackageCounts struct)
    in
        column structAttrs
            [ el [Element.centerX] (structureView struct)
            , removeButton struct.key
            , el 
                [ Element.padding 20
                , Element.width Element.fill
                ] 
                (Maybe.withDefault Element.none list)
            ]

structAttrs : List (Element.Attribute Msg)
structAttrs =
    [ Element.spacing 10
    , Border.width 2
    , Element.width Element.fill
    , Element.padding 10
    ]
    
addButton : Element Msg
addButton =
    Input.button (Element.alignRight :: buttonAttrs)
        { onPress = Just AddStructure
        , label = Element.text "Add structure"
        }

removeButton : AutoIncDict.Key -> Element Msg
removeButton key = 
    Input.button (Element.alignRight :: buttonAttrs)
        { onPress = Just <| RemoveStructure key
        , label = Element.text "Remove structure"
        }

buttonAttrs : List (Element.Attribute Msg)
buttonAttrs =
    [ Border.width 1
    , Border.rounded 5
    , Element.padding 5
    ]

isNothing : Maybe a -> Bool
isNothing m =
    case m of
        Just _ -> False
        Nothing -> True

