module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Phoenix.Socket as Socket
import Phoenix.Channel
import Json.Encode as JE

import Arena
import World exposing (World, Nest)

type alias Flags =
  { location: String
  }

type alias Model =
  { world : World
  , socket : Socket.Socket Msg
  }

type Msg
  = SentWorld JE.Value
  | PhoenixMsg (Socket.Msg Msg)
  | JoinChannel

main : Program Flags
main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

room : String
room = "room:admin"

initSocket : String -> Socket.Socket Msg
initSocket location =
  Socket.init (websocketUrl location)
  |> Socket.on "world:update" room SentWorld

init : Flags -> (Model, Cmd Msg)
init {location} =
  let model = { world = World.empty
              , socket = initSocket location
              }
  in
    update JoinChannel model

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    PhoenixMsg msg ->
        let
            (socket, phxCmd) = Socket.update msg model.socket
        in
            {model | socket = socket} ! [Cmd.map PhoenixMsg phxCmd]

    SentWorld json ->
        let world = parseResponse json
        in
            {model | world = world} ! []

    JoinChannel ->
      let
        channel = Phoenix.Channel.init room
        (socket, phxCmd) = Socket.join channel model.socket
      in
        {model | socket = socket} ! [Cmd.map PhoenixMsg phxCmd]

subscriptions : Model -> Sub Msg
subscriptions {socket} =
    Socket.listen socket PhoenixMsg

websocketUrl : String -> String
websocketUrl hostname =
  "ws://" ++ hostname ++ ":4000/socket/websocket"

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

nestRow : Nest -> Html a
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

parseResponse : JE.Value -> World
parseResponse message =
    Result.withDefault World.empty (World.parse message)
