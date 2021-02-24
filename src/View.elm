module View exposing (view)

import Element exposing (Element, el, column)
import Element.Background as Background
import Element.Font as Font
import Element.Region as Region

import Model exposing (Model)
import Model.Output exposing (ModelOutput)
import Model.Output.Total.Counts as TotalCounts

import Msg exposing (Msg)

import Palette.Font
import Palette.Colors as Colors
import Palette.Font.Size as FontSize
import Version exposing (currentVersion)

import Widget exposing (columnHelper)
import Widget.PackageList as PackageList
import Widget.StructList as StructList
import Widget.TotalList as TotalList
import Widget.TotalWeight as TotalWeight
import Widget.WastedList as WastedList

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
    , StructList.view model.input model.output.structures
    , Maybe.withDefault Element.none
        <| Maybe.map
            ( el
                    [ Element.padding 20
                    , Element.width Element.fill
                    ]
            )
        <| totalsColumn model.output
    , el [] Element.none
    , footer
    , el [] Element.none
    --, el [] ( Element.text
                --<| Base64.Encode.encode
                --<| Base64.Encode.bytes
                --<| Flate.deflate
                --<| S.encodeToBytes Model.codec model
            --)
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
        version = "v" ++ Version.toString currentVersion
    in column
        [ FontSize.xSmall
        , Element.width Element.fill
        ]
        [ el [Element.centerX] (Element.text version)
        , el [Element.centerX, Font.italic] (Element.text copyright)
        ]

totalsColumn : ModelOutput -> Maybe (Element Msg)
totalsColumn output =
    let
        heading = Element.text "Totals"
        pkgCounts = TotalCounts.toPackageCountsAll output.packages
        totalPkgs = PackageList.view pkgCounts
        totalRes = TotalList.view output.packages
        wasted = WastedList.view output.excess
        weight = TotalWeight.view output.weight
    in columnHelper
        [ Region.heading 2
        , Font.underline
        ]
        [Element.padding 20
        , Background.color Colors.black
        ]
        heading
        [totalPkgs, totalRes, wasted, weight]
