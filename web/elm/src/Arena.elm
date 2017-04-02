module Arena exposing (..)

import Html exposing (Html)
import Element exposing (..)
import Collage exposing (..)
import Text
import Color exposing (Color)
import World exposing (World, Ant, Nest, Point)
import Util exposing (randomColor, parseInt)


scale : number
scale =
    20


render : ( Int, Int ) -> World -> Html a
render ( width, height ) { ants, food, nests } =
    let
        renderedBg =
            background 51 51 scale

        renderedAnts =
            List.map (renderAnt scale) ants

        renderedFood =
            List.map (renderFood scale) food

        renderedHive =
            box scale ( 0, 0 ) Color.black

        elements =
            [ renderedBg ] ++ renderedAnts ++ renderedFood ++ [ renderedHive ]
    in
        toHtml <| collage width height elements


renderColorSquare : Nest -> Html a
renderColorSquare { id } =
    let
        nestColor =
            randomColor <| parseInt id

        colorSquare =
            square scale |> filled nestColor
    in
        toHtml <| collage 10 10 [ colorSquare ]


background : Float -> Float -> Float -> Form
background blocksWide blocksHigh scale =
    let
        width =
            blocksWide * scale

        height =
            blocksHigh * scale
    in
        rect width height |> filled Color.lightGrey


renderAnt : Float -> Ant -> Form
renderAnt scale ant =
    let
        antColor =
            randomColor <| parseInt ant.nestId

        renderedAnt =
            box scale ant.position antColor

        renderedName =
            scaledText "F" scale ant.position
    in
        if ant.hasFood then
            group [ renderedAnt, renderedName ]
        else
            renderedAnt


renderFood : Float -> Point -> Form
renderFood scale ( x, y ) =
    let
        sideLength =
            scale / 2
    in
        ngon 6 sideLength
            |> filled Color.lightBrown
            |> move ( x * scale, y * scale )


scaledText : String -> Float -> Point -> Form
scaledText string scale ( x, y ) =
    let
        position =
            ( x * scale, (y * scale) + (scale / 8) )

        displayed =
            Text.fromString string
    in
        Text.fromString string
            |> Text.height (scale * 0.75)
            |> Text.color Color.white
            |> text
            |> move position


box : Float -> ( Float, Float ) -> Color -> Form
box scale ( x, y ) color =
    square scale
        |> filled color
        |> move ( x * scale, y * scale )
