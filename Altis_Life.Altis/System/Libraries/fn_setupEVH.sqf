/*
    File: fn_setupEVH.sqf
    Author: Bryan "Tonic" Boardwine
    Created: Jun 20, 2015
    
    Description:
        Master Event Handler
*/
/*
player addEventHandler["Killed", {_this spawn life_fnc_onPlayerKilled}];
player addEventHandler["handleDamage",{_this call life_fnc_handleDamage;}];
player addEventHandler["Respawn", {_this call life_fnc_onPlayerRespawn}];
player addEventHandler["Take",{_this call life_fnc_onTakeItem}]; //Prevent people from taking stuff they shouldn't...
player addEventHandler["Fired",{_this call life_fnc_onFired}];
player addEventHandler["InventoryClosed", {_this call life_fnc_inventoryClosed}];
player addEventHandler["InventoryOpened", {_this call life_fnc_inventoryOpened}];
*/
"SYS_fnc_MP_packet" addPublicVariableEventHandler {[_this select 0,_this select 1] call SYS_fnc_MPexec;};