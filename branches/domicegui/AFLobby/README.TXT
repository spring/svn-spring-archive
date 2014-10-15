===== Building/Running AFLobby from svn checkout ====

The command "java -jar JLobby.jar" should run AFLobby assuming that you're in the fodler equivilant to trunk/AFLobby/dist/.

Windows suers with the Sun JRE may be able to simply double click on jlobby.jar to run it.

To build AFLobby from source, you can sue any Java IDE by creatign a project and importing the source in /trunk/AFLobby/src/jlobby/. If you have NetBeans 5+ You can just OpenProject and select /trunk/AFLobby/ as the project and click OK and follow the usual steps to compile.

===== Notes =======

AFLobby is released under GPL2 and is copyright of Tom.J.Nowell Darkstars 2006. AFLobby was built udner NetBeans 5 with Sun Java JDK 1.5

========================
BUILD OUTPUT DESCRIPTION
========================

When you build an Java application project that has a main class, the IDE
automatically copies all of the JAR
files on the projects classpath to your projects dist/lib folder. The IDE
also adds each of the JAR files to the Class-Path element in the application
JAR files manifest file (MANIFEST.MF).

To run the project from the command line, go to the dist folder and
type the following:

java -jar "JLobby.jar" 

To distribute this project, zip up the dist folder (including the lib folder)
and distribute the ZIP file.

Notes:

* If two JAR files on the project classpath have the same name, only the first
JAR file is copied to the lib folder.
* If the classpath contains a folder of classes or resources, none of the
classpath elements are copied to the dist folder.
* If a library on the projects classpath also has a Class-Path element
specified in the manifest,the content of the Class-Path element has to be on
the projects runtime path.
* To set a main class in a standard Java project, right-click the project node
in the Projects window and choose Properties. Then click Run and enter the
class name in the Main Class field. Alternatively, you can manually type the
class name in the manifest Main-Class element.
