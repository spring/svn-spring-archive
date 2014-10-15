//////////////////////////////////////////////////////////////////////////
// Copyright (c) 2004 Facundo M. Carreiro
// fcarreiro <at> fibertel <dot> com <dot> ar
// v0rtex <at> fibertel <dot> com <dot> ar
// v0rtex__ <at> hotmail <dot> com
//////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////
// console default construtor & destructor
//////////////////////////////////////////////////////////////////////////
#include "StdAfx.h"
#include "CConsole.h"
#include <string>
#include <sstream>
#include <list>

//using CConsole::CConsole;

CConsole::CConsole(): m_lineIndex(0),
		defaultCommand(NULL), m_commandBufferSize(20),
		m_textBufferSize(50)

//CConsole::CConsole()
{
	// initialize variables to default
	
}

CConsole::~CConsole()
{
	// all the containers are automatically cleared
}

//////////////////////////////////////////////////////////////////////////
// print() : Prints text in the console (adds to the list)
//////////////////////////////////////////////////////////////////////////

void CConsole::print(const std::string & strTxt)
{
}

//////////////////////////////////////////////////////////////////////////
// parseCommandLine() : Executes commandline
//////////////////////////////////////////////////////////////////////////

std::string CConsole::parseCommandLine(std::string in)
{
	std::string result = "";
	std::string::size_type index = 0;
	std::vector<std::string> arguments;
	std::ostringstream out; // more info here
	std::list<console_item_t>::const_iterator iter;

	//m_commandBuffer.push_back(in);
	//result = result + "\tcommand: " + in+"\n";
	std::stringstream os(in);
	std::string tempS;
	while(os >> tempS)
		{
		arguments.push_back(tempS);
		}

	// execute
	bool found = false;
	if (m_itemList.empty())
		{
		return "No commands found \n";
		}
	for(iter = m_itemList.begin(); iter != m_itemList.end(); ++iter)
		{
		if(iter->name == arguments[0])
			{
			switch(iter->type)
				{
			case CTYPE_UCHAR:
				if(arguments.size() > 2)
				{
					return result;
				}
				else if(arguments.size() == 1)
				{
					out.str("");
					out << (*iter).name << " = " << *((unsigned char *)(*iter).var);
					result = result + out.str();
					found = true;
					return result;
				}
				else if(arguments.size() == 2)
				{
					*((unsigned char *)(*iter).var) = (unsigned char) atoi(arguments[1].c_str());
					found = true;
					return result;
				}
				break;

			case CTYPE_CHAR:
				if(arguments.size() > 2)
				{
					return result;
				}
				else if(arguments.size() == 1)
				{
					out.str("");
					out << (*iter).name << " = " << *((char *)(*iter).var);
					result = result + out.str();
					found = true;
					return result;
				}
				else if(arguments.size() == 2)
				{
					*((char *)(*iter).var) = (char) atoi(arguments[1].c_str());
					found = true;
					return result;
				}
				break;

			case CTYPE_UINT:
				if(arguments.size() > 2)
				{
					return result;
				}
				else if(arguments.size() == 1)
				{
					out.str("");
					out << (*iter).name << " = " << *((unsigned int *)(*iter).var);
					result = result + out.str();
					found = true;
					return result;
				}
				if(arguments.size() == 2)
				{
					*((unsigned int *)(*iter).var) = (unsigned int) atoi(arguments[1].c_str());
					found = true;
					return result;
				}
				break;

			case CTYPE_INT:
				if(arguments.size() > 2)
				{
					return result;
				}
				else if(arguments.size() == 1)
				{
					out.str("");
					out << (*iter).name << " = " << *((int *)(*iter).var);
					result = result + out.str();
					found = true;
					return result;
				}
				if(arguments.size() == 2)
				{
					*((int *)(*iter).var) = (int) atoi(arguments[1].c_str());
					found = true;
					return result;
				}
				break;
			case CTYPE_BOOL:
				if(arguments.size() > 2)
				{
					return result;
				}
				else if(arguments.size() == 1)
				{
					out.str("");
					out << (*iter).name << " = " << *((int *)(*iter).var);
					result = result + out.str();
					found = true;
					return result;
				}
				if(arguments.size() == 2)
				{
					*((int *)(*iter).var) = (bool) atoi(arguments[1].c_str());
					found = true;
					return result;
				}
				break;
			case CTYPE_FLOAT:
				if(arguments.size() > 2)
				{
					return result;
				}
				else if(arguments.size() == 1)
				{
					out.str("");
					out << (*iter).name << " = " << *((float *)(*iter).var);
					result = result + out.str();
					found = true;
					return result;
				}
				if(arguments.size() == 2)
				{
					*((float *)(*iter).var) = (float)atof(arguments[1].c_str());
					found = true;
					return result;
				}
				break;

			case CTYPE_STRING:
				if(arguments.size() == 1)
				{
					out.str("");
					std::string deref = *(std::string *)((*iter).var);
					out << (*iter).name << " = " << deref;
					result = result + out.str();
					found = true;
					return result;
				}
				else if(arguments.size() > 1)
				{
					// reset variable
					//*((std::string *)(*iter).var) = "";
					*(std::string *)((*iter).var) = "";
					// add new string
					
					for(int i = 1; i < arguments.size(); ++i)
						{
						*((std::string *)(*iter).var) += arguments[i];
						}
					result = result + ": set to " + arguments[1];

					found = true;
					return result;
				}
				break;

			case CTYPE_FUNCTION:
				(*iter).function(arguments);
				found = true;
				return result;
				break;

			default:
				//m_defaultCommand(arguments);
				result = "\tCommand: " +in+" not found\n";
				return result;
				break;
			}
		}
		
	}
	if (!found)
			{
			result = "\tCommand: " +in+" not found\n";
			}
	// end
	
	return result;
}

//////////////////////////////////////////////////////////////////////////
// addItem() : Adds a variable or function to the console
//////////////////////////////////////////////////////////////////////////

void CConsole::addItem(const std::string & strName, void *pointer, console_item_type_t type)
{
	console_item_t it;

	// fill item properties
	it.name = strName;
	it.type = type;

	// address
	if(type != CTYPE_FUNCTION)
	{
		it.var = pointer;
	}
	else
	{
		it.function = (console_function) pointer;
	}

	// add item
	m_itemList.push_back(it);
}

//////////////////////////////////////////////////////////////////////////
// deleteItem() : Deletes a variable or function from the console
//////////////////////////////////////////////////////////////////////////

void CConsole::deleteItem(const std::string & strName)
{
}

//////////////////////////////////////////////////////////////////////////
// passKey() : Processes console keypress
//////////////////////////////////////////////////////////////////////////

void CConsole::passKey(char key)
{
}

//////////////////////////////////////////////////////////////////////////
// passBackspace() : Removes last character
//////////////////////////////////////////////////////////////////////////

void CConsole::passBackspace()
{
}

//////////////////////////////////////////////////////////////////////////
// passIntro() : Executes Commandline
//////////////////////////////////////////////////////////////////////////

void CConsole::passIntro()
{
}

//////////////////////////////////////////////////////////////////////////
// setTextBufferSize() : Sets and checks text buffer size
//////////////////////////////////////////////////////////////////////////

void CConsole::setTextBufferSize(int size)
{
}

//////////////////////////////////////////////////////////////////////////
// setCommandBufferSize() : Sets and checks line buffer size
//////////////////////////////////////////////////////////////////////////

void CConsole::setCommandBufferSize(int size)
{

}

//////////////////////////////////////////////////////////////////////////
// historyGo() : Changes actual commandline into some past command
//////////////////////////////////////////////////////////////////////////

void CConsole::historyGo(int intin)
{
}

//////////////////////////////////////////////////////////////////////////
// End
//////////////////////////////////////////////////////////////////////////
