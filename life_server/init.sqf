#define SYSPATH(FILE) format["\life_server\System\%1",##FILE##]
#include "\life_server\script_macros.hpp"
/*
	Author: Bryan "Tonic" Boardwine

	Description:
	Initialize the server and required systems.
*/
"BIS_fnc_MP_packet" addPublicVariableEventHandler {_this call SYS_fnc_MPexec};
SYS_Async_Active = false;
SYS_Async_ExtraLock = false;
SYS_server_isReady = false;
SYS_server_extDB_notLoaded = "";
serv_sv_use = [];

if(isNil {GVAR_UINS "SYS_sql_id"}) then {
	SYS_sql_id = round(random(9999));
	CONSTVAR(SYS_sql_id);
	SVAR_UINS ["SYS_sql_id",SYS_sql_id];

	//Retrieve extDB version
	_result = EXTDB_TAG callExtension "9:VERSION";
	diag_log format ["extDB: Version: %1", _result];
	if(EQUAL(_result,"")) exitWith {EXTDB_FAILED("The server-side extension extDB was not loaded into the engine, report this to the server admin.")};
	if ((parseNumber _result) < 14) exitWith {EXTDB_FAILED("extDB version is not compatible with current Altis life version. Require version 14 or higher.")};

	//Initialize connection to Database
	_result = EXTDB_TAG callExtension "9:ADD_DATABASE:AltisLife";
	if(!(EQUAL(_result,"[1]"))) exitWith {EXTDB_FAILED("extDB: Error with Database Connection")};
	_result = EXTDB_TAG callExtension format["9:ADD_DATABASE_PROTOCOL:AltisLife:SQL_CUSTOM_V2:%1:altisliferpg",FETCH_CONST(SYS_sql_id)];
	if(!(EQUAL(_result,"[1]"))) exitWith {EXTDB_FAILED("extDB: Error with Database Connection")};
	/* Insert any additional code here for extDB features, the next line will lock extDB */
	EXTDB_TAG callExtension "9:LOCK";
	diag_log "extDB: Connected to Database";
} else {
	SYS_sql_id = GVAR_UINS "SYS_sql_id";
	CONSTVAR(SYS_sql_id);
	diag_log "extDB: Still Connected to Database";
};

{
	_hs = createVehicle ["Land_Hospital_main_F", [0,0,0], [], 0, "NONE"];
	_hs setDir (markerDir _x);
	_hs setPosATL (getMarkerPos _x);
	_var = createVehicle ["Land_Hospital_side1_F", [0,0,0], [], 0, "NONE"];
	_var attachTo [_hs, [4.69775,32.6045,-0.1125]];
	detach _var;
	_var = createVehicle ["Land_Hospital_side2_F", [0,0,0], [], 0, "NONE"];
	_var attachTo [_hs, [-28.0336,-10.0317,0.0889387]];
	detach _var;
} foreach ["hospital_2","hospital_3"];

{
	if(!isPlayer _x) then {
		_npc = _x;
		{
			if(_x != "") then {
				_npc removeWeapon _x;
			};
		} foreach [primaryWeapon _npc,secondaryWeapon _npc,handgunWeapon _npc];
	};
} foreach allUnits;

life_adminLevel = 0;
life_medicLevel = 0;
life_copLevel = 0;
CONST(JxMxE_PublishVehicle,"false");

/* Setup radio channels for Emergency Personnel/Civilian */
life_radio_emergency = radioChannelCreate [[0.722, 0, 0, 0.8], "EAS Channel", "%UNIT_NAME", []];
life_radio_civ = radioChannelCreate [[0, 0.95, 1, 0.8], "Side Channel", "%UNIT_NAME", []];

[] call compile preprocessFileLineNumbers SYSPATH("Core\eventhandlers.sqf");
//[] call compile preprocessFileLineNumbers "\life_server\functions.sqf";

onMapSingleClick "if(_alt) then {vehicle player setPos _pos};"; //Local debug for myself

[8,true,12] execFSM SYSPATH("Core\FSM\timeModule.fsm");
//[] execFSM SYSPATH("Core\FSM\cleanup.fsm");

/* Setup the federal reserve building(s) */
private["_dome","_rsb"];
_dome = nearestObject [[16019.5,16952.9,0],"Land_Dome_Big_F"];
_rsb = nearestObject [[16019.5,16952.9,0],"Land_Research_house_V1_F"];

for "_i" from 1 to 3 do {_dome setVariable[format["bis_disabled_Door_%1",_i],1,true]; _dome animate [format["Door_%1_rot",_i],0];};
_rsb setVariable["bis_disabled_Door_1",1,true];
_rsb allowDamage false;
_dome allowDamage false;

/* Tell clients that the server is ready and is accepting queries */
SYS_server_isReady = true;
PVAR_ALL("SYS_server_isReady");