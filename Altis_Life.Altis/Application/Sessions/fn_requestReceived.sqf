#include <macro.h>
/*
	File: fn_requestReceived.sqf
	Author: Bryan "Tonic" Boardwine
	Revised By: Dillon "Itsyuka" Modine-Thuen
	
	Description:
	Called by the server saying that we have a response so let's
	sort through the information, validate it and if all valid
	set the client up.
*/
diag_log format["Data: %1",_this];
APP_session_tries = APP_session_tries + 1;
if(APP_session_completed) exitWith {}; //Why did this get executed when the client already initialized? Fucking arma...
if(APP_session_tries > 3) exitWith {cutText[localize "STR_Session_Error","BLACK FADED"]; 0 cutFadeOut 999999999;};

0 cutText [localize "STR_Session_Received","BLACK FADED"];
0 cutFadeOut 9999999;

//Error handling and junk..
if(!(EQUAL(steamid,SEL(_this,0)))) exitWith {[] call APP_fnc_dataQuery;};

//Lets make sure some vars are not set before hand.. If they are get rid of them, hopefully the engine purges past variables but meh who cares.
if(!isServer && (!isNil "life_adminlevel" OR !isNil "life_coplevel")) exitWith {
	[[profileName,getPlayerUID player,"VariablesAlreadySet"],"SPY_fnc_cookieJar",false,false] call SYS_fnc_MP;
	[[profileName,format["Variables set before client initialization...\nlife_adminlevel: %1\nlife_coplevel: %2",life_adminlevel,life_coplevel]],"SPY_fnc_notifyAdmins",true,false] call SYS_fnc_MP;
	sleep 0.9;
	failMission "SpyGlass";
};

//Parse basic player information.
CASH = SEL(_this,2);
BANK = SEL(_this,3);
CONST(life_adminlevel,parseNumber (SEL(_this,4)));

//Loop through licenses
if(count (SEL(_this,5)) > 0) then {
	{SVAR_MNS [SEL(_x,0),SEL(_x,1)];} foreach (SEL(_this,5));
};

life_gear = SEL(_this,7);
//[true] call life_fnc_loadGear;

//Parse side specific information.
switch(playerSide) do {
	case west: {
		CONST(life_coplevel, parseNumber(SEL(_this,6)));
		CONST(life_medicLevel,0);
		life_blacklisted = SEL(_this,8);
	};

	case civilian: {
		life_is_arrested = SEL(_this,6);
		CONST(life_coplevel, 0);
		CONST(life_medicLevel, 0);
	};

	case independent: {
		CONST(life_medicLevel, parseNumber(SEL(_this,6)));
		CONST(life_coplevel,0);
	};
};

if(count (SEL(_this,12)) > 0) then {
	{life_vehicles pushBack _x;} foreach (SEL(_this,12));
};

APP_session_completed = true;