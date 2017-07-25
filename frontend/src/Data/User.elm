module Data.User exposing (..)

{-| Represents user objects in Elm
-}

import Json.Decode as Dec exposing (..)
import Json.Encode as Enc


{-| Represents a simple user
-}
type alias User =
    { name : String
    , alias_ : String -- needed
    , email : String -- needed
    , email_confirmation : String -- needed
    , id : Int
    , password : String -- needed
    , password_confirmation : String -- needed
    , school_id: String -- needed
    }


testUser : User
testUser =
    { name = "Anonymous", alias_ = "unknown", email = "none@gmail.com", email_confirmation = "none@gmail.com", id = 1, password = "123456", password_confirmation = "123456", school_id = "15/0344750" }


{-| A decoder for user objects
-}
userDecoder : Dec.Decoder User
userDecoder =
    Dec.map8 User
        (field "name" string)
        (field "alias" string)
        (field "email" string)
        (field "email_confirmation" string)
        (field "id" int)
        (field "password" string)
        (field "password_confirmation" string)
        (field "school_id" string)


{-| Convert user to JSON
-}
toJson : User -> Dec.Value
toJson user =
    let
        str =
            Enc.string
    in
    Enc.object
        [ ( "name", str user.name )
        , ( "alias", str user.alias_ )
        , ( "email_confirmation", str user.email )
        , ( "email", str user.email )
        , ( "id", Enc.int user.id )
        , ( "password", str user.password)
        , ( "password_confirmation", str user.password_confirmation)
        , ( "school_id", str user.school_id)
        ]


{-| Return the REST URL associated with the user
-}
toURL : User -> String
toURL user =
    "/users/" ++ toString user.id
