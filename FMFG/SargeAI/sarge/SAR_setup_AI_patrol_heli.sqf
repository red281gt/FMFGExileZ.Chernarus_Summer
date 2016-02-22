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
private ["_ai_type","_riflemenlist","_side","_leader_group","_patrol_area_name","_rndpos","_groupheli","_heli","_leader","_man2heli","_man3heli","_argc","_grouptype","_respawn","_leader_weapon_names","_leader_items","_leader_tools","_soldier_weapon_names","_soldier_items","_soldier_tools","_leaderskills","_sniperskills","_ups_para_list","_type","_error","_respawn_time","_leadername"];

if (!isServer) exitWith {};

_patrol_area_name = _this select 0;
_argc = count _this;
_error = false;

if (_argc > 1) then {
    _grouptype = _this select 1;
    switch (_grouptype) do
    {
        case 1:
        {
            _side = SAR_AI_friendly_side;
            _type = "sold";
            _ai_type = "AI Military";
        };
        case 2:
        {
            _side = SAR_AI_friendly_side;
            _type = "surv";
            _ai_type = "AI Survivor";
        };
        case 3:
        {
            _side = SAR_AI_unfriendly_side;
            _type = "band";
            _ai_type = "AI Bandit";
        };
    };
    _leader_group = call compile format ["SAR_leader_%1_list",_type] call BIS_fnc_selectRandom;
    _riflemenlist = call compile format ["SAR_soldier_%1_list",_type];

    _leaderskills = call compile format ["SAR_leader_%1_skills",_type];

    _sniperskills = call compile format ["SAR_sniper_%1_skills",_type];

    _leader_weapon_names = ["leader",_type] call SAR_unit_loadout_weapons;
    _leader_items = ["leader",_type] call SAR_unit_loadout_items;
    _leader_tools = ["leader",_type] call SAR_unit_loadout_tools;
	
} else {
	_error = true;
};

if (_argc > 2) then {
    _respawn = _this select 2;
} else {
    _respawn = false;
};

if (_argc > 3) then {
    _respawn_time = _this select 3;
} else {
    _respawn_time = SAR_respawn_waittime;
};

if (_error) exitWith {diag_log "SAR_AI: Heli patrol setup failed, wrong parameters passed!";};

// get a random starting position, UPSMON will handle the rest
_rndpos = [_patrol_area_name] call SHK_pos;

_groupheli = createGroup _side;

// protect group from being deleted by DayZ
_groupheli setVariable ["SAR_protect",true,true];

// create the vehicle
_heli = createVehicle [(SAR_heli_type call BIS_fnc_selectRandom), [(_rndpos select 0) + 10, _rndpos select 1, 80], [], 0, "FLY"];
_heli setFuel 1;
_heli setVariable ["Sarge",1,true];
_heli engineon true;
_heli setVehicleAmmo 1;

_heli addMPEventHandler ["HandleDamage", {_this spawn SAR_AI_VEH_HIT;_this select 2;}];

[_heli] joinSilent _groupheli;

_leader = _groupheli createunit [_leader_group, [(_rndpos select 0) + 10, _rndpos select 1, 0], [], 0.5, "NONE"];

[_leader,_leader_weapon_names,_leader_items,_leader_tools] call SAR_unit_loadout;

[_leader] spawn SAR_AI_trace_veh;
switch (_grouptype) do
{
	case 1:{_leader setIdentity "id_SAR_sold_man";};
	case 2:{_leader setIdentity "id_SAR_surv_lead";};
	case 3:{_leader setIdentity "id_SAR_band";};
};
[_leader] spawn SAR_AI_reammo;
	
_leader addMPEventHandler ["MPkilled", {Null = _this spawn SAR_AI_killed;}];
_leader addMPEventHandler ["MPHit", {Null = _this spawn SAR_AI_hit;}];

_leader moveInDriver _heli;
_leader assignAsDriver _heli;

[_leader] joinSilent _groupheli;

{
    _leader setskill [_x select 0,(_x select 1 +(floor(random 2) * (_x select 2)))];
} foreach _leaderskills;

SAR_leader_number = SAR_leader_number + 1;
_leadername = format["SAR_leader_%1",SAR_leader_number];

_leader setVehicleVarname _leadername;
_leader setVariable ["SAR_leader_name",_leadername,false];

// store AI type on the AI
_leader setVariable ["SAR_AI_type",_ai_type + " Leader",false];

// set behaviour & speedmode
_leader setspeedmode "FULL";
_leader setBehaviour "AWARE";


// Gunner 1
_man2heli = _groupheli createunit [_riflemenlist call BIS_fnc_selectRandom, [(_rndpos select 0) - 30, _rndpos select 1, 0], [], 0.5, "NONE"];

_soldier_weapon_names = ["rifleman",_type] call SAR_unit_loadout_weapons;
_soldier_items = ["rifleman",_type] call SAR_unit_loadout_items;
_soldier_tools = ["rifleman",_type] call SAR_unit_loadout_tools;
[_man2heli,_soldier_weapon_names,_soldier_items,_soldier_tools] call SAR_unit_loadout;

_man2heli moveInTurret [_heli,[0]];

[_man2heli] spawn SAR_AI_trace_veh;
switch (_grouptype) do
{
	case 1:{_man2heli setIdentity "id_SAR_sold_man";};
	case 2:{_man2heli setIdentity "id_SAR_surv_lead";};
	case 3:{_man2heli setIdentity "id_SAR_band";};
};
[_man2heli] spawn SAR_AI_reammo;

_man2heli addMPEventHandler ["MPkilled", {Null = _this spawn SAR_AI_killed;}];
_man2heli addMPEventHandler ["MPHit", {Null = _this spawn SAR_AI_hit;}];
_man2heli addMPEventHandler ["HandleDamage",{if (_this select 1!="") then {_unit=_this select 0;damage _unit+((_this select 2)-damage _unit)*1}}];
[_man2heli] joinSilent _groupheli;

// set skills
{
    _man2heli setskill [_x select 0,(_x select 1 +(floor(random 2) * (_x select 2)))];
} foreach _sniperskills;

// store AI type on the AI
_man2heli setVariable ["SAR_AI_type",_ai_type,false];


//Gunner 2
_man3heli = _groupheli createunit [_riflemenlist call BIS_fnc_selectRandom, [_rndpos select 0, (_rndpos select 1) + 30, 0], [], 0.5, "NONE"];

_soldier_weapon_names = ["rifleman",_type] call SAR_unit_loadout_weapons;
_soldier_items = ["rifleman",_type] call SAR_unit_loadout_items;
_soldier_tools = ["rifleman",_type] call SAR_unit_loadout_tools;

[_man3heli,_soldier_weapon_names,_soldier_items,_soldier_tools] call SAR_unit_loadout;

_man3heli moveInTurret [_heli,[1]];

[_man3heli] spawn SAR_AI_trace_veh;
switch (_grouptype) do
{
	case 1:{_man3heli setIdentity "id_SAR_sold_man";};
	case 2:{_man3heli setIdentity "id_SAR_surv_lead";};
	case 3:{_man3heli setIdentity "id_SAR_band";};
};
[_man3heli] spawn SAR_AI_reammo;

_man3heli addMPEventHandler ["MPkilled", {Null = _this spawn SAR_AI_killed;}];
_man3heli addMPEventHandler ["MPHit", {Null = _this spawn SAR_AI_hit;}];
_man3heli addMPEventHandler ["HandleDamage",{if (_this select 1!="") then {_unit=_this select 0;damage _unit+((_this select 2)-damage _unit)*1}}];
[_man3heli] joinSilent _groupheli;

// set skills
{
    _man3heli setskill [_x select 0,(_x select 1 +(floor(random 2) * (_x select 2)))];
} foreach _sniperskills;

// store AI type on the AI
_man3heli setVariable ["SAR_AI_type",_ai_type,false];

if (SAR_HC) then {
	{
		_hcID = getPlayerUID _x;
		if(_hcID select [0,2] isEqualTo 'HC')then {
			_SAIS_HC = _groupheli setGroupOwner (owner _x);
			if (_SAIS_HC) then {
				if (SAR_DEBUG) then {
					diag_log format ["Sarge's AI System: Moved group %1 to Headless Client %2",_groupheli,_hcID];
				};
			} else {
				if (SAR_DEBUG) then {
					diag_log format ["Sarge's AI System: Moving group %1 to Headless Client %2 has failed",_groupheli,_hcID];
				};
			};
		};
	} forEach allPlayers;
};

// initialize upsmon for the group
_leader = leader _groupheli;
_ups_para_list = [_leader,_patrol_area_name,'nofollow','aware','spawned','delete:',SAR_DELETE_TIMEOUT];

if (_respawn) then {
    _ups_para_list = _ups_para_list + ['respawn'];
    _ups_para_list set [count _ups_para_list,'respawntime:'];
    _ups_para_list set [count _ups_para_list,_respawn_time];
};

_ups_para_list spawn UPSMON;

if(SAR_DEBUG) then {
    diag_log format["Sarge's AI System: AI Heli patrol (%2) spawned in: %1.",_patrol_area_name,_groupheli];
};

_groupheli;