/*
	class Functions:
		 List of whitelisted functions that is allowed to be executed by BIS_fnc_MP, SYS_fnc_MP, remoteExec, or remoteExecCall
	class Commands:
		List of whitelisted scripting commands that is allowed to be executed by BIS_fnc_MP, SYS_fnc_MP, remoteExec, or remoteExecCall
	mode:
		0: remoteExec turned off
		1: remoteExec turned on with whitelisting
		2: remoteExec turned on ignoring whitelisting
*/

/* Functions/Commands the server can execute */
class Server
{
	mode = 2;
	class Functions
	{
		class APP_fnc_playerSessionStart {};
		class SYS_fnc_MP {};
		class SYS_fnc_MPexec {};
		class APP_fnc_requestReceived {};
	};
	class Commands
	{
		/* Eventually */
	};
};

/* Functions/Commands the client can execute */
class Client
{
	mode = 2;
	class Functions
	{
		jip = true;
		class APP_fnc_playerSessionStart {allowedTargets=2; jip = false;};
	};
	class Commands
	{
		/* Is there a point into allow commands to be executed over the client? */
	};
};