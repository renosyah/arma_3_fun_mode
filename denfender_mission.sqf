
this addAction ["Call Resistance",{
params ["_target", "_caller", "_actionId", "_arguments"];

systemChat "Undercover Civ : Request reinforcement,Bos!, Send your best man!";

_random_civil = "O_G_Survivor_F";
_random_survivor = ["I_Survivor_F","B_Survivor_F","B_G_Survivor_F"] call BIS_fnc_selectRandom;

_side_attacker = east;
if ((side _caller) == east) then {
	_side_attacker = west;
} else {
	_side_attacker = east;
};

_group_attacker = createGroup [_side_attacker, true];

_baseVest = [];
_VestList = (configfile >> "cfgWeapons") call BIS_fnc_getCfgSubClasses;

{
	if (getnumber (configFile >> "cfgWeapons" >> _x >> "scope") == 2) then {
		_itemType = _x call bis_fnc_itemType;
		if (((_itemType select 0) == "Equipment") && ((_itemType select 1) == "Vest")) then {
			_baseName = _x call BIS_fnc_baseWeapon;
			if (!(_baseName in _baseVest)) then {
				_baseVest = _baseVest + [_baseName];
			};
		};
	};

} foreach _VestList;

_baseWeapons = [];
_wpList = (configFile >> "cfgWeapons") call BIS_fnc_getCfgSubClasses;
{
	if (getnumber (configFile >> "cfgWeapons" >> _x >> "scope") == 2) then {
		_itemType = _x call bis_fnc_itemType;
		if (((_itemType select 0) == "Weapon") && !((_itemType select 1) == "RocketLauncher") && !((_itemType select 1) == "MissileLauncher")) then {
			_baseName = _x	call BIS_fnc_baseWeapon;
			if (!(_baseName in _baseWeapons)) then {
				_baseWeapons = _baseWeapons + [_baseName];
			};
		};
	};

} foreach _wpList;


for [{_i=0}, {_i<5}, {_i=_i+1}] do {

	_random_civil createUnit [position enemy_spawner_marker, _group_attacker];
};


_all_group_spawn = (units _group_attacker);

{

	_my_unit = _x;

	_my_unit allowFleeing 0;
	_my_unit addVest (_baseVest call BIS_fnc_selectRandom);
	_my_unit_weapon = (_baseWeapons call BIS_fnc_selectRandom);
	_my_unit addWeapon _my_unit_weapon;	
	_my_unit addVest (_baseVest call BIS_fnc_selectRandom);

	_unit_primary_ammo_array = getArray (configFile >> "CfgWeapons" >> _my_unit_weapon >> "magazines");
	{
		_my_unit addMagazines[_x,1];

	} forEach _unit_primary_ammo_array;


	_my_unit execVM "FUN\reduce_damage.sqf";

	_my_unit addeventhandler ["Fired"," _this execVM 'FUN\ai_reload_handle.sqf'"];

	_my_unit doMove (position _caller);

} forEach _all_group_spawn;

systemChat "Mercenary Boss : Roger, My guys its on its way to assist you!";
_target say3D [(["RadioAmbient2","RadioAmbient6","RadioAmbient8"] call BIS_fnc_selectRandom),100,1];

}];




this addAction ["Call ReinForcement!",{
params ["_target", "_caller", "_actionId", "_arguments"];

_random_civil = "O_G_Survivor_F";
_random_survivor = ["I_Survivor_F","B_Survivor_F","B_G_Survivor_F"] call BIS_fnc_selectRandom;

_group_fighter = createGroup [(side _caller), true];

_baseVest = [];
_VestList = (configfile >> "cfgWeapons") call BIS_fnc_getCfgSubClasses;

{
	if (getnumber (configFile >> "cfgWeapons" >> _x >> "scope") == 2) then {
		_itemType = _x call bis_fnc_itemType;
		if (((_itemType select 0) == "Equipment") && ((_itemType select 1) == "Vest")) then {
			_baseName = _x call BIS_fnc_baseWeapon;
			if (!(_baseName in _baseVest)) then {
				_baseVest = _baseVest + [_baseName];
			};
		};
	};

} foreach _VestList;

_baseWeapons = [];
_wpList = (configFile >> "cfgWeapons") call BIS_fnc_getCfgSubClasses;
{
	if (getnumber (configFile >> "cfgWeapons" >> _x >> "scope") == 2) then {
		_itemType = _x call bis_fnc_itemType;
		if (((_itemType select 0) == "Weapon") && !((_itemType select 1) == "RocketLauncher") && !((_itemType select 1) == "MissileLauncher")) then {
			_baseName = _x	call BIS_fnc_baseWeapon;
			if (!(_baseName in _baseWeapons)) then {
				_baseWeapons = _baseWeapons + [_baseName];
			};
		};
	};

} foreach _wpList;


for [{_i=0}, {_i<5}, {_i=_i+1}] do {

	_spawn_point = [spawner_marker_1,spawner_marker_2,spawner_marker_3] call BIS_fnc_selectRandom;
	_random_survivor createUnit [position _spawn_point, _group_fighter];
};


_all_group_spawn = (units _group_fighter);
{

	_my_unit = _x;

	_my_unit allowFleeing 0;
	_my_unit addVest (_baseVest call BIS_fnc_selectRandom);
	_my_unit_weapon = (_baseWeapons call BIS_fnc_selectRandom);
	_my_unit addWeapon _my_unit_weapon;	
	_my_unit addVest (_baseVest call BIS_fnc_selectRandom);

	_unit_primary_ammo_array = getArray (configFile >> "CfgWeapons" >> _my_unit_weapon >> "magazines");
	{
		_my_unit addMagazines[_x,1];

	} forEach _unit_primary_ammo_array;

	_my_unit addEventHandler ["Killed"," _this execVM 'FUN\reward_box.sqf'"];

	_my_unit execVM "FUN\reduce_damage.sqf";
	_my_unit addeventhandler ["respawn"," _this execVM 'FUN\reduce_damage.sqf'"];

	_my_unit execVM "FUN\chemical_equipment.sqf";
	_my_unit addeventhandler ["respawn"," _this execVM 'FUN\chemical_equipment.sqf'"];

	
	_my_unit addeventhandler ["Fired"," _this execVM 'FUN\ai_reload_handle.sqf'"];

	_my_unit doMove (position _caller);

} forEach _all_group_spawn;


}];