PROJECT(UnitTester)
SET(CMAKE_CXX_FLAGS "-g -O1 -Wall")
INCLUDE_DIRECTORIES(../ /usr/include/SDL)
ADD_DEFINITIONS(-DDEBUG)

AUX_SOURCE_DIRECTORY(../ netfiles)
ADD_EXECUTABLE(UnitTest main ${netfiles})
TARGET_LINK_LIBRARIES(UnitTest SDL boost_thread)
