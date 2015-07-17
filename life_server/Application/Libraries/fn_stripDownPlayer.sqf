/*
	File: fn_stripDownPlayer.sqf
	Author: Tobias 'Xetoxyc' Sittenauer
	Description: Strip the player down
*/
private "_unit";
_unit = param [0,objNull,[objNull]];
{_unit removeWeaponGlobal _x;} forEach (weapons _unit);
{_unit removeMagazine _x;} forEach (magazines _unit);
removeUniform _unit;
removeVest _unit;
removeBackpackGlobal _unit;
removeGoggles _unit;
removeHeadGear _unit;

{
	_unit unassignItem _x;
	_unit removeItem _x;
} forEach (assignedItems _unit);

if(hmd _unit != "") then {
	_unit unlinkItem (hmd _unit);
};