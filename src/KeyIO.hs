module KeyIO(formatKey,unformatKey,formatSecret,unformatSecret,keyInfo,resultToJSON,keyToJSON,justResult,writeData) where
import KeyTypes
import KeyGen
import Numeric
import Data.List.Split

formatKey :: Key -> String
formatKey (Key x (GenData p g)) = "PANDAKEY:"++(show x)++"-"++(show p)++":"++(show g)

unformatKey :: String -> Key
unformatKey x = Key (getKeyX x) (GenData (getKeyP x) (getKeyG x))

formatSecret :: Integer -> String
formatSecret x = "PANDASECRET:"++(showHex x "")

unformatSecret :: String -> Integer
unformatSecret x = read ("0x"++((splitOn ":" x)!!1))::Integer

getKeyX :: String -> Integer
getKeyX x = (read ((splitOn ":" ((splitOn "-" x)!!0))!!1)::Integer)

getKeyP :: String -> Integer
getKeyP x = (read ((splitOn ":" ((splitOn "-" x)!!1))!!0)::Integer)

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