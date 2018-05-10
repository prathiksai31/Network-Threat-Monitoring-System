#@uthor 1: Sai Prathik
#@uthor 2: Nikhil Pinto
#Title: Shell script to create custom timeout to have control on the duration of execution of individual linux commands.

#!/bin/bash

custom_timeout() {
  time=$1

  command="/bin/sh -c \"$2\""

  expect -c "set echo \"-noecho\"; set timeout $time; spawn -noecho $command; expect timeout { exit 1 } eof { exit 0 }"

  if [ $? = 1 ] ; then
    echo "Timeout after ${time} seconds"
  fi

}
