module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode exposing (Decoder, field, string)
import Json.Decode.Pipeline exposing (required)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL state of application


type Model
    = Failure
    | Loading
    | Sucess String


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getRandomMessage )



-- UPDATE-update your state based messages


type Msg
    = MoreIdeas
    | GotIdea (Result Http.Error String)
    | GotText (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MoreIdeas ->
            ( Loading, getRandomMessage )

        GotIdea result ->
            case result of
                Ok url ->
                    ( Sucess url, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )

        GotText result ->
            --Ok ayshaDecoder ->
            ( Sucess ayshaDecoder, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW-turn your stated into html


view : Model -> Html Msg
view model =
    case model of
        Failure ->
            div
                [ div [] [ text "Could not load" ]
                , button
                    [ onClick MoreIdeas ]
                    [ text "try again" ]
                ]

        Loading ->
            div [] [ text "loading.." ]

        Sucess url ->
            div
                []
                [ button
                    [ onClick MoreIdeas
                    , style "display" "block"
                    ]
                    [ text "More Please!" ]
                , text [ src url ] []
                ]



--decoder
--field : String -> Decoder ayshaDecoder -> Decoder ayshaDecoder


type alias Aysha =
    { activity : String
    , accessibility : Float
    , type1 : String
    , participants : Int
    , price : String
    , link : String
    , key : String
    }



--Decoder


ayshaDecoder : Decoder Aysha
ayshaDecoder =
    Json.Decode.succeed Aysha
        |> required "activity" string


result =
    Json.Decode.decodeString
        ayshaDecoder
        """
  { "activity": "Go see a Broadway production" }
"""



--HTTP


getRandomMessage : Cmd Msg
getRandomMessage =
    Http.get
        { expect = Http.expectJson GotText
        , url = "http://www.boredapi.com/api/activity/"
        }
