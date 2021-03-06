/*
	Copyright (c) 2008 Robin Vobruba <hoijui.quaero@gmail.com>
	
	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef _IGROUPAILIBRARY_H
#define	_IGROUPAILIBRARY_H

#include "Interface/ELevelOfSupport.h"
#include <string>
#include <vector>
#include <map>

struct SGAISpecifier;
struct InfoItem;
struct Option;
struct SAIInterfaceSpecifier;

class IGroupAILibrary {
public:
	virtual ~IGroupAILibrary() {}
	
	virtual SGAISpecifier GetSpecifier() const = 0;
	/**
	 * Level of Support for a specific engine version and AI interface.
	 * @return see enum LevelOfSupport (higher values could be used optionally)
	 */
	virtual LevelOfSupport GetLevelOfSupportFor(int teamId, int groupId,
			const std::string& engineVersionString, int engineVersionNumber,
			const SAIInterfaceSpecifier& interfaceSpecifier) const = 0;
	
//    virtual std::map<std::string, InfoItem> GetInfo() const = 0;
//	virtual std::vector<Option> GetOptions() const = 0;
	
	
    virtual void Init(int teamId, int groupId) const = 0;
    virtual void Release(int teamId, int groupId) const = 0;
    virtual int HandleEvent(int teamId, int groupId, int topic, const void* data) const = 0;
};

#endif	/* _IGROUPAILIBRARY_H */

