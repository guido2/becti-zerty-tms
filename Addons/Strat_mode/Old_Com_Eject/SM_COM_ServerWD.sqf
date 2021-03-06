_side=_this;
_side_logic=(_this) call CTI_CO_FNC_GetSideLogic;
diag_log format [":: COM %1 :: Starting watchdog",_side];

while {!CTI_GameOver} do {
	if (count (_side_logic getvariable "CTI_COM_VOTES") >0 ) then {
		_pl_count = {isplayer leader _x} count ((_side) call CTI_CO_FNC_GetSideGroups);
		_votes=count (_side_logic getvariable ["CTI_COM_VOTES",[]]);
		if ((_votes/_pl_count) >= CTI_VOTE_RATIO) then {
			_side_logic setvariable ["CTI_COM_VOTES",[],true];
			_curent_com_gr=_side_logic getvariable  "cti_commander";
			_curent_com_pl=objnull;
			{if (isplayer _x) then {_curent_com_pl=_x};true}count (units _curent_com_gr);
			if (!isNull _curent_com_gr) then {
				[_side,true] call CTI_COM_UNSET_SERVER;
				if ! (isnull _curent_com_pl) then { _side_logic setvariable ["CTI_COM_BLACKLIST",(_side_logic getvariable ["CTI_COM_BLACKLIST",[]])+[getPlayerUID _curent_com_pl],true];};
			};
			_side_logic setvariable ["CTI_COM_VOTES",[],true];
		};
		//diag_log format [":: COM %1 :: %2 votes %3 ratio",_side,_votes,(_votes/_pl_count)];
	};
	sleep 2;
};
diag_log format [":: COM %1 :: END watchdog",_side];