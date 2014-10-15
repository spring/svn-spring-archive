##################################
AFLobby Readme

Welcome to AFlobby, a Java based, cross-platform lobby client for the Spring RTS engine project on Windows Mac and Linux operating systems. The current aims for project are to liberate users from the hell that is TASClient,whil moving in a multi-platform context as Spring increasingly extends support to other platforms.

Please keep in mind that this software is in beta, so not all features have been implemented and you may encounter some bugs or crashes that are not intended for in the envisioned final product. However, AFLobby is capable of supporting a multi-player experience in its current state. Consider this a preview of what is to come, and an opportunity to give feedback to the developer as he tries to clean up issues and bring in new features.

Requirements/Dependencies:
Sun Java 6 (no java cgi, etc...)
Spring 0.74b3+ (Required to use multi-player)

Beta 1 final will have an installer under windows. Linux users wont have an installer unless aflobby is included as part of  spring package.

##################################
Linux installation and running~~ (Assumes you downloaded the Linux version of AFLobby)

This guide assumes that the SpringRTS engine, and a selection of mods and maps are installed, so please refer to this wiki page for more information regarding spring installation:
http://spring.clan-sy.com/wiki/SetupGuide

The Linux version comes with two packages; package1.zip contains  images, sounds, flags, smileys, ranks, themes, settings etc; whereas package2.zip contains the lobby executable binary, start script, and dependencies.

1. Create an ".aflobby" directory in your Home folder: mkdir -p ~/.aflobby

2. Extract the package1.zip folders to ~/.aflobby so your .aflobby folder has “images”, “sounds”, and “minimaps” folders.

3. Extract the files and folders from package2.zip, then cut and paste to:
       /usr/share/games/spring
You may need root access to write these files to this directory depending upon your distro and preferences.

4. To start AFLobby open a session of your terminal and type in the following two commands:

cd /usr/share/games/spring
bash aflobby.sh

5. Login and play spring

##################################
Windows installation and running~~ (Assumes you downloaded the Windows version of AFLobby)

This guide assumes that the Spring RTS engine is installed and in the default directory. Please download and install the regular installer from the official Spring RTS download page if you have not already: http://spring.clan-sy.com/download.php

1. Create the "aflobby" folder in c:/program files/spring/lobby

2. Extract the contents of package1.zip to c:/program files/spring/lobby/aflobby

3. Extract the contents of package2.zip to c:/program files/spring

4. To run AFLobby double click aflobby.jar.

If aflobby.jar opens in a archive tool such as winrar/winzip, use aflobby.bat



Note: This build doesn't have a windows java unitsync yet as it would require numerous dependencies from spring 0.75 which is yet to be released.
