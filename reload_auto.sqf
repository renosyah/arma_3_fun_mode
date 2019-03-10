params[ "_unit" ];

_ammo_qty = _unit ammo currentWeapon _unit;
if (_ammo_qty == 0 && currentWeapon _unit != secondaryWeapon _unit) then {
	reload _unit;
		if (currentWeapon _unit == handgunWeapon _unit) then {
			_unit setVehicleAmmo 1;
		};
};