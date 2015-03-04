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

module Cmd.MainOpts where
import Control.Applicative
import Options

data MainOptions = MainOptions { optFile :: String
							   , optVersion :: Bool }

instance Options MainOptions where
    defineOptions = pure MainOptions
        <*> defineOption optionType_string (\o -> o
			{ optionShortFlags = ['f']
			, optionLongFlags = ["file"]
			, optionDefault = ""
			, optionDescription = "The file to print output to."
			})
        <*> defineOption optionType_bool (\o -> o
			{ optionShortFlags = ['v']
			, optionLongFlags = ["version"]
			, optionDefault = False
			, optionDescription = "Displays license and version information."
			})