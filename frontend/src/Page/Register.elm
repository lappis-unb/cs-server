module Page.Register exposing (view)

import Codeschool.Model exposing (Model, Route(..))
import Codeschool.Msg as Msg exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Polymer.Paper exposing (button)
import Ui.Generic exposing (container)
import Ui.Parts exposing (promoSimple, promoTable, simpleHero)

regForm model field tp modelValue =
    div []
        [ div [ class "item-form" ]
            [ input [ placeholder field, type_ tp, onInput (Msg.UpdateRegister modelValue) ] []
            ]
        ]


encodeTest =
    Debug.log "wow...." ""


view : Model -> Html Msg
view model =
    div []
        [ simpleHero "Register" "" "simple-hero__page-blue"
        , div [ class "main-container" ]
            [ h1 [ class "form-title" ] [ text "Required Fields" ]
            , regForm model "First Name" "text" "name"
            , regForm model "Last Name" "text"  "name"
            , regForm model "School id" "text" "school_id"
            , regForm model "Username" "text" "alias_"
            , regForm model "E-mail" "email" "email"
            , regForm model "Password" "password" "password"
            , regForm model "Repeat Password" "password" "password_confirmation"
            , h1 [ class "form-title" ] [ text "Optional Fields" ]
            , regForm model "Gender" "text" ""
            , regForm model "Birthday" "date" ""
            , regForm model "About me" "text" ""
            , Polymer.Paper.button [ class "submit-button", onClick Msg.DispatchUserRegistration ] [ text "Submit" ]
            ]
        ]
