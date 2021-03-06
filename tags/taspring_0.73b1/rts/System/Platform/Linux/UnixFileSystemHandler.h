/**
 * @file UnixFileSystemHandler.h
 * @brief Abstracts locating of content on different platforms
 * @author Tobi Vollebregt
 *
 * Unix implementation
 *
 * Copyright (C) 2006.  Licensed under the terms of the
 * GNU GPL, v2 or later
 */

#ifndef UNIXFILESYSTEMHANDLER_H
#define UNIXFILESYSTEMHANDLER_H

#include <string>
#include <vector>
#include "Platform/FileSystem.h"

/**
 * @brief Unix file system / data directory handler
 */
class UnixFileSystemHandler : public FileSystemHandler
{
	public:

		virtual ~UnixFileSystemHandler();
		UnixFileSystemHandler(bool verbose, bool mapArchives);

		virtual bool mkdir(const std::string& dir) const;

		virtual std::string GetWriteDir() const;
		virtual std::vector<std::string> FindFiles(const std::string& dir, const std::string& pattern, int flags) const;
		virtual std::string LocateFile(const std::string& file) const;
		virtual std::vector<std::string> GetDataDirectories() const;

	private:

		struct DataDir
		{
			DataDir(const std::string& p);
			std::string path;
			bool readable;
			bool writable;
		};

		std::string SubstEnvVars(const std::string& in) const;
		void AddDirs(const std::string& in);
		void DeterminePermissions(int start_at = 0);
		void LocateDataDirs();
		void InitVFS(bool mapArchives = true) const;
		void FindFilesSingleDir(std::vector<std::string>& matches, const std::string& dir, const std::string &pattern, int flags) const;

		std::vector<DataDir> datadirs;
		const DataDir* writedir;
};

#endif // !UNIXFILESYSTEMHANDLER_H
