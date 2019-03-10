

this addAction["Call Reinforcement!",{
params ["_target", "_caller", "_actionId", "_arguments"];

systemChat format ["%1 : Request marine reinforcement!",name _caller];

_choose_to_load = [1,2]  call BIS_fnc_selectRandom;

_marker_spawn = [[[position player, 1000]],[]] call BIS_fnc_randomPos;
_marker_land_heli = _caller;
_marker_move_after_land = _marker_spawn;
_marker_troop_to_secure = _caller;

_troop_class = ["B_T_Recon_F","B_T_Recon_JTAC_F","B_T_Soldier_F"];
_heli_class = ["UH1H_FFV","UH1H_Transport"] call BIS_fnc_selectRandom;

private _heli_group_attacker = createGroup [side _caller, true];
private _troop_group_attacker = createGroup [side _caller, true];


_heli = createVehicle [_heli_class, _marker_spawn, [], 0, "FLY"];
createVehicleCrew _heli;

(crew _heli) join _heli_group_attacker;

for [{_i=0}, {_i<8}, {_i=_i+1}] do {

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
	private _my_unit_weapon = (["hlc_rifle_Colt727","hlc_rifle_M14","hlc_rifle_SLR","hlc_lmg_m60"] call BIS_fnc_selectRandom);
	
	removeAllWeapons _my_unit;
	_my_unit unassignItem (goggles _my_unit);
	_my_unit unassignItem (hmd _my_unit);
	_my_unit unassignItem (headgear _my_unit);

	_my_unit allowFleeing 0;
	_my_unit addUniform "U_B_T_Soldier_F";
	_my_unit addHeadgear (["H_PASGT_basic_olive_F","H_Booniehat_oli","H_HeadBandage_bloody_F"] call BIS_fnc_selectRandom);
	_my_unit addWeapon _my_unit_weapon;	
	_my_unit addVest (["V_Pocketed_olive_F"] call BIS_fnc_selectRandom);
	_my_unit addBackpack (["B_Carryall_oli","B_Kitbag_rgr","B_TacticalPack_rgr"] call BIS_fnc_selectRandom);

	_my_unit_primary_ammo_array = getArray (configFile >> "CfgWeapons" >> _my_unit_weapon >> "magazines");
	{
		_my_unit addMagazines[_x,1];

	} forEach _my_unit_primary_ammo_array;

	_my_unit addItem "FirstAidkit";
	_my_unit addItem "FirstAidkit";
	_my_unit addItem "FirstAidkit";

	_my_unit execVM "FUN\reduce_damage.sqf";
	_my_unit addeventhandler ["Fired"," _this execVM 'FUN\ai_reload_handle.sqf'"];
	
	_my_unit moveInCargo _heli;

} forEach (units  _troop_group_attacker);

_target say3D [(["RadioAmbient2","RadioAmbient6","RadioAmbient8"] call BIS_fnc_selectRandom),100,1];
systemChat "Us Marine Officer : Roger, reinforcement its one the way!";

_wp_heli_1 = _heli_group_attacker addWaypoint [position _marker_land_heli, 1];

_wp_heli_1 setWaypointType "MOVE";

waitUntil { (currentWaypoint (_wp_heli_1 select 0)) > (_wp_heli_1 select 1) };

if (_choose_to_load == 1) then {

	_troop_group_attacker leaveVehicle _heli;

} else {

 	[_heli] call AR_Rappel_All_Cargo;
};


_wp_troop_2 = _troop_group_attacker addWaypoint [position _marker_troop_to_secure, 2];

_wp_troop_2 setWaypointType "GUARD";
_wp_troop_2 waypointAttachVehicle vehicle _marker_troop_to_secure;

waitUntil { (count (fullCrew [_heli, "cargo"]) < 1) };


_wp_heli_2 = _heli_group_attacker addWaypoint [_marker_move_after_land, 2];

_wp_heli_2 setWaypointType "MOVE";
_heli_group_attacker setSpeedMode "full";
(driver _heli) doMove (_marker_move_after_land);

(units _troop_group_attacker) join _unit;

waitUntil { (currentWaypoint (_wp_heli_2 select 0)) > (_wp_heli_2 select 1) };

{
	_heli deleteVehicleCrew _x;
} forEach crew _heli;

deleteVehicle _heli;


}];












this addAction["Calling Trouble!",{
params ["_target", "_caller", "_actionId", "_arguments"];

_message_taunt = ["come and get me, cunt!","iam ready to fight you!","where is your pathetic troops!"]  call BIS_fnc_selectRandom;

systemChat format ["%1 : %2",name _caller,_message_taunt];


_marker_spawn = [[[position player, 1000]],[]] call BIS_fnc_randomPos;
_marker_land_heli = _caller;
_marker_move_after_land = _marker_spawn;
_marker_troop_to_secure = _caller;

_troop_class = ["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_GL_F"];
_heli_class = ["O_Heli_Transport_04_covered_F"] call BIS_fnc_selectRandom;

private _heli_group_attacker = createGroup [east, true];
private _troop_group_attacker = createGroup [east, true];


_heli = createVehicle [_heli_class, _marker_spawn, [], 0, "FLY"];
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
	_my_unit addeventhandler ["Fired"," _this execVM 'FUN\ai_reload_handle.sqf'"];

	_x moveInCargo _heli;

} forEach (units  _troop_group_attacker);

_target say3D [(["RadioAmbient2","RadioAmbient6","RadioAmbient8"] call BIS_fnc_selectRandom),100,1];

_message_response = ["we send team to kill you!","this is geting out of hand!","shut up, you will die shotly!"]  call BIS_fnc_selectRandom;
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


}];