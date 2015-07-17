private ["_params","_script"];

_params = [];
_script = param ["",["",[]]];

if (typename _script == typename []) then {
	_params = param [0,[]];
	_script = param [1,"",[""]];
};

_params execvm _script