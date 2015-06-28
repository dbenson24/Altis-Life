#include <macro.h>
/*
    File: init.sqf
    Author: Bryan "Tonic" Boardwine
    Revised: Dillon "Itsyuka" Modine-Thuen
    Created: Jun 18, 2015
    
    Description:
        Master Client Initialization File
*/
APP_firstSpawn = true;
APP_session_completed = false;
private["_handle","_timeStamp"];
0 cutText["Setting up client, please wait...","BLACK FADED"];
0 cutFadeOut 1e+30;
_timeStamp = diag_tickTime;
diag_log "------------------------------------------------------------------------------------------------------";
diag_log "--------------------------------- Starting Altis Life Client Init ----------------------------------";
diag_log "------------------------------------------------------------------------------------------------------";
waitUntil {!isNull player && player == player}; //Wait till the player is ready

//Setup initial client core functions
diag_log "::Life Client:: Initialization Variables";
[] call compile PreprocessFileLineNumbers "Application\Config\configuration.sqf";
diag_log "::Life Client:: Variables initialized";

diag_log "::Life Client:: Setting up Eventhandlers";
[] call SYS_fnc_setupEVH;
diag_log "::Life Client:: Eventhandlers completed";

0 cutText ["Waiting for the server to be ready...","BLACK FADED"];
0 cutFadeOut 1e+30;

diag_log "::Life Client:: Waiting for the server to be ready..";
waitUntil{!isNil "SYS_server_isReady"};
waitUntil{(SYS_server_isReady OR !isNil "SYS_server_extDB_notLoaded")};

if(!isNil "SYS_server_extDB_notLoaded" && {SYS_server_extDB_notLoaded != ""}) exitWith {
	diag_log SYS_server_extDB_notLoaded;
	1e+30 cutText [SYS_server_extDB_notLoaded,"BLACK FADED"];
	1e+30 cutFadeOut 1e+30;
};

[] call APP_fnc_dataQuery;
waitUntil {APP_session_completed};
0 cutText["Finishing client setup procedure","BLACK FADED"];
0 cutFadeOut 1e+30;

[] spawn SYS_fnc_escInterrupt;

player SVAR ["restrained",false,true];
player SVAR ["Escorting",false,true];
player SVAR ["transporting",false,true];

diag_log "Past Settings Init";
//[] execFSM "core\fsm\client.fsm";

diag_log "Executing client.fsm";
waitUntil {!(isNull (findDisplay 46))};

diag_log "Display 46 Found";
//(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call life_fnc_keyHandler"];
player addRating 1e+30;
diag_log "------------------------------------------------------------------------------------------------------";
diag_log format["			 End of Altis Life Client Init :: Total Execution Time %1 seconds ",(diag_tickTime) - _timeStamp];
diag_log "------------------------------------------------------------------------------------------------------";

0 cutText ["","BLACK IN"];
[0] call APP_fnc_hudSystem;

player SVAR ["steam64ID",getPlayerUID player];
player SVAR ["realname",profileName,true];

SYS_fnc_moveIn = compileFinal
"
	player moveInCargo (_this select 0);
";

[] execFSM "System\Core\clientFSM.fsm";

if(EQUAL(LIFE_SETTINGS(getNumber,"enable_fatigue"),0)) then {player enableFatigue false;};