class DefaultEventhandlers;
class CfgPatches
{
	class life_server
	{
		units[] = {"C_man_1"};
		weapons[] = {};
		requiredAddons[] = {"A3_Data_F","A3_Soft_F","A3_Soft_F_Offroad_01","A3_Characters_F"};
		fileName = "life_server.pbo";
		author[]= {"Tonic", "Itsyuka"};
	};
};

class CfgFunctions
{
	class BIS_Overwrite
	{
		tag = "BIS";
		class MP
		{
			file = "\life_server\System\Core\MP";
			class initMultiplayer{};
			class call{};
			class spawn{};
			class execFSM{};
			class execVM{};
			class execRemote{};
			class addScore{};
			class setRespawnDelay{};
			class onPlayerConnected{};
			class initPlayable{};
			class missionTimeLeft{};
		};
	};

	class Application
	{
		tag = "APP";
		class Core
		{
			file = "\life_server\Application\Core";
		};
		class Libraries
		{
			file = "\life_server\Application\Libraries";
		};
		class Models
		{
			file = "\life_server\Application\Models";
		};
		class Sessions
		{
			file = "\life_server\Application\Sessions";
		};
		class Third_Party
		{
			file = "\life_server\Application\Third_Party"
		};
	};

	class System
	{
		tag = "SYS";
		class Core
		{
			file = "\life_server\System\Core";
		};
		class Database
		{
			file = "\life_server\System\Database";
			class queryRequest{};
			class asyncCall{};
			class insertRequest{};
			class updateRequest{};
			class insertVehicle {};
			class updatePartial {};
		};
		class Helpers
		{
			file = "\life_server\System\Helpers";
			class numberSafe {};
			class mresArray {};
			class mresString {};
			class mresToArray {};
			class bool{};
		};
	};
};