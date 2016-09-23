module World exposing (World, Ant, Nest, Point, parse, empty)

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

parse : String -> Result String World
parse string =
    decodeString worldDecoder string

worldDecoder : Decoder World
worldDecoder =
  object3 World
    ("ants" := (list antDecoder))
    ("food" := (list pointDecoder))
    ("nests" := (list nestDecoder))

antDecoder : Decoder Ant
antDecoder =
  object4 Ant
    ("location" := pointDecoder)
    ("team" := string)
    ("got_food" := bool)
    ("nest" := int)

nestDecoder : Decoder Nest
nestDecoder =
  object5 Nest
    ("id" := int)
    ("location" := pointDecoder)
    ("team" := string)
    ("ants" := int)
    ("food" := int)

pointDecoder : Decoder Point
pointDecoder =
  tuple2 (,) float float
