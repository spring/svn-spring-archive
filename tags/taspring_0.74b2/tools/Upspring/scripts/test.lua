-- Test script that will show up in Scripts menu

local function Exec()
	upsMsgBox "Empty script..."
end

function TestScriptHandler(goal)
	if goal == SCRIPT_EXEC then
		Exec()
	elseif goal == SCRIPT_GETNAME then
		return "Empty test script"
	end
end

-- Register the script to upspring
upsAddScript "TestScriptHandler"

