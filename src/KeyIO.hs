module KeyIO(formatKey,formatSecret,unformatSecret) where
import KeyTypes
import Numeric
import Data.List.Split

formatKey :: Key -> String
formatKey (Key x (GenData p g)) = "PANDAKEY:"++(show x)++"|"++(show p)++":"++(show g)

formatSecret :: Integer -> String
formatSecret x = "PANDASECRET:"++(showHex x "")

unformatSecret :: String -> Integer
unformatSecret x = read ("0x"++((splitOn ":" x)!!1))::Integer