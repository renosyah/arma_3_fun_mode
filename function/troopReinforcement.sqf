/* ----- */
/* [ player, west , ["B_T_Recon_F","B_T_Recon_JTAC_F","B_T_Soldier_F"] ,1 , true ] call FUN_fnc_troopReinforcement; */


/* -----*/
/* [ player, east , ["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_GL_F"] , 1 , false ] call FUN_fnc_troopReinforcement; */



/* ----- */

null = _this spawn { 

	params[ "_caller","_side","_list_troop","_troop_count","_will_join_the_caller" ];


	_marker_spawn = [[[position _caller, 130]],[[position _caller, 125]]] call BIS_fnc_randomPos;
	_marker_troop_to_secure = _caller;

	private _troop_group_attacker = createGroup [_side, true];

	for [{_i=0}, {_i<_troop_count}, {_i=_i+1}] do {
	 	(_list_troop call BIS_fnc_selectRandom) createUnit [_marker_spawn, _troop_group_attacker];
	};


	{
		_x allowFleeing 0;
		_x execVM "FUN\reduce_damage.sqf";
		_x allowFleeing 0;

		if (_will_join_the_caller) then {

			_x disableAI "COVER";
			_x disableAI "TARGET";
			_x disableAI "AUTOTARGET";
			_x disableAI "AUTOCOMBAT";
			_x disableAI "SUPPRESSION";
			_x setCaptive 1;
		};

	} forEach (units  _troop_group_attacker);


	_wp_troop = _troop_group_attacker addWaypoint [position _marker_troop_to_secure, 1];
	_troop_group_attacker setSpeedMode "full";
	_wp_troop setWaypointType "MOVE";
	_wp_troop waypointAttachVehicle vehicle _marker_troop_to_secure;

	if (!(_will_join_the_caller)) then {
		_troop_group_attacker setBehaviour "COMBAT";
		_wp_troop setWaypointType "SAD";
		_troop_group_attacker setSpeedMode "NORMAL";
	};

	waitUntil { (currentWaypoint (_wp_troop select 0)) > (_wp_troop select 1) };

	{
		_x allowFleeing 0;
		_x enableAI "COVER";
		_x enableAI "TARGET";
		_x enableAI "AUTOTARGET";
		_x enableAI "AUTOCOMBAT";
		_x enableAI "SUPPRESSION";
		_x setCaptive 0;

	} forEach (units  _troop_group_attacker);

	if (_will_join_the_caller) then {
		(units _troop_group_attacker) join _caller;
	};

};

