#! /bin/sh
# Configure your paths and filenames
SOURCEBINPATH=.
SOURCEDIR=keyring/
SOURCEBIN=keyring/garl.lua
GENBIN=svirfneblin-keyring-generator
BINBIN=svirfneblin-keyring-engage
SOURCEDOC=README.md
DEBFOLDER=svirfneblin-keyring-agent

DEBVERSION=$(date +%Y%m%d)

if [ -n "$BASH_VERSION" ]; then
	TOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
else
	TOME=$( cd "$( dirname "$0" )" && pwd )
fi
cd $TOME

git pull origin master

rm -rf $DEBFOLDERNAME
# Create your scripts source dir
mkdir $DEBFOLDERNAME

# Copy your script to the source dir
cp -R $TOME $DEBFOLDERNAME/
cd $DEBFOLDERNAME

pwd

# Create the packaging skeleton (debian/*)
dh_make --indep --createorig 

mkdir -p debian/tmp/usr
cp -R usr debian/tmp/usr

# Remove make calls
grep -v makefile debian/rules > debian/rules.new 
mv debian/rules.new debian/rules 

# debian/install must contain the list of scripts to install 
# as well as the target directory
echo etc/xdg/svirfneblin/rc.lua.pech.example etc/xdg/svirfneblin >> debian/install
echo etc/xdg/svirfneblin/$SOURCEBIN etc/xdg/svirfneblin/$SOURCEDIR >> debian/install
echo usr/bin/$GENBIN usr/bin >> debian/install
echo usr/bin/$BINBIN usr/bin >> debian/install
cp $SOURCEDOC usr/share/doc/$DEBFOLDER/$SOURCEDOC
echo usr/share/doc/$DEBFOLDER/$SOURCEDOC usr/share/doc/$DEBFOLDER >> debian/install

echo "Source: $DEBFOLDER
Section: unknown
Priority: optional
Maintainer: cmotc <cmotc@openmailbox.org>
Build-Depends: debhelper (>= 9)
Standards-Version: 3.9.5
Homepage: https://www.github.com/cmotc/svirfneblin-keyring-agent
#Vcs-Git: git@github.com:cmotc/svirfneblin-keyring-agent
#Vcs-Browser: https://www.github.com/cmotc/svirfneblin-keyring-agent

Package: $DEBFOLDER
Architecture: all
Depends: lightdm, lightdm-gtk-greeter, awesome (>= 3.4), gpg, gpg-agent, ssh, ssh-agent, svirfneblin-panel, \${misc:Depends}
Description: A keyring agent widget for svirfneblin
" > debian/control

#echo "gsettings set org.gnome.desktop.session session-name awesome-gnome
#dconf write /org/gnome/settings-daemon/plugins/cursor/active false
#gconftool-2 --type bool --set /apps/gnome_settings_daemon/plugins/background/active false
#" > debian/postinst
# Remove the example files
rm debian/*.ex
rm debian/*.EX

# Build the package.
# You  will get a lot of warnings and ../somescripts_0.1-1_i386.deb
debuild -us -uc >> ../log
