module Model.Input exposing (..)

import Serialize exposing (Codec)
import Dict.AutoInc as AutoIncDict exposing (AutoIncDict)
import Model.Input.Structure as StructureInput exposing (StructureInput)

type alias ModelInput = AutoIncDict StructureInput

init : ModelInput
init = AutoIncDict.singletonNeedingInc "structure" StructureInput.init

codec : Codec e ModelInput
codec = AutoIncDict.codec StructureInput.codec
