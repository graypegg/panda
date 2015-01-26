module KeyGen(keyGen, keysGen, commonKey, commonKeys, GenData, Key, Result) where
import KeyTypes

p = 10007   --Prime Number
g = 5       --Primitive Root

keyGen :: Integer -> Key
keyGen x = Key ((g^x) `mod` p) (GenData p g)

keysGen :: [Integer] -> Key
keysGen xs = Keys [((g^x) `mod` p) | x <- xs] (GenData p g)

commonKey :: Key -> Integer -> Result
commonKey (Key x (GenData ps _)) s = Result (x^s `mod` ps)

commonKeys :: Key -> [Integer] -> Result
commonKeys (Keys xs (GenData ps _)) ss = Result $ foldl (\acc (x,s) -> acc + (x^s `mod` ps)) 0 (zip xs ss)