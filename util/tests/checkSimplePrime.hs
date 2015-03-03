{-# LANGUAGE DoAndIfThenElse #-}

module Main where

import System.Exit (exitFailure)
import KeyGen
import KeyTypes
import KeyIO

keyOneP = (keyGen 2)
keyOneS = 2
keyTwoP = (keyGen 3)
keyTwoS = 3

resultOne = commonKey keyOneP keyTwoS
resultTwo = commonKey keyTwoP keyOneS

main = do
	if (resultOne==resultTwo) then do
		putStrLn "Prime passes simple DH exchange"
		putStrLn "Alice:"
		putStrLn ("    Public => " ++ (formatKey keyOneP))
		putStrLn ("    Private => " ++ (formatSecret keyOneS))
		putStrLn "Bob:"
		putStrLn ("    Public => " ++ (formatKey keyTwoP))
		putStrLn ("    Private => " ++ (formatSecret keyTwoS))
		putStrLn "Result:"
		putStrLn ("    " ++ (show resultOne))
	else do
		putStrLn "Prime fails simple DH exchange"
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