module Widget.PackageList exposing (view)

-- Display the list of packages from a 'PackageCountAll'. This can be used
-- for a structure's individual list or the combined list from all structures.

import Element exposing (Element, el)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region

import Resource as Resource
import Resource.Types exposing (Resource)
import Resource.Types.All exposing (PackageCountsAll)
import Resource.Types.PackageCounts exposing (PackageCounts)

import Resource.ChiralCrystals as ChiralCrystals
import Resource.Resins as Resins
import Resource.Metal as Metal
import Resource.Ceramics as Ceramics
import Resource.Chemicals as Chemicals
import Resource.SpecialAlloys as SpecialAlloys

import Msg exposing (Msg)

import Palette.Colors as Colors
import Widget exposing (columnHelper)

view : PackageCountsAll -> Maybe (Element Msg)
view counts =
    let
        resElems =
            [ single ChiralCrystals.resource counts.chiralCrystals
            , single Resins.resource counts.resins
            , single Metal.resource counts.metal
            , single Ceramics.resource counts.ceramics
            , single Chemicals.resource counts.chemicals
            , single SpecialAlloys.resource counts.specialAlloys
            ]
        heading = Element.text "Packages needed:"
    in columnHelper
        [Region.heading 2]
        [Background.color Colors.xDarkBlue]
        heading
        resElems

single : Resource r -> PackageCounts r -> Maybe (Element Msg)
single resource counts =
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
                    (Element.text (Resource.printPackage resource pkg))
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
