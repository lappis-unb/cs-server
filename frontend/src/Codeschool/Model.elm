module Codeschool.Model
    exposing
        ( Model
        , Route(..)
        , init
        )

{-| Page model components.
-}

import Data.User exposing (..)
import Data.Date exposing (..)
import Data.Classroom exposing (Classroom, ClassroomInfo)

{-| Main page Model
-}
type alias Model =
    { user : User
    , userError: UserError
    , route : Route
    , classroomInfoList : List ClassroomInfo
    , classroom : Maybe Classroom
    , loadedAssets : List String
    , date : Date
    }


{-| Starts the main model to default state.
-}
init : Model
init =
    { user = testUser
    , userError = testUserError
    , route = Index
    , classroomInfoList = []
    , classroom = Nothing
    , loadedAssets = []
    , date = testDate
    }



---- ROUTES ----


type alias Slug =
    String


type alias Id =
    Int


{-| A list of all valid routes in Codeschool
-}
type Route
    = Index
    | NotFound
    | ClassroomList
    | Classroom Slug
    | SubmissionList
    | ScoreBoard
    | Progress
    | Learn
    | Help
    | QuestionList
    | Question Id
    | Social
    | Profile Id
    | Logout
    | Actions
    | Register
