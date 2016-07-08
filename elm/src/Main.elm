module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as Html
import WebSocket

import Arena
import World exposing (World)
import Util exposing (randomColor)

type alias Flags =
  { location: String
  }

type alias Model =
  { world: World
  , location: String
  }

type Msg
  = Response String

main : Program Flags
main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

init : Flags -> (Model, Cmd Msg)
init {location} =
    ({world = World.empty, location = location},  Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Response message ->
      let world = parseResponse message
      in ({model | world = world}, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions {location} =
  let
      url = websocketUrl location
  in
      Sub.batch [ WebSocket.listen url Response ]


websocketUrl : String -> String
websocketUrl hostname =
  "ws://" ++ hostname ++ ":4000/ws"


view : Model -> Html Msg
view {world} =
    let arena = Arena.render (1040, 1040) world
        nests = nestBox world.nests
        elements = [header, nests, arena]
    in
        div
          []
          elements

header : Html Msg
header =
  h1
  [ style [ ("textAlign", "center") ] ]
  [ text "Welcome to the 🐜💨 Battle Zone™" ]

nestRow nest =
  tr []
    [ td [] [ Arena.renderColorSquare nest ]
    , td [ style [ ("textAlign", "center")
                 , ("maxWidth", "100px")
                 , ("overflow", "hidden")
                 , ("textOverflow", "ellipsis")
                 ]
         ] [ text nest.team ]
    , td [] [ text <| toString nest.ants ]
    , td [] [ text <| toString nest.food ]
    ]

nestBox : List World.Nest -> Html Msg
nestBox nests =
    let sortedNests = List.sortBy .id nests
        rows = List.map nestRow sortedNests
        header = tr []
                   [ th [ style [ ("width", "20px") ] ] []
                   , th [ style [ ("width", "100px") ] ] [ text "Team" ]
                   , th [ style [ ("width", "20px") ] ] [ text "Ants" ]
                   , th [ style [ ("width", "20px") ] ] [ text "Food" ]
                   ]
        tableBody = header::rows
    in
        div
          [ style [ ("float", "right") ] ]
          [ h3 [] [ text "Nests" ]
          , table [] tableBody
          ]

parseResponse : String -> World
parseResponse message =
    Result.withDefault World.empty (World.parse message)
