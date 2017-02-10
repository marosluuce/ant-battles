module World exposing (World, Ant, Nest, Point, parse, empty)

import Json.Encode as JE
import Json.Decode exposing (..)

type alias Point = (Float, Float)

type alias Nest =
    { id: Int
    , position: Point
    , team: String
    , ants: Int
    , food: Int
    }

type alias Ant =
    { position: Point
    , team: String
    , hasFood: Bool
    , nestId: Int
    }

type alias World =
    { ants: List Ant
    , food: List Point
    , nests: List Nest
    }

empty : World
empty =
    { ants = []
    , food = []
    , nests = []
    }

parse : JE.Value -> Result String World
parse value =
    decodeValue worldDecoder value

worldDecoder : Decoder World
worldDecoder =
  map3 World
    (field "ants" (list antDecoder))
    (field "food" (list pointDecoder))
    (field "nests" (list nestDecoder))

antDecoder : Decoder Ant
antDecoder =
  map4 Ant
    (field "location" pointDecoder)
    (field "team" string)
    (field "got_food" bool)
    (field "nest" int)

nestDecoder : Decoder Nest
nestDecoder =
  map5 Nest
    (field "id" int)
    (field "location" pointDecoder)
    (field "team" string)
    (field "ants" int)
    (field "food" int)

pointDecoder : Decoder Point
pointDecoder =
  map2 (,) (index 0 float) (index 1 float)
