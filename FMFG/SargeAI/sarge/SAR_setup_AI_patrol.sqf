/*
	# Original #
	Sarge AI System 1.5
	Created for Arma 2: DayZ Mod
	Author: Sarge
	https://github.com/Swiss-Sarge

	# Fork #
	Sarge AI System 2.0+
	Modded for Arma 3: Exile Mod
	Changes: Dango
	http://www.hod-servers.com

*/
private ["_leadername","_type","_patrol_area_name","_grouptype","_snipers","_riflemen","_action","_side","_leader_group","_riflemenlist","_sniperlist","_rndpos","_group","_leader","_cond","_respawn","_leader_weapon_names","_leader_items","_leader_tools","_soldier_weapon_names","_soldier_items","_soldier_tools","_sniper_weapon_names","_sniper_items","_sniper_tools","_leaderskills","_riflemanskills","_sniperskills","_ups_para_list","_respawn_time","_argc","_ai_type"];

if (!isServer) exitWith {};

_patrol_area_name = _this select 0;
_grouptype = _this select 1;
_snipers = _this select 2;
_riflemen = _this select 3;
_action = tolower (_this select 4);
_respawn = _this select 5;

_argc = count _this;

if (_argc > 6) then {
    _respawn_time = _this select 6;
} else {
    _respawn_time = SAR_respawn_waittime;
};

switch (_grouptype) do
{
    case 1: // military
    {
        _side = SAR_AI_friendly_side;
        _type = "sold";
        _ai_type = "AI Military";
    };
    case 2: // survivors
    {
        _side = SAR_AI_friendly_side;
        _type = "surv";
        _ai_type = "AI Survivor";
    };
    case 3: // bandits
    {
        _side = SAR_AI_unfriendly_side;
        _type = "band";
        _ai_type = "AI Bandit";
    };
};

_leader_group = call compile format ["SAR_leader_%1_list",_type] call BIS_fnc_selectRandom;

_riflemenlist = call compile format ["SAR_soldier_%1_list",_type];
_sniperlist = call compile format ["SAR_sniper_%1_list",_type];

_leaderskills = call compile format ["SAR_leader_%1_skills",_type];
_riflemanskills = call compile format ["SAR_soldier_%1_skills",_type];
_sniperskills = call compile format ["SAR_sniper_%1_skills",_type];

// get a random starting position that is on land
_rndpos = [_patrol_area_name] call SHK_pos;

_group = createGroup _side;

// create leader of the group
_leader = _group createunit [_leader_group, [(_rndpos select 0) , _rndpos select 1, 0], [], 0.5, "NONE"];

_leader_weapon_names = ["leader",_type] call SAR_unit_loadout_weapons;
_leader_items = ["leader",_type] call SAR_unit_loadout_items;
_leader_tools = ["leader",_type] call SAR_unit_loadout_tools;

[_leader,_leader_weapon_names,_leader_items,_leader_tools] call SAR_unit_loadout;

[_leader] spawn SAR_AI_trace;
_leader setIdentity "id_SAR_sold_lead";
[_leader] spawn SAR_AI_reammo;

_leader addMPEventHandler ["MPkilled", {Null = _this spawn  SAR_AI_killed;}];
_leader addMPEventHandler ["MPHit", {Null = _this spawn SAR_AI_hit;}];

[_leader] joinSilent _group;
	
// set skills of the leader
{
    _leader setskill [_x select 0,(_x select 1 +(floor(random 2) * (_x select 2)))];
} foreach _leaderskills;

// define and store the leadername
SAR_leader_number = SAR_leader_number + 1;
_leadername = format ["SAR_leader_%1",SAR_leader_number];

_leader setVehicleVarname _leadername;
_leader setVariable ["SAR_leader_name",_leadername,false];

// store AI type on the AI
_leader setVariable ["SAR_AI_type",_ai_type + " Leader",false];

// set behaviour & speedmode
_leader setspeedmode "FULL";
_leader setBehaviour "AWARE";

// if needed broadcast to the clients
//_leader Call Compile Format ["%1=_This ; PublicVariable ""%1""",_leadername];

// create crew
for "_i" from 0 to (_snipers - 1) do
{
    _this = _group createunit [_sniperlist call BIS_fnc_selectRandom, [(_rndpos select 0), _rndpos select 1, 0], [], 0.5, "NONE"];
	
    _sniper_weapon_names = ["sniper",_type] call SAR_unit_loadout_weapons;
    _sniper_items = ["sniper",_type] call SAR_unit_loadout_items;
    _sniper_tools = ["sniper",_type] call SAR_unit_loadout_tools;

    [_this,_sniper_weapon_names,_sniper_items,_sniper_tools] call SAR_unit_loadout;

	[_this] spawn SAR_AI_trace;
	_this setIdentity "id_SAR";
	[_this] spawn SAR_AI_reammo;

    _this addMPEventHandler ["MPkilled", {Null = _this spawn SAR_AI_killed;}];
    _this addMPEventHandler ["MPHit", {Null = _this spawn SAR_AI_hit;}];
    _this addMPEventHandler ["HandleDamage",{if (_this select 1!="") then {_unit=_this select 0;damage _unit+((_this select 2)-damage _unit)*1}}];

    [_this] joinSilent _group;
	
    // set skills
    {
        _this setskill [_x select 0,(_x select 1 +(floor(random 2) * (_x select 2)))];
    } foreach _sniperskills;

    // store AI type on the AI
    _this setVariable ["SAR_AI_type",_ai_type,false];
};

for "_i" from 0 to (_riflemen - 1) do
{
    _this = _group createunit [_riflemenlist call BIS_fnc_selectRandom, [(_rndpos select 0) , _rndpos select 1, 0], [], 0.5, "NONE"];

    _soldier_items = ["rifleman",_type] call SAR_unit_loadout_items;
    _soldier_tools = ["rifleman",_type] call SAR_unit_loadout_tools;
    _soldier_weapon_names = ["rifleman",_type] call SAR_unit_loadout_weapons;

    [_this,_soldier_weapon_names,_soldier_items,_soldier_tools] call SAR_unit_loadout;

	[_this] spawn SAR_AI_trace;
	_this setIdentity "id_SAR_sold_man";
	[_this] spawn SAR_AI_reammo;

    _this addMPEventHandler ["MPkilled", {Null = _this spawn SAR_AI_killed;}];
    _this addMPEventHandler ["MPHit", {Null = _this spawn SAR_AI_hit;}];
    _this addMPEventHandler ["HandleDamage",{if (_this select 1!="") then {_unit=_this select 0;damage _unit+((_this select 2)-damage _unit)*1}}];

    [_this] joinSilent _group;

    // set skills
    {
        _this setskill [_x select 0,(_x select 1 +(floor(random 2) * (_x select 2)))];
    } foreach _riflemanskills;

    // store AI type on the AI
    _this setVariable ["SAR_AI_type",_ai_type,false];
};

if (SAR_HC) then {
	{
		_hcID = getPlayerUID _x;
		if(_hcID select [0,2] isEqualTo 'HC')then {
			_SAIS_HC = _group setGroupOwner (owner _x);
			if (_SAIS_HC) then {
				if (SAR_DEBUG) then {
					diag_log format ["Sarge's AI System: Moved group %1 to Headless Client %2",_group,_hcID];
				};
			} else {
				if (SAR_DEBUG) then {
					diag_log format ["Sarge's AI System: Moving group %1 to Headless Client %2 has failed",_group,_hcID];
				};
			};
		};
	} forEach allPlayers;
};

// initialize upsmon for the group
_leader = leader _group;
_ups_para_list = [_leader,_patrol_area_name,'nofollow','aware','spawned','delete:',SAR_DELETE_TIMEOUT];

if (_respawn) then {
    _ups_para_list set [count _ups_para_list,'respawn'];
    _ups_para_list set [count _ups_para_list,'respawntime:'];
    _ups_para_list set [count _ups_para_list,_respawn_time];
};

if(!SAR_AI_STEAL_VEHICLE) then {
    _ups_para_list set [count _ups_para_list,'noveh'];
};

if(SAR_AI_disable_UPSMON_AI) then {
	_ups_para_list set [count _ups_para_list,'noai'];
};

if(_action == "") then {_action = "patrol";};

switch (_action) do {

    case "noupsmon":
    {
    };
    case "fortify":
    {
        _ups_para_list set [count _ups_para_list,'fortify'];
        _ups_para_list spawn UPSMON;
    };
    case "patrol":
    {
        _ups_para_list spawn UPSMON;
    };
    case "ambush":
    {
        _ups_para_list set [count _ups_para_list,'ambush'];
        _ups_para_list spawn UPSMON;
    };
	default
	{
		_ups_para_list spawn UPSMON;
	};
};

if (SAR_DEBUG) then {
    diag_log format ["Sarge's AI System: Infantry group (%3) spawned in: %1 with action: %2 on side: %4",_patrol_area_name,_action,_group,(side _group)];
};

_group;