module Util exposing (randomColor)

import Color exposing (..)
import Random exposing (..)

randomColor : Int -> Color
randomColor nestId =
    let seed = initialSeed nestId
        (r, seed1) = step (int 0 255) seed
        (g, seed2) = step (int 0 255) seed1
        (b, seed3) = step (int 0 255) seed2
        (a, _) = step (float 0.5 1) seed3
    in rgba r g b a
