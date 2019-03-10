params[ "_unit" ];

private _marker_spawn = [[[position _unit, 80]],[[position _unit, 75]]] call BIS_fnc_randomPos;

private _marker_troop_to_secure = _unit;

private _troop_class = ["B_T_Recon_F","B_T_Recon_JTAC_F","B_T_Soldier_F"];
private _troop_group_attacker = createGroup [civilian, true];

(_troop_class call BIS_fnc_selectRandom) createUnit [_marker_spawn, _troop_group_attacker];

{
	private _my_unit = _x;
	private _my_unit_weapon = (["hlc_rifle_Colt727","hlc_rifle_M14","hlc_rifle_Colt727","hlc_rifle_SLR","hlc_rifle_Colt727","hlc_lmg_m60","hlc_rifle_Colt727"] call BIS_fnc_selectRandom);
	
	removeAllWeapons _my_unit;
	_my_unit unassignItem (goggles _my_unit);
	_my_unit unassignItem (hmd _my_unit);
	_my_unit unassignItem (headgear _my_unit);

	_my_unit setSkill 1;
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

} forEach (units  _troop_group_attacker);
{
	_x allowFleeing 0;
	_x disableAI "COVER";
	_x disableAI "TARGET";
	_x disableAI "AUTOTARGET";
	_x disableAI "AUTOCOMBAT";
	_x disableAI "SUPPRESSION";
	_x setCaptive 1;

} forEach (units  _troop_group_attacker);

_wp_troop = _troop_group_attacker addWaypoint [position _marker_troop_to_secure, 1];

_wp_troop setWaypointType "MOVE";
_wp_troop waypointAttachVehicle vehicle _marker_troop_to_secure;

_troop_group_attacker setSpeedMode "full";

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

(units _troop_group_attacker) join _unit;

