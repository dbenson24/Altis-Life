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
		class hudSystem{};
	};
	class Sessions
	{
		file = "Application\Sessions";
		class dataQuery{};
		class requestReceived{};
	};
	class Third_Party
	{
		file = "Application\Third_Party";
	};
	class Dialog_Functions
	{
		file = "Application\Dialog\Function";
		class setMapPosition{};
		class spawnConfirm{};
		class spawnMenu{};
		class spawnPointCfg{};
		class spawnPointSelected{};
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
		class broadcast{};
		class corpse{};
		class jumpFnc{};
		class say3D{};
		class setFuel{};
		class setTexture{};
		class soundDevice{};
	};
	class Helpers
	{
		file = "System\Helpers";
	};
	class Libraries
	{
		file = "System\Libraries";
		class escInterrupt{};
		class setupEVH{};
	};
};