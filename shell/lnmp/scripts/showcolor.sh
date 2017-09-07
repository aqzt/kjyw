# color funiction
color(){
# show color text
# color colorname "color text"
case $1 in 
     blk)
	echo -en "\E[1;30m"
        ;;
     red)
        echo -en "\E[1;31m"
        ;;
     grn)
        echo -en "\E[1;32m"
        ;;
     yel)
       echo -en "\E[1;33m"
       ;;
     blu)
       echo -en "\E[1;34m"
       ;;
     mag)
       echo -en "\E[1;35m"
       ;;
     cyn)
       echo -en "\E[1;36m"
       ;;
     whi)
       echo -en "\E[1;37m"
       ;;
     dgrn)
       echo -en "\E[0;32m"
       ;;
     dyel)
       echo -en "\E[0;33m"
       ;;
     dblu)
       echo -en "\E[0;34m"
       ;;
     dmag)
       echo -en "\E[0;35m"
       ;;
     dcyn)
       echo -en "\E[0;36m"
       ;;
     dwhi)
       echo -en "\E[0;37m"
       ;;
     res)
       echo -en "\E[0m"
       ;;
     nor)
       echo -en ""
       ;;
esac
}

