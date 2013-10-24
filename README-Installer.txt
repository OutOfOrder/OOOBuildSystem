MojoSetup Instructions
---------------

I'm using MojoSetup for the linux installer.. The installer binaries themselves are already pre-packaged in a "sh" install header (mojosetup.sh).  So all that is required is to simply put the game data and binaries in the right  folders beneath Monaco.mojo and run the mojosetup-prepare script to build the installer.

Copying Files
--------------

Game data files go into the GameName.mojo/data/noarch folder..  this includes the Game content folders from the Mac asset build, project.ini, etc.. steam_appid.txt (for now as we are distruting a "Steam build")..  and the Monoaco.png in the Code/Main/Projects/ folder.

The binaries and libraries go into the GameName.mojo/data/x86 or GameName.mojo/data/x86_64 depending on the architecture..  the structure is as follows..  (Libraries can be found in the 3rdParty folders)

x86/
  GameName.bin.x86
  lib/libSDL2-2.0.so.0
  lib/libsteam_api.so

the SDL2 lib needs to be the full SO with that name (e.g. libSDL2-2.0.so.0.0.0 renamed to libSDL2.2.0.so.0)  this is so we don't have to fiddle with symlinks (although mojo handles it perfectly..)

x86_64/
  GameName.bin.x86
  lib64/libSDL2-2.0.so.0

*NOTE* we currently do not have a 64bit build as the non-steam build doesn't work currently. and valve has not released a 64bit linux steam SDK.


Once everything is "in-place".. it's time to build the installer..   

./mojosetup-prepare Monoaco.mojo GameName-Linux-1.0-2013-09-30.sh

it may ask you permission to remove a previous install.zip.. just say yes.

What this script does is package the contents of GameName.mojo into a zip file and then "append" the zip to the mojosetup.sh header.  and TADA, linux installer..


