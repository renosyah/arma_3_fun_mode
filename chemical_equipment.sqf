params[ "_unit" ];

_random_gas_mask = ["avon_fm12","avon_fm12_strapless","avon_ct12","avon_ct12_strapless","avon_SF12","avon_SF12_strapless"] call BIS_fnc_selectRandom;

_unit addItem _random_gas_mask;

_unit removeMagazines "HandGrenade";
_unit removeMagazines "MiniGrenade";

_unit addItem "CBRN_Grenade_S";
_unit addItem "CBRN_Grenade_S";
_unit addItem "CBRN_Grenade_S";
_unit addItem "CBRN_Grenade_S";
_unit addItem "CBRN_Grenade_S";