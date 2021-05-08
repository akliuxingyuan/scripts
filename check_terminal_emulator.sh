#
# check which terminal emulator is using

# run as script
pstree -sA $$ | head -n1 | awk -F "---" '{print $(NF-2)}'

# run follow command in terminal emulator
# pstree -sA $$ | head -n1 | awk -F "---" '{print $(NF-1)}'
