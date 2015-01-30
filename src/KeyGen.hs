module KeyGen(keyGen, keysGen, commonKey, commonKeys, keyGenPG, keysGenPG) where
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

keyGenPG :: Integer -> (Integer, Integer) -> Key
keyGenPG x (ps, gs) = Key ((gs^x) `mod` ps) (GenData ps gs)

keysGenPG :: [Integer] -> (Integer, Integer) -> Key
keysGenPG xs (ps, gs) = Keys [((gs^x) `mod` ps) | x <- xs] (GenData ps gs)