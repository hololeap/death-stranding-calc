module Version exposing 
    ( Version
    , currentVersion
    , toString
    )

type Version = Version (List Int)

currentVersion : Version
currentVersion = Version [0, 2, 0]

toString : Version -> String
toString (Version version) =
    let loop v = case v of
            [] -> ""
            [n] -> String.fromInt n
            (n :: ns) -> String.fromInt n ++ "." ++ loop ns
    in loop version
