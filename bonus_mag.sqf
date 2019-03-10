params[ "_unit" ];
if (currentWeapon _unit != "") then {
	_ammo_class_array = getArray (configFile >> "CfgWeapons" >> currentWeapon _unit >> "magazines");
	_ammo_choosed_to_give = _ammo_class_array call BIS_fnc_selectRandom;
	_unit addMagazines[_ammo_choosed_to_give,10];
};