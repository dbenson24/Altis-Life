#define F(CLASSNAME,SBOOL,BBOOL) class CLASSNAME{serverOnly = SBOOL; blacklist = BBOOL;};
/*
	F(Command,Server only?,Blacklist)
*/
F(BIS_fnc_endMission,true,false)
F(BIS_fnc_endMissionServer,false,true)
F(BIS_fnc_spawn,false,true)
F(BIS_fnc_call,false,true)