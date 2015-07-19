#include "\life_server\script_macros.hpp"
/*
    File: fn_loadoutHandler.sqf
    Author: Dillon "Itsyuka" Modine-Thuen
    Created: Jul 16, 2015
    
    Description:
    	Sets default gear for players.
*/
private["_unit"];
_unit = param [0,objNull,[objNull]];
_uid = param [1,"",[""]];
_side = param [2,sideUnknown,[civilian]];

if(isNull _unit || _uid isEqualTo "") exitWith {};

/*
	Todo: Redo how the item's are being set from the loadout handler.
*/
switch(side _unit) do {
	case west: {
		_handle = [_unit,"U_Rangemaster",true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};
		_handle = [_unit,"V_Rangemaster_belt",true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};
		_unit addMagazines ["16Rnd_9x21_Mag",6];
		_handle = [_unit,"hgun_P07_snds_F",true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};
		{_handle = [_unit,_x,true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};} foreach ["ItemMap","ItemCompass","ItemWatch","ItemGPS"];
		[[_unit,0,"Application\Textures\police_uniform.jpg"],"SYS_fnc_setTexture",true,false] call SYS_fnc_MP;
	};
	case civilian: {
		_clothings = ["U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_C_Poloshirt_salmon","U_C_Poloshirt_redwhite","U_C_Commoner1_1"];
		_handle = [_unit,(_clothings select (floor(random (count _clothings)))),true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};
        {_handle = [_unit,_x,true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};} foreach ["ItemMap","ItemCompass","ItemWatch"];
	};
	case independent: {
		_handle = [_unit,"U_Rangemaster",true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};
        {_handle = [_unit,_x,true,false,false,false] spawn SYS_fnc_itemHandler; waitUntil {scriptDone _handle};} foreach ["ItemMap","ItemCompass","ItemWatch","ItemGPS","FirstAidKit","FirstAidKit"];

        [[_unit,0,"Application\Textures\medic_uniform.jpg"],"SYS_fnc_setTexture",true,false] call SYS_fnc_MP;
	};
};

[_unit,_uid,_side] spawn APP_fnc_updatePlayerGear;