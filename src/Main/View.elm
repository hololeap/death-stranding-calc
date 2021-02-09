module Main.View exposing
    ( view
    )
    
import Element exposing (Element, el, column)
import Element.Border as Border
import Element.Input as Input
import Element.Region as Region

import Dict.AutoInc as AutoIncDict exposing (AutoIncDict)
import Dict.Count as CountDict

import Resource exposing (..)
import Resource.Ceramics exposing (..)
import Resource.Metal exposing (..)
import Resource.Types exposing (..)

import Structure.Model exposing (Structure)
import Structure.View exposing (structureView)

import Main.Model exposing (Model, CombinedCounts, TotalCounts)
--import Main.Controller exposing (..)

import Types.Msg exposing (Msg(..))

view : Model -> Element Msg
view model = column
    [ Element.width <| Element.maximum 500 <| Element.fill
    , Element.centerX
    ]
    [ mainTitle
    , structsElement model.structDict
    , packageListElement model.totalCounts
    , totalListElement model.totalCounts
    , wastedListElement model.totalCounts
    ]

    
mainTitle : Element Msg
mainTitle =
    el
        [ Region.heading 1
        , Element.centerX
        ]
        (Element.text "Death Stranding Structure Calc")

wastedListElement : TotalCounts -> Element Msg
wastedListElement totalCounts =
    let
        resElem resource selector =
            wastedListResElement resource (.excess (selector totalCounts))
        resElems =
            [ resElem ceramicsResource .ceramics
            , resElem metalResource .metal
            ]
        header =
            el 
                [Region.heading 2
                ] 
                (Element.text "Resources wasted:")
    in columnHelper [] header resElems        
        
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
totalListElement : TotalCounts -> Element Msg
totalListElement totalCounts =
    let
        resElem resource selector =
            totalListResElement resource (.pkgs (selector totalCounts))
        resElems =
            [ resElem ceramicsResource .ceramics
            , resElem metalResource .metal
            ]
        header =
            el 
                [Region.heading 2
                ] 
                (Element.text "Resources needed:")
    in columnHelper [] header resElems

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
        
packageListElement : TotalCounts -> Element Msg
packageListElement totalCounts =
    let
        resElem resource selector = 
            packageListResElement resource (.pkgs (selector totalCounts))
        resElems = 
            [ resElem ceramicsResource .ceramics
            , resElem metalResource .metal
            ]
        heading =
            el [Region.heading 2] (Element.text "Packages needed:")
    in columnHelper [Element.moveRight 40] heading resElems
        
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
    column structAttrs
        [ el [] (structureView struct)
        , removeButton struct.key
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

{-
view : Model -> Html Msg
view model =
    let
        conv key msg = ResourceChange
            { structureKey = key
            , structureMsg = msg
            }
        remButton key =
            div [] [ button 
                        [ onClick (RemoveStructure key) ]
                        [ text "Remove Structure" ] 
                    ]
        mkDiv struct =
            div []
                [ Element.layout [] (structureView (conv struct.key) struct)
                , remButton struct.key
                , hr [] []
                ]
        structDivs = List.map mkDiv <| Dict.values model.structDict
        
        countDiv : Resource r -> CombinedCounts r -> Html Msg
        countDiv resource counts =
            div []
                [ div [] [ text resource.name ]
                , div [] [ text (printPackageCounts resource counts.pkgs) ]
                , div [] [ text (printExcess resource counts.excess) ]
                ]
        
        totalDiv : Resource r -> CombinedCounts r -> Html Msg
        totalDiv resource counts =
            div [] [ text (printResourceTotal resource counts.pkgs) ]
    in
        main_ []
            [ h1 [] [ text "DeAtH sTrAnDiNg???" ]
            , div [] structDivs
            , div [] [ button [ onClick AddStructure ] [ text "Add Structure" ] ]
            , div []
                [ div [] [ text "Packages needed:" ]
                , countDiv ceramicsResource model.totalCounts.ceramics
                , countDiv metalResource model.totalCounts.metal
                ]
            , div []
                [ p [] [ text "Total resources needed:" ]
                , totalDiv ceramicsResource model.totalCounts.ceramics
                , totalDiv metalResource model.totalCounts.metal
                ]
            ]

-}
