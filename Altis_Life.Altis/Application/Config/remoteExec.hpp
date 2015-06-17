class Server
{
    // 0-turned off, 1-turned on, taking whitelist into account, 2-turned on, however, ignoring whitelists (default because of backward compatibility)
    mode = 1;
    // List of script functions enabled to be executed on server
    class Functions
    {
        class bis_fnc_Something {};
        class YourFunction1 {};
    };
    // List of script commands enabled to be executed on server
    class Commands
    {
        class hint {};
        class setFuel {};
    };
};
class Client
{
    mode = 2;
    class Functions { /*your functions here*/ };
    class Commands { /*your commands here*/ };
};