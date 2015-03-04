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

module KeyTypes where

data GenData = GenData Integer Integer
instance Show GenData where
		show (GenData p g) = "[p="++(show p)++",g="++(show g)++"]"
data Key = Key Integer GenData | Keys [Integer] GenData deriving(Show)
data Result = Result Integer | Fail deriving(Show, Eq)
data KeyType = Public | Private | AllKey deriving(Eq)