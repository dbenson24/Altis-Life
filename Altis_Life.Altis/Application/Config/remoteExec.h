/*
	class Functions:
		List of whitelisted functions that is allowed to be executed by BIS_fnc_MP, SYS_fnc_MP, remoteExec, or remoteExecCall
	class Commands:
		List of whitelisted scripting commands that is allowed to be executed by BIS_fnc_MP, SYS_fnc_MP, remoteExec, or remoteExecCall
	mode:
		0: remoteExec turned off
		1: remoteExec turned on with whitelisting
		2: remoteExec turned on ignoring whitelisting
	allowedTargets:
		0: Everyone (including server)
		1: Only server can execute
		2: Only Server
	jip:
		1 = True
		0 = False

*/

class Functions
{
	mode = 1;
	jip = 0;
	class APP_fnc_playerSessionStart {allowedTargets=2;};
};
class Commands
{
	mode = 1;
	jip = 0;
	class addWeapon{allowedTargets=0;};
	class addMagazine{allowedTargets=0;};
	class addPrimaryWeaponItem{allowedTargets=0;};
	class addHandgunItem{allowedTargets=0;};
};