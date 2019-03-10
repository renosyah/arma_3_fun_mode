if !(hasInterface) exitWith{};

waitUntil {!isNull player};

[] spawn {
	if (!isDedicated) then
	{
		[] execVM "FUN\fun_mode.sqf";
	};
};


	