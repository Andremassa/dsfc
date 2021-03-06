#!/bin/bash

clear
echo ""
echo  -e "\t""Joomla Setup!"
echo ""
echo  -e "\t"$(date "+DATE: %D") "\n""\t"$(date "+TIME: %T")
echo ""
sleep 3

# Install Joomla?
while true
do
  read -r -p "Execute script? [Y/N] " exej

  case $exej in
    [yY][eE][sS]|[yY])
      break
  ;;
    [nN][oO]|[nN])
      sleep 2
      exit
  ;;
    *)
  esac
done

apt -y install php-xml php-zip

mkdir /opt

wget 'https://downloads.joomla.org/cms/joomla3/3-9-24/Joomla_3-9-24-Stable-Full_Package.zip?format=zip'
mv 'Joomla_3-9-24-Stable-Full_Package.zip?format=zip' /opt/joomla.zip
unzip /opt/joomla.zip -d /var/www/html/joomla

chown -R www-data:www-data /var/www/html/joomla
chmod -R 755 /var/www/html/joomla

echo '<VirtualHost *:80>
     ServerAdmin admin@your-domain.com
     DocumentRoot /var/www/html/joomla/
     ServerName your-domain.com
     ServerAlias www.your-domain.com

     ErrorLog ${APACHE_LOG_DIR}/error.log
     CustomLog ${APACHE_LOG_DIR}/access.log combined

     <Directory /var/www/html/joomla/>
            Options FollowSymlinks
            AllowOverride All
            Require all granted
     </Directory>

</VirtualHost>
' > /etc/apache2/sites-available/joomla.conf

a2ensite joomla
a2ensite joomla.conf
a2enmod rewrite

stty -echo
echo ""
read -r -p "Set a pwd for joomla user: " joomlapwd
echo ""
echo ""
stty echo

# Database
echo "Login into MySQL "
mysql -u root -p << EOF
CREATE DATABASE joomladb;
create user 'joomla'@'localhost' IDENTIFIED BY '$joomlapwd';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON joomladb.* TO 'joomla'@'localhost';
FLUSH PRIVILEGES;
EOF

systemctl restart apache2

# Webpage Installation

chmod -R 777 /var/www/html/joomla

whiptail --title "Joomla Installation!" --msgbox "Now head to the joomla page and do the following! 1/1


- DataBase Type

Choose: mysqli

- DataBase Settings

Host name: localhost

Database: joomladb

User: joomla

Password: passwd (the password for the user you created)


Press ok to close!" 25 70

chmod -R 755 /var/www/html/joomla

exit
