CXX = g++
CXXFLAGS = -g -Wall

OBJS = BattleRoomManager.o ChatRoom.o ChatroomManager.o CrashDumpHandler.o Dbase.o Log.o \
       Net.o ServerSettings.o SunParser.o User.o float3.o main.o netfuncs.o

all: depend server

server: $(OBJS)
	$(CXX) -o $@ -lmysqlclient -lpthread $^

depend: .depend

.depend:
	$(CXX) $(CXXFLAGS) -M *.cpp > $@

clean:
	rm -fv *.o .depend server

include .depend
