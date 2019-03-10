params[ "_unit" ];
removeAllActions _unit;
_unit addAction ["Pick Up Medkit",{
	params ["_target", "_caller", "_actionId", "_arguments"];

	_unit_damage = (getDammage _caller);
	if (_unit_damage > 0) then {
		_caller setDammage (_unit_damage - 1);
	};

	{
		_caller addItem "FirstAidkit";
	} forEach [1];

	deleteVehicle _target;

	_caller groupChat "I got one First Aid kit!";
}];