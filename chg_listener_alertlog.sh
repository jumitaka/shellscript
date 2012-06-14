cd $HOME
adrci exec=show home|grep listener > listener.txt
read LISTENER < listener.txt
echo set home $LISTENER > listener.txt
echo purge -age 1440 -type alert >> listener.txt
adrci script=listener.txt