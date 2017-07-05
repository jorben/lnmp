#!/bin/bash

# [ INITIALIZE ]
## [[ SET PATH ]]
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
clear
## [[ SET PATH END ]]

## [[ DEFINED FUNCTION ]]
    function msgt()
    {
        echo "================ Shell Msg ================="
    }
    function msgb()
    {
        echo "============================================"
    }
    function get_char()
    {
        SAVEDSTTY=`stty -g`
        stty -echo
        stty cbreak
        dd if=/dev/tty bs=1 count=1 2> /dev/null
        stty -raw
        stty echo
        stty $SAVEDSTTY
    }
    function get_err()
    {
        msgt
        echo -e "Error: $1 [ \033[31;40mFALSE\033[0m ]"
        msgb
    }
    function prestogo()
    {
        msgt
        echo "Press any key to continue..."
        msgb
        char=`get_char`
        clear
    }
## [[ DEFINED FUNCTION END ]]

## [[ CHECK RIGHTS ]]
    if [ $(id -u) != "0" ]; then
        msgt
        echo -e "Please run this shell with user root [ \033[31;40mFALSE\033[0m ]"
        msgb
        exit
    fi
## [[ CHECK RIGHTS END ]]

## [[ SET VERSION & REMOTE PATH ]]
    dirname=`pwd`
    sourceurl='ftp://192.168.18.100/'
    v_nginx='0.8.54'
    v_mysql='5.1.48'
    v_php='5.2.14'
    v_pdoMysql='1.0.2'
    v_zendoptimizer='3.3.9'
    v_suhosinPatch='5.2.14-0.9.7'    
    v_mhash='0.9.9.9'
    v_pcre='8.10'
    v_memcache='2.2.5'
    v_eaccelerator='0.9.5.3'
    v_mcrypt='2.6.8'
    v_libiconv='1.13'
    v_libmcrypt='2.5.8'
    v_autoconf='2.13'
    if [ '32' = `getconf WORD_BIT` ] && [ '64' = `getconf LONG_BIT` ]; then
        v_bit='x86_64'
    else
        v_bit='i386'
    fi
## [[ SET VERSION & REMOTE PATH END ]]

## [[ SET TIMEZONE ]]
    rm -f /etc/localtime
    ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
## [[ SET TIMEZOEN END ]]

## [[ GET INPUT ]]
### [[[ SET DOMAIN ]]]
    domain="localhost"
    msgt
	echo "Default domain is \"localhost\"!"    
	read -p "Please input your domain:" domain
	if [ "$domain" = "" ]; then
		domain="localhost"
	fi
    echo "Domain is \"$domain\""
    msgb
### [[[ SET DOMAIN END ]]]

### [[[ SET MYSQL PWD ]]]
    mypwd="mysql"
    msgt
	echo "Default root password of mysql is \"mysql\"!"    
	read -p "Please input password for user root of mysql:" mypwd
	if [ "$mypwd" = "" ]; then
		mypwd="mysql"
	fi
    echo "Mysql password is \"$mypwd\""
    msgb
### [[[ SET MYSQL PWD END ]]]
## [[ GET INPUT END ]]

prestogo
# [ INITIALIZE END ]