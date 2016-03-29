[10,true,true,40] execFSM "FMFG\timeModule.fsm";
if (isDedicated || isServer) then {
	"do_MakeBike" addPublicVariableEventHandler {
		_parameters = (_this select 1);
		_parameters2  =(_parameters select 1);
		diag_log format ["createVehicleRequested %1 ", _parameters]; // YOU NEED THIS FOR LOGS TO SEE WHO DID IT
		veh = createVehicle["Exile_Bike_MountainBike", _parameters2 , [] ,0 , "NONE"];
	};
};
if (isServer) then {
	//fn_getBuildingstospawnLoot = compile preProcessFileLineNumbers "FMFG\loot\fn_LSgetBuildingstospawnLoot.sqf";
   // LSdeleter = compile preProcessFileLineNumbers "FMFG\loot\LSdeleter.sqf";
    //execVM "FMFG\loot\Lootspawner.sqf";
    execVM "SearchAndReplace.sqf";
};
