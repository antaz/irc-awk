## Qubot
This is a small IRC bot/client written as a combination of common GNU/Linux utilities

---
## Features
* Wikipedia abstract .w
* Urban dictionary defnitions .ud
* lichess.org ratings and aliasing capability .l

## Dependencies
* [bash](https://www.gnu.org/software/bash/http:// "bash") (preinstalled on most linux distributions)
* [gawk](https://www.gnu.org/software/gawk/ "gawk") (also preinstalled on most linux distros. note the difference with other implementations of [awk](http://https://en.wikipedia.org/wiki/AWK "awk"))
* [curl](https://curl.se/ "curl")
* [jq](https://stedolan.github.io/jq/ "jq")

## Executing
```
IRC_NICKNAME=MyNick IRC_CHANNEL=##MyChannel ./main.sh
```
**Note: set the `main.sh` file to be executable through: `chmod +x main.sh`**
## TODO
* Implement user identification
* use an envirnoment variable to specify the IRC server (right now libera.chat is hardcoded in the main.sh file)
* make this entirely modular
