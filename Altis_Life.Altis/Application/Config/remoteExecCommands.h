#define true 1
#define false 0
#define C(CLASSNAME,SERVER) class CLASSNAME{serverOnly = SERVER;};
/*
	C(Command,Server only?)
*/
C(addWeapon,true)
C(addMagazine,true)
C(addPrimaryWeaponItem,true)
C(addHandgunItem,true)
C(removeAllHandgunItems,true)