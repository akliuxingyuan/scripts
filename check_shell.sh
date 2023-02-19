#/bin/zsh
# check which shell the script or terminal is using

# method 1:
cat /proc/$$/comm

# method 2:
# readlink /proc/$$/exe

# method 3:
# ps --format cmd -p "$$"

