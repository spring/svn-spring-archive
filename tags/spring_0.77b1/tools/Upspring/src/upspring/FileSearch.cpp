 

#include  <stdio.h> 
#include  <stdlib.h> 
#include  <io.h> 
#include  <time.h> 


#include <string>
#include <list>

#include <FileSearch.h>


std::list<std::string>* FindFiles(const std::string& searchPattern, bool recursive, const std::string& path)
{
    struct  _finddata_t  c_file;
    intptr_t  hFile;

	std::string searchPath;

	if (!path.empty()) 
		searchPath = path + "\\";

	std::list<std::string>* r = new std::list<std::string>();

	// search for directories to scan
	if (recursive)
	{
		hFile = _findfirst( (searchPath + "*").c_str(),  &c_file);
		while (hFile != -1)
		{
			if (strcmp(c_file.name, "..") &&  strcmp(c_file.name, "."))
			{
				if (c_file.attrib & _A_SUBDIR)
				{
					std::string ns = path + c_file.name;
					ns += "\\";
					
					std::list<std::string>* subdir = FindFiles(searchPattern, true, ns);
					r->insert(r->end(), subdir->begin(), subdir->end());
					delete subdir;
				}
			}

			if (_findnext(hFile, &c_file) != 0) 
			{
				_findclose(hFile);
				hFile = -1;
			}
		} 
	}

	// search files that match the pattern
	hFile = _findfirst( (searchPath + searchPattern).c_str(),  &c_file);
	while (hFile != -1)
	{
		if (!(c_file.attrib & _A_SUBDIR))
			r->push_back(searchPath + c_file.name);

		if (_findnext(hFile, &c_file) != 0) {
			_findclose(hFile);
			hFile = -1;
		}
    } 


	return r;
}
