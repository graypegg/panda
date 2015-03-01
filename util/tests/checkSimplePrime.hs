{-# LANGUAGE DoAndIfThenElse #-}

module Main where

import System.Exit (exitFailure)
import KeyGen
import KeyTypes

keyOneP = (keyGen 2)
keyOneS = 2
keyTwoP = (keyGen 3)
keyTwoS = 3

main = do
	if ((commonKey keyOneP keyTwoS)==(commonKey keyTwoP keyOneS)) then do
		putStrLn "Prime passes simple DH exchange"
	else do
		putStrLn "Prime fails simple DH exchange"
		exitFailure