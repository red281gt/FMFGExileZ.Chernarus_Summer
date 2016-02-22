[] spawn {    
		waitUntil{player == player};
		playSound "intro";
		_worldName = switch(toLower worldName)do{
                case "altis"             :{"Altis"};
                case "bornholm"             :{"Bornholm"};
                case "chernarus"             :{"Chernarus"};
                default{worldName};
        };
        /* GR8 */
        [[format["Welcome %2, to [FMFG] FMFG Down South Exile %1", _worldName, name player],"","Double Click On Radio To Deploy Bike,"Click 7 to Open View Distance Menu","","","","",""," ","","","",""], -.5, .85] call BIS_fnc_typeText;
        //sleep 2;
        [["Visit Us At:","www.FMFCLANDIVISION.com","For Rules"," And Forums","",""], .5, .85] call BIS_fnc_typeText;
        /* GR8 */
};