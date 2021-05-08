#
# check which shell the script or terminal is using

# method 1:
readlink /proc/$$/exe

# method 2:
# ps --format cmd -p "$$"
