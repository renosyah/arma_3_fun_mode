params[ "_unit" ];
removeAllActions _unit;
_unit addAction ["Pick Up Ammo",{
	params ["_target", "_caller", "_actionId", "_arguments"];

	_weapon_type_use = [currentWeapon _caller,primaryWeapon _caller,handgunWeapon _caller] call BIS_fnc_selectRandom;
 
	_killer_primary_ammo_array = getArray (configFile >> "CfgWeapons" >> _weapon_type_use >> "magazines");

	_ammo_choosed_to_give = _killer_primary_ammo_array call BIS_fnc_selectRandom;
	_ammo_count_reward = [1,2] call BIS_fnc_selectRandom;

	_caller addMagazines[_ammo_choosed_to_give,_ammo_count_reward];

	deleteVehicle _target;

	_ammo_name = ((configFile >> "CfgMagazines" >> _ammo_choosed_to_give >> "displayName") call BIS_fnc_GetCfgData);
	_caller groupChat format ["I got %1 of %2 ammo!",_ammo_count_reward,_ammo_name];
}];