module Main.View exposing
    ( view
    )
    
import Element exposing (Element, el, column)
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
    ]
    [ mainTitle
    , structsElement model.structDict
    , totalsColumn model.totalCounts
    ]
    
mainTitle : Element Msg
mainTitle =
    el
        [ Region.heading 1
        , Element.centerX
        ]
        (Element.text "Death Stranding Structure Calc")

totalsColumn : TotalCounts -> Element Msg
totalsColumn totalCounts =
    let
        heading =
            el
                [ Region.heading 2
                , Font.underline
                ]
                (Element.text "Totals")
        pkgCounts = totalCountsPackageCounts totalCounts
        totalPkgs = packageListElement pkgCounts
        totalRes = totalListElement pkgCounts
        wasted = wastedListElement totalCounts
    in columnHelper [] heading [totalPkgs, totalRes, wasted]

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
        header =
            el 
                [Region.heading 3
                ] 
                (Element.text "Resources wasted:")
    in 
        if List.all isNothing resElems
            then Nothing
            else Just <| columnHelper [] header resElems        
        
wastedListResElement : Resource r -> Excess -> Maybe (Element Msg)
wastedListResElement resource excess =
    if excess == 0
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
                        (Element.text (String.fromInt excess))
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
        header =
            el 
                [Region.heading 3
                ] 
                (Element.text "Resources needed:")
    in 
        if List.all isNothing resElems
            then Nothing
            else Just <| columnHelper [] header resElems

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
        heading =
            el [Region.heading 2] (Element.text "Packages needed:")
    in 
        if List.all isNothing resElems
            then Nothing
            else Just <|
                columnHelper [] heading resElems
        
packageListResElement : Resource r -> PackageCounts r -> Maybe (Element Msg)
packageListResElement resource counts =
    let
        pkgList =
            Resource.packagesNeededByValueDesc resource counts
        pkgElement (pkg, count) =
            Element.row [Element.width <| Element.maximum 490 <| Element.fill]
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
                    [ Element.width (Element.px 100)
                    ]
                    ( el 
                        [ Element.alignRight
                        ] 
                        (Element.text (String.fromInt count))
                    )
                ]
        heading = el [Region.heading 3] (Element.text resource.name)
    in
        if List.isEmpty pkgList
            then Nothing
            else Just <|
                column 
                    [ Element.width Element.fill
                    , Element.padding 10
                    ]
                    [ heading
                    , column
                        [ Element.padding 20
                        , Element.spacing 10
                        ] 
                        (List.map pkgElement pkgList)
                    ]

columnHelper
    :  List (Element.Attribute Msg) -- Extra attributes for column
    -> Element Msg -- Heading
    -> List (Maybe (Element Msg))
    -> Element Msg
columnHelper columnAttrs heading list =
    if List.all isNothing list
        then Element.none
        else
            column 
                (    Element.width Element.fill
                  :: Element.padding 10
                  :: columnAttrs
                )
                [ heading
                , column
                    [ Element.padding 20
                    , Element.spacing 10
                    ] 
                    (List.map (Maybe.withDefault Element.none) list)
                ]                
            
structsElement : AutoIncDict Structure -> Element Msg
structsElement dict =
    column [Element.width (Element.px 490)]
        [ column structsElementAttrs (structList dict)
        , addButton
        ]

structsElementAttrs : List (Element.Attribute Msg)
structsElementAttrs =
    [ Element.padding 20
    , Element.spacing 10
    ]
        
structList : AutoIncDict Structure -> List (Element Msg)
structList = List.map structElem << AutoIncDict.values

structElem : Structure -> Element Msg
structElem struct =
    let list = packageListElement (structurePackageCounts struct)
    in
        column structAttrs
            [ el [] (structureView struct)
            , removeButton struct.key
            , Maybe.withDefault Element.none list
            ]

structAttrs : List (Element.Attribute Msg)
structAttrs =
    [ Element.padding 15
    , Element.spacing 10
    , Border.solid
    , Border.width 2
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
    [ Border.solid
    , Border.width 1
    , Border.rounded 5
    , Element.padding 5
    ]

isNothing : Maybe a -> Bool
isNothing m =
    case m of
        Just _ -> False
        Nothing -> True

