module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Http
import Json.Decode exposing (Decoder, field, string)



-- MAIN


main =
  Browser.element 
  { init = init
  , update = update
  , subscriptions = subscriptions
  , view = view 
  }



-- MODEL state of application


type  Model 
 =Failure
 |Loading
 |Sucess String


init : () -> (Model, Cmd Msg)
init _=
  (Loading, getRandomMessage)



-- UPDATE-update your state based messages


type Msg
  = MoreIdeas
  | GotIdea (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MoreIdeas ->
      ( Loading, getRandomMessage )
    GotIdea result ->
      case result of 
        Ok url ->
          (Sucess url, Cmd.none)
        Err_->
          (Failure, Cmd.none)

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW-turn your stated into html


viewIdea : Model -> Html Msg
viewIdea model = 
   case model of 
     Failure ->
       div []
         []
        [ text "Could not load"
        ,button[ onClick MoreIdeas][text"try again"]
        ]
      Loading ->
        text "loading.."
      Sucess url ->
        div[]
        [ button [onClick MoreIdeas, style "display" "block"] [ text "More Please!" ]
        , img [ src url ] []
        ]
    [ --input [placeholder "your name"  ] [ ]
    --, input [placeholder "thier name"  ] [ ]
    button [ ] [ text "Click here" ]
    ]



--HTTP
getRandomMessage : Cmd Msg
getRandomMessage =
   Http.get
   {url = "http://www.boredapi.com/api/activity/"}


