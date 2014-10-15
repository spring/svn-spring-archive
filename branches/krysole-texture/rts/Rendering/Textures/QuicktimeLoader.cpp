/*
 *  QuicktimeLoader.cpp
 *  SpringRTS
 */

#include "QuicktimeLoader.h"

#include "Rendering/GL/myGL.h"

#include <QuickTime/ImageCompression.h>
#include <QuickTime/QuickTimeComponents.h>

#include "System/FileSystem/FileHandler.h"
#include "System/bitops.h"

#ifdef _BIG_ENDIAN
#define SPRING_GL_UNSIGNED_INT_8_8_8_8 GL_UNSIGNED_INT_8_8_8_8_REV
#else
#define SPRING_GL_UNSIGNED_INT_8_8_8_8 GL_UNSIGNED_INT_8_8_8_8
#endif

#include "Texture.h"
#include "EnvMap.h"
#include "MemTexture.h"
#include "MemTextureEffects.h"

Texture QuicktimeLoader::LoadTexture(const std::string &filename, bool mipmaps)
{
	// Load texture data in ARGB or BGRA format depending on architecture
	std::size_t width = 0, height = 0;
	unsigned char *data = LoadTextureData(filename, &width, &height);
	if (!data) {
		// NOTE: the actual error has already been logged...we just return
		return Texture();
	}
	
	// ARB_non_power_of_two indicates that we can load npot textures with mipmapping chains
	if ((width != next_power_of_2(width) || height != next_power_of_2(height)) && !GLEW_ARB_texture_non_power_of_two)
	{
		// Convert the bytes to a MemTexture compatible RGBA buffer
		ChangeBytesToRGBA(data, width, height);
		
		// Scale our texture
		MemTexture rsztex = MemTexture(data, width, height, true);
		
		std::size_t nextWidth = next_power_of_2(width);
		std::size_t nextHeight = next_power_of_2(height);
		
		rsztex = mtxeffect::ScaleToSize(rsztex, nextWidth, nextHeight);
		
		return rsztex.CreateTexture(mipmaps);
	}
	
	// Create texture and load our texture data into it
	Texture tex;
	glPushAttrib(GL_TEXTURE_BIT);
	tex.Bind();
	glEnable(GL_TEXTURE_2D);

	// These should be the same as in Texture::Texture(...)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	
	if (mipmaps) {
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, 
			GL_LINEAR_MIPMAP_LINEAR);
		
		// If we can simply let gl generate mipmaps it might save the
		// cpu some work depending on the gl idc driver;)
		if (GLEW_SGIS_generate_mipmap) {
			glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, true);
			
			// Hint GL to generate 'nicest' mipmaps
			glHint(GL_GENERATE_MIPMAP_HINT_SGIS, GL_NICEST);
			
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_BGRA, 
				SPRING_GL_UNSIGNED_INT_8_8_8_8, data);
		} else {
			gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA8, width, height, GL_BGRA, 
				SPRING_GL_UNSIGNED_INT_8_8_8_8, data);
		}
	} else {
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_BGRA, 
			SPRING_GL_UNSIGNED_INT_8_8_8_8, data);
	}
	
	glPopAttrib();
	delete[] data;
	
	return tex;
}

MemTexture QuicktimeLoader::LoadMemTexture(const std::string &filename)
{
	// Load texture data in ARGB or BGRA format depending on architecture
	std::size_t width = 0, height = 0;
	unsigned char *data = LoadTextureData(filename, &width, &height);
	if (!data) {
		// NOTE: the actual error has already been logged...we just return
		return MemTexture();
	}
	
	// Convert bytes to the format expected by MemTexture
	ChangeBytesToRGBA(data, width, height);
	
	return MemTexture(data, width, height, true);
}

EnvMap QuicktimeLoader::LoadEnvMap(const std::string &filename)
{
	// QuicktimeLoader does not deal with cube maps
	// TODO: log error message before returning
	return EnvMap();
}

bool QuicktimeLoader::SaveMemTexture(const MemTexture &mtx, const std::string &filename)
{
	// TODO: impl
	return false;
}

unsigned char *QuicktimeLoader::LoadTextureData(const std::string &filename, 
	std::size_t *width, std::size_t *height)
{
	std::size_t rawDataSize = 0;
	unsigned char *rawData = LoadResData(filename, &rawDataSize);
	if (!rawData) {
		return NULL;
	}
	
	// If this succeeds we need to keep our rawData ptr until we release the handle
	char **dataRef = GetPtrDataRef(rawData, rawDataSize, filename);
	if (!dataRef) {
		delete[] rawData;
		return NULL;
	}
	
	bool hasAlpha = false;
	unsigned char *texData = DecodeTextureData(dataRef, width, height, &hasAlpha);
	
	DisposeHandle(dataRef);
	delete[] rawData;
	
	if (!texData) {
		return NULL;
	}
	
	if (!hasAlpha) {
		AddAlpha(texData, *width, *height); // We use an internal alg this time
	}
	
	// the format is still ARGB on PPC and BGRA on X86 on return! NOT RGBA!
	return texData;
}

char **QuicktimeLoader::GetPtrDataRef(const unsigned char *mem, std::size_t size, 
	const std::string &filename)
{
	// Load Data Reference
	PointerDataRef dataRef = 0;
	ComponentInstance dataHandler = 0;
	Handle fileNameHandle = 0;
	
	// TODO: replace this eventually with the exception based error handler
	//       that way we actually get details of what caused the error too!
	while (true) { // Oldschool error fall-through loop
	
		// Allocate the data reference info structure
		dataRef = (PointerDataRef)NewHandle(sizeof(PointerDataRefRecord));
		
		HLock((char **)dataRef); // We don't need to maintain old lock state
		(**dataRef).data = const_cast<unsigned char *>(mem); // we don't own this pointer...but we need nonconst ptr for legacy fn
		(**dataRef).dataLength = size;
		HUnlock((char **)dataRef);
	
		// Get Data Handler (Pointer Data Handler Component)
		if (noErr != OpenADataHandler((char **)dataRef, 
				PointerDataHandlerSubType, NULL, (OSType)0, NULL, kDataHCanRead, &dataHandler)) {
			break;
		}
		
		// get the extension and append it to our dummy file name "a.*"
		std::string tfilename = "a" + filename.substr(filename.rfind('.'));
		if (tfilename.length() > 255) { // no image has a filename extension this long!
			// use dummy filename: filename instead and let quicktime sort figure it out here (slow).
			tfilename = "a";
		}
		
		// Allocate and copy filename into a handle block
		fileNameHandle = NewHandle(tfilename.length() + 1);
		HLock((char **)fileNameHandle); // We don't need to maintain old lock state
		CopyCStringToPascal(tfilename.c_str(), (unsigned char*)*fileNameHandle);
		HUnlock((char **)fileNameHandle);
		
		// Add filename extension
		if (noErr != DataHSetDataRefExtension(dataHandler, fileNameHandle, 
				kDataRefExtensionFileName)) {
			break;
		}
	
		// Grab the new version of the data ref from the data handler
		Handle extDataRef;
		if (noErr != DataHGetDataRef(dataHandler, &extDataRef)) {
			break;
		}
		
		// Clean Up!
		DisposeHandle(fileNameHandle);
		DisposeHandle((char **)dataRef);
		CloseComponent(dataHandler);
		
		// DataRef now points to our filename extension ptr handle!
		return extDataRef;
	}
	
	// Error occurred!
	if (fileNameHandle)		DisposeHandle(fileNameHandle);
	if (dataRef)			DisposeHandle((char **)dataRef);
	if (dataHandler)		CloseComponent(dataHandler);
	
	// TODO: report failure to get data reference...very bad
	return 0;
}
		
unsigned char *QuicktimeLoader::DecodeTextureData(char **dataRef, 
	std::size_t *xsize, std::size_t *ysize, bool *hasAlpha)
{
	GWorldPtr gworld = 0;
	GraphicsImportComponent gicomp = 0;
	unsigned char *imageData = 0;
	
	// TODO: replace this eventually with the exception based error handler
	//       that way we actually get details of what caused the error too!
	while (true) { // oldschool procedural fall-through error handler block
	
		// Get the graphics importer
		if (noErr != GetGraphicsImporterForDataRef(dataRef, 'ptr ', &gicomp) ||
			noErr != GraphicsImportSetQuality(gicomp, codecLosslessQuality)) {
			break;
		}
		
		// Get the image description (width, height and src alpha)
		ImageDescriptionHandle desc;
		if (noErr != GraphicsImportGetImageDescription(gicomp, &desc)) {
			break;
		}
		HLock((char **)desc); // We don't need to maintain old lock state
		*hasAlpha = (**desc).depth == 32; // Only if it returns 32 does the image have an alpha chanel!
		*xsize = (**desc).width;
		*ysize = (**desc).height;
		HUnlock((char **)desc);
		DisposeHandle((char **)desc);
		
		// Create GWorld to draw into using out buffer as the destination memory
		imageData = new unsigned char[(*xsize) * (*ysize) * 4];
		Rect gworldSize = {0, 0, (*ysize), (*xsize)}; // T, L, B, R
		QTNewGWorldFromPtr(&gworld, k32ARGBPixelFormat, &gworldSize, 0, 0, 0, imageData, (*xsize) * 4);
		if (!gworld) {
			break;
		}
	
		// Save old Graphics Device and Graphics Port to restore after
		GDHandle origDevice;
		CGrafPtr origPort;
		GetGWorld (&origPort, &origDevice);
	
		// Set Destination gworld to our memory buffer gworld
		if (noErr != GraphicsImportSetGWorld(gicomp, gworld, 0)) {
			break;
		}
	
		// Lock pixels so that we can draw to our memory texture
		if (!GetGWorldPixMap(gworld) || !LockPixels(GetGWorldPixMap(gworld))) {
			break;
		}
	
		//*** Draw GWorld into our Memory Texture!
		GraphicsImportDraw(gicomp);
	
		// Clean up
		UnlockPixels(GetGWorldPixMap(gworld));
		SetGWorld(origPort, origDevice); // set graphics port to offscreen (we don't need it now)
		DisposeGWorld(gworld); // These three are duplicated in the error fallthrough
		CloseComponent(gicomp);
		
		// Texture Loaded Successfully!
		return imageData;
	}
		
	// Error has occurred, Clean Up!
	if (gworld)		DisposeGWorld(gworld);
	if (gicomp) 	CloseComponent(gicomp);
	if (imageData)	delete[] imageData;
	
	// TODO: report (log) that the file could not be decoded!
	return 0;
}

unsigned char *QuicktimeLoader::LoadResData(const std::string &resName, std::size_t *resSize)
{
	CFileHandler file(resName);
	if  (!file.FileExists()) {
		// TODO: report (log) that the file did not exist!
		return 0;
	}

	unsigned char *mem = new unsigned char[file.FileSize()];
	file.Read(mem, file.FileSize());
	*resSize = file.FileSize();
	
	return mem;
}

// TODO: REALLY IMPORTANT, I screwed up the two functions below
// I forgot that I'm not dealing with packed integers here, they're
// only packed integers when using gl importing functions. Right now
// they're still in ARGB UNSIGNED_BYTE format!...leave a note so
// I don't forget that detail later (or anyone else;))

void QuicktimeLoader::ChangeBytesToRGBA(unsigned char *data, 
	std::size_t width, std::size_t height)
{
#if defined (_BIG_ENDIAN)
	// ARGB to RGBA : 0123 to 1230
	std::size_t total = width * height * 4;
	for (int i = 0; i < total; i += 4) {
		unsigned char t = data[i + 0]; // t = A
		
		unsigned int *iptr = (unsigned int *)&data[i];
		*iptr <<= 8; // move rgb bits left 1 byte so that we have RGBX
		
		data[i + 3] = t; // A = t
	}
#else // _LITTLE_ENDIAN
	// BGRA to RGBA : 0123 to 2103
	std::size_t total = width * height * 4;
	for (int i = 0; i < total; i += 4) {
		// Swap B and R bytes
		unsigned char t = data[i + 0]; // t = B
		data[i + 0] = data[i + 2]; // B = R
		data[i + 2] = t; // R = B
	}
#endif
}

void QuicktimeLoader::AddAlpha(unsigned char *data, 
	std::size_t width, std::size_t height)
{
	std::size_t channel;
#if defined (_BIG_ENDIAN)
	// Alpha in ARGB is channel 0
	channel = 0;
#else
	// Alpha in BGRA is channel 3
	channel = 3;
#endif
	std::size_t totalBytes = width * height * 4;
	for (std::size_t i = 0; i < totalBytes; i += 4) {
		data[i + channel] = 255; // Set to fully opaque (remove transparency)
	}
}
