/*
    class Functions:
        List of whitelisted functions that is allowed to be executed by BIS_fnc_MP, APP_fnc_MP, remoteExec, or remoteExecCall
    class Commands:
        List of whitelisted scripting commands that is allowed to be executed by BIS_fnc_MP, APP_fnc_MP, remoteExec, or remoteExecCall
    mode:
        0: remoteExec check turned off
        1: remoteExec turned on with whitelisting
        2: remoteExec turned on ignoring whitelisting
*/

class Server
{
    // 0-turned off, 1-turned on, taking whitelist into account, 2-turned on, however, ignoring whitelists (default because of backward compatibility)
    mode = 1;
    class Functions
    {
        class APP_fnc_playerSessionStart {};
    };
    class Commands
    {
        // No point in enabling commands for the server
    };
};
class Client
{
    mode = 1;
    class Functions
    {
        // Will populate this list when the time comes
    };
    class Commands
    {
        // Is there a point into allow commands to be executed over the client?
    };
};