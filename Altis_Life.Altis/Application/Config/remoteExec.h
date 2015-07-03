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
		1: Only Clients
		2: Only Server
	jip:
		1 = True
		0 = False

*/

/* Functions/Commands the client can execute */
mode = 1;
class Functions
{
	jip = 0;
	class APP_fnc_playerSessionStart {allowedTargets=2;};
};
class Commands
{
	/* Is there a point into allow commands to be executed over the client? */
};