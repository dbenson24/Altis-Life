#include "\life_server\script_macros.hpp"
/*
    Author: Dillon "Itsyuka" Modine-Thuen
    File: fn_playerSessionEnd.sqf
    Description: Saves all data to the MySQL from the Memory.
*/
private["_unit","_id","_uid","_name"];
_unit = SEL(_this,0);
_id = SEL(_this,1);
_uid = SEL(_this,2);
_name = SEL(_this,3);
_key = [_this,4,0,[0]] call BIS_fnc_param;

if(!(EQUAL(_key,serverKey))) exitWith {}; //Doesn't match, probably a bad request
if(isNull _unit) exitWith {}; //These people leaving too early.
_side = (side _unit);

_getCachedData = GVAR_MNS [format["%1_%2",_uid,_side], ""];
if(_getCachedData = "") exitWith {}; //Player Data wasn't cached, probably decided to leave before session started.
/* [playerid, name, cash, bank, adminlevel, licenses, arrested/med_cop_level, gear] */

_cash = SEL(_getCachedData,2);
_bank = SEL(_getCachedData,3);
_licenses = SEL(_getCachedData,5);
_gear = SEL(_getCachedData,7);

[_uid, _name, _side, _cash, _bank, _licenses, _gear] call APP_fnc_updateRequest;