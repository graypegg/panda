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

module KeyIO(formatKey,unformatKey,formatSecret,unformatSecret,keyInfo,resultToJSON,keyToJSON,justResult,writeData,readData,readPublicKey,readSecretKey,toSecretList) where
import KeyTypes
import KeyGen
import Numeric
import Data.List.Split
import Data.List

showHexs :: [Integer] -> String -> String
showHexs (x:xs) acc = showHexs xs ((showHex x "")++","++acc)
showHexs [] acc = (init acc)

formatKey :: Key -> String
formatKey (Key x (GenData p g)) = "PANDAKEY:"++(showHex x "")++"-"++(showHex p "")++":"++(show g)
formatKey (Keys x (GenData p g)) = "PANDAKEYS:"++(showHexs x "")++"-"++(showHex p "")++":"++(show g)

unformatKey :: String -> Key
unformatKey x = Key (getKeyX x) (GenData (getKeyP x) (getKeyG x))

formatSecret :: Integer -> String
formatSecret x = "PANDASECRET:"++(showHex x "")

unformatSecret :: String -> Integer
unformatSecret x = read ("0x"++((splitOn ":" x)!!1))::Integer

getKeyX :: String -> Integer
getKeyX x = (read ("0x"++((splitOn ":" ((splitOn "-" x)!!0))!!1))::Integer)

getKeyP :: String -> Integer
getKeyP x = (read ("0x"++((splitOn ":" ((splitOn "-" x)!!1))!!0))::Integer)

getKeyG :: String -> Integer
getKeyG x = (read ((splitOn ":" ((splitOn "-" x)!!1))!!1)::Integer)

keyInfo :: Integer -> Bool -> Bool -> Bool -> String
keyInfo n c p s
	| c==True   = (printIf p ("# This is your public key, give this to people.\n"++(formatKey (keyGen n))))++(printIf s ("\n# This is your private key, hide this.\n"++(formatSecret n)))
	| otherwise = (printIf p (formatKey (keyGen n)))++"\n"++(printIf s (formatSecret n))

printIf :: Bool -> String -> String
printIf b str
	| b==True   = str
	| otherwise = ""

resultToJSON :: Key -> Integer -> Result -> String
resultToJSON (Key k (GenData p g)) s (Result r) = "{\"key\":"++(show k)++",\"secret\":"++(show s)++",\"result\":"++(show r)++",\"genData\":{\"p\":"++(show p)++",\"g\":"++(show g)++"}}"

keyToJSON :: Key -> Integer -> KeyType -> String
keyToJSON (Key k (GenData p g)) s t
	| t==Private = "{\"secret\":"++(show s)++",\"genData\":{\"p\":"++(show p)++",\"g\":"++(show g)++"}}"
	| t==Public  = "{\"key\":"++(show k)++",\"genData\":{\"p\":"++(show p)++",\"g\":"++(show g)++"}}"
	| otherwise  = "{\"key\":"++(show k)++",\"secret\":"++(show s)++",\"genData\":{\"p\":"++(show p)++",\"g\":"++(show g)++"}}"

justResult :: Result -> String
justResult (Result r) = (show r)

writeData :: String -> String -> IO()
writeData f str = writeFile f str

isComment :: String -> Bool
isComment ('#':_) = True
isComment _ = False

sanitise :: [String] -> [String]
sanitise rawData = foldl (\acc x -> if (isComment x) then (acc) else (acc++[x])) [] rawData

readData :: String -> IO([String])
readData f = do
    rawData <- readFile f
    return (sanitise (lines rawData))

readPublicKey :: [String] -> Key
readPublicKey (x:xs)
    | "PANDAKEY:" `isPrefixOf` x = unformatKey x
    | otherwise                  = readPublicKey xs
readPublicKey [] = Key 0 (GenData 0 0)

readSecretKey :: [String] -> Integer
readSecretKey (x:xs)
    | "PANDASECRET:" `isPrefixOf` x = unformatSecret x
    | otherwise                     = readSecretKey xs
readSecretKey [] = (-1)

splitM :: String -> [String]
splitM m = splitOn "," m

toSecretList :: String -> [Integer]
toSecretList m = map read (splitM m)