/*
 *  EnvMap.h
 *  SpringRTS
 */

#ifndef SPRING_RTS_ENV_MAP_H
#define SPRING_RTS_ENV_MAP_H

#include <boost/shared_ptr.hpp>

class TextureImpl;

class EnvMap
{
public:
	EnvMap(); // GL texture created on first call to Bind()
	
	void Bind() const; // Bind to GL_TEXTURE_CUBE_MAP_ARB

	// Indicates if this texture has been bound at least once
	// Usually this is used to determine if the texture hasn't been loaded
	typedef struct unspecified_bool_type_struct {} *unspecified_bool_type;
	operator unspecified_bool_type() const;
private:
	// NOTE: We're using TextureImpl here since only the
	//       bind function really differs in code
	mutable boost::shared_ptr<TextureImpl> pimpl_;
};

#endif /* SPRING_RTS_ENV_MAP_H */
