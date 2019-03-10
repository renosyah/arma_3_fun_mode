/* ----- */
/* [ player, west , ["B_T_Recon_F","B_T_Recon_JTAC_F","B_T_Soldier_F"] , ["UH1H_FFV"] , 8 , false , true ] call FUN_fnc_troopHeliReinforcement; */


/* -----*/
/* [ player, east , ["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_GL_F"] , ["O_Heli_Transport_04_covered_F"] , 12 , true , false ] call FUN_fnc_troopHeliReinforcement; */



/* ----- */

null = _this spawn { 

params[ "_caller","_side","_list_troop","_list_heli","_troop_count","_is_rapel_from_heli" ,"_will_join_the_caller"];


_marker_spawn = [[[position _caller, 1000]],[[position _caller, 900]]] call BIS_fnc_randomPos;
_marker_land_heli = _caller;
_marker_move_after_land = _marker_spawn;
_marker_troop_to_secure = _caller;

_troop_class = _list_troop;
_heli_class = _list_heli call BIS_fnc_selectRandom;

private _heli_group_attacker = createGroup [_side, true];
private _troop_group_attacker = createGroup [_side, true];

private _heli = createVehicle [_heli_class, _marker_spawn, [], 0, "FLY"];
createVehicleCrew _heli;


(crew _heli) join _heli_group_attacker;

for [{_i=0}, {_i<_troop_count}, {_i=_i+1}] do {

	 (_troop_class call BIS_fnc_selectRandom) createUnit [position _heli, _troop_group_attacker];
};

{
	_x allowFleeing 0;
	_x disableAI "COVER";
	_x disableAI "TARGET";
	_x disableAI "AUTOTARGET";
	_x disableAI "AUTOCOMBAT";
	_x disableAI "SUPPRESSION";
	_x setCaptive 1;

} forEach (units _heli_group_attacker);

{
	private _my_unit = _x;
	_my_unit allowFleeing 0;

	_my_unit execVM "FUN\reduce_damage.sqf";

	_x moveInCargo _heli;

} forEach (units  _troop_group_attacker);


_wp_heli_1 = _heli_group_attacker addWaypoint [position _marker_land_heli, 1];

_wp_heli_1 setWaypointType "MOVE";

waitUntil { (currentWaypoint (_wp_heli_1 select 0)) > (_wp_heli_1 select 1) };

if (_is_rapel_from_heli) then {
	[_heli] call AR_Rappel_All_Cargo;
} else {
	_troop_group_attacker leaveVehicle _heli;
};


_wp_troop_2 = _troop_group_attacker addWaypoint [position _marker_troop_to_secure, 2];

_wp_troop_2 setWaypointType "SAD";
_wp_troop_2 waypointAttachVehicle vehicle _marker_troop_to_secure;

waitUntil { (count (fullCrew [_heli, "cargo"]) < 1) };

_troop_group_attacker setSpeedMode "full";
_wp_heli_2 = _heli_group_attacker addWaypoint [_marker_move_after_land, 2];

_wp_heli_2 setWaypointType "MOVE";
_heli_group_attacker setSpeedMode "full";
(driver _heli) doMove (_marker_move_after_land);

if (_will_join_the_caller) then {
	(units _troop_group_attacker) join _caller;
};

waitUntil { (currentWaypoint (_wp_heli_2 select 0)) > (_wp_heli_2 select 1) };

{
	_heli deleteVehicleCrew _x;
} forEach crew _heli;

deleteVehicle _heli;

};


