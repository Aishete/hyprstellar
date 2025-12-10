#!/usr/bin/env bash

# classic spin animation

# iterating over a list of characters and escaping any special chars
# echoing to print, -en and \r (carriage return) allow it to stay in one place on the line
# sleep .1 sets the speed; while true; do ... done makes it an infinite loop


while true; do for var in / - \\ \|; do echo -en "\r$var"; sleep .1; done; done


# suggestion for use in scripts:
# run in background, and store the last background process id in a var with $!
# then kill that PID once needed
