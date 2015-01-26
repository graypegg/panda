import KeyGen
import KeyIO
import System.Environment
import System.IO

main = do
	args <- getArgs
	if args==[] then do
		hPutStrLn stderr "Enter your private key:"
		priv <- getLine
		hPutStrLn stderr "-----------------------"
		putStrLn "# This is your public key, give this to people."
		putStrLn (formatKey (keyGen (read priv::Integer)))
		putStrLn "# This is your private key, hide this."
		putStrLn (formatSecret (read priv::Integer))
	else do
		putStrLn $ show $ commonKey (unformatKey (head args)) (unformatSecret (last args))
