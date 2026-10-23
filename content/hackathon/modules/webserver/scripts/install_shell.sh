#!/bin/bash
#set -x



echo "23.1.48.99 dev.mysql.com" >> /etc/hosts

# Install MySQL Community Edition 8.0
rpm -ivh https://dev.mysql.com/get/mysql84-community-release-$(uname -r | sed 's/^.*\(el[0-9]\+\).*$/\1/')-2.noarch.rpm
yum install -y mysql-shell --enablerepo=mysql-tools-innovation-community
# Install Maven first so any Java dependencies cannot override the default JDK.
yum install -y maven

# Discover Oracle JDK releases only from the Oracle Linux 9 OCI repository.
# OCI Oracle Linux images include this repository configuration by default.
jdk_repo=ol9_oci_included
jdk_packages=$(dnf -q --refresh --disablerepo='*' --enablerepo="$jdk_repo" \
  --setopt="${jdk_repo}.skip_if_unavailable=False" \
  repoquery --available --archlist="$(uname -m)" \
  --queryformat='%{name}' 'jdk-*-headful') || exit 1
jdk_major=$(printf '%s\n' "$jdk_packages" \
  | sed -n 's/^jdk-\([0-9][0-9]*\)-headful$/\1/p' | sort -nu | tail -n 1)
if [ -z "$jdk_major" ]; then
  echo "No Oracle JDK development package found in ${jdk_repo}." >&2
  exit 1
fi

# Restrict the JDK source to Oracle; dependencies may use other enabled repos.
jdk_package="jdk-${jdk_major}-headful"
echo "Installing Oracle JDK ${jdk_major} from ${jdk_repo}."
dnf -y --enablerepo="$jdk_repo" --setopt="${jdk_repo}.skip_if_unavailable=False" \
  repository-packages "$jdk_repo" install "$jdk_package" || exit 1

# The Oracle RPM maintains this symlink across updates of the selected major.
jdk_home="/usr/java/jdk-${jdk_major}"
alternatives --set java "$(readlink -f "${jdk_home}/bin/java")" || exit 1
alternatives --set javac "$(readlink -f "${jdk_home}/bin/javac")" || exit 1
printf 'export JAVA_HOME=%s\n' "$jdk_home" > /etc/profile.d/java.sh

yum install -y npm
yum install -y httpd

# check if shell is installed and force manual installation
which mysqlsh > /dev/null 2>&1
if [ $? -eq 1 ]; 
then 
  rpm -ivh https://repo.mysql.com/yum/mysql-tools-innovation-community/el/$(uname -r | sed 's/^.*el\([0-9]\+\).*$/\1/')/x86_64/mysql-shell-9.5.0-1.$(uname -r | sed 's/^.*\(el[0-9]\+\).*$/\1/').x86_64.rpm
fi

echo "MySQL Shell successfully installed !"

firewall-cmd --zone=public --permanent --add-port=80/tcp
firewall-cmd --zone=public --permanent --add-port=443/tcp
firewall-cmd --reload

chcon --type httpd_sys_rw_content_t /var/www/html
chcon --type httpd_sys_rw_content_t /var/www/html/*
setsebool -P httpd_can_network_connect_db 1
setsebool -P httpd_can_network_connect=1

systemctl enable httpd
systemctl start httpd

echo "Local Security Granted !"


