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

module KeyGen(keyGen, keysGen, commonKey, commonKeys, keyGenPG, keysGenPG) where
import KeyTypes

p = 987123025220232575950828439   --Prime Number
g = 19                            --Primitive Root

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