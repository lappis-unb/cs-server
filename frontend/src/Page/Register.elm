module Page.Register exposing (view)

import Codeschool.Model exposing (Model, Route(..))
import Codeschool.Msg as Msg exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, on)
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
            , regForm model "First Name" "text" "name"
            , regForm model "Last Name" "text"  "name"
            , regForm model "School id" "text" "school_id"
            , regForm model "Username" "text" "alias_"
            , regForm model "E-mail" "email" "email"
            , regForm model "Password" "password" "password"
            , regForm model "Repeat Password" "password" "password_confirmation"
            , h1 [ class "form-title" ] [ text "Optional Fields" ]
            -- , Polymer.Paper.dropdownMenu [attribute "label" "Gender", class "dropdown-menu" ]
            --   [ Polymer.Paper.listbox [ attribute "slot" "dropdown-content", attribute "selected" "0" ]
            --     [ Polymer.Paper.item [class "select-item", onClick (Msg.UpdateRegister "gender" "Male")] [text "Male"]
            --     , Polymer.Paper.item [class "select-item", onClick (Msg.UpdateRegister "gender" "Female")] [text "Female"]
            --     , Polymer.Paper.item [class "select-item", onClick (Msg.UpdateRegister "gender" "Other")] [text "Other"]
            --     ]
            --   ]
            , select [Html.Attributes.name "Gender", class "item-form", onChange (Msg.UpdateRegister "gender")]
                [ option [value "", disabled True, selected True, style [("display", "none")]] [text "Gender"]
                , option [value "Male"] [ text "Male"]
                , option [value "Female"] [ text "Female"]
                , option [value "Other"] [ text "Other"]
                ]




            , regForm model "Birthday" "date" "birthday"
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
