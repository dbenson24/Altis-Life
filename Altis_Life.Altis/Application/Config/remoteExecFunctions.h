#define true 1
#define false 0
#define F(CLASSNAME,SBOOL) class CLASSNAME{serverOnly = SBOOL;};
/*
	F(Command,Server only?)
*/

/* Client Functions */
F(BIS_fnc_execVM,false) /* This has a built-in check, no worries about it being used */
F(APP_fnc_playerSessionStart,false)
F(SYS_fnc_setTexture,false)
F(APP_fnc_vehicleStoreHandler,false)
F(SYS_fnc_broadcast,false)

/* Server Functions */
F(BIS_fnc_endMission,true)
F(APP_fnc_requestReceived,true)