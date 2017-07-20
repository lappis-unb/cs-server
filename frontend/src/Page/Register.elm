module Page.Register exposing (view)

import Codeschool.Model exposing (Model)
import Codeschool.Msg as Msg exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import Polymer.Paper exposing (button)
import Ui.Generic exposing (container)
import Ui.Parts exposing (promoSimple, promoTable, simpleHero)


regForm model field tp =
    div []
        [ div [ class "item-form" ]
            [ input [ placeholder field, type_ tp ] []
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ simpleHero "Register" "" "simple-hero__page-blue"
        , div [ class "main-container" ]
            [ h1 [ class "form-title" ] [ text "Required Fields" ]
            , regForm model "First Name" "text"
            , regForm model "Last Name" "text"
            , regForm model "Username" "text"
            , regForm model "E-mail" "email"
            , regForm model "Password" "password"
            , regForm model "Repeat Password" "password"
            , h1 [ class "form-title" ] [ text "Optional Fields" ]
            , regForm model "Gender" "text"
            , regForm model "Birthday" "date"
            , regForm model "About me" "text"
            , Polymer.Paper.button [ class "submit-button" ] [ text "Submit" ]
            ]
        ]
