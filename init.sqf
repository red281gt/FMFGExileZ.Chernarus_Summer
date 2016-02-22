call compile preprocessFileLineNumbers "FMFG\SargeAI\scripts\Init_UPSMON.sqf";
call compile preprocessFile "FMFG\SargeAI\SHK_pos\shk_pos_init.sqf";

[] execVM "FMFG\SargeAI\sarge\SAR_AI_init.sqf";
[] execVM "FMFG\Revive\init.sqf";