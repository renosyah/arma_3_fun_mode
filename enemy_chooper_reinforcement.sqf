params[ "_unit" ];

private _caller = _unit;

_message_taunt = ["is that the best you can do?!!","come and get me, cunt!","iam ready to fight you!","where is your pathetic troops!"]  call BIS_fnc_selectRandom;

systemChat format ["%1 : %2",name _caller,_message_taunt];


_marker_spawn = [[[position player, 1000]],[]] call BIS_fnc_randomPos;
_marker_land_heli = _caller;
_marker_move_after_land = _marker_spawn;
_marker_troop_to_secure = _caller;

_troop_class = ["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_GL_F"];
_heli_class = ["O_Heli_Transport_04_covered_F"] call BIS_fnc_selectRandom;

private _heli_group_attacker = createGroup [east, true];
private _troop_group_attacker = createGroup [east, true];


private _heli = createVehicle [_heli_class, _marker_spawn, [], 0, "FLY"];
createVehicleCrew _heli;


(crew _heli) join _heli_group_attacker;

for [{_i=0}, {_i<12}, {_i=_i+1}] do {

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


_message_response = ["we send team to kill you!","this is geting out of hand!","shut up, you will die shotly!","fuck off!, we will see you, in body bag!"]  call BIS_fnc_selectRandom;
systemChat format ["CSAT officer : %1",_message_response];

_wp_heli_1 = _heli_group_attacker addWaypoint [position _marker_land_heli, 1];

_wp_heli_1 setWaypointType "MOVE";

waitUntil { (currentWaypoint (_wp_heli_1 select 0)) > (_wp_heli_1 select 1) };

[_heli] call AR_Rappel_All_Cargo;

_wp_troop_2 = _troop_group_attacker addWaypoint [position _marker_troop_to_secure, 2];

_wp_troop_2 setWaypointType "SAD";
_wp_troop_2 waypointAttachVehicle vehicle _marker_troop_to_secure;

waitUntil { (count (fullCrew [_heli, "cargo"]) < 1) };

_troop_group_attacker setSpeedMode "full";
_wp_heli_2 = _heli_group_attacker addWaypoint [_marker_move_after_land, 2];

_wp_heli_2 setWaypointType "MOVE";
_heli_group_attacker setSpeedMode "full";
(driver _heli) doMove (_marker_move_after_land);

waitUntil { (currentWaypoint (_wp_heli_2 select 0)) > (_wp_heli_2 select 1) };

{
	_heli deleteVehicleCrew _x;
} forEach crew _heli;

deleteVehicle _heli;

