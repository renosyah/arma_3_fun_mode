params[ "_unit" ];

// Damage reduction from https://forums.bistudio.com/forums/topic/198136-reducing-player-damage/

// Exit if we are a player and not local
// Otherwise add EH for AI every where just in case their locality
// changes due to moving into a players group
// the EH will only fire where the AI is local
if ( isPlayer _unit && { !local _unit } ) exitWith {};

//if ( isPlayer _unit ) then {
//	_unit removeAllEventHandlers 'HandleDamage';
//};

// Only damage from last applied handleDamage EH is taken into consideration by the engine
// Apply a new EH so as we can override the damage applied
_unit addEventHandler [ "HandleDamage", {
	params ["_unit", "_hitSelection", "_damage","_source","_projectile","_hitPartIndex", "_instigator", "_hitPoint"];

	// Damage multipliers.  The damage of each projectile will be multiplied by this number.
	private _damageMultiplierHead = 0.09;
	private _damageMultiplierBody = 0.025;
	private _damageMultiplierLimbs = 0.035;
	private _damageMultiplierOverall = 0.025;

	// Damage limits.  Each projectile will be limited to a max of this much damage.
	private _limitHead = 0.8;
	private _limitBody = 0.6;
	private _limitLimbs = 0.4;
	private _limitOverall = 0.2;

	private _oldDamage = 0;
	if (_hitSelection isEqualTo "") then {_oldDamage = damage _unit} else {_oldDamage = _unit getHit _hitSelection};
	private _newDamage = _damage - _oldDamage max 0;
	private _incomingDamage = _newDamage;
	private _playerHealth = damage _unit;

	// Infantry selections
	// Keep in mind that if revive is enabled then incapacitation may occur at around 0.7 damage.
	// "": The overall damage that determines the damage value of the unit. Unit dies at damage equal to or above 1
	// "face_hub": Unit dies at damage equal to or above 1
	// "neck": Unit dies at damage equal to or above 1
	// "head": Unit dies at damage equal to or above 1
	// "pelvis": Unit dies at damage equal to or above 1
	// "spine1": Unit dies at damage equal to or above 1
	// "spine2": Unit dies at damage equal to or above 1
	// "spine3": Unit dies at damage equal to or above 1
	// "body": Unit dies at damage equal to or above 1
	// "arms": Unit doesn't die with damage to this part
	// "hands": Unit doesn't die with damage to this part
	// "legs": Unit doesn't die with damage to this part

	// Do any other damage calculations here
	// _damage is the previous damage plus any new damage and will be applied
	// as the total damage the unit has for this selection once this EH returns

	// Only modify damage if it is a known projectile (leave falling damage etc alone)
	if (_newDamage > 0 && !(_projectile isEqualTo "")) then {
		// Reduce damage by damage multiplier
		private _damageMultiplier = _damageMultiplierBody;
		private _upperLimit = _limitBody;
		switch (_hitSelection) do {
			case "face_hub";
			case "head": {
				_damageMultiplier = _damageMultiplierHead;
				_upperLimit = _limitHead;
			};
			case "arms";
			case "hands";
			case "legs": {
				_damageMultiplier = _damageMultiplierLimbs;
				_upperLimit = _limitLimbs;
			};
			case "": {
				_damageMultiplier = _damageMultiplierOverall;
				_upperLimit = _limitOverall;
			};
			default { 
				_damageMultiplier = _damageMultiplierBody;
				_upperLimit = _limitBody;
			};
		};
		_newDamage = _newDamage * _damageMultiplier;

		// Place an upper limit on projectile damage done at once
		if (_newDamage > _upperLimit) then {
			_newDamage = _upperLimit;
		};

		_damage = _oldDamage + _newDamage;
	};
	
	// For players ignore damage if they are incapacitated and pass damage to bis revive handler
	if ( isPlayer _unit ) then {
		if ( lifeState _unit == "INCAPACITATED" ) then {
			//if we are incapacitated take no additional damage
			_damage = _oldDamage;
		} else {
			_this set[ 2, _damage ];
			//Call BI REVIVE HandleDamage EH passing new _damage value
			_damage = _this call bis_fnc_reviveEhHandleDamage;
		};
	};
	if (_damage > 0.3) then {
		_unit unassignItem (goggles _unit);
	};
	if (_damage > 0.9) then {
		_unit unassignItem (hmd _unit);
		if (headgear _unit != "H_HeadBandage_bloody_F") then {
			_unit unassignItem (headgear _unit);
		};
		_unit addHeadgear "H_HeadBandage_bloody_F";
	};


	_damage
	
}];
