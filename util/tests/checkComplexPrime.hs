{-# LANGUAGE DoAndIfThenElse #-}

module Main where

import System.Exit (exitFailure)
import KeyGen
import KeyTypes
import KeyIO

keyOneS = 5133
keyOneP = (keyGenComplex keyOneS)
keyTwoS = 5345
keyTwoP = (keyGenComplex keyTwoS)

resultOne = commonKey keyOneP keyTwoS
resultTwo = commonKey keyTwoP keyOneS

main = do
	if (resultOne==resultTwo) then do
		putStrLn "Prime passes complex DH exchange"
		putStrLn "Alice:"
		putStrLn ("    Public => " ++ (formatKey keyOneP))
		putStrLn ("    Private => " ++ (formatSecret keyOneS))
		putStrLn "Bob:"
		putStrLn ("    Public => " ++ (formatKey keyTwoP))
		putStrLn ("    Private => " ++ (formatSecret keyTwoS))
		putStrLn "Result:"
		putStrLn ("    " ++ (show resultOne))
	else do
		putStrLn "Prime fails complex DH exchange"
		putStrLn "Alice:"
		putStrLn ("    Public => " ++ (formatKey keyOneP))
		putStrLn ("    Private => " ++ (formatSecret keyOneS))
		putStrLn "Bob:"
		putStrLn ("    Public => " ++ (formatKey keyTwoP))
		putStrLn ("    Private => " ++ (formatSecret keyTwoS))
		putStrLn "Result (Alice):"
		putStrLn ("    " ++ (show resultOne))
		putStrLn "Result (Bob):"
		putStrLn ("    " ++ (show resultTwo))
		exitFailure