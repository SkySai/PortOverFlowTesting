#/bin/sh

rbshell -c Gui startLocalView 

while true
do
    echo "Putting system to sleep and NOT disabling video in."
    #i2c_test w 1 176 9 f
    rbshell -c Gui stopPresentation
    #sleep 2
    rbshell -c Gui sleepNow
    sleep 10
    echo "Waking system."
    rbshell -c Gui wakeNow
    #sleep 2
    #i2c_test w 1 176 9 0
    rbshell -c Gui startPresentation
    sleep 10
    numfails=$(tail -n 400 /var/log/sys.log | grep -c -i "overflow" )
    echo "Number of fails detected this iteration: $numfails"
    parserline=$(tail -n 400 /var/log/sys.log | grep -i "parser" )
    parsercount=$(echo $parserline | tail -1 | awk '{print $NF}' | tr -d '[^M]')
    echo "Current Parser Count: $parsercount"
    if [ "$numfails" -ne 0 ]
    then
	# output relevant portions of log file
	tail -n 200 /var/log/sys.log | awk -f parse_log.awk
    fi
    if [ "$parsercount" -gt 20 ]
    then
	echo "Hit Parser Reset limit!"
	break
    fi
       
done

