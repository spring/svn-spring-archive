/*
 *  Textures.h
 *  SpringRTS
 *
 *  All the important texturing interfaces are defined after
 *  importing this file. This helps to keep includes short and
 *  brief between subsystems. This should usually be included
 *  in the source file but may be needed in some header files also.
 *
 *  Each interface is described in its respective header (all are
 *  in Rendering/Textures). A list of the classes included here 
 *  has been included for brievety.
 *
 *  - Texture		Provides *Shared* GL Texture Support
 *  - MemTexture	Provides efficient cpu bound texture manipulation
 *  - mtxeffect::*	Provides manipulation algorithms for MemTexture objects
 *  - EnvMap		Provides *Shared* GL Texture (CUBE_MAP_ARB) Support
 *  - TextureLoader	Provides Loading/Saving of All Texture Objects (Singleton)
 *
 *  Simplest usage is shown below:
 *
 *  Texture tex = TextureLoader::Instance()->LoadTexture(_filename_);
 *  MemTexture mtx = TextureLoader::Instance()->LoadMemTexture(_filename_);
 *  EnvMap em = TextureLoader::Instance()->LoadEnvMap(_filename_);
 *
 *  To find out programatically if the texture loaded ok just use it like a bool!
 *  if (!tex) OMG();
 *  
 *  See individual mtxeffect classes for usage details.
 *
 *  All classes here have well defined copy/assign operators, which
 *  use efficient copying semantics. This can cause some operations
 *  to create a new copy of the texture data when a manipulation
 *  of that memory is attempted (MemTexture).
 */

#ifndef SPRING_RTS_TEXTURES_H
#define SPRING_RTS_TEXTURES_H

#include "Textures/Texture.h"
#include "Textures/EnvMap.h"
#include "Textures/MemTexture.h"
#include "Textures/MemLumTexture.h"
#include "Textures/MemTextureEffects.h"
#include "Textures/TextureLoader.h"

#endif /* !SPRING_RTS_TEXTURES_H */
