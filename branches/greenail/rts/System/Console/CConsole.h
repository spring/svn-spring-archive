//////////////////////////////////////////////////////////////////////////
// Copyright (c) 2004 Facundo M. Carreiro
// fcarreiro <at> fibertel <dot> com <dot> ar
// v0rtex <at> fibertel <dot> com <dot> ar
// v0rtex__ <at> hotmail <dot> com
//////////////////////////////////////////////////////////////////////////


#include <string>
#include <vector>
#include <list>
//////////////////////////////////////////////////////////////////////////
// Console item type constants
//////////////////////////////////////////////////////////////////////////

enum console_item_type_t
{
	CTYPE_UCHAR,
	CTYPE_CHAR,
	CTYPE_CHARP,
	CTYPE_UINT,
	CTYPE_INT,
	CTYPE_FLOAT,
	CTYPE_STRING,
	CTYPE_FUNCTION,
	CTYPE_BOOL
};

//////////////////////////////////////////////////////////////////////////
// Console function pointer
//////////////////////////////////////////////////////////////////////////

typedef void (*console_function)(const std::vector<std::string> &);

//////////////////////////////////////////////////////////////////////////
// Item structure
//////////////////////////////////////////////////////////////////////////

typedef struct {
	// item name
	std::string name;

	// item type
	console_item_type_t type;
	
	// function callback or pointer to the value
	union 
	{
		console_function function;
		void *var;
	};
} console_item_t;

//////////////////////////////////////////////////////////////////////////
// console class
//////////////////////////////////////////////////////////////////////////

class CConsole
{
public:
	// constructor & destructor
	CConsole();
	virtual ~CConsole();

	// adds an item to the console
	void addItem(const std::string & strName,
		void *pointer, console_item_type_t type);

	// deletes an item from the console
	void deleteItem(const std::string & strName);

	// prints text on the console
	void print(const std::string & strText);

	// sets commandline buffer size
	void setCommandBufferSize(int size);

	// clears the console's commandline text buffer
	void clearCommandBuffer() { m_commandBuffer.clear(); }

	// sets text buffer size
	void setTextBufferSize(int size);

	// clears the console's text buffer
	void clearTextBuffer() { m_textBuffer.clear(); }

	// changes the commandline text to a previous one
	void historyGo(int where);

	// sets the command that is to be executed when no commandline match is found
	void setDefaultCommand(console_function def) { defaultCommand = def; }

	// text key hit
	void passKey(char key);

	// clears one character
	void passBackspace();

	// executes
	void passIntro();

	std::string parseCommandLine(std::string in);
	
private:
	// define item database type
	typedef std::list<console_item_t> ITEM_DB;

	// holds the command line
	std::string m_commandLine;

	// command to be executed by default
	console_function defaultCommand;

	// holds the list of items
	ITEM_DB m_itemList;

	// actual line index (in history)
	int m_lineIndex;

	// buffers size
	int m_commandBufferSize;
	int m_textBufferSize;

protected:
	// holds the text buffer
	std::list<std::string> m_textBuffer;

	// holds the buffer for previously entered commands
	std::vector<std::string> m_commandBuffer;
};

//////////////////////////////////////////////////////////////////////////
// End
//////////////////////////////////////////////////////////////////////////


