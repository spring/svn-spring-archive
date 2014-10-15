#ifndef GLOBAL_H
#define GLOBAL_H

#include "../rts/archdef.h"

#include "Log.h"
#include "netfuncs.h"

#include "port.h"

#ifdef ARCHDEF_PLATFORM_WIN32
#include "pthread/include/pthread.h"
#else
#include <pthread.h>
#endif
#include <new>
#include <exception>
#include <stdexcept>

using namespace std;

#define DEBUG
#define MUTEX_DEBUG

#define					VERMAJOR				0
#define					VERMINOR				5

#define					MAXNAME					16
#define					MAXMAPNAME				32
#define					MAXPASSWD				16
#define					MAXCHATNAME				16
#define					MAXBATTLENAME			50
#define					MAXCLAN					3
#define					MAXATTEMPTS				3
#define					MAXMESSAGELEN			256
#define					MAXLOGSIZE				5000000

#define					LOGINERROR_VERSION		1
#define					LOGINERROR_USER			2
#define					LOGINERROR_PASSWORD		3

#define					PACK_LOGIN				1
#define					PACK_CHATMESSAGE		2
#define					PACK_REQJOINCHAT		3
#define					PACK_CHATLIST			4
#define					PACK_BOOTFROMCHAT		5
#define					PACK_KILLCHAT			6
#define					PACK_KICKEDFROMCHAT		7
#define					PACK_LOGGEDIN			8
#define					PACK_LOGINFAILED		9
#define					PACK_BLOCKED			10
#define					PACK_JOINCHAT			11
#define					PACK_LEAVECHAT			12
#define					PACK_USERENTERCHAT		13
#define					PACK_USERLEAVECHAT		14
#define					PACK_REGISTER			15
#define					PACK_JOINBATTLE			16
#define					PACK_LEAVEBATTLE		17
#define					PACK_USERENTERBATTLE	18
#define					PACK_USERLEAVEBATTLE	19
#define					PACK_REQJOINBATTLE		20
#define					PACK_BATTLEMESSAGE		21
#define					PACK_BATTLELIST			22
#define					PACK_BOOTFROMBATTLE		23
#define					PACK_CREATECHAT			24
#define					PACK_CREATEBATTLE		25
#define					PACK_KICKEDFROMBATTLE	26
#define					PACK_DESTROYBATTLE		27
#define					PACK_CHATCREATESUCCESS	28
#define					PACK_FAILEDCREATECHAT	29
#define					PACK_CHATDESTROYED		30
#define					PACK_BATTLECREATESUCCESS 31
#define					PACK_BATTLECREATEFAILED	32
#define					PACK_BATTLELOGGEDIN		33
#define					PACK_INTERNALBATTLELIST	34
#define					PACK_REGISTERSUCCESS    35
#define					PACK_REGISTERFAILED		36
#define					PACK_KEEPALIVE			37
#define					PACK_IPOVERRIDE			38
#define					PACK_CHATSIZEUPDATE		39
#define					PACK_BATTLESIZEUPDATE	41
#define					PACK_MAPUPDATE			42
#define					PACK_BATTLEPROGRESS		43
#define					PACK_BATTLETEST			44

#define					REGISTER_USEREXISTS		1
#define					REGISTER_BADUSERNAME	2
#define					REGISTER_FORMATMISMATCH	3
#define					REGISTER_BADPASSWORD	4
#define					REGISTER_GENERIC		5

#endif
