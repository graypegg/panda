module KeyTypes where

data GenData = GenData Integer Integer
instance Show GenData where
		show (GenData p g) = "[p="++(show p)++",g="++(show g)++"]"
data Key = Key Integer GenData | Keys [Integer] GenData deriving(Show)
data Result = Result Integer deriving(Show)
data KeyType = Public | Private | AllKey deriving(Eq)