private ["_objs"];
_objs = [
	["Land_LampHalogen_F",[6332.73,7829.74,0],300.909,[[-0.857984,0.513676,0],[0,0,1]],false],
	["Land_LampHalogen_F",[6303.91,7846.58,0],289.545,[[-0.942379,0.334547,0],[0,0,1]],false],
	["HeliHCivil",[6323.74,7796.83,0],0,[[0,1,0],[0,0,1]],false],
	["HeliHCivil",[6306.79,7808.8,0],0,[[0,1,0],[0,0,1]],false],
	["CDF_WarfareBBarrier10xTall",[6305.43,7850.29,0],34.5454,[[0.567059,0.823677,0],[0,0,1]],false],
	["Land_LampHalogen_F",[6352.65,7815.24,0],300.909,[[-0.857984,0.513676,0],[0,0,1]],false],
	["Land_LampHalogen_F",[6374.69,7797.44,0],300.909,[[-0.857984,0.513676,0],[0,0,1]],false],
	["CDF_WarfareBBarrier10xTall",[6319.49,7840.61,0],34.5454,[[0.567059,0.823677,0],[0,0,1]],false],
	["CDF_WarfareBBarrier10xTall",[6333.55,7830.93,0],34.5454,[[0.567059,0.823677,0],[0,0,1]],false],
	["CDF_WarfareBBarrier10xTall",[6347.61,7821.25,0],34.5454,[[0.567059,0.823677,0],[0,0,1]],false],
	["CDF_WarfareBBarrier10xTall",[6361.67,7811.57,0],34.5454,[[0.567059,0.823677,0],[0,0,1]],false],
	["CDF_WarfareBBarrier10xTall",[6375.73,7801.89,0],34.5454,[[0.567059,0.823677,0],[0,0,1]],false],
	["CDF_WarfareBBarrier10xTall",[6389.79,7792.21,0],34.5454,[[0.567059,0.823677,0],[0,0,1]],false],
	["CDF_WarfareBBarrier10xTall",[6392.35,7781.46,0],303.182,[[-0.836936,0.547301,0],[0,0,1]],false],
	["CDF_WarfareBBarrier10xTall",[6374.51,7754.69,0],303.182,[[-0.836936,0.547301,0],[0,0,1]],false],
	["CDF_WarfareBBarrier10xTall",[6363.29,7753.48,0],210.455,[[-0.506861,-0.862028,0],[-0,0,1]],false],
	["CDF_WarfareBBarrier10xTall",[6348.58,7762.13,0],210.455,[[-0.506861,-0.862028,0],[-0,0,1]],false],
	["CDF_WarfareBBarrier10xTall",[6333.86,7770.78,0],210.455,[[-0.506861,-0.862028,0],[-0,0,1]],false],
	["CDF_WarfareBBarrier10xTall",[6319.15,7779.43,0],210.455,[[-0.506861,-0.862028,0],[-0,0,1]],false],
	["CDF_WarfareBBarrier10xTall",[6304.43,7788.09,0],210.455,[[-0.506861,-0.862028,0],[-0,0,1]],false],
	["CDF_WarfareBBarrier10xTall",[6289.72,7796.74,0],210.455,[[-0.506861,-0.862028,0],[-0,0,1]],false],
	["CDF_WarfareBBarrier10xTall",[6275,7805.39,0],210.455,[[-0.506861,-0.862028,0],[-0,0,1]],false],
	["RU_WarfareBBarrier10xTall",[6294.49,7849.34,0],122.727,[[0.841256,-0.540637,0],[0,-0,1]],false],
	["RU_WarfareBBarrier10xTall",[6285.26,7834.98,0],122.727,[[0.841256,-0.540637,0],[0,-0,1]],false],
	["Land_LampAirport_F",[12158.6,12757,1.24268],192.386,[0,0,1],true]
];

{
	private ["_obj"];
	_obj = createVehicle [_x select 0, [0,0,0], [], 0, "CAN_COLLIDE"];
	if (_x select 4) then {
		_obj setDir (_x select 2);
		_obj setPos (_x select 1);
	} else {
		_obj setPosATL (_x select 1);
		_obj setVectorDirAndUp (_x select 3);
	};
} foreach _objs;