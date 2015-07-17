private ["_params","_code"];

_params = [];
_code = param [{},[{},[]]];

if (typename _code == typename []) then {
	_params = param [0,[]];
	_code = param [1,{},[{}]];
};

_params call _code