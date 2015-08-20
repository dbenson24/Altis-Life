#include <macro.h>
/*
	File: fn_vehicleShopBuy.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Does something with vehicle purchasing.
*/
private["_mode","_spawnPoints","_className","_basePrice","_colorIndex","_spawnPoint","_vehicle","_shopSide","_license"];
_mode = SEL(_this,0);
if((lbCurSel 2302) == -1) exitWith {hint "You didn't pick a vehicle";};
_className = lbData[2302,(lbCurSel 2302)];
_vIndex = lbValue[2302,(lbCurSel 2302)];
_colorIndex = lbValue[2304,(lbCurSel 2304)];

[[[(life_veh_shop select 0),_className,_colorIndex,(life_veh_shop select 1),_mode],player],"APP_fnc_vehicleStoreHandler",false] call SYS_fnc_MP;
closeDialog 0; //Exit the menu.
true;