params[ "_unit" ];

_random_jamming_chance = [10,12,13,14,25,26,27,28,29,30] call BIS_fnc_selectRandom;
_ammo_qty = _unit ammo currentWeapon _unit;
if (_random_jamming_chance == _ammo_qty) then {
	reload _unit;
	_unit setVehicleAmmo 1;
};