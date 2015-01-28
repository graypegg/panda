# panda
Panda Key Exchange uses the Diffie-Hellman key exchange to generate a common passcode between two computers over a unsecured network.

## Installing
You'll need to compile panda from source, but don't worry, it ain't that hard.

### You'll need:
- GHC compiler
- Cabal
- A linux distro (Ubuntu preferably)

### Compiling
1. Clone the repo
2. Run "make.sh" as root, from the main directory
3. You should be able to use panda as a command!

## How to use
Panda works by using the Diffie-Hellman key exchange, which means you'll have to move the actual keys around yourself, but panda will generate them for you.

```shell
panda gen -n 202
```
Will generate a key, with a secret number of 202. This secret number should be much more random than this.

```shell
panda make -p PANDAKEY:8009-10007:5 -s PANDASECRET:31a3b
```
Will generate the result, p should be someone elses public key, and s should be your secret key.
