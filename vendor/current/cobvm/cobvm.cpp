// cobvm.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "CobFile.h"
#include "CobInstance.h"
#include "CobEngine.h"
#include "FileHandler.h"

#include <windows.h>
//#include "InfoConsole.h"

int _tmain(int argc, _TCHAR* argv[])
{
	int i;
	info = new CInfoConsole();

	CFileHandler in("scripts/flatbridge.cob");
	CCobFile f(in, "jao");

	CCobInstance unit(f, NULL);
	vector<long> params;
	params.push_back(0);
	//params.push_back(40);
	//i = unit.Call("Create", params);
	//i = unit.Call("Activate", params);
	i = unit.Call("Transbordement", params);
	if (i == 0) {
		printf("Script terminated\n");
		for (i = 0; i < params.size(); ++i) {
			printf("Variable %i: %i\n", i, params[i]);
		}
	}
	
	LARGE_INTEGER starttime;
	QueryPerformanceCounter(&starttime);

	for (i = 0; i < 10; ++i) {
		GCobEngine.Tick(1500);
		//printf("tick\n");
	}
	//unit.Tick(10);

	LARGE_INTEGER stop;
	QueryPerformanceCounter(&stop);

	printf("time: %ld\n", stop.QuadPart - starttime.QuadPart);

	int x=0;
	scanf("%i", &x);
	return 0;
}

