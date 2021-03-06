#pragma once
#include <string>
#include <map>

class CCategoryHandler;

extern CCategoryHandler* categoryHandler;

class CCategoryHandler
{
public:
	~CCategoryHandler(void);

	std::map<std::string,unsigned int> categories;

	unsigned int GetCategory(std::string name);
	unsigned int GetCategories(std::string names);

	int firstUnused;

	static CCategoryHandler* Instance(){
		if(instance==0){
			instance=new CCategoryHandler();
			categoryHandler=instance;
		}
		return instance;
	}
	static void RemoveInstance(){
		delete instance;
		instance=0;
	}
protected:
	CCategoryHandler(void);
	static CCategoryHandler* instance;
};
