/**
 * @file SoLib.h
 * @brief Linux shared library loader
 * @author Christopher Han <xiphux@gmail.com>
 * 
 * Linux Shared Object loader class definition
 * Copyright (C) 2005.  Licensed under the terms of the
 * GNU GPL, v2 or later.
 */
#ifndef SOLIB_H
#define SOLIB_H

#include "Platform/SharedLib.h"

/**
 * @brief Linux shared library base
 *
 * This class loads *nix-type *.so shared objects.
 * Derived from the abstract SharedLib.
 */
class SoLib: public SharedLib
{
public:
	/**
	 * @brief Constructor
	 * @param filename shared object to load
	 */
	SoLib(const char *filename);

	/**
	 * @brief Destructor
	 */
	~SoLib();

	/**
	 * @brief Find address
	 * @param symbol Function (symbol) to locate
	 * @return void pointer to the function if found, NULL otherwise
	 */
	void *FindAddress(const char *symbol);
private:
	/**
	 * @brief so pointer
	 * Stores the loaded shared object as a void pointer
	 * (as per the standard convention)
	 */
	void *so;
};

#endif /* SOLIB_H */
