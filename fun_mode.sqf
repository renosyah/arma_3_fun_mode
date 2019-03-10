player switchCamera "External";
player enableStamina false;
player addeventhandler ["Fired"," _this execVM 'FUN\reload_auto.sqf'"];

[player,"CallMarineSquadHeli"] call BIS_fnc_addCommMenuItem;

//[] execVM "FUN\marker.sqf";

{

	
	_x addEventHandler ["Killed"," _this execVM 'FUN\reward_box.sqf'"];

	_x execVM "FUN\reduce_damage.sqf";
	_x addeventhandler ["respawn"," _this execVM 'FUN\reduce_damage.sqf'"];

	//_x execVM "FUN\chemical_equipment.sqf";
	//_x addeventhandler ["respawn"," _this execVM 'FUN\chemical_equipment.sqf'"];

	//if ( !(isPlayer _x) ) then {
	//	_x addeventhandler ["Fired"," _this execVM 'FUN\ai_reload_handle.sqf'"];
	//};

	//_x execVM "FUN\bonus_mag.sqf";
	//_x addeventhandler ["respawn"," _this execVM 'FUN\bonus_mag.sqf'"];

} forEach allUnits;