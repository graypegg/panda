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

module Cmd.MakeOpts where
import Control.Applicative
import Options

data MakeOpts = MakeOpts { optKeySecret :: String
					     , optKeyPublic :: String
					     , optJSON :: Bool
					     , optQuiet :: Bool }

instance Options MakeOpts where
    defineOptions = pure MakeOpts
        <*> defineOption optionType_string (\o -> o
			{ optionShortFlags = ['s']
			, optionLongFlags = ["secret"]
			, optionDefault = ""
			, optionDescription = "Your own secret key."
			})
    	<*> defineOption optionType_string (\o -> o
			{ optionShortFlags = ['p']
			, optionLongFlags = ["public"]
			, optionDefault = ""
			, optionDescription = "Their public key."
			})
    	<*> defineOption optionType_bool (\o -> o
			{ optionShortFlags = ['j']
			, optionLongFlags = ["json"]
			, optionDefault = False
			, optionDescription = "Output all information in JSON format."
			})
    	<*> defineOption optionType_bool (\o -> o
			{ optionShortFlags = ['q']
			, optionLongFlags = ["quiet"]
			, optionDefault = False
			, optionDescription = "Only output the result."
			})