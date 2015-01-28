import KeyGen
import KeyIO
import KeyTypes
import System.Environment
import System.IO
import Control.Applicative
import Options

data MainOptions = MainOptions { optFile :: String }

instance Options MainOptions where
    defineOptions = pure MainOptions
        <*> defineOption optionType_string (\o -> o
			{ optionShortFlags = ['f']
			, optionLongFlags = ["file"]
			, optionDefault = ""
			, optionDescription = "The file to print output to."
			})

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

makeNumber :: MainOptions -> MakeOpts -> [String] -> IO ()
makeNumber mainOpts opts args
	| (optFile mainOpts)/="" && (optJSON opts)==True = do
		writeData (optFile mainOpts) $ resultToJSON (unformatKey (optKeyPublic opts)) (unformatSecret (optKeySecret opts)) (commonKey (unformatKey (optKeyPublic opts)) (unformatSecret (optKeySecret opts)))
	| (optFile mainOpts)/="" && (optQuiet opts)==True = do
		writeData (optFile mainOpts) $ justResult (commonKey (unformatKey (optKeyPublic opts)) (unformatSecret (optKeySecret opts)))
	| (optJSON opts)==True   = do
		putStrLn $ resultToJSON (unformatKey (optKeyPublic opts)) (unformatSecret (optKeySecret opts)) (commonKey (unformatKey (optKeyPublic opts)) (unformatSecret (optKeySecret opts)))
	| (optQuiet opts)== True = do
		putStrLn $ justResult (commonKey (unformatKey (optKeyPublic opts)) (unformatSecret (optKeySecret opts)))
	| otherwise              = do
    	putStrLn $ show $ commonKey (unformatKey (optKeyPublic opts)) (unformatSecret (optKeySecret opts))

data GenOpts = GenOpts { optKeyGenerator :: Integer
					   , optComments :: Bool
					   , optGenJSON :: Bool
					   , optJustSecret :: Bool
					   , optJustPublic :: Bool }
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
        
genKey :: MainOptions -> GenOpts -> [String] -> IO ()
genKey mainOpts opts args = do
		if (optJustPublic opts)==True then do
			if (optGenJSON opts)==True then do
				if (optFile mainOpts)/="" then do
					writeData (optFile mainOpts) $ keyToJSON (keyGen (optKeyGenerator opts)) (optKeyGenerator opts) Public
				else do
					putStrLn $ keyToJSON (keyGen (optKeyGenerator opts)) (optKeyGenerator opts) Public
			else do
				if (optFile mainOpts)/="" then do
					writeData (optFile mainOpts) $ (hashtagsStr opts "# This is your public key, give this to people.\n")++(formatKey (keyGen (optKeyGenerator opts)))
				else do
					hashtags opts "# This is your public key, give this to people."
					putStrLn (formatKey (keyGen (optKeyGenerator opts)))
		else do
			if (optJustSecret opts)==True then do
				if (optGenJSON opts)==True then do
					if (optFile mainOpts)/="" then do
						writeData (optFile mainOpts) $ keyToJSON (keyGen (optKeyGenerator opts)) (optKeyGenerator opts) Private
					else do
						putStrLn $ keyToJSON (keyGen (optKeyGenerator opts)) (optKeyGenerator opts) Private
				else do
					if (optFile mainOpts)/="" then do
						writeData (optFile mainOpts) $ (hashtagsStr opts "# This is your private key, hide this.\n")++(formatSecret (optKeyGenerator opts))
					else do
						hashtags opts "# This is your private key, hide this."
						putStrLn (formatSecret (optKeyGenerator opts))
			else do
				if (optGenJSON opts)==True then do
					if (optFile mainOpts)/="" then do
						writeData (optFile mainOpts) $ keyToJSON (keyGen (optKeyGenerator opts)) (optKeyGenerator opts) AllKey
					else do
						putStrLn $ keyToJSON (keyGen (optKeyGenerator opts)) (optKeyGenerator opts) AllKey
				else do
					if (optFile mainOpts)/="" then do
						writeData (optFile mainOpts) $ (hashtagsStr opts "# This is your public key, give this to people.\n")++(formatKey (keyGen (optKeyGenerator opts)))++"\n"++(hashtagsStr opts "# This is your private key, hide this.\n")++(formatSecret (optKeyGenerator opts))
					else do
						hashtags opts "# This is your public key, give this to people."
						putStrLn (formatKey (keyGen (optKeyGenerator opts)))
						hashtags opts "# This is your private key, hide this."
						putStrLn (formatSecret (optKeyGenerator opts))

hashtags :: GenOpts -> String -> IO()
hashtags opts str
	| (optComments opts)==True = putStrLn str
	| otherwise                = return ()

hashtagsStr :: GenOpts -> String -> String
hashtagsStr opts str
	| (optComments opts)==True = str
	| otherwise                = ""

askGenKey :: GenOpts -> [String] -> IO()
askGenKey opts args = do
		hPutStrLn stderr "Enter a generator:"
		priv <- getLine
		hPutStrLn stderr "-----------------------"
		hashtags opts "# This is your public key, give this to people."
		putStrLn (formatKey (keyGen (read priv::Integer)))
		hashtags opts "# This is your private key, hide this."
		putStrLn (formatSecret (read priv::Integer))

main = do
	args <- getArgs
	if args==[] then do
		runCommand $ \opts args -> do
			askGenKey opts args
	else do
		runSubcommand [ subcommand "make" makeNumber
					  , subcommand "gen" genKey
					  ]

