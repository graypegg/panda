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

module Cmd.GenOpts where
import Control.Applicative
import Options

data GenOpts = GenOpts { optKeyGenerator :: Integer
					   , optComments :: Bool
					   , optGenJSON :: Bool
					   , optJustSecret :: Bool
					   , optJustPublic :: Bool
					   , optGenPrime :: Integer
					   , optGenRoot :: Integer
					   , optComplex :: Bool
					   , optMulti :: String }

instance Options GenOpts where
    defineOptions = pure GenOpts
    	<*> defineOption optionType_integer (\o -> o
			{ optionShortFlags = ['n']
			, optionLongFlags = ["generator"]
			, optionDefault = 0
			, optionDescription = "A generator number. (Warning, make sure this number is as random as possible)"
			})
    	<*> defineOption optionType_bool (\o -> o
			{ optionShortFlags = ['c']
			, optionLongFlags = ["comments"]
			, optionDefault = False
			, optionDescription = "Shows comments in output. (Lines prepended with #)"
			})
    	<*> defineOption optionType_bool (\o -> o
			{ optionShortFlags = ['j']
			, optionLongFlags = ["json"]
			, optionDefault = False
			, optionDescription = "Output all information in JSON format."
			})
    	<*> defineOption optionType_bool (\o -> o
			{ optionShortFlags = ['s']
			, optionLongFlags = ["secret"]
			, optionDefault = False
			, optionDescription = "Shows just the secret."
			})
    	<*> defineOption optionType_bool (\o -> o
			{ optionShortFlags = ['p']
			, optionLongFlags = ["public"]
			, optionDefault = False
			, optionDescription = "Shows just the public key."
			})
    	<*> defineOption optionType_integer (\o -> o
			{ optionLongFlags = ["prime"]
			, optionDefault = 0
			, optionDescription = "A new prime number to generate with"
			})
    	<*> defineOption optionType_integer (\o -> o
			{ optionLongFlags = ["root"]
			, optionDefault = 0
			, optionDescription = "A new primative root number to generate with"
			})
    	<*> defineOption optionType_bool (\o -> o
			{ optionShortFlags = ['x']
			, optionLongFlags = ["complex"]
			, optionDefault = False
			, optionDescription = "Use a more secure, but more processor intensive, prime and primitive root (1024 bit)"
			})
    	<*> defineOption optionType_string (\o -> o
			{ optionShortFlags = ['m']
			, optionLongFlags = ["multi"]
			, optionDefault = ""
			, optionDescription = "Use multiple secrets for one key, seperate generators with a comma (,)"
			})