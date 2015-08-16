#include "\life_server\script_macros.hpp"
/*
    File: fn_getPlayerGear.sqf
    Author: Bryan "Tonic" Boardwine
    Revised by: Dillon "Itsyuka" Modine-Thuen
    Created: Jul 16, 2015
    
    Description:
    	Fetches gear from array.
*/
private["_itemArray","_uniform","_vest","_backpack","_goggles","_headgear","_items","_prim","_seco","_uItems","_bItems","_vItems","_pItems","_hItems","_yItems","_uMags","_bMags","_vMags","_handle"];
_unit = param [0,objNull,[objNull]];
_uid = param [1,"",[""]];
_side = param [2,sideUnknown,[civilian]];

_getCachedData = GVAR_MNS [format["%1_%2",_uid,_side], ""];
if(EQUAL(_getCachedData,"")) exitWith {};
_itemArray = SEL(_getCachedData,7);

_handle = [_unit] spawn APP_fnc_stripDownPlayer;
waitUntil {scriptDone _handle};

if(EQUAL(count _itemArray,0)) exitWith {
    [_unit,_uid,_side] call APP_fnc_loadoutHandler;
};

_uniform = [_itemArray,0,"",[""]] call BIS_fnc_param;
_vest = [_itemArray,1,"",[""]] call BIS_fnc_param;
_backpack = [_itemArray,2,"",[""]] call BIS_fnc_param;
_goggles = [_itemArray,3,"",[""]] call BIS_fnc_param;
_headgear = [_itemArray,4,"",[""]] call BIS_fnc_param;
_items = [_itemArray,5,[],[[]]] call BIS_fnc_param;
_prim = [_itemArray,6,[],[[]]] call BIS_fnc_param;
_seco = [_itemArray,7,[],[[]]] call BIS_fnc_param;
_uItems = [_itemArray,8,[],[[]]] call BIS_fnc_param;
_uMags = [_itemArray,9,[],[[]]] call BIS_fnc_param;
_bItems = [_itemArray,10,[],[[]]] call BIS_fnc_param;
_bMags = [_itemArray,11,[],[[]]] call BIS_fnc_param;
_vItems = [_itemArray,12,[],[[]]] call BIS_fnc_param;
_vMags = [_itemArray,13,[],[[]]] call BIS_fnc_param;
/*
[
	"U_NikosAgedBody","V_PlateCarrier1_blk","","","",[],
	[
		"arifle_MXM_F",
		["","","",""],
		"30Rnd_65x39_caseless_mag_Tracer"
	],
	[
		"hgun_ACPC2_snds_F",
		["muzzle_snds_acp","","",""],
		"9Rnd_45ACP_Mag"
	],
	[],
	[
		["30Rnd_65x39_caseless_mag_Tracer",1]
	],
	[],
	[],
	[
		["FirstAidKit",3]
	],
	[
		["30Rnd_65x39_caseless_mag_Tracer",4],
		["9Rnd_45ACP_Mag",3],
		["Chemlight_green",3]
	]
]
*/
if(!(EQUAL(_goggles,""))) then {_handle = [_unit,_goggles,true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};};
if(!(EQUAL(_headgear,""))) then {_handle = [_unit,_headgear,true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};};
if(!(EQUAL(_uniform,""))) then {_handle = [_unit,_uniform,true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};};
if(!(EQUAL(_vest,""))) then {_handle = [_unit,_vest,true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};};
if(!(EQUAL(_backpack,""))) then {_handle = [_unit,_backpack,true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};};

{_handle = [_unit,_x,true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};} foreach _items;

/* Correct way to put items in unit, fk you tonic */
if(!((_prim select 0) isEqualTo "")) then {
	if(!((_prim select 2) isEqualTo "")) then {
       	[[_unit,(_prim select 2)],"addMagazine",_unit] call SYS_fnc_MP;
    };
    [[_unit,(_prim select 0)],"addWeapon",_unit] call SYS_fnc_MP;
	removeAllPrimaryWeaponItems _unit;
	{
		if(!(_x isEqualTo "")) then {[[_unit,_x],"addPrimaryWeaponItem",_unit] call SYS_fnc_MP;};
	} forEach (_prim select 1);
};
if(!((_seco select 0) isEqualTo "")) then {
	if(!((_seco select 2) isEqualTo "")) then {
       	[[_unit,(_seco select 2)],"addMagazine",_unit] call SYS_fnc_MP;
    };
    [[_unit,(_seco select 0)],"addWeapon",_unit] call SYS_fnc_MP;
	removeAllHandgunItems _unit;
	{
		if(!(_x isEqualTo "")) then {[[_unit,_x],"addHandgunItem",_unit] call SYS_fnc_MP;};
	} forEach (_seco select 1);
};

{(uniformContainer _unit) addItemCargoGlobal [_x select 0,_x select 1];} foreach (_uItems);
{(uniformContainer _unit) addMagazineCargoGlobal [_x select 0,_x select 1];} foreach (_uMags);

{(vestContainer _unit) addItemCargoGlobal [_x select 0,_x select 1];} foreach (_vItems);
{(vestContainer _unit) addMagazineCargoGlobal [_x select 0,_x select 1];} foreach (_vMags);

{(backpackContainer _unit) addItemCargoGlobal [_x select 0,_x select 1];} foreach (_bItems);
{(backpackContainer _unit) addMagazineCargoGlobal [_x select 0,_x select 1];} foreach (_bMags);

if(side _unit == independent && {EQUAL(uniform _unit,"U_Rangemaster")}) then {
	[[_unit,0,"Application\Textures\medic_uniform.jpg"],"SYS_fnc_setTexture",true,false] call SYS_fnc_MP;
};
if(side _unit == west && {EQUAL(uniform _unit,"U_Rangemaster")}) then {
	[[_unit,0,"Application\Textures\police_uniform.jpg"],"SYS_fnc_setTexture",true,false] call SYS_fnc_MP;
};