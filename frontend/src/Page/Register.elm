module Page.Register exposing (view)

import Codeschool.Model exposing (Model, Route(..))
import Codeschool.Msg as Msg exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, on, onSubmit)
import Http exposing (Part)
import Polymer.App exposing (..)
import Polymer.Events exposing (onValueChanged)
import Polymer.Paper exposing (button)
import Ui.Generic exposing (container)
import Ui.Parts exposing (promoSimple, promoTable, simpleHero)
import Json.Decode as Json

regForm model field tp modelValue =
    div []
        [ div [ class "item-form" ]
            [ input [ placeholder field, type_ tp, onInput (Msg.UpdateRegister modelValue) ] []
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ simpleHero "Register" "" "simple-hero__page-blue"
        , div [ class "main-container" ]
            [ h1 [ class "form-title" ] [ text "Required Fields" ]
            , regForm model "Full name" "text" "name"
            , regForm model "School id" "text" "school_id"
            , regForm model "Username" "text" "alias_"
            , regForm model "E-mail" "email" "email"
            , regForm model "E-mail confirmation" "email" "email_confirmation"
            , regForm model "Password" "password" "password"
            , regForm model "Repeat Password" "password" "password_confirmation"
            , h1 [ class "form-title" ] [ text "Optional Fields" ]
            , select [Html.Attributes.name "Gender", class "item-form", onChange (Msg.UpdateRegister "gender")]
                [ option [value "", disabled True, selected True, class "disabled-item"] [text "Gender"]
                , option [value "Male"] [ text "Male"]
                , option [value "Female"] [ text "Female"]
                , option [value "Other"] [ text "Other"]
                ]
            , div [class "date-form"]
                [ monthPicker
                , input [maxlength 2, placeholder "Day", class "date-item", onInput (Msg.UpdateDate "day")] []
                , input [maxlength 4, placeholder "Year", class "date-item", onInput (Msg.UpdateDate "year")] []
                ]
            , regForm model "About me" "text" "about_me"
            , Polymer.Paper.button [ class "submit-button", onClick Msg.DispatchUserRegistration ] [ text "Submit" ]
            ]
        ]

radio option =
    Html.label [class "radio-item"]
        [ input [type_ "radio", name "action", onClick (Msg.UpdateRegister "gender" option) ] []
        , text option
        ]

onChange : (String -> msg) -> Attribute msg
onChange handler =
  Html.Events.on "change" <| Json.map handler <| Json.at ["target", "value"] Json.string

monthPicker =
  select [Html.Attributes.name "Month", class "date-month", onChange (Msg.UpdateDate "month")]
      [ option [value "", disabled True, selected True, class "disabled-item"] [text "Month"]
      , option [value "January"] [ text "January"]
      , option [value "February"] [ text "February"]
      , option [value "March"] [ text "March"]
      , option [value "April"] [ text "April"]
      , option [value "May"] [ text "May"]
      , option [value "June"] [ text "June"]
      , option [value "July"] [ text "July"]
      , option [value "August"] [ text "August"]
      , option [value "September"] [ text "September"]
      , option [value "October"] [ text "October"]
      , option [value "November"] [ text "November"]
      , option [value "December"] [ text "December"]

      ]
