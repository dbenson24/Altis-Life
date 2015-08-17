/*
    File: fn_randomSeq.sqf
    Author: Dillon "Itsyuka" Modine-Thuen
    Created: Aug 14, 2015

    Description:
    	Creates a randomly generated sequence and returns it.
*/
private["_filter","_filterArray","_return","_length"];
_length = param [0,6,[6]];
_filter = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
_filterArray = toArray _filter;
_return = [];
for "_i" from 1 to _length do {
	_return pushBack (_filterArray select floor random count _filterArray);
};
_return = str(toString _return);
_return;