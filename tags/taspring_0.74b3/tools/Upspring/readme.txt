
Upspring Model Editor (freeware)
version 1.3
---------------------
By Jelmer Cnossen

This is a unit model editor that can be used to put TA spring S3O and 3DO units together.
It supports the 3DO (original Total Annihilation) format, the S3O format, and 3DS format and Wavefront OBJ format.

Documentation
-------------
See the springtut.pdf for a complete tutorial on creating S3O files with Upspring.

Program info
------------
Rendering: OpenGL (www.opengl.org)
Image loading: DevIL (openil.sf.net)
GUI: FLTK (www.fltk.org)
zlib: ZIP archive loading
GLEW: OpenGL extension loading (glew.sf.net)

Known problems
--------------
Redrawing problems with adding/removing views, resize the views a bit to get them correct again.

Thanks to
---------
-Maestro for testing, writing a spring manual(!) and creating the application icon
-Weaver for testing and creating tool icons
-The guy that made the armpw model who's name I forgot :O, if you object to this being included as a sample let me know.
-The rest of the spring mod community for testing... :)

Keys (should be obvious though)
-------------------------------

In viewports:
Alt			= 	Force camera tool

When object tab is enabled:
Copy			=	Ctrl-C
Cut			=	Ctrl-X
Paste			=	Ctrl-V
Delete			=	Delete selected polygons or selected objects, depending on which tool is active.

There are many other keys avaiable, most menu items have a key selected 
but you can see those next to the menu item name.


Changes since 1.2
-----------------
- 3DO colors are not messed up anymore. 
- You can flip and mirror the UVs in the UV viewer window.
- Black texture bug fixed
- S3O texture behavior improved: 
	- names of textures will be written in S3O even if they are missing
	- A texture loading directory can be set (You would usually set this to something like c:\spring\unittextures)
- S3O texture rendering can be changed, so you can view the textures seperately and without teamcolor applied.
- S3O texture builder, you can convert an RGB texture + grayscale texture into a single RGBA texture.
