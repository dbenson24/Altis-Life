#include <macro.h>
#define IDC_LIFE_BAR_FOOD 2200
#define IDC_LIFE_BAR_WATER 2201
#define IDC_LIFE_BAR_HEALTH 2202
#define IDC_LIFE_FOOD_TEXT 1000
#define IDC_LIFE_WATER_TEXT 1001
#define IDC_LIFE_HEALTH_TEXT 1002
#define LIFEdisplay (GVAR_UINS ["playerHUD",displayNull])
#define LIFEctrl(ctrl) ((GVAR_UINS ["playerHUD",displayNull]) displayCtrl ctrl)
/*
    File: fn_hudSystem.sqf
    Author: Dillon "Itsyuka" Modine-Thuen
    Created: Jun 27, 2015
    
    Description:
        Library that control's the HUD
*/
private["_mode"];
_mode = [_this,0,0,[0]] call BIS_fnc_param;

disableSerialization;

switch(_mode) do {
    case 0: {2 cutRsc ["playerHUD","PLAIN"]; [1] call APP_fnc_hudSystem;};
    case 1: {
        if(isNull LIFEdisplay) then {[0] call APP_fnc_hudSystem;};
        LIFEctrl(IDC_LIFE_BAR_FOOD) progressSetPosition (1 / (100 / APP_hunger));
        LIFEctrl(IDC_LIFE_BAR_WATER) progressSetPosition (1 / (100 / APP_thirst));
        LIFEctrl(IDC_LIFE_BAR_HEALTH) progressSetPosition (1 - (damage player));

        LIFEctrl(IDC_LIFE_FOOD_TEXT) ctrlsetText format["%1", APP_hunger];
        LIFEctrl(IDC_LIFE_WATER_TEXT) ctrlsetText format["%1", APP_thirst];
        LIFEctrl(IDC_LIFE_HEALTH_TEXT) ctrlsetText format["%1", round((1 - (damage player)) * 100)];
    };
    default {};
};