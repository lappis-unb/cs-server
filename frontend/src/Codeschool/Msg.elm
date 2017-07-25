module Codeschool.Msg exposing (..)

{-| Main page messages and update function
-}

import Codeschool.Model exposing (Model, Route)
import Codeschool.Routing exposing (parseLocation, reverse)
import Data.User exposing (User, toJson, userDecoder)
import Http exposing (..)
import Navigation exposing (Location, back, newUrl)
import Debug

{-| Message type
-}
type Msg
    = ChangeLocation Location
    | ChangeRoute Route
    | RequireAsset String
    | AssetLoaded String
    | GoBack Int
    | DispatchUserRegistration
    | UpdateRegister String String
    | RequestReceiver (Result Http.Error User)

{-| Update function
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeRoute route ->
            model ! [ newUrl (reverse route) ]

        ChangeLocation loc ->
            { model | route = parseLocation loc } ! []

        RequireAsset asset ->
            if List.any ((==) asset) model.loadedAssets then
                model ! []
                --- TODO: send a message requesting to load an asset
            else
                model ! []

        AssetLoaded asset ->
            { model | loadedAssets = withElement asset model.loadedAssets } ! []

        GoBack int->
         (model, back int)

        DispatchUserRegistration ->
          let
              data = sendData model.user

          in
        --    Debug.log (toString data)
            (model, data)

        UpdateRegister inputModel inputValue ->
            let
                newUser = formReceiver model.user inputModel inputValue
            in
              ({model | user = newUser}, Cmd.none)

        RequestReceiver user ->
          Debug.log(toString user)
          (model, Cmd.none)


{-| Return a new list that surely include the given element
-}
withElement : a -> List a -> List a
withElement el lst =
    if List.any ((==) el) lst then
        lst
    else
        el :: lst
formReceiver : User -> String -> String -> User
formReceiver user inputModel inputValue =
  case inputModel of
    "name" ->
        {user | name = inputValue}
    "alias_" ->
        {user | alias_ = inputValue}
    "email" ->
        {user | email = inputValue}
    "password" ->
        {user | password = inputValue}

    "password_confirmation" ->
        {user | password_confirmation = inputValue}

    "school_id" ->
        {user | school_id = inputValue}

    _ ->
        user


sendData user =
      -- Debug.log (toString test)
      -- Http.post "http://cadernos-api.herokuapp.com/users" (Http. ( user) userDecoder
    Debug.log (toString (toJson user))
    Http.request
    { body = toJson user |> Http.jsonBody
    , expect = Http.expectJson userDecoder
    , headers = []
    , method = "POST"
    , timeout = Nothing
    , url = "http://192.168.0.17:3000/users"
    , withCredentials = False
    }
      |> Http.send RequestReceiver
