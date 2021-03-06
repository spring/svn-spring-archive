### Skirmish AIs
add_definitions(-DBUILDING_AI)

set(SKIRMISH_SRC "${CMAKE_SOURCE_DIR}/AI/Skirmish")
set(SKIRMISH_DATA "${DATADIR}/AI/Skirmish")

#set(SKIRMISHAI_FIND_QUIETLY True)

## KAI
set(KAI_SRC "${SKIRMISH_SRC}/KAI")
if (EXISTS ${KAI_SRC})
	set(KAI_VERS "UNKNOWN_VERSION")
	if (EXISTS ${KAI_SRC}/VERSION)
		file(STRINGS "${KAI_SRC}/VERSION" KAI_VERS LIMIT_COUNT 1)
	endif (EXISTS ${KAI_SRC}/VERSION)
	#set(KAI_TARGET "KAI-${KAI_VERS}")
	set(KAI_TARGET "KAI")
	set(KAI_DATA_DIR ${SKIRMISH_DATA}/KAI/${KAI_VERS})
	if (NOT SKIRMISHAI_FIND_QUIETLY)
		message(STATUS "Found Skirmish AI: KAI ${KAI_VERS}")
	endif (NOT SKIRMISHAI_FIND_QUIETLY)

	# install data files
	#install(DIRECTORY "${KAI_SRC}/data/"
	#		DESTINATION "${KAI_DATA_DIR}" PATTERN ".svn" EXCLUDE)

	aux_source_directory(${KAI_SRC} kai)
	#add_library(${KAI_TARGET} MODULE ${kai} ${legacycppaienv} ${creg})
	#set_target_properties(${KAI_TARGET} PROPERTIES COMPILE_FLAGS "-DUSING_CREG")
	#install (TARGETS ${KAI_TARGET} DESTINATION ${KAI_DATA_DIR})
endif (EXISTS ${KAI_SRC})


## KAIK
set(KAIK_SRC "${SKIRMISH_SRC}/KAIK")
if (EXISTS ${KAIK_SRC})
	set(KAIK_VERS "UNKNOWN_VERSION")
	if (EXISTS ${KAIK_SRC}/VERSION)
		file(STRINGS "${KAIK_SRC}/VERSION" KAIK_VERS LIMIT_COUNT 1)
	endif (EXISTS ${KAIK_SRC}/VERSION)
	#set(KAIK_TARGET "KAIK-${KAIK_VERS}")
	set(KAIK_TARGET "KAIK")
	set(KAIK_DATA_DIR ${SKIRMISH_DATA}/KAIK/${KAIK_VERS})
	if (NOT SKIRMISHAI_FIND_QUIETLY)
		message(STATUS "Found Skirmish AI: KAIK ${KAIK_VERS}")
	endif (NOT SKIRMISHAI_FIND_QUIETLY)

	# install data files
	install(DIRECTORY "${KAIK_SRC}/data/"
			DESTINATION "${KAIK_DATA_DIR}" PATTERN ".svn" EXCLUDE)

	aux_source_directory(${KAIK_SRC} kaik)
	add_library(${KAIK_TARGET} MODULE ${kaik} ${legacycppaienv} ${creg})
	set_target_properties(${KAIK_TARGET} PROPERTIES COMPILE_FLAGS "-DUSING_CREG")
	install (TARGETS ${KAIK_TARGET} DESTINATION ${KAIK_DATA_DIR})
endif (EXISTS ${KAIK_SRC})


## RAI
set(RAI_SRC "${SKIRMISH_SRC}/RAI")
if (EXISTS ${RAI_SRC})
	set(RAI_VERS "UNKNOWN_VERSION")
	if (EXISTS ${RAI_SRC}/VERSION)
		file(STRINGS "${RAI_SRC}/VERSION" RAI_VERS LIMIT_COUNT 1)
	endif (EXISTS ${RAI_SRC}/VERSION)
	#set(RAI_TARGET "RAI-${RAI_VERS}")
	set(RAI_TARGET "RAI")
	set(RAI_DATA_DIR ${SKIRMISH_DATA}/RAI/${RAI_VERS})
	if (NOT SKIRMISHAI_FIND_QUIETLY)
		message(STATUS "Found Skirmish AI: RAI ${RAI_VERS}")
	endif (NOT SKIRMISHAI_FIND_QUIETLY)

	# install data files
	install(DIRECTORY "${RAI_SRC}/data/"
			DESTINATION "${RAI_DATA_DIR}" PATTERN ".svn" EXCLUDE)

	aux_source_directory(${RAI_SRC} rai)
	add_library(${RAI_TARGET} MODULE ${rai} ${legacycppaienv})
	install (TARGETS ${RAI_TARGET} DESTINATION ${RAI_DATA_DIR})
endif (EXISTS ${RAI_SRC})


## AAI
set(AAI_SRC "${SKIRMISH_SRC}/AAI")
if (EXISTS ${AAI_SRC})
	set(AAI_VERS "UNKNOWN_VERSION")
	if (EXISTS ${AAI_SRC}/VERSION)
		file(STRINGS "${AAI_SRC}/VERSION" AAI_VERS LIMIT_COUNT 1)
	endif (EXISTS ${AAI_SRC}/VERSION)
	#set(AAI_TARGET "AAI-${AAI_VERS}")
	set(AAI_TARGET "AAI")
	set(AAI_DATA_DIR ${SKIRMISH_DATA}/AAI/${AAI_VERS})
	if (NOT SKIRMISHAI_FIND_QUIETLY)
		message(STATUS "Found Skirmish AI: AAI ${AAI_VERS}")
	endif (NOT SKIRMISHAI_FIND_QUIETLY)

	# install data files
	install(DIRECTORY "${AAI_SRC}/data/"
			DESTINATION "${AAI_DATA_DIR}" PATTERN ".svn" EXCLUDE)

	aux_source_directory(${AAI_SRC} aai)
	add_library(${AAI_TARGET} MODULE ${aai} ${legacycppaienv})
	install (TARGETS ${AAI_TARGET} DESTINATION ${AAI_DATA_DIR})
endif (EXISTS ${AAI_SRC})


## NTai
set(NTai_SRC "${SKIRMISH_SRC}/NTai")
if (EXISTS ${NTai_SRC})
	set(NTai_VERS "UNKNOWN_VERSION")
	if (EXISTS ${NTai_SRC}/VERSION)
		file(STRINGS "${NTai_SRC}/VERSION" NTai_VERS LIMIT_COUNT 1)
	endif (EXISTS ${NTai_SRC}/VERSION)
	#set(NTai_TARGET "NTai-${NTai_VERS}")
	set(NTai_TARGET "NTai")
	set(NTai_DATA_DIR ${SKIRMISH_DATA}/NTai/${NTai_VERS})
	if (NOT SKIRMISHAI_FIND_QUIETLY)
		message(STATUS "Found Skirmish AI: NTai ${NTai_VERS}")
	endif (NOT SKIRMISHAI_FIND_QUIETLY)

	# install data files
	install(DIRECTORY "${NTai_SRC}/data/"
			DESTINATION "${NTai_DATA_DIR}" PATTERN ".svn" EXCLUDE)

	aux_source_directory(${NTai_SRC} ntai)
	aux_source_directory(${NTai_SRC}/AI/NTai/Units ntai)
	aux_source_directory(${NTai_SRC}/AI/NTai/Units/Behaviours ntai)
	aux_source_directory(${NTai_SRC}/AI/NTai/Tasks ntai)
	aux_source_directory(${NTai_SRC}/AI/NTai/Helpers ntai)
	aux_source_directory(${NTai_SRC}/AI/NTai/Helpers/grid ntai)
	aux_source_directory(${NTai_SRC}/AI/NTai/Helpers/Terrain ntai)
	aux_source_directory(${NTai_SRC}/AI/NTai/Helpers/Units ntai)
	aux_source_directory(${NTai_SRC}/AI/NTai/Engine ntai)
	aux_source_directory(${NTai_SRC}/AI/NTai/Core ntai)
	aux_source_directory(${NTai_SRC}/AI/NTai/Agents ntai)
	add_library(${NTai_TARGET} MODULE ${ntai} ${legacycppaienv})
	target_link_libraries(${NTai_TARGET} boost_thread-mt)
	install (TARGETS ${NTai_TARGET} DESTINATION ${NTai_DATA_DIR})
endif (EXISTS ${NTai_SRC})


## Null Legacy C++ AI
set(NullLegacyCppAI_SRC "${SKIRMISH_SRC}/NullLegacyCppAI")
if (EXISTS ${NullLegacyCppAI_SRC})
	set(NullLegacyCppAI_VERS "UNKNOWN_VERSION")
	if (EXISTS ${NullLegacyCppAI_SRC}/VERSION)
		file(STRINGS "${NullLegacyCppAI_SRC}/VERSION" NullLegacyCppAI_VERS LIMIT_COUNT 1)
	endif (EXISTS ${NullLegacyCppAI_SRC}/VERSION)
	#set(NullLegacyCppAI_TARGET "NullLegacyCppAI-${NullLegacyCppAI_VERS}")
	set(NullLegacyCppAI_TARGET "NullLegacyCppAI")
	set(NullLegacyCppAI_DATA_DIR ${SKIRMISH_DATA}/NullLegacyCppAI/${NullLegacyCppAI_VERS})
	if (NOT SKIRMISHAI_FIND_QUIETLY)
		message(STATUS "Found Skirmish AI: NullLegacyCppAI ${NullLegacyCppAI_VERS}")
	endif (NOT SKIRMISHAI_FIND_QUIETLY)

	# install data files
	install(DIRECTORY "${NullLegacyCppAI_SRC}/data/"
			DESTINATION "${NullLegacyCppAI_DATA_DIR}" PATTERN ".svn" EXCLUDE)

	aux_source_directory(${NullLegacyCppAI_SRC} nulllegacycppai)
	add_library(${NullLegacyCppAI_TARGET} MODULE ${nulllegacycppai} ${legacycppaienv})
	install (TARGETS ${NullLegacyCppAI_TARGET} DESTINATION ${NullLegacyCppAI_DATA_DIR})
endif (EXISTS ${NullLegacyCppAI_SRC})


## Null C AI
set(NullAI_SRC "${SKIRMISH_SRC}/NullAI")
if (EXISTS ${NullAI_SRC})
	set(NullAI_VERS "UNKNOWN_VERSION")
	if (EXISTS ${NullAI_SRC}/VERSION)
		file(STRINGS "${NullAI_SRC}/VERSION" NullAI_VERS LIMIT_COUNT 1)
	endif (EXISTS ${NullAI_SRC}/VERSION)
	#set(NullAI_TARGET "NullAI-${NullAI_VERS}")
	set(NullAI_TARGET "NullAI")
	set(NullAI_DATA_DIR ${SKIRMISH_DATA}/NullAI/${NullAI_VERS})
	if (NOT SKIRMISHAI_FIND_QUIETLY)
		message(STATUS "Found Skirmish AI: NullAI ${NullAI_VERS}")
	endif (NOT SKIRMISHAI_FIND_QUIETLY)

	# install data files
	install(DIRECTORY "${NullAI_SRC}/data/"
			DESTINATION "${NullAI_DATA_DIR}" PATTERN ".svn" EXCLUDE)

	aux_source_directory(${NullAI_SRC} nullai)
	add_library(${NullAI_TARGET} MODULE ${mySrc} ${nullai})
	install (TARGETS ${NullAI_TARGET} DESTINATION ${NullAI_DATA_DIR})
endif (EXISTS ${NullAI_SRC})


## Null Java AI
if (NOT JAVA_FOUND)
	set(JAVA_FIND_QUIETLY ${SKIRMISHAI_FIND_QUIETLY})
	FIND_PACKAGE(JAVA) # Note: this is not the CMake builtin FindJava
endif (NOT JAVA_FOUND)
set(NullJavaAI_SRC "${SKIRMISH_SRC}/NullJavaAI")
if (JAVA_FOUND AND EXISTS ${NullJavaAI_SRC})
	set(NullJavaAI_VERS "UNKNOWN_VERSION")
	if (EXISTS ${NullJavaAI_SRC}/VERSION)
		file(STRINGS "${NullJavaAI_SRC}/VERSION" NullJavaAI_VERS LIMIT_COUNT 1)
	endif (EXISTS ${NullJavaAI_SRC}/VERSION)
	#set(NullJavaAI_TARGET "NullJavaAI-${NullJavaAI_VERS}")
	set(NullJavaAI_TARGET "NullJavaAI")
	set(NullJavaAI_DATA_DIR ${SKIRMISH_DATA}/NullJavaAI/${NullJavaAI_VERS})
	set(NullJavaAI_PKG "nulljavaai")
	set(NullJavaAI_PKG_FIRST_PART "nulljavaai")
	set(Java_AIINTERFACE_SRC "../../Interfaces/Java")
	set(NullJavaAI_CLASSPATH ".${PATH_DELIM}${Java_AIINTERFACE_SRC}/interface.jar${PATH_DELIM}${Java_AIINTERFACE_SRC}/data/jlib/jna/jna.jar${PATH_DELIM}${Java_AIINTERFACE_SRC}/data/jlib/vecmath.jar")
	if (NOT SKIRMISHAI_FIND_QUIETLY)
		message(STATUS "Found Skirmish AI: NullJavaAI ${NullJavaAI_VERS}")
	endif (NOT SKIRMISHAI_FIND_QUIETLY)

	# install data files
	install(DIRECTORY "${NullJavaAI_SRC}/data/"
			DESTINATION "${NullJavaAI_DATA_DIR}" PATTERN ".svn" EXCLUDE)

	file(REMOVE_RECURSE "${NullJavaAI_SRC}/build")
	file(MAKE_DIRECTORY "${NullJavaAI_SRC}/build")
	file(GLOB_RECURSE NullJavaAI_JAVA_SOURCES RELATIVE "${NullJavaAI_SRC}" FOLLOW_SYMLINKS "${NullJavaAI_SRC}/*.java")
	#add_custom_command(OUTPUT "${NullJavaAI_DATA_DIR}/ai.jar"
	#add_custom_command(TARGET ${NullJavaAI_TARGET}
	add_custom_target(${NullJavaAI_TARGET} ALL
		COMMAND "${JAVA_COMPILE}" "-cp" "\"${NullJavaAI_CLASSPATH}\"" "-d" "${NullJavaAI_SRC}/build" ${NullJavaAI_JAVA_SOURCES}
		COMMAND "${JAVA_ARCHIVE}" "cmf" "${NullJavaAI_SRC}/manifest.mf" "${NullJavaAI_SRC}/ai.jar" "-C" "${NullJavaAI_SRC}/build" "${NullJavaAI_PKG_FIRST_PART}"
		WORKING_DIRECTORY "${NullJavaAI_SRC}"
		COMMENT "  Creating Java AI library ai.jar" VERBATIM)
	add_custom_target(${NullJavaAI_TARGET}-SRC ALL
		COMMAND "${JAVA_ARCHIVE}" "cf" "${NullJavaAI_SRC}/ai-src.jar" "-C" "${NullJavaAI_SRC}" "${NullJavaAI_PKG_FIRST_PART}"
		WORKING_DIRECTORY "${NullJavaAI_SRC}"
		COMMENT "  Creating Java AI library ai-src.jar" VERBATIM)

	install (FILES ${NullJavaAI_SRC}/ai.jar DESTINATION ${NullJavaAI_DATA_DIR})
	install (FILES ${NullJavaAI_SRC}/ai-src.jar DESTINATION ${NullJavaAI_DATA_DIR}/jlib)
endif (JAVA_FOUND AND EXISTS ${NullJavaAI_SRC})


## Null Object Oriented Java AI
if (NOT JAVA_FOUND)
	set(JAVA_FIND_QUIETLY ${SKIRMISHAI_FIND_QUIETLY})
	FIND_PACKAGE(JAVA) # Note: this is not the CMake builtin FindJava
endif (NOT JAVA_FOUND)
set(NullOOJavaAI_SRC "${SKIRMISH_SRC}/NullOOJavaAI")
if (JAVA_FOUND AND EXISTS ${NullOOJavaAI_SRC})
	set(NullOOJavaAI_VERS "UNKNOWN_VERSION")
	if (EXISTS ${NullOOJavaAI_SRC}/VERSION)
		file(STRINGS "${NullOOJavaAI_SRC}/VERSION" NullOOJavaAI_VERS LIMIT_COUNT 1)
	endif (EXISTS ${NullOOJavaAI_SRC}/VERSION)
	#set(NullOOJavaAI_TARGET "NullOOJavaAI-${NullOOJavaAI_VERS}")
	set(NullOOJavaAI_TARGET "NullOOJavaAI")
	set(NullOOJavaAI_DATA_DIR ${SKIRMISH_DATA}/NullOOJavaAI/${NullOOJavaAI_VERS})
	set(NullOOJavaAI_PKG "nulloojavaai")
	set(NullOOJavaAI_PKG_FIRST_PART "nulloojavaai")
	set(Java_AIINTERFACE_SRC "../../Interfaces/Java")
	set(NullOOJavaAI_CLASSPATH ".${PATH_DELIM}${Java_AIINTERFACE_SRC}/interface.jar${PATH_DELIM}${Java_AIINTERFACE_SRC}/data/jlib/jna/jna.jar${PATH_DELIM}${Java_AIINTERFACE_SRC}/data/jlib/vecmath.jar")
	if (NOT SKIRMISHAI_FIND_QUIETLY)
		message(STATUS "Found Skirmish AI: NullOOJavaAI ${NullOOJavaAI_VERS}")
	endif (NOT SKIRMISHAI_FIND_QUIETLY)

	# install data files
	install(DIRECTORY "${NullOOJavaAI_SRC}/data/"
			DESTINATION "${NullOOJavaAI_DATA_DIR}" PATTERN ".svn" EXCLUDE)

	file(REMOVE_RECURSE "${NullOOJavaAI_SRC}/build")
	file(MAKE_DIRECTORY "${NullOOJavaAI_SRC}/build")
	file(GLOB_RECURSE NullOOJavaAI_JAVA_SOURCES RELATIVE "${NullOOJavaAI_SRC}" FOLLOW_SYMLINKS "${NullOOJavaAI_SRC}/*.java")
	add_custom_target(${NullOOJavaAI_TARGET} ALL
		COMMAND "${JAVA_COMPILE}" "-cp" "\"${NullOOJavaAI_CLASSPATH}\"" "-d" "${NullOOJavaAI_SRC}/build" ${NullOOJavaAI_JAVA_SOURCES}
		COMMAND "${JAVA_ARCHIVE}" "cmf" "${NullOOJavaAI_SRC}/manifest.mf" "${NullOOJavaAI_SRC}/ai.jar" "-C" "${NullOOJavaAI_SRC}/build" "${NullOOJavaAI_PKG_FIRST_PART}"
		WORKING_DIRECTORY "${NullOOJavaAI_SRC}"
		COMMENT "  Creating Java OO AI library ai.jar" VERBATIM)
	add_custom_target(${NullOOJavaAI_TARGET}-SRC ALL
		COMMAND "${JAVA_ARCHIVE}" "cf" "${NullOOJavaAI_SRC}/ai-src.jar" "-C" "${NullOOJavaAI_SRC}" "${NullOOJavaAI_PKG_FIRST_PART}"
		WORKING_DIRECTORY "${NullOOJavaAI_SRC}"
		COMMENT "  Creating Java OO AI library ai-src.jar" VERBATIM)

	install (FILES ${NullOOJavaAI_SRC}/ai.jar DESTINATION ${NullOOJavaAI_DATA_DIR})
	install (FILES ${NullOOJavaAI_SRC}/ai-src.jar DESTINATION ${NullOOJavaAI_DATA_DIR}/jlib)
endif (JAVA_FOUND AND EXISTS ${NullOOJavaAI_SRC})


## JCAI
# does currently not build in win32
if (UNIX)
	set(JCAI_SRC "${SKIRMISH_SRC}/JCAI")
	if (EXISTS ${JCAI_SRC})
		set(JCAI_VERS "UNKNOWN_VERSION")
		if (EXISTS ${JCAI_SRC}/VERSION)
			file(STRINGS "${JCAI_SRC}/VERSION" JCAI_VERS LIMIT_COUNT 1)
		endif (EXISTS ${JCAI_SRC}/VERSION)
		#set(JCAI_TARGET "JCAI-${JCAI_VERS}")
		set(JCAI_TARGET "JCAI")
		set(JCAI_DATA_DIR ${SKIRMISH_DATA}/JCAI/${JCAI_VERS})
		if (NOT SKIRMISHAI_FIND_QUIETLY)
			message(STATUS "Found Skirmish AI: JCAI ${JCAI_VERS}")
		endif (NOT SKIRMISHAI_FIND_QUIETLY)

		# install data files
		#install(DIRECTORY "${JCAI_SRC}/data/"
		#		DESTINATION "${JCAI_DATA_DIR}" PATTERN ".svn" EXCLUDE)

		aux_source_directory(${JCAI_SRC} jcai)
		#add_library(${JCAI_TARGET} MODULE ${jcai} ${legacycppaienv})
		#install (TARGETS ${JCAI_TARGET} DESTINATION ${JCAI_DATA_DIR})
	endif (EXISTS ${JCAI_SRC})
endif (UNIX)

