private ["_params","_fsm"];

_params = [];
_fsm = param ["",["",[]]];

if (typename _fsm == typename []) then {
	_params = param [0,[]];
	_fsm = param [1,"",[""]];

};

_params execfsm _fsm