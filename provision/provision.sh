# note: most of this provision script was created by Maarten Smeets (AMIS) - see https://github.com/AMIS-Services/sig-graalvm-quarkus-15082019

#Desktop
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-cache policy docker-ce

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y install terminator firefox jq wget aptitude apt-transport-https ca-certificates gnupg2 curl software-properties-common docker-ce docker-compose libxss1 libgconf2-4 evince socat maven openjdk-8-jdk build-essential libz-dev
aptitude -y install --without-recommends ubuntu-desktop 
#Fix root not allowed to start X-window
xhost local:root

#developer user
useradd -d /home/developer -m developer
echo -e "Welcome01\nWelcome01" | passwd developer
usermod -a -G vboxsf developer
usermod -a -G docker developer
usermod -a -G sudo developer
usermod --shell /bin/bash developer

#Fix screen flickering issue
perl -e '$^I=".backup";while(<>){s/#(WaylandEnable=false)/$1/;print;}' /etc/gdm3/custom.conf

#Hide vagrant
echo '[User]' > /var/lib/AccountsService/users/vagrant
echo 'SystemAccount=true' >> /var/lib/AccountsService/users/vagrant

cp /etc/sudoers.d/vagrant /etc/sudoers.d/developer
sed -i 's/vagrant/developer/g' /etc/sudoers.d/developer

#Install Eclipse
snap install --classic eclipse

#Install Chrome Browser (for debugging with GraalVM and Chrome DevTools)
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# use -f to fix broken dependencies
sudo apt-get -y update && sudo apt-get install -f
sudo dpkg -i google-chrome-stable_current_amd64.deb

#Install Visual Studio Source (https://linuxize.com/post/how-to-install-visual-studio-code-on-ubuntu-18-04/)
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt update
sudo apt install code

#install VSS extension
code --list-extensions
code --install-extension oracle-labs-graalvm.graalvm


#Install GraalVM. Based on https://gist.github.com/ricardozanini/fa65e485251913e1467837b1c5a8ed28
wget https://github.com/oracle/graal/releases/download/vm-19.2.1/graalvm-ce-linux-amd64-19.2.1.tar.gz  -O /tmp/graalvm.tar.gz

tar -xvzf /tmp/graalvm.tar.gz 
mv graalvm-ce-19.2.1 /usr/lib/jvm/
ln -s /usr/lib/jvm/graalvm-ce-19.2.1 /usr/lib/jvm/graalvm
update-alternatives --install /usr/bin/java java /usr/lib/jvm/graalvm/bin/java 1
update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/graalvm/bin/javac 1
update-alternatives --install /usr/bin/native-image native-image /usr/lib/jvm/graalvm/bin/native-image 1
update-alternatives --set java /usr/lib/jvm/graalvm/bin/java
update-alternatives --set javac /usr/lib/jvm/graalvm/bin/javac
update-alternatives --set native-image /usr/lib/jvm/graalvm/bin/native-image
rm -f /tmp/graalvm.tar.gz

#Install native image tool
/usr/lib/jvm/graalvm-ce-19.2.1/bin/gu install native-image

#Install graalpython , R and ruby
/usr/lib/jvm/graalvm-ce-19.2.1/bin/gu install python
/usr/lib/jvm/graalvm-ce-19.2.1/bin/gu install R
/usr/lib/jvm/graalvm-ce-19.2.1/bin/gu install ruby


#Set GRAALVM_HOME
echo 'export GRAALVM_HOME=/usr/lib/jvm/graalvm' > /etc/profile.d/setGRAALVM_HOME.sh
#Set JAVA_HOME
echo 'export JAVA_HOME=/usr/lib/jvm/graalvm' > /etc/profile.d/setJAVA_HOME.sh
echo 'export PATH=$PATH:/usr/lib/jvm/graalvm/bin' > /etc/profile.d/addgraalvmtopath.sh

#Git Clone the Workshop Sources
cd /home/developer
git clone https://github.com/AMIS-Services/graalvm-polyglot-meetup-november2019 
sudo chmod -R ugo+rw graalvm-polyglot-meetup-november2019


shutdown now -h