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
		exit
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
    istPATH=`pwd`
    sourceurl='ftp://192.168.18.100/'
    v_nginx='0.8.54'
    v_mysql='5.1.48'
    v_php='5.2.14'
    v_fpm='0.5.14'
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
    install_logs=${istPATH}/install_logs
    mkdir -p $install_logs
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

# [ CLEAN AND UPDATE ]
## [[ CLEAN-UP ]]
    rpm -qa|grep  httpd
    rpm -e httpd
    rpm -qa|grep mysql
    rpm -e mysql
    rpm -qa|grep php
    rpm -e php

    yum -y remove httpd
    yum -y remove php
    yum -y remove mysql-server mysql
    yum -y remove php-mysql
## [[ CLEAN-UP END ]]

## [[ DISABLE SELINUX ]]
    if [ -s /etc/selinux/config ]; then
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    fi
## [[ DISABLE SELINUX END ]]

## [[ UPDATE ]]
    yum -y install yum-fastestmirror ntp    
    yum -y update
    ntpdate cn.pool.ntp.org
## [[ UPDATE END ]]
# [ CLEAN AND UPDATE END ]

# [ INSTALL TOOLS & LIBS ]
    yum -y install wget gcc gcc-c++ make patch autoconf unzip libjpeg libjpeg-devel libpng libpng-devel libxml2 libxml2-devel gd gd-devel freetype freetype-devel zlib zlib-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel libidn libidn-devel openssl openssl-devel   
# [ INSTALL TOOLS & LIBS END]

# [ MAKE & INSTALL ]
## [[ CHECK PACKAGES ]]
    for packages in autoconf-$v_autoconf.tar.gz libiconv-$v_libiconv.tar.gz libmcrypt-$v_libmcrypt.tar.gz mhash-$v_mhash.tar.gz mcrypt-$v_mcrypt.tar.gz mysql-$v_mysql.tar.gz php-$v_php.tar.gz suhosin-patch-$v_suhosinPatch.patch.gz php-$v_php-fpm-$v_fpm.diff.gz memcache-$v_memcache.tgz PDO_MYSQL-$v_pdoMysql.tgz ZendOptimizer-$v_zendoptimizer-linux-glibc23-$v_bit.tar.gz pcre-$v_pcre.tar.gz nginx-$v_nginx.tar.gz eaccelerator-$v_eaccelerator.tar.bz2;
    do
        if [ -s $packages ]; then
            echo -e "Check $packages [\033[32;40m  O K  \033[0m]"
        else
            echo -e "Check $packages [\033[33;40m NOTICE \033[0m]"
            wget -c $sourceurl/$packages
            echo -e "Wget $packages [\033[32;40m  O K  \033[0m]"
        fi
    done
## [[ CHECK PACKAGES END ]]

## [[ AUTOCONF INSTALL ]]
    msgt
    echo "autoconf is being installed!"
    msgb
    cd $istPATH
    tar zxvf autoconf-$v_autoconf.tar.gz
    cd autoconf-$v_autoconf/
    ./configure --prefix=/usr/local/autoconf-$v_autoconf > $install_logs/autoconf-conf.log 2>&1
    [ $? != 0 ] && get_err "autoconf configure error"
    make > $install_logs/autoconf-make.log 2>&1
    [ $? != 0 ] && get_err "autoconf make error"
    make install > $install_logs/autoconf-install.log 2>&1
    [ $? != 0 ] && get_err "autoconf install error"
    msgt
    echo -e "autoconf has being installed! [\033[32;40m  O K  \033[0m]"
    msgb
## [[ AUTOCONF INSTALL END ]]

## [[ LIBICONV INSTALL ]]
    msgt
    echo "libiconv is being installed!"
    msgb
    cd $istPATH
    tar zxvf libiconv-$v_libiconv.tar.gz
    cd libiconv-$v_libiconv/
    ./configure --prefix=/usr/local > $install_logs/libiconv-conf.log 2>&1
    [ $? != 0 ] && get_err "libiconv configure error"
    make > $install_logs/libiconv-make.log 2>&1
    [ $? != 0 ] && get_err "libiconv make error"
    make install  > $install_logs/libiconv-install.log 2>&1
    [ $? != 0 ] && get_err "libiconv install error"
    msgt
    echo -e "libiconv has being installed! [\033[32;40m  O K  \033[0m]"
    msgb
## [[ LIBICONV INSTALL END ]]

## [[ LIBMCRYPT INSTALL ]]
    msgt
    echo "libmcrypt is being installed!"
    msgb
    cd $istPATH
    tar zxvf libmcrypt-$v_libmcrypt.tar.gz
    cd libmcrypt-$v_libmcrypt/
    ./configure > $install_logs/libmcrypt-conf.log 2>&1
    [ $? != 0 ] && get_err "libmcrypt configure error"
    make > $install_logs/libmcrypt-make.log 2>&1
    [ $? != 0 ] && get_err "libmcrypt make error"
    make install > $install_logs/libmcrypt-install.log 2>&1
    [ $? != 0 ] && get_err "libmcrypt install error"
    /sbin/ldconfig
    cd libltdl/
    ./configure --enable-ltdl-install > $install_logs/libmcrypt-conf2.log 2>&1
    [ $? != 0 ] && get_err "libmcrypt configure2 error"
    make > $install_logs/libmcrypt-make2.log 2>&1
    [ $? != 0 ] && get_err "libmcrypt make2 error"
    make install > $install_logs/libmcrypt-install2.log 2>&1
    [ $? != 0 ] && get_err "libmcrypt install2 error"
    ln -s /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
    ln -s /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
    ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
    ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
    msgt
    echo -e "libmcrypt has being installed! [\033[32;40m  O K  \033[0m]"
    msgb
## [[ LIBMCRYPT INSTALL END ]]

## [[ MHASH INSTALL ]]
    msgt
    echo "mhash is being installed!"
    msgb
    cd $istPATH
    tar zxvf mhash-$v_mhash.tar.gz
    cd mhash-$v_mhash/
    ./configure > $install_logs/mhash-conf.log 2>&1
    [ $? != 0 ] && get_err "mhash configure error"
    make > $install_logs/mhash-make.log 2>&1
    [ $? != 0 ] && get_err "mhash make error"
    make install > $install_logs/mhash-install.log 2>&1
    [ $? != 0 ] && get_err "mhash install error"
    ln -s /usr/local/lib/libmhash.a /usr/lib/libmhash.a
    ln -s /usr/local/lib/libmhash.la /usr/lib/libmhash.la
    ln -s /usr/local/lib/libmhash.so /usr/lib/libmhash.so
    ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2
    ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1
    msgt
    echo -e "mhash has being installed! [\033[32;40m  O K  \033[0m]"
    msgb
## [[ MHASH INSTALL END ]]

## [[ MCRYPT INSTALL ]]
    msgt
    echo "mcrypt is being installed!"
    msgb
    cd $istPATH
    tar zxvf mcrypt-$v_mcrypt.tar.gz
    cd mcrypt-$v_mcrypt/
    ./configure > $install_logs/mcrypt-conf.log 2>&1
    [ $? != 0 ] && get_err "mcrypt configure error"
    make > $install_logs/mcrypt-make.log 2>&1
    [ $? != 0 ] && get_err "mcrypt make error"
    make install > $install_logs/mcrypt-install.log 2>&1
    [ $? != 0 ] && get_err "mcrypt install error"
    msgt
    echo -e "mcrypt has being installed! [\033[32;40m  O K  \033[0m]"
    msgb
## [[ MCRYPT INSTALL END ]]

## [[ MYSQL INSTALL ]]
    msgt
    echo "Mysql is being installed!"
    msgb
    cd $istPATH
    /usr/sbin/groupadd mysql
    /usr/sbin/useradd -s /sbin/nologin -g mysql mysql
    tar zxvf mysql-$v_mysql.tar.gz
    cd mysql-$v_mysql/
    ./configure --prefix=/usr/local/mysql --with-extra-charsets=complex --with-big-tables --with-readline --with-ssl --with-embedded-server --with-plugins=innobase --enable-assembler --enable-thread-safe-client --enable-local-infile  > $install_logs/mysql-conf.log 2>&1
    [ $? != 0 ] && get_err "mysql configure error"
    make > $install_logs/mysql-make.log 2>&1
    [ $? != 0 ] && get_err "mysql make error"
    make install > $install_logs/mysql-insatll.log 2>&1
    [ $? != 0 ] && get_err "mysql install error"
    mkdir -p /home/mysql/datadir
    chown -R mysql:mysql /usr/local/mysql
    chown -R mysql:mysql /home/mysql
    /usr/local/mysql/bin/mysql_install_db --datadir=/home/mysql/datadir --user=mysql > $install_logs/mysql-testdb-install.log 2>&1
    cp /usr/local/mysql/share/mysql/my-medium.cnf /etc/my.cnf
    sed -i 's#skip-locking#datadir = /home/mysql/datadir\nmax_connections = 500\nskip-locking#' /etc/my.cnf
    cp /usr/local/mysql/share/mysql/mysql.server /etc/init.d/mysql
    chmod 0755 /etc/init.d/mysql
    chkconfig --level 345 mysql on
    echo "/usr/local/mysql/lib/mysql" >> /etc/ld.so.conf
    echo "/usr/local/lib" >> /etc/ld.so.conf
    ldconfig
    ln -s /usr/local/mysql/lib/mysql /usr/lib/mysql
    ln -s /usr/local/mysql/lib/include/mysql /usr/include/mysql
    /etc/init.d/mysql start
    /usr/local/mysql/bin/mysqladmin -u root password $mypwd
    /etc/init.d/mysql restart
    /etc/init.d/mysql stop
    msgt
    if [ -s /usr/local/mysql ]; then
        echo -e "Mysql has being installed! [\033[32;40m  O K  \033[0m]"
    else
        echo -e "The installing of Mysql is failed! [\033[31;40m FLASE \033[0m]"
    fi
    msgb
## [[ MYSQL INSTALL END ]]

## [[ PHP INSTALL ]]
    msgt
    echo "PHP with fpm is being installed!"
    msgb
    export PHP_AUTOCONF=/usr/local/autoconf-2.13/bin/autoconf
    export PHP_AUTOHEADER=/usr/local/autoconf-2.13/bin/autoheader
    cd $istPATH
    tar zxvf php-$v_php.tar.gz
    gzip -cd php-$v_php-fpm-$v_fpm.diff.gz | patch -d php-$v_php -p1
    cd php-$v_php
    ./buildconf --force
    ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-mysql=/usr/local/mysql --with-mysqli=/usr/local/mysql/bin/mysql_config --with-iconv-dir --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-discard-path --enable-magic-quotes --enable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-fastcgi --enable-fpm --enable-force-cgi-redirect --enable-mbstring --with-mcrypt --enable-ftp --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --without-pear --with-gettext --with-mime-magic > $install_logs/php-conf.log 2>&1
    [ $? != 0 ] && get_err "php configure error"
    make ZEND_EXTRA_LIBS='-liconv' > $install_logs/php-make.log 2>&1
    [ $? != 0 ] && get_err "php make error"
    make install > $install_logs/php-install.log 2>&1
    [ $? != 0 ] && get_err "php install error"
    cp php.ini-dist /usr/local/php/etc/php.ini
    ln -s /usr/local/php/bin/php /usr/bin/php
    cd $istPATH
    tar zxvf memcache-$v_memcache.tgz
    cd memcache-$v_memcache/
    /usr/local/php/bin/phpize
    ./configure --with-php-config=/usr/local/php/bin/php-config > $install_logs/memcache-conf.log 2>&1
    [ $? != 0 ] && get_err "memcache configure error"
    make > $install_logs/memcache-make.log 2>&1
    [ $? != 0 ] && get_err "memcache make error"
    make install > $install_logs/memcache-install.log 2>&1
    [ $? != 0 ] && get_err "memcache install error"
    cd $istPATH
    tar zxvf PDO_MYSQL-$v_pdoMysql.tgz
    cd PDO_MYSQL-$v_pdoMysql/
    /usr/local/php/bin/phpize
    ./configure --with-php-config=/usr/local/php/bin/php-config --with-pdo-mysql=/usr/local/mysql > $install_logs/pdoMysql-conf.log 2>&1
    [ $? != 0 ] && get_err "pdoMysql configure error"
    make > $install_logs/pdoMysql-make.log 2>&1
    [ $? != 0 ] && get_err "pdoMysql make error"
    make install > $install_logs/pdoMysql-install.log 2>&1
    [ $? != 0 ] && get_err "pdoMysql install error"
    sed -i 's#extension_dir = "./"#extension_dir = "/usr/local/php/lib/php/extensions/no-debug-non-zts-20060613/"\nextension = "memcache.so"\nextension = "pdo_mysql.so"\n#' /usr/local/php/etc/php.ini
    sed -i 's#output_buffering = Off#output_buffering = On#' /usr/local/php/etc/php.ini
    sed -i 's#post_max_size = 8M#post_max_size = 50M#' /usr/local/php/etc/php.ini
    sed -i 's#upload_max_filesize = 2M#upload_max_filesize = 50M#' /usr/local/php/etc/php.ini
    sed -i 's#;date.timezone =#date.timezone = PRC#' /usr/local/php/etc/php.ini
    sed -i 's#; cgi.fix_pathinfo=0#cgi.fix_pathinfo=1#' /usr/local/php/etc/php.ini
    sed -i 's#max_execution_time = 30#max_execution_time = 300#' /usr/local/php/etc/php.ini
    cd $istPATH
    tar zxvf ZendOptimizer-$v_zendoptimizer-linux-glibc23-$v_bit.tar.gz
    mkdir -p /usr/local/zend/
    cp ZendOptimizer-$v_zendoptimizer-linux-glibc23-$v_bit/data/5_2_x_comp/ZendOptimizer.so /usr/local/zend/
    cat >>/usr/local/php/etc/php.ini<<EOF
;eaccelerator

;ionCube

[Zend Optimizer] 
zend_optimizer.optimization_level=1 
zend_extension="/usr/local/zend/ZendOptimizer.so" 
EOF

    groupadd nginx
    useradd -s /sbin/nologin -g nginx nginx
	mkdir -p /home/webs/public/default
	mkdir -p /home/webs/vhost
    mkdir -p /home/webs/logs
	chmod +w /home/webs
    chown -R nginx:nginx /home/webs/public
    rm -f /usr/local/php/etc/php-fpm.conf
	cp conf/php-fpm.conf /usr/local/php/etc/php-fpm.conf
	cp conf/php-fpm /etc/init.d/php-fpm
	chmod +x /etc/init.d/php-fpm
	chkconfig --level 345 php-fpm on
    msgt
    if [ -s /usr/local/php ]; then
        echo -e "PHP has being installed! [\033[32;40m  O K  \033[0m]"
    else
        echo -e "The installing of PHP is failed! [\033[31;40m FLASE \033[0m]"
    fi
    msgb
## [[ PHP INSTALL END ]]

## [[ NGINX INSTALL BEGIN ]]
	msgt
    echo "Nginx is being installed!"
    msgb
	cd $istPATH
	tar zxvf pcre-$v_pcre.tar.gz
	cd pcre-$v_pcre/
	./configure > $install_logs/pcre-conf.log 2>&1
	[ $? != 0 ] && get_err "pcre configure error"
	make > $install_logs/pcre-make.log 2>&1
	[ $? != 0 ] && get_err "pcre make error"
	make install > $install_logs/pcre-install.log 2>&1
	[ $? != 0 ] && get_err "pcre insatll error"
	cd $istPATH
	tar zxvf nginx-$v_nginx.tar.gz
	cd nginx-$v_nginx/
	./configure --user=nginx --group=nginx --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module > $install_logs/nginx-conf.log 2>&1
	[ $? != 0 ] && get_err "nginx configure error"
	make > $install_logs/nginx-make.log 2>&1
	[ $? != 0 ] && get_err "nginx make error"
	make install > $install_logs/nginx-install.log 2>&1
	[ $? != 0 ] && get_err "nginx install error"
	cd $istPATH
	rm -f /usr/local/nginx/conf/nginx.conf
	rm -f /usr/local/nginx/conf/fcgi.conf
	cp conf/nginx.conf /usr/local/nginx/conf/nginx.conf
	sed -i 's#www.wangdianla.com#'$domain'#g' /usr/local/nginx/conf/nginx.conf
	cp conf/fcgi.conf /usr/local/nginx/conf/fcgi.conf
	cp conf/rewrite/discuz.conf /usr/local/nginx/conf/rw_discuz.conf
	cp conf/rewrite/wordpress.conf /usr/local/nginx/conf/rw_wordpress.conf
	touch /usr/local/nginx/conf/re_default.conf
	cat >/home/webs/public/default/phpinfo.php<<EOF
<?php
phpinfo();
EOF
	cp conf/nginx /etc/init.d/nginx
	chmod +x /etc/init.d/nginx
	chkconfig --level 345 nginx on
	/etc/init.d/mysql start
	/etc/init.d/php-fpm start
	/etc/init.d/nginx start
	msgt
    if [ -s /usr/local/nginx ]; then
        echo -e "Nginx has being installed! [\033[32;40m  O K  \033[0m]"
    else
        echo -e "The installing of Nginx is failed! [\033[31;40m FLASE \033[0m]"
    fi
    msgb
## [[ NGINX INSTALL END ]]

# [ MAKE & INSTALL END ]