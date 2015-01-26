import KeyGen

alice = keyGen 843
bob = keyGen 980

main = do
	putStrLn $ show (commonKey bob 843)