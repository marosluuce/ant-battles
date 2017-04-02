module Util exposing (randomColor, parseInt)

import Color exposing (..)
import Random exposing (..)


randomColor : Int -> Color
randomColor seedVal =
    let
        seed =
            initialSeed seedVal

        ( r, seed1 ) =
            step (int 0 255) seed

        ( g, seed2 ) =
            step (int 0 255) seed1

        ( b, seed3 ) =
            step (int 0 255) seed2

        ( a, _ ) =
            step (float 0.5 1) seed3
    in
        rgba r g b a

parseInt : String -> Int
parseInt val =
    String.toInt val |> Result.withDefault 0
