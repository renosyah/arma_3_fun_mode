	params ["_unit", "_killer"];
	
	_drop_boxes_chance = [1,2,3,4,5] call BIS_fnc_selectRandom;
	_message_to_show_in_chat_group = ""; 
	_report_default = [(format ["%1 has been eliminated!",(name _unit)]),(format ["%1 has been neutralize!",(name _unit)])] call BIS_fnc_selectRandom;

	if ((_drop_boxes_chance == 1) or (_drop_boxes_chance == 5)) then {
		_mine_spawn = ["BombCluster_03_UXO2_F","APERSMineDispenser_Mine_F","APERSBoundingMine"] call BIS_fnc_selectRandom;
		createMine [_mine_spawn, position _unit, [], 0];
	};

	_drop_grenade_chance = [1,2] call BIS_fnc_selectRandom;
	if (_drop_boxes_chance == 3 && _drop_grenade_chance == 1) then {


		_message_to_show_in_chat_group = [(format ["%1's grenades exploding!",(name _unit)]),(format ["%1's charges exploding!",(name _unit)]),(format ["%1's grenades detonating!",(name _unit)])]  call BIS_fnc_selectRandom;

		_grenade = "DemoCharge_Remote_Ammo_Scripted" createVehicle position _unit;
		0 = _grenade spawn {
			_this setDamage 1;
		};
	};
	

	if (_drop_boxes_chance == 1) then {

		_message_to_show_in_chat_group = [(format ["%1 has been eliminated!, %2 has dropped loot!",(name _unit),(name _unit)]),(format ["%1 has been neutralize!, %2 has dropped loot!",(name _unit),(name _unit)])] call BIS_fnc_selectRandom;

		_box = ["Land_MetalCase_01_small_F","Land_PlasticCase_01_small_gray_F","Land_PlasticCase_01_medium_gray_F"] call BIS_fnc_selectRandom;
		_reward_box = createVehicle [_box, position _unit, [], 0];
		_reward_box addAction["Destroy Box!",{
			params ["_target", "_caller", "_actionId", "_arguments"];
			deleteVehicle _target;
		}];

		clearItemCargoGlobal _reward_box;
		clearWeaponCargoGlobal _reward_box;
		clearMagazineCargoGlobal _reward_box;
		clearBackpackCargoGlobal _reward_box;

		_killer_primary_ammo_array = getArray (configFile >> "CfgWeapons" >> (primaryWeapon _killer) >> "magazines");
		{
			_ammo_count_reward = [1,2,3,4] call BIS_fnc_selectRandom;
			_reward_box addItemCargoGlobal[_x,_ammo_count_reward];

		} forEach _killer_primary_ammo_array;

		_killer_handgun_ammo_array = getArray (configFile >> "CfgWeapons" >> (handgunWeapon _killer) >> "magazines");
		{
			_ammo_count_reward = [1,2,3] call BIS_fnc_selectRandom;
			_reward_box addItemCargoGlobal[_x,_ammo_count_reward];

		} forEach _killer_handgun_ammo_array;

		_first_aid_count_reward = [1,2,3,4] call BIS_fnc_selectRandom;
		_reward_box addItemCargoGlobal["FirstAidKit",_first_aid_count_reward];

		_random_weapon_reward_chance = [1,2] call BIS_fnc_selectRandom;

		if (_random_weapon_reward_chance == 1) then {

			_baseWeapons = [];
			_wpList = (configFile >> "cfgWeapons") call BIS_fnc_getCfgSubClasses;
			{
				if (getnumber (configFile >> "cfgWeapons" >> _x >> "scope") == 2) then {
					_itemType = _x call bis_fnc_itemType;
					if (((_itemType select 0) == "Weapon")) then {
						_baseName = _x	call BIS_fnc_baseWeapon;
						if (!(_baseName in _baseWeapons)) then {
							_baseWeapons = _baseWeapons + [_baseName];
						};
					};
				};

			} foreach _wpList;


			_random_weapon_reward_count = [1,2,3,4] call BIS_fnc_selectRandom;

			for [{_i=0}, {_i<_random_weapon_reward_count}, {_i=_i+1}] do {
				_random_weapon_reward = _baseWeapons call BIS_fnc_selectRandom; 
				_reward_box addItemCargoGlobal[_random_weapon_reward,1];

				_random_weapon_reward_cfg_ammo_array = getArray (configFile >> "CfgWeapons" >> _random_weapon_reward >> "magazines");
				{
					_ammo_count_reward = [1,2,3] call BIS_fnc_selectRandom;
					_reward_box addItemCargoGlobal[_x,_ammo_count_reward];

				} forEach _random_weapon_reward_cfg_ammo_array;
			};
		};
	};

	_healing_box = "Land_FirstAidKit_01_closed_F";
	_ammo_box_dropped = "Land_Ammobox_rounds_F";

	if (_drop_boxes_chance == 4) then {
		
		_message_to_show_in_chat_group = [(format ["%1 has been eliminated!, %2 has dropped Medkit!",(name _unit),(name _unit)]),(format [" %1 has dropped Medkit!",(name _unit)])] call BIS_fnc_selectRandom;		

		_healing_box_create = createVehicle [_healing_box, position _unit, [], 0];
		_healing_box_create execVM "FUN\healing_box.sqf";
	};
	if (_drop_boxes_chance == 5) then {	

		_random_ammo_reward_count = [1,2,3] call BIS_fnc_selectRandom;
		for [{_i=0}, {_i<_random_ammo_reward_count}, {_i=_i+1}] do {

			_ammo_box_create = createVehicle [_ammo_box_dropped, position _unit, [], 0];
			_ammo_box_create execVM "FUN\ammo_box.sqf";
		};

		_message_to_show_in_chat_group = [(format ["%1 has been eliminated!, %2 has dropped %3 AmmoBox!",(name _unit),(name _unit),_random_ammo_reward_count]),(format ["%1 has dropped %2 AmmoBox!",(name _unit),_random_ammo_reward_count])] call BIS_fnc_selectRandom;	
	};

	if (_message_to_show_in_chat_group != "") then {

		_killer groupChat _message_to_show_in_chat_group;

	} else {


		_killer groupChat _report_default;

	};





