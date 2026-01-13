module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Simple
import Test exposing (..)


suite : Test
suite =
    test "Double 2 => 4"
        (\_ -> Expect.equal 4 (Simple.double 2))
