class Application
{
    tag = "APP";
    class Config
    {
	   file = "Application\Config";
    };
    class Libraries
    {
	   file = "Application\Libraries";
    };
    class Sessions
    {
	   file = "Application\Sessions";
    };
    class Third_Party
    {
	   file = "Application\Third_Party"
    };
};

class System
{
    tag = "SYS";
    class Core
    {
	   file = "System\Core";
	   class MP{};
	   class MPexec{};
    };
};