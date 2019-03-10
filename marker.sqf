addMissionEventHandler [ "Draw3D", {

	{
		_distance = (cameraOn distanceSqr _x) / ( 130^2 );
		_distance_for_name = (cameraOn distanceSqr _x) / ( 6^2 );

		_x selectionPosition "head" params[ "_headX", "_headY", "_headZ" ];

		_tag_1_pos = _x modelToWorldVisual [ _headX - 0.05, _headY, _headZ + 0.5  + _distance];
		_tag_2_pos = _x modelToWorldVisual [ _headX - 0.05, _headY, _headZ + 0.7  + _distance];

		_color_blufor = [0,0,1,1];
		_color_opfor = [0.9,0,0,1];
		_color_ind = [0,0.5,0,1];
		_color_civ = [0.4,0,0.5,1];
		_color_neutral = [1,1,1,1];

		_color_code = _color_neutral;
		_color_code_name = _color_neutral;

		_text_name = parseText format ["%1. %2",rank _x,name _x];
		_text = parseText format ["HP %1%2",(((1.00 - (damage _x)) * 100) toFixed 0),"%"];

		_score = score _x;

		_record_kill = parseText format ["Kills : %1",_score];

		if ( isPlayer _x) then {
			_tag_1_pos = _x modelToWorldVisual [ _headX - 0.05, _headY, _headZ - 0.2 + _distance];
			_tag_2_pos = _x modelToWorldVisual [ _headX - 0.05, _headY, _headZ - 0.1 + _distance];
			_text = _record_kill;
		};
		if (side _x == west) then {

			_color_code = _color_blufor;
			_color_code_name = _color_blufor;

		};
		 if (side _x == east) then {

			_color_code = _color_opfor;
			_color_code_name = _color_opfor;

		};
		 if (side _x == resistance) then {

			_color_code = _color_ind;
			_color_code_name = _color_ind;

		};
		if (side _x == civilian) then {

			_color_code = _color_civ;
			_color_code_name = _color_civ;
		};

		if (_score == 0 && isPlayer _x) then {
			_text = "";
		};

		_color_code_to_show = +_color_code;
		_color_code_name_show = +_color_code_name;

		_color_code_to_show set [3,1.5 - _distance];
		_color_code_name_show set [3,1.5 - _distance_for_name];

		if ((vehicle _x == _x) && (side _x in [west,east,civilian,resistance])) then {
			drawIcon3D ["",_color_code_to_show,_tag_1_pos, 0.8, 0, 0, format ["%1",_text], 2,  0.0315, "EtelkaMonospacePro"];
			drawIcon3D ["",_color_code_name_show, _tag_2_pos, 0.8, 0, 0, format ["%1",_text_name], 2,  0.0255, "EtelkaMonospacePro"];
		};

	
	}forEach AllUnits;
}];