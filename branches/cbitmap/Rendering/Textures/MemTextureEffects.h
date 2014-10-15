/*
 *  MemTextureEffects.h
 *  SpringRTS
 */

#ifndef SPRING_RTS_MEM_TEXTURE_EFFECTS
#define SPRING_RTS_MEM_TEXTURE_EFFECTS

class MemTexture;
class Texture;

namespace mtxeffect {

	void AlphaWithColorKey(MemTexture &mtx, 
		unsigned char red, unsigned char green, unsigned char blue);

	// This version does not calculate the average color of non transparent
	// pixels applying them to the transparent pixels as well as making their
	// alpha value 0
	void AlphaWithColorKeyWithoutFix(MemTexture &mtx, 
		unsigned char red, unsigned char green, unsigned char blue);

	MemTexture ScaleToSize(const MemTexture &mtx, 
		std::size_t newWidth, std::size_t newHeight);

	void SetAlpha(MemTexture &mtx, unsigned char alpha);

	Texture Create1x1Texture(unsigned char red, unsigned char green, 
		unsigned char blue, unsigned char alpha = 255);

	MemTexture Create1x1MemTexture(unsigned char red, unsigned char green, 
		unsigned char blue, unsigned char alpha = 255);

	MemTexture Flip(const MemTexture &mtx);

	void Renormalize(MemTexture mtx, const float3 &newCol);

	MemTexture CreatePow2Aligned(const MemTexture &);
}

#endif /* SPRING_RTS_MEM_TEXTURE_EFFECTS */
