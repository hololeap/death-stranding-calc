module Model.Input exposing (..)

import Serialize exposing (Codec)
import Flate
import Base64.Encode as B64E
import Base64.Decode as B64D
import Url exposing (Url)
import Url.Builder
import Url.Parser
import Url.Parser.Query as QueryP

import Dict.AutoInc as AutoIncDict exposing (AutoIncDict)
import Model.Input.Structure as StructureInput exposing (StructureInput)

import Version

type alias ModelInput = AutoIncDict StructureInput

init : ModelInput
init = AutoIncDict.singletonNeedingInc "structure" StructureInput.init

codec : Codec e ModelInput
codec = AutoIncDict.codec StructureInput.codec

encode : ModelInput -> String
encode = Serialize.encodeToBytes codec
    >> Flate.deflate
    >> B64E.bytes
    >> B64E.encode

decode : String -> Maybe ModelInput
decode = B64D.decode B64D.bytes
    >> Result.toMaybe
    >> Maybe.andThen Flate.inflate
    >> Maybe.andThen (Serialize.decodeFromBytes codec >> Result.toMaybe)

-- Url.Builder.relative and Browser.Navigation.replaceUrl both handle strings
-- instead of Uri types, so we return a string here.
encodeUrl : ModelInput -> String
encodeUrl input =
    let encodedInput = encode input
    in Url.Builder.relative 
        [] 
        [ Url.Builder.string "version" (Version.toString Version.currentVersion)
        , Url.Builder.string "state" encodedInput ]

decodeUrl : Url -> Maybe ModelInput
decodeUrl url =
    let
        -- This is a hack to completely ignore the path and just extract the
        -- query
        modifiedUrl = { url | path = "" }

        checkVersion maybeVersion maybeState =
            case maybeVersion of
                -- If there is no version info, just let the state through
                Nothing -> maybeState
                Just version ->
                    if version == Version.toString Version.currentVersion
                        then maybeState
                        else Nothing
        queryParser =
            QueryP.map2
                checkVersion
                (QueryP.string "version")
                (QueryP.string "state")
        parser = Url.Parser.query queryParser
    in
        Maybe.andThen
            (Maybe.andThen decode)
            (Url.Parser.parse parser modifiedUrl)
