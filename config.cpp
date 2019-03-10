class CfgPatches 
{
	class FUN_Mode
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"A3_Data_F"};
		author[] = {"RENO"};
	};
};

class CfgCommunicationMenu
{
	class CallMarineSoldier
	{
		text = "Recuit Marine!";
        	expression = "player execVM 'FUN\call_one_marine_reinforcement.sqf';";
        	cursor = "";
        	enable = "1";
        	removeAfterExpressionCall = 0;
	};
	class CallMarineSquadHeli
	{
		text = "Marine Squad!";
        	expression = "player execVM 'FUN\call_marine_reinforcement.sqf';";
        	cursor = "";
        	enable = "1";
        	removeAfterExpressionCall = 0;
	};
};

class CfgFunctions
{
	class FUN
	{
		class fun_mode
		{
			class postinit
			{
				preInit = 0;
				postInit = 1;
				file = "\FUN\postinit.sqf";
			};

			class fun_mode
			{
				file = "\FUN\fun_mode.sqf";
			};

			class reduce_damage
			{
				file = "\FUN\reduce_damage.sqf";
			};

			class reload_auto
			{
				file = "\FUN\reload_auto.sqf";
			};
			
			class ai_reload_handle
			{
				file = "\FUN\ai_reload_handle.sqf";
			};

			class chemical_equipment
			{
				file = "\FUN\chemical_equipment.sqf";
			};

			class bonus_mag
			{
				file = "\FUN\bonus_mag.sqf";
			};
			class troopHeliReinforcement
			{
				file = "\FUN\function\troopHeliReinforcement.sqf";
			};
			class troopReinforcement
			{
				file = "\FUN\function\troopReinforcement.sqf";
			};
		};
	};
};
