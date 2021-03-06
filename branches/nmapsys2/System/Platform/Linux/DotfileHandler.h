/**
 * @file DotfileHandler.h
 * @brief linux dotfile config base
 * @author Christopher Han <xiphux@gmail.com>
 *
 * DotfileHandler configuration class definition
 * Copyright (C) 2005.  Licensed under the terms of the
 * GNU GPL, v2 or later.
 */

#ifndef _DOTFILEHANDLER_H
#define _DOTFILEHANDLER_H

#include "Platform/ConfigHandler.h"

#include <string>
#include <fstream>
#include <map>

using std::string;

/**
 * @brief dotconfig file
 *
 * Defines the name of the configuration file to use
 */
#define DOTCONFIGFILE ".springrc"

/**
 * @brief dotconfig path
 *
 * Defines the full path to the config file (including dotconfig filename)
 */
#define DOTCONFIGPATH (string(getenv("HOME")).append("/").append(DOTCONFIGFILE))

/**
 * @brief DotfileHandler
 *
 * Linux dotfile handler config class, derived
 * from the abstract ConfigHandler.
 */
class DotfileHandler: public ConfigHandler
{
public:
	/**
	 * @brief Constructor
	 * @param fname path to config file
	 */
	DotfileHandler(string fname);

	/**
	 * @brief Destructor
	 */
	virtual ~DotfileHandler();

	/**
	 * @brief set integer
	 * @param name name of key to set
	 * @param value integer value to set
	 */
	virtual void SetInt(std::string name, int value);

	/**
	 * @brief set string
	 * @param name name of key to set
	 * @param value string value to set
	 */
	virtual void SetString(std::string name, std::string value);

	/**
	 * @brief get string
	 * @param name name of key to get
	 * @param def default string value to use if key is not found
	 * @return string value
	 */
	virtual std::string GetString(std::string name, std::string def);

	/**
	 * @brief get integer
	 * @param name name of key to get
	 * @param def default integer value to use if key is not found
	 * @return integer value
	 */
	virtual int GetInt(std::string name, int def);
protected:
	/**
	 * @brief filename
	 *
	 * Stores the path to the config file
	 */
	std::string filename;

	/**
	 * @brief file
	 * 
	 * Output stream for file
	 */
	std::ofstream file;

	/**
	 * @brief data map
	 *
	 * Map used to internally cache data
	 * instead of constantly rereading from the file
	 */
	std::map<string,string> data;

	/**
	 * @brief flush file
	 */
	virtual void flushfile(void);

	/**
	 * @brief truncate file
	 */
	virtual void truncatefile(void);
	
};

#endif /* _DOTFILEHANDLER_H */
