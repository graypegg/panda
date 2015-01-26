module KeyIO(formatKey,unformatKey,formatSecret,unformatSecret) where
import KeyTypes
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