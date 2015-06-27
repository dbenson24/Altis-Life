/*
	File: fn_dataQuery.sqf
	Author: Bryan "Tonic" Boardwine

	Description:
	Starts the 'authentication' process and sends a request out to
	the server to check for player information.
*/
private["_uid","_side","_sender","_name"];
if(APP_session_completed) exitWith {}; //Why did this get executed when the client already initialized? Fucking arma...
_sender = player;
_uid = getPlayerUID _sender;
_side = playerSide;
_name = profileName;
cutText[format[localize "STR_Session_Query",_uid],"BLACK FADED"];
0 cutFadeOut 999999999;

[_uid,_side,_name,_sender] remoteExec ["APP_fnc_playerSessionStart",2];