
JCAI global AI
--------------

Version 0.20

By Zaphod/Jelmer Cnossen


Intro
-----

JCAI is a working and fairly stable AI, but it still has a lot of things that need to be taken care of.
Currently, it's a nice way for beginners to start exploring the game, 
but gives the average player no challenge at all. Expect a lot of improvement in next versions...


Installation
------------

Extract the contents of the zip file to <Your TA spring directory>\aidll\globalai\
The globalai directory will contain a directory named JCAI, which contains the AI config files.

It should look like this:

C:\taspring
	\aidll
		\globalai
			Test.dll
			\JCAI
				AI config files
	\base
	\demos
	\docs
	\maps
	\mods
	\shaders



Running spring with AI
----------------------

You can either use the TASClient to create a server with bots in it, 
or you can start spring.exe directly:

Run spring.exe and select Yes to "Do you want to be server?"
Then select the "GlobalAI test" and select the map you want to play.

In game, you can use these to spectate on the AI player (First enable cheating by saying ".cheat"):

".spectator" makes you a spectator, so you can watch what the AI is doing.
".team <x>" changes you back to a normal player that is controlling team <x>. 
You might want to use this if the AI is stuck 
(These are pathfinding bugs of spring itself, I still have to find a way to work around them).

You can't join the same team as the AI, it will not be able to match the created units to it's
own internal task list, and will crash. However you can cooperate with the AI (join the same allyteam)


Source Code
-----------

The source code is avaiable under GPL license, so you can use it as a base for your AI (or anything else) or use parts of it.
However, I would appreciate if you would send any fixes, improvements or extensions to me, so I can include it in this AI.


Support
-------

JCAI currently supports Core and Arm on the default XTA mod that comes with spring.

You can support your own spring mod by creating config file named after the mod filename.
For example the XTA mod in the mods directory is called xta_se_v*.sdz, and the XTA AI script is called xta_se_v*.cfg
Because mod info and the build table are now cached on disk, you have to disable caching if you modify units.
This can be done within the mod AI config, look for "CacheBuildTable"


Feedback
--------

Use the forum for any feedback you might have on this AI.

Known bugs:
- Capturing an AI builder will result in a crash, because the AI can currently not detect that one of it's units is captured.
- Ground force groups like to chase aircraft.
- It uses the commander too much, and doesn't build extra builders
- It doesn't support water maps
- It doesn't build support units (defense/radar)

Todo list
---------

- Improve building
- Defense/support building
- Support geothermal buildings
- Calculate 'threat proximity' to optimize building placement.
- Map own defenses to be able to place buildings at the safest locations
- Use the pathfinder to calculate path length instead of just Euclidean distance, this should also improve behavior on water maps
- Make force groups be able to cooperate, or at least attack together

Changelog
---------

0.20

- Rewritten most parts of the AI:
- There is no cell system anymore, building is now based on building tasks
- Optimized build table to directly find suitable factory types to perform a certain task
	Unit definitions are cached so startup loading time is decreased.
- Metal spot generator is now seperated from the other mapinfo, and scales with the extractor radius
	This makes it work better on metal maps
- Recon is improved with a 'SpreadFactor' that makes recon planes keep distance to eachother.
- The configuration file parser is rewritten. It now supports nested config nodes and including files
- Threat mapping has been greatly improved, it now brings weapon ranges into account.
	You can write the current threatmap to a TGA file by typing '.writethreatmap'
- You can show runtime AI info by typing '.debugwindow', make sure you are in windowed mode though.

0.11

- fixed unit groups moving to sector (-1,0) if no good goal sector could be found.
- improved handling of failed building tasks - they now stop after 9 tries
- updated force info in aiscript-help.txt
- adapted log file functions so log file will also be saved if a crash occurs.
- optimized and improved force production and factory selection
- extended communication between parent and child cells

0.10

Initial release
