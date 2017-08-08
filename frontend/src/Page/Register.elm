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

regForm model field tp modelValue regex errorMessage =
    div [ class "item-form" ]
            [ input [ pattern regex,placeholder field, type_ tp, onInput (Msg.UpdateRegister modelValue), title errorMessage ] []
            ]


view : Model -> Html Msg
view model =
    div []
        [ simpleHero "Register" "" "simple-hero__page-blue"
        , div [ class "main-container" ]
            [ h1 [ class "form-title" ] [ text "Required Fields" ]
            , regForm model "Full name" "text" "name" "^[A-Za-záàâãéèêíïóôõöúçñÁÀÂÃÉÈÊÍÏÓÔÕÖÚÇÑ ]{1,50}$" "Por favor insira um nome entre 1 e 50 caracteres"
            , regForm model "School id" "text" "school_id" "^[0-9]{1,15}$" "Somente números são permitidos."
            , regForm model "Username" "text" "alias_" "^[A-Za-z0-9_.]{1,20}$" "Por favor insira um usuário de 1 a 20 caracteres alfanuméricos. Somente _ e . são permitidos."
            , div [ class "item-form" ]
                  [ input [placeholder "E-mail", type_ "email", onInput (Msg.UpdateRegister "email") ] []
                  ]
            , div [ class "item-form" ]
                  [ input [placeholder "E-mail confirmation", type_ "email", onInput (Msg.UpdateRegister "email_confirmation") ] []
                  ]
            , regForm model "Password" "password" "password" "^[\\S]{6,30}$" "Sua senha deve conter no mínimo 6 caracteres alfanuméricos. Símbolos permitidos."
            , regForm model "Repeat Password" "password" "password_confirmation" "^[\\S]{6,30}$" "Confirme sua senha"
            , h1 [ class "form-title" ] [ text "Optional Fields" ]
            , select [Html.Attributes.name "Gender", class "item-form", onChange (Msg.UpdateRegister "gender")]
                [ option [value "", disabled True, selected True, class "disabled-item"] [text "Gender"]
                , option [value "Male"] [ text "Male"]
                , option [value "Female"] [ text "Female"]
                , option [value "Other"] [ text "Other"]
                ]
            , div [class "date-form"]
                [ monthPicker
                , input [pattern "([0]?[1-9]|[12][0-9]|3[01])", maxlength 2, placeholder "Day", class "date-item", onInput (Msg.UpdateDate "day")] []
                , input [pattern "^(19|20)[0-9]{2}$", maxlength 4, placeholder "Year", class "date-item", onInput (Msg.UpdateDate "year")] []
                ]
            , div [ class "item-form" ]
                  [ textarea [ maxlength 500, placeholder "About me", onInput (Msg.UpdateRegister "about_me") ] []
                  ]
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
