#include "\life_server\script_macros.hpp"
/*
    File: fn_vehicleStoreHandler.sqf
    Author: Dillon "Itsyuka" Modine-Thuen
    Created: Aug 17, 2015
    
    Description:
    N/A
*/
private["_purchase","_player","_vehObj","_vehicle","_vehShop","_colorIndex","_marker","_vehicles","_vehInfo","_pUID","_pSide","_pLicenses","_hasLicense","_formatSide"];
_purchase = param[0,[],[[]]];
_player = param[1,objNull,[objNull]];

if(_purchase isEqualTo [] || isNull _player) exitWith {}; /* No */

_vehShop = _purchase param[0,"",[""]];
_vehicle = _purchase param[1,"", [""]];
_colorIndex = _purchase param[2,0,[0]];
_markers = _purchase param[3,[],[[]]];
_mode = _purchase param[4,false,[false]];

_vehicles = M_CONFIG(getArray,"CarShops",_vehShop,"vehicles");
_vehInfo = [];
{
	if(_vehicle isEqualTo (_x select 0)) exitWith {
		_vehInfo = _x;
	};
} forEach _vehicles;

if(_vehInfo isEqualTo []) exitWith {}; /* Vehicle isn't found in the shop */

_pUID = getPlayerUID _player;
_pSide = side _player;

_formatSide = switch(_pSide) do {
	case west: {"cop"};
	case civilian: {"civ"};
	case independent: {"med"};
};

_pLicenses = [_pUID,_pSide,5] call APP_fnc_playerGetSession;
_pCash = [_pUID,_pSide,2] call APP_fnc_playerGetSession;

_hasLicense = _pLicenses find format["license_%1_%2",_formatSide,(_vehInfo select 2)];

diag_log format["Licenses: %1 || License Required: %2 || Has license: %3",_pLicenses,format["license_%1_%2",_formatSide,_vehInfo select 2],_hasLicense];
diag_log format["Player's Cash: %1 || Cash Required: %2",_pCash,_vehInfo select 1];

if((_vehInfo select 2) != "" && _hasLicense == -1) exitWith {[[1,"You do not have the required license to purchase this vehicle"],"SYS_fnc_broadcast",_player] call SYS_fnc_MP;};
if(!(_pCash >= (_vehInfo select 1))) exitWith {[[1,"You don't have enough money"],"SYS_fnc_broadcast",_player] call SYS_fnc_MP;};

_pCash = _pCash - (_vehInfo select 1);
[_pUID,_pSide,0,_pCash] call APP_fnc_playerSessionUpdate;

SYS_vehicleQueue pushBack [_vehicle,_markers,_colorIndex,_mode,_player];