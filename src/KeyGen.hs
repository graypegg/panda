module KeyGen(keyGen, keysGen, commonKey, commonKeys) where

p = 761
g = 6

data GenData = GenData Integer Integer
instance Show GenData where
		show (GenData p g) = "[p="++(show p)++",g="++(show g)++"]"
data Key = Key Integer GenData | Keys [Integer] GenData deriving(Show)
data Result = Result Integer deriving(Show)

keyGen :: Integer -> Key
keyGen x = Key ((g^x) `mod` p) (GenData p g)

keysGen :: [Integer] -> Key
keysGen xs = Keys [((g^x) `mod` p) | x <- xs] (GenData p g)

commonKey :: Key -> Integer -> Result
commonKey (Key x (GenData ps _)) s = Result (x^s `mod` ps)

commonKeys :: Key -> [Integer] -> Result
commonKeys (Keys xs (GenData ps gs)) ss = Result $ foldl (\acc (x,s) -> acc + (x^s `mod` ps)) 0 (zip xs ss)