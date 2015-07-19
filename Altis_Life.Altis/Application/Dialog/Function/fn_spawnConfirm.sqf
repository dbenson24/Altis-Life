/*
	File: fn_spawnConfirm.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Spawns the player where he selected.
*/
private["_spCfg","_sp","_spawnPos"];
closeDialog 0;
cutText ["","BLACK IN"];
if(count APP_spawn_point == 0) then
{
	private["_sp","_spCfg"];
	_spCfg = [playerSide] call APP_fnc_spawnPointCfg;
	_sp = _spCfg select 0;
	
	if(playerSide == civilian) then
	{
		if(isNil {(call compile format["%1", _sp select 0])}) then {
			player setPos (getMarkerPos (_sp select 0));
		} else {
			_spawnPos = (call compile format["%1", _sp select 0]) call BIS_fnc_selectRandom;
			_spawnPos = _spawnPos buildingPos 0;
			player setPos _spawnPos;
		};
	}
		else
	{
		player setPos (getMarkerPos (_sp select 0));
	};
	titleText[format["%2 %1",_sp select 1,localize "STR_Spawn_Spawned"],"BLACK IN"];
}
	else
{
	if(playerSide == civilian) then
	{
		/*
			Todo: Reimplement the housing system
		*/
		if(isNil {(call compile format["%1",APP_spawn_point select 0])}) then {
			player setPos (getMarkerPos (APP_spawn_point select 0));
		} else {
			_spawnPos = (call compile format["%1", APP_spawn_point select 0]) call BIS_fnc_selectRandom;
			_spawnPos = _spawnPos buildingPos 0;
			player setPos _spawnPos;
		};
	}
		else
	{
		player setPos (getMarkerPos (APP_spawn_point select 0));
	};
	titleText[format["%2 %1",APP_spawn_point select 1,localize "STR_Spawn_Spawned"],"BLACK IN"];
};

if(APP_firstSpawn) then {
	APP_firstSpawn = false;
	//[] call life_fnc_welcomeNotification;
};
[0] call APP_fnc_hudSystem;