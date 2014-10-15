/*
Static lightmapping class
*/


namespace terrain
{
	// The lightmap contains a shading texture to apply the lights on the terrain,
	// and a shadow texture for unit shadowing

	class Lightmap : public BaseTexture
	{
	public:
		Lightmap (Heightmap *hm, int level, LightingInfo *li);

		const Texture &GetShadowTexture() { return shadowTex; }
		const Texture &GetShadingTexture() { return shadingTex; }

	protected:
		Texture shadowTex, shadingTex;
	};
};
