module Page.Questions.Base exposing (viewDetail, viewList, clsList)

-- import Codeschool.Msg exposing (..)
-- import Data.User exposing (User)
import Codeschool.Model exposing (Model)
import Html exposing (..)
import Ui.Parts exposing (promoSimple, promoTable, simpleHero)
import Data.Question exposing (..)
import Html.Attributes exposing (..)
import Polymer.Paper as Paper exposing (button, fab)
import Polymer.Attributes exposing (icon)
import Ui.Generic exposing (date, emoticon)

-- import Html.Events exposing (..)


viewDetail : Model -> Html msg
viewDetail m =
    div [] [ text "#teste" ]


viewList : List QuestionInfo -> Html msg
viewList m =
    let
      -- testing if there are no questions
      --  m = []
        empty =
            [ emoticon ":-("
            , p [ class "center-text" ]
                [ text "Sorry, there are no questions for you."
                , br [] []
                , text "Please wait for more questions or send a message to you teacher to check if everything is ok."
                ]
            ]

        listing =
            [ div [ class "question-info-list" ] (List.map questionInfo m)
            ]

        fab_ =
            fab [ icon "add", class "content-fab", alt "Find a new classroom" ] []

        children =
            case m of
                [] ->
                    fab_ :: empty

                _ ->
                    fab_ :: listing

    in
        div []
        [ simpleHero "List of Questions" "See all questions available for you"
        , div [ class "container" ] children
        ]


questionInfo : QuestionInfo -> Html msg
questionInfo cls =
    div [ class "question-info-card" ]
        [ Ui.Generic.icon [class "question-info-card__icon"] cls.icon
        , h1 [ class "question-info-card__title" ]
            [ text cls.questionName
            ]
        , p [ class "question-info-card__description" ]
            [ text cls.shortDescription
            ]
        ]

questionOne : QuestionInfo
questionOne =
    { questionName = "VEMMM MALUCOOOOO"
    , shortDescription = "DESCREVE INSANOOOOOOOOOOOOOO."
    , icon = "code"
    }

questionTwo : QuestionInfo
questionTwo =
    { questionName = "nome da questão pois é"
    , shortDescription = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris varius tellus velit, ut accumsan odio tincidunt in."
    , icon = "sentiment_very_satisfied"
    }

questionThree : QuestionInfo
questionThree =
    { questionName = "Sequência de Fibonacci"
    , shortDescription = "Questão para testar seus conhecimentos sobre como funciona o algoritmo de fibonacci"
    , icon = "all_out"
    }

questionFour : QuestionInfo
questionFour =
    { questionName = "Sequência de Fibonacci"
    , shortDescription = "Questão para testar seus conhecimentos sobre como funciona o algoritmo de fibonacci"
    , icon = "all_out"
    }

clsList : List QuestionInfo
clsList =
    [ questionOne, questionTwo, questionThree, questionFour ]
