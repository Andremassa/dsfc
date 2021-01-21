#!/bin/bash

clear
echo ""
echo  -e "\t""Moodle Setup!"
echo ""
echo  -e "\t"$(date "+DATE: %D") "\n""\t"$(date "+TIME: %T")
echo ""
sleep 3

mkdir /opt

wget 'https://download.moodle.org/download.php/direct/stable310/moodle-3.10.1.zip'
mv 'moodle-3.10.1.zip' /opt/moodle.zip
uzip /opt/moodle.zip /var/www/html

mkdir /var/www/moodledata

chown -R www-data /var/moodledata

chmod -R 777 /var/moodledata

chmod -R 0755 /var/www/html/moodle

stty -echo
read -r -p "Chose the pwd for moodle user: " pwd
echo ""
stty echo

# Database
mysql -u root -p << EOF
CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
create user 'moodle'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON moodle.* TO 'moodle'@'localhost' IDENTIFIED BY '$pwd';
FLUSH PRIVILEGES;
EOF

service apache2 restart

exit
