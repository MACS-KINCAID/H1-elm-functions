module TestSuite exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, niceFloat, string)
import Helper exposing (..)
import Test exposing (..)


doubleFunc : Test
doubleFunc =
    describe "double function"
        [ fuzz int "Double accept int" <|
            \num ->
                double num
                    |> Expect.equal (num * 2)
        , fuzz niceFloat "Double accept float" <|
            \num ->
                double num
                    |> Expect.within (Expect.Absolute 0.000000001) (num * 2)
        ]


squareFunc : Test
squareFunc =
    describe "square function"
        [ fuzz int "Square accept int" <|
            \num ->
                square num
                    |> Expect.equal (num ^ 2)
        , fuzz niceFloat "Square accept float" <|
            \num ->
                square num
                    |> Expect.within (Expect.Absolute 0.000000001) (num ^ 2)
        ]


above5Func : Test
above5Func =
    describe "above5 function"
        [ fuzz int "above5 accept int" <|
            \num ->
                above5 num
                    |> Expect.equal (num > 5)
        , fuzz niceFloat "above5 accept float" <|
            \num ->
                above5 num
                    |> Expect.equal (num > 5)
        ]


boolTranslateFunc : Test
boolTranslateFunc =
    describe "ifBoolTranslate function"
        [ test "ifBoolTranslate true" <|
            \_ ->
                ifBoolTranslate True
                    |> Expect.equal "Verdadero"
        , test "ifBoolTranslate false" <|
            \_ ->
                ifBoolTranslate False
                    |> Expect.equal "Falso"
        ]


numberSignFunc : Test
numberSignFunc =
    describe "ifNumberSign function"
        [ fuzz int "ifNumberSign accept int" <|
            \num ->
                ifNumberSign num
                    |> Expect.equal
                        (if num == 0 then
                            "Neutral"

                         else if num > 0 then
                            "Positive"

                         else
                            "Negative"
                        )
        , fuzz niceFloat "ifNumberSign accept float" <|
            \num ->
                ifNumberSign num
                    |> Expect.equal
                        (if num == 0 then
                            "Neutral"

                         else if num > 0 then
                            "Positive"

                         else
                            "Negative"
                        )
        ]


intExcept123 : Fuzzer Int
intExcept123 =
    Fuzz.oneOf
        [ Fuzz.intRange -100000 -1
        , Fuzz.intRange 4 100000
        ]


getNameByIdFunc : Test
getNameByIdFunc =
    describe "getNameById function"
        [ test "Id 1 -> Fernanda" <|
            \_ ->
                getNameById 1
                    |> Expect.equal "Fernanda"
        , test "Id 2 -> Miguel" <|
            \_ ->
                getNameById 2
                    |> Expect.equal "Miguel"
        , test "Id 3 -> Juan" <|
            \_ ->
                getNameById 3
                    |> Expect.equal "Juan"
        , fuzz intExcept123 "Id not 1, 2 or 3 -> Desconocido" <|
            \num ->
                getNameById num
                    |> Expect.equal "Desconocido"
        ]


stringExcept : List String -> Fuzzer String
stringExcept forbidden =
    Fuzz.filter (\s -> not (List.member s forbidden)) Fuzz.string


customStringFuzzer : Fuzzer String
customStringFuzzer =
    stringExcept [ "Fernanda", "Miguel", "Juan" ]


getGradeByNameFunc : Test
getGradeByNameFunc =
    describe "getGradeByName function"
        [ test "Fernanda -> 9.4" <|
            \_ ->
                getGradeByName "Fernanda"
                    |> Expect.within (Expect.Absolute 0.000000001) 9.4
        , test "Miguel -> 8.7" <|
            \_ ->
                getGradeByName "Miguel"
                    |> Expect.within (Expect.Absolute 0.000000001) 8.7
        , test "Juan -> 9.3" <|
            \_ ->
                getGradeByName "Juan"
                    |> Expect.within (Expect.Absolute 0.000000001) 9.3
        , fuzz customStringFuzzer "Random string except Fernanda, Miguel or Juan -> 0" <|
            \name ->
                getGradeByName name
                    |> Expect.within (Expect.Absolute 0.000000001) 0
        ]
