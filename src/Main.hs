{-# LANGUAGE DoAndIfThenElse #-}

{-
    Panda Diffie-Hellman Key Exchange
    Copyright (C) 2015 Graham John Pegg

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
-}

import KeyGen
import KeyIO
import KeyTypes
import System.Environment
import System.IO
import Options
import Cmd.MainOpts
import Cmd.MakeOpts
import Cmd.GenOpts

makeNumber :: MainOptions -> MakeOpts -> [String] -> IO ()
makeNumber mainOpts opts args
	| (optVersion mainOpts) = printVersion
	| (optFile mainOpts)/="" && (optJSON opts)==True = do
		writeData (optFile mainOpts) $ resultToJSON (unformatKey (optKeyPublic opts)) (unformatSecret (optKeySecret opts)) (commonKey (unformatKey (optKeyPublic opts)) (unformatSecret (optKeySecret opts)))
	| (optFile mainOpts)/="" && (optQuiet opts)==True = do
		writeData (optFile mainOpts) $ justResult (commonKey (unformatKey (optKeyPublic opts)) (unformatSecret (optKeySecret opts)))
	| (optJSON opts)==True   = do
		putStrLn $ resultToJSON (unformatKey (optKeyPublic opts)) (unformatSecret (optKeySecret opts)) (commonKey (unformatKey (optKeyPublic opts)) (unformatSecret (optKeySecret opts)))
	| (optQuiet opts)== True = do
		putStrLn $ justResult (commonKey (unformatKey (optKeyPublic opts)) (unformatSecret (optKeySecret opts)))
	| otherwise              = do
    	putStrLn $ show $ commonKey (unformatKey (optKeyPublic opts)) (unformatSecret (optKeySecret opts))
        
genKey :: MainOptions -> GenOpts -> [String] -> IO ()
genKey mainOpts opts args = do
	if (optVersion mainOpts) then do
		printVersion
	else do
		if (optJustPublic opts)==True then do
			if (optGenJSON opts)==True then do
				if (optFile mainOpts)/="" then do
					writeData (optFile mainOpts) $ keyToJSON (keyGenChoose (optComplex opts) (optGenPrime opts) (optGenRoot opts) (optKeyGenerator opts)) (optKeyGenerator opts) Public
				else do
					putStrLn $ keyToJSON (keyGenChoose (optComplex opts) (optGenPrime opts) (optGenRoot opts) (optKeyGenerator opts)) (optKeyGenerator opts) Public
			else do
				if (optFile mainOpts)/="" then do
					writeData (optFile mainOpts) $ (hashtagsStr opts "# This is your public key, give this to people.\n")++(formatKey (keyGenChoose (optComplex opts) (optGenPrime opts) (optGenRoot opts) (optKeyGenerator opts)))
				else do
					hashtags opts "# This is your public key, give this to people."
					putStrLn (formatKey (keyGenChoose (optComplex opts) (optGenPrime opts) (optGenRoot opts) (optKeyGenerator opts)))
		else do
			if (optJustSecret opts)==True then do
				if (optGenJSON opts)==True then do
					if (optFile mainOpts)/="" then do
						writeData (optFile mainOpts) $ keyToJSON (keyGenChoose (optComplex opts) (optGenPrime opts) (optGenRoot opts) (optKeyGenerator opts)) (optKeyGenerator opts) Private
					else do
						putStrLn $ keyToJSON (keyGenChoose (optComplex opts) (optGenPrime opts) (optGenRoot opts) (optKeyGenerator opts)) (optKeyGenerator opts) Private
				else do
					if (optFile mainOpts)/="" then do
						writeData (optFile mainOpts) $ (hashtagsStr opts "# This is your private key, hide this.\n")++(formatSecret (optKeyGenerator opts))
					else do
						hashtags opts "# This is your private key, hide this."
						putStrLn (formatSecret (optKeyGenerator opts))
			else do
				if (optGenJSON opts)==True then do
					if (optFile mainOpts)/="" then do
						writeData (optFile mainOpts) $ keyToJSON (keyGenChoose (optComplex opts) (optGenPrime opts) (optGenRoot opts) (optKeyGenerator opts)) (optKeyGenerator opts) AllKey
					else do
						putStrLn $ keyToJSON (keyGenChoose (optComplex opts) (optGenPrime opts) (optGenRoot opts) (optKeyGenerator opts)) (optKeyGenerator opts) AllKey
				else do
					if (optFile mainOpts)/="" then do
						writeData (optFile mainOpts) $ (hashtagsStr opts "# This is your public key, give this to people.\n")++(formatKey (keyGenChoose (optComplex opts) (optGenPrime opts) (optGenRoot opts) (optKeyGenerator opts)))++"\n"++(hashtagsStr opts "# This is your private key, hide this.\n")++(formatSecret (optKeyGenerator opts))
					else do
						hashtags opts "# This is your public key, give this to people."
						putStrLn (formatKey (keyGenChoose (optComplex opts) (optGenPrime opts) (optGenRoot opts) (optKeyGenerator opts)))
						hashtags opts "# This is your private key, hide this."
						putStrLn (formatSecret (optKeyGenerator opts))

hashtags :: GenOpts -> String -> IO()
hashtags opts str
	| (optComments opts)==True = putStrLn str
	| otherwise                = return ()

hashtagsStr :: GenOpts -> String -> String
hashtagsStr opts str
	| (optComments opts)==True = str
	| otherwise                = ""

keyGenChoose :: Bool -> Integer -> Integer -> Integer -> Key
keyGenChoose x p g s
	| p/=0 || g/=0 = keyGenPG s (p,g)
	| x == True    = keyGenComplex s
	| otherwise    = keyGen s

printVersion :: IO()
printVersion = do
	putStrLn ("Panda Diffie-Hellman Key Exchange  Copyright (C) 2015 Graham John Pegg")
	putStrLn ("This program comes with ABSOLUTELY NO WARRANTY.")
	putStrLn ("This is free software, and you are welcome to redistribute it")
	putStrLn ("under certain conditions; Please see LICENSE to learn more.")
	putStrLn ("----------------------------------------------------------------------")
	putStrLn ("Version 3.2                                             Feb. 19th 2015")

askGenKey :: GenOpts -> [String] -> IO()
askGenKey opt args= do
		hPutStrLn stderr "Enter a generator:"
		priv <- getLine
		hPutStrLn stderr "-----------------------"
		putStrLn "# This is your public key, give this to people."
		putStrLn (formatKey (keyGen (read priv::Integer)))
		putStrLn "# This is your private key, hide this."
		putStrLn (formatSecret (read priv::Integer))

main = do
	args <- getArgs
	if args==[] then do
		runCommand $ \opts args -> do
			askGenKey opts args
	else do
		if (args!!0)=="-v"||(args!!0)=="--version" then do
			printVersion
		else do
			runSubcommand [ subcommand "make" makeNumber
						  , subcommand "gen" genKey
						  ]

