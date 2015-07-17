#include "\life_server\script_macros.hpp"
/*
	Author: Bryan "Tonic" Boardwine
	Description
	Main gear handling functionality.
*/
private["_item","_details","_bool","_ispack","_items","_isgun","_ongun","_override","_toUniform","_toVest","_preview"];
_unit = param [0,objNull,[objNull]];
_item = param [1,"",[""]];
_bool = param [2,false,[false]];
_ispack = param [3,false,[false]];
_ongun = param [4,false,[false]];
_override = param [5,false,[false]];
_toUniform = param [6,false,[false]]; //Manual override to send items specifically to a uniform.
_toVest = param [7,false,[false]]; //Manual override to send items specifically to a vest
_preview = param [8,false,[true]];

//Some checks
if(EQUAL(_item,"")) exitWith {};
_isgun = false;

_details = [_item] call SYS_fnc_fetchCfgDetails;
if(EQUAL(count _details,0)) exitWith {};

if(_bool) then {
	switch((_details select 6)) do {
		case CONFIG_GLASSES: {
			if(_toUniform) exitWith {_unit addItemToUniform _item;};
			if(_toVest) exitWith {_unit addItemToVest _item;};

			if(_ispack) then {
				_unit addItemToBackpack _item;
			} else {
				if(_override) then {
					_unit addItem _item;
				} else {
					if(!(EQUAL(goggles _unit,""))) then {
						removeGoggles _unit;
					};
					_unit addGoggles _item;
				};
			};
		};

		case CONFIG_VEHICLES: {
			if(!(EQUAL(backpack _unit,""))) then {
				_items = (backpackItems _unit);
				removeBackpack _unit;
			};

			_unit addBackpack _item;
			clearAllItemsFromBackpack _unit;

			if(!isNil {_items}) then {
				{[_x,true,true,false,true] call SYS_fnc_handleItem; } forEach _items;
			};
		};

		case CONFIG_MAGAZINES: {
			if(_toUniform) exitWith {_unit addItemToUniform _item;};
			if(_toVest) exitWith {_unit addItemToVest _item;};
			if(_ispack) exitWith {_unit addItemToBackpack _item;};

			_unit addMagazine _item;
		};

		case CONFIG_WEAPONS: {
			//New addition
			if(_toUniform) exitWith {_unit addItemToUniform _item;};
			if(_toVest) exitWith {_unit addItemToVest _item;};
			if(_ispack) exitWith {_unit addItemToBackpack _item;};

			if((SEL(_details,4)) in [1,2,4,5,4096]) then {
				if(EQUAL(SEL(_details,4),4096)) then {
					if(EQUAL(SEL(_details,5),-1)) then {
						_isgun = true;
					};
				} else {
					_isgun = true;
				};
			};

			if(_isgun) then {
				if(!_ispack && _override) exitWith {}; //It was in the vest/uniform, try to close to prevent it overriding stuff... (Actual weapon and not an item)
				if(EQUAL(_item,"MineDetector")) then {
					_unit addItem _item;
				} else {
					_unit addWeaponGlobal _item;
				};
			} else {
				switch(SEL(_details,5)) do {
					case 0:  {
						if(_ispack) then {
							_unit addItemToBackpack _item;
						} else {
							if(_override) then {
								_unit addItem _item;
							} else {
								if(_item in (assignedItems  _unit)) then {
									_unit addItem _item;
								} else {
									_unit addItem _item;
									_unit assignItem _item;
								};
							};
						};
					};

					case 605: {
						if(_ispack) then{
							_unit addItemToBackpack _item;
						} else {
							if(_override) then {
								_unit addItem _item;
							} else {
								if(EQUAL(headGear _unit,_item)) then{
									_unit addItem _item;
								} else {
									if(!(EQUAL(headGear _unit,""))) then {removeHeadGear _unit;};
									_unit addHeadGear _item;
								};
							};
						};
					};

					case 801: {
						if(_ispack) then {
							_unit addItemToBackpack _item;
						} else {
							if(_override) then {
								_unit addItem _item;
							} else {
								if(_unit isKindOf "Civilian") then {
									if(EQUAL(uniform _unit,_item) && {!_preview}) then {
										_unit addItem _item;
									} else {
										if(!(EQUAL(uniform _unit,""))) then {
											_items = uniformItems _unit;
											removeUniform _unit;
										};

										_unit addUniform _item;
										if(!isNil "_items") then {
											{_unit addItemToUniform _x} foreach _items;
										};
									};
								} else {
									if(!(EQUAL(uniform _unit,""))) then {
										_items = uniformItems _unit;
										removeUniform _unit;
									};

									if(!(_unit isUniformAllowed _item)) then {
										_unit forceAddUniform _item;
									} else {
										_unit addUniform _item;
									};
									if(!isNil "_items") then {
										{_unit addItemToUniform _x} foreach _items;
									};
								};
							};
						};
					};

					case 701: {
						if(_ispack) then {
							_unit addItemToBackpack _item;
						} else {
							if(_override) then{
								_unit addItem _item;
							} else {
								if(EQUAL(vest _unit,_item)) then {
									_unit addItem _item;
								} else {
									if(!(EQUAL(vest _unit,""))) then {
										_items = vestItems _unit;
										removeVest _unit;
									};

									_unit addVest _item;

									if(!isNil {_items}) then {
										{[_x,true,false,false,true] spawn SYS_fnc_handleItem;} forEach _items;
									};
								};
							};
						};
					};

					case 201: {
						if(_ispack) then {
							_unit addItemToBackpack _item;
						} else {
							private "_type";
							_type = [_item,201] call SYS_fnc_accType;
							if(_ongun) then {
								switch (_type) do {
									case 1: { _unit addPrimaryWeaponItem _item; };
									case 2: { _unit addSecondaryWeaponItem _item; };
									case 3: { _unit addHandgunItem _item; };
								};
							} else {
								if(_override) then {
									_unit addItem _item;
								} else {
									private["_wepItems","_action","_slotTaken"];
									_wepItems = switch(_type) do {case 1:{primaryWeaponItems _unit}; case 2:{secondaryWeaponItems _unit}; case 3:{handgunItems _unit}; default {["","",""]};};
									_slotTaken = false;

									if(!(EQUAL(SEL(_wepItems,2),""))) then {_slotTaken = true;};

									if(_slotTaken) then {
										_action = [localize "STR_MISC_AttachmentMSG",localize "STR_MISC_Attachment",localize "STR_MISC_Weapon",localize "STR_MISC_Inventory"] call BIS_fnc_guiMessage;
										if(_action) then {
											switch(_type) do {
												case 1: {_unit addPrimaryWeaponItem _item;};
												case 2: {_unit addSecondaryWeaponItem _item;};
												case 3: {_unit addHandgunItem _item;};
												default {_unit addItem _item;};
											};
										} else {
											_unit addItem _item; //Add it to any available container
										};
									} else {
										switch(_type) do {
											case 1: {_unit addPrimaryWeaponItem _item;};
											case 2: {_unit addSecondaryWeaponItem _item;};
											case 3: {_unit addHandgunItem _item;};
											default {_unit addItem _item;};
										};
									};
								};
							};
						};
					};

					case 301: {
						if(_ispack) then {
							_unit addItemToBackpack _item;
						} else {
							private "_type";
							_type = [_item,301] call SYS_fnc_accType;

							if(_ongun) then {
								switch (_type) do {
									case 1: { _unit addPrimaryWeaponItem _item; };
									case 2: { _unit addSecondaryWeaponItem _item; };
									case 3: { _unit addHandgunItem _item; };
								};
							} else {
								if(_override) then {
									_unit addItem _item;
								} else {
									private["_wepItems","_action","_slotTaken"];
									_wepItems = switch(_type) do {case 1:{primaryWeaponItems _unit}; case 2:{secondaryWeaponItems _unit}; case 3:{handgunItems _unit}; default {["","",""]};};
									_slotTaken = false;

									if(!(EQUAL(SEL(_wepItems,1),""))) then {_slotTaken = true;};

									if(_slotTaken) then {
										_action = [localize "STR_MISC_AttachmentMSG",localize "STR_MISC_Attachment",localize "STR_MISC_Weapon",localize "STR_MISC_Inventory"] call BIS_fnc_guiMessage;
										if(_action) then {
											switch(_type) do {
												case 1: {_unit addPrimaryWeaponItem _item;};
												case 2: {_unit addSecondaryWeaponItem _item;};
												case 3: {_unit addHandgunItem _item;};
												default {_unit addItem _item;};
											};
										} else {
											_unit addItem _item; //Add it to any available container
										};
									} else {
										switch(_type) do {
											case 1: {_unit addPrimaryWeaponItem _item;};
											case 2: {_unit addSecondaryWeaponItem _item;};
											case 3: {_unit addHandgunItem _item;};
											default {_unit addItem _item;};
										};
									};
								};
							};
						};
					};

					case 101:{
						if(_ispack) then {
							_unit addItemToBackpack _item;
						} else {
							private "_type";
							_type = [_item,101] call APP_fnc_accType;

							if(_ongun) then {
								switch (_type) do {
									case 1: { _unit addPrimaryWeaponItem _item; };
									case 2: { _unit addSecondaryWeaponItem _item; };
									case 3: { _unit addHandgunItem _item; };
								};
							} else {
								if(_override) then {
									_unit addItem _item;
								} else {
									private["_wepItems","_action","_slotTaken"];
									_wepItems = switch(_type) do {case 1:{primaryWeaponItems _unit}; case 2:{secondaryWeaponItems _unit}; case 3:{handgunItems _unit}; default {["","",""]};};
									_slotTaken = false;

									if(!(EQUAL(SEL(_wepItems,0),""))) then {_slotTaken = true;};

									if(_slotTaken) then {
										_action = [localize "STR_MISC_AttachmentMSG",localize "STR_MISC_Attachment",localize "STR_MISC_Weapon",localize "STR_MISC_Inventory"] call BIS_fnc_guiMessage;
										if(_action) then {
											switch(_type) do {
												case 1: {_unit addPrimaryWeaponItem _item;};
												case 2: {_unit addSecondaryWeaponItem _item;};
												case 3: {_unit addHandgunItem _item;};
												default {_unit addItem _item;};
											};
										} else {
											_unit addItem _item; //Add it to any available container
										};
									} else {
										switch(_type) do {
											case 1: {_unit addPrimaryWeaponItem _item;};
											case 2: {_unit addSecondaryWeaponItem _item;};
											case 3: {_unit addHandgunItem _item;};
											default {_unit addItem _item;};
										};
									};
								};
							};
						};
					};

					case 621: {
						if(_ispack) then {
							_unit addItemToBackpack _item;
						} else {
							if(_override) then {
								_unit addItem _item;
							} else {
								_unit addItem _item;
								_unit assignItem _item;
							};
						};
					};

					case 616: {
						if(_ispack) then {
							_unit addItemToBackpack _item;
						} else {
							if(_override) then {
								_unit addItem _item;
							} else {
								_unit addItem _item;
								_unit assignItem _item;
							};
						};
					};

					default {
						if(_ispack) then {
							_unit addItemToBackpack _item;
						} else {
							_unit addItem _item;
						};
					};
				};
			};
		};
	};
} else {
	switch(SEL(_details,6)) do {
		case CONFIG_VEHICLES: {
			removeBackpack _unit;
		};

		case CONFIG_MAGAZINES: {
			_unit removeMagazine _item;
		};

		case CONFIG_GLASSES: {
			if(EQUAL(_item,goggles _unit)) then {
				removeGoggles _unit;
			} else {
				_unit removeItem _item;
			};
		};

		case CONFIG_WEAPONS: {
			if(SEL(_details,4) in [1,2,4,5,4096]) then {
				if(EQUAL(SEL(_details,4),4096)) then {
					if(EQUAL(SEL(_details,5),1)) then {
						_isgun = true;
					};
				} else {
					_isgun = true;
				};
			};

			if(_isgun) then {
				switch(true) do {
					case (EQUAL(primaryWeapon _unit,_item)) : {_ispack = false;};
					case (EQUAL(secondaryWeapon _unit,_item)) : {_ispack = false;};
					case (EQUAL(handgunWeapon _unit,_item)) : {_ispack = false;};
					case (_item in assignedItems _unit) : {_ispack = false;};
					default {_ispack = true;};
				};

				if(_item == "MineDetector") then {
					_unit removeItem _item;
				} else {

					//Lovely code provided by [OCB]Dash
					private "_tmpfunction";
					_tmpfunction = {
						private["_tWeapons","_tWeaponCount"];
						switch(true) do {
							case (_this in (uniformItems _unit)): {
								_tWeapons = (getWeaponCargo (uniformContainer _unit)) select 0;
								_tWeaponCount = (getWeaponCargo (uniformContainer  _unit)) select 1;

								clearWeaponCargo (uniformContainer _unit);
								{
									_numVestWeps = _tWeaponCount select _forEachIndex;
									if(_x == _this) then
									{
										_numVestWeps = _numVestWeps - 1;
									};
									(uniformContainer _unit) addWeaponCargoGlobal [ _x,_numVestWeps];
								}forEach _tWeapons;
							};

							case (_this in (vestItems _unit)): {
								_tWeapons = (getWeaponCargo (vestContainer _unit)) select 0;
								_tWeaponCount = (getWeaponCargo (vestContainer  _unit)) select 1;

								clearWeaponCargo (vestContainer _unit);
								{
									_numVestWeps = _tWeaponCount select _forEachIndex;
									if(_x == _this) then
									{
										_numVestWeps = _numVestWeps - 1;
									};
									(vestContainer _unit) addWeaponCargoGlobal [ _x,_numVestWeps];
								}forEach _tWeapons;
							};

							case (_this in (backpackItems _unit)): {
								_tWeapons = (getWeaponCargo (backpackContainer _unit)) select 0;
								_tWeaponCount = (getWeaponCargo (backpackContainer  _unit)) select 1;

								clearWeaponCargo (backpackContainer _unit);
								{
									_numVestWeps = _tWeaponCount select _forEachIndex;
									if(_x == _this) then
									{
										_numVestWeps = _numVestWeps - 1;
									};
									(backpackContainer _unit) addWeaponCargoGlobal [ _x,_numVestWeps];
								}forEach _tWeapons;
							};
						};
					};

					if(_ispack) then {
						_item call _tmpfunction;
					} else {
						switch(true) do {
							case (_item in (uniformItems _unit)): {_item call _tmpfunction;};
							case (_item in (vestItems _unit)) : {_item call _tmpfunction;};
							case (_item in (backpackItems _unit)) : {_item call _tmpfunction;};
							default {_unit removeWeapon _item;};
						};
					};
				};
			} else {
				switch(SEL(_details,5)) do {
					case 0: {_unit unassignItem _item; _unit removeItem _item;};
					case 605: {if(EQUAL(headGear _unit,_item)) then {removeHeadgear _unit} else {_unit removeItem _item};};
					case 801: {if(EQUAL(uniform _unit,_item)) then {removeUniform _unit} else {_unit removeItem _item};};
					case 701: {if(EQUAL(vest _unit,_item)) then {removeVest _unit} else {_unit removeItem _item};};
					case 621: {_unit unassignItem _item; _unit removeItem _item;};
					case 616: {_unit unassignItem _item; _unit removeItem _item;};
					default {
						switch (true) do {
							case (_item in primaryWeaponItems _unit) : {_unit removePrimaryWeaponItem _item;};
							case (_item in handgunItems _unit) : {_unit removeHandgunItem _item;};
							default {_unit removeItem _item;};
						};
					};
				};
			};
		};
	};
};