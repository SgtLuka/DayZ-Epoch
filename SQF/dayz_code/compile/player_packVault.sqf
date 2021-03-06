/*
	_obj spawn player_packVault;
*/

if (dayz_actionInProgress) exitWith {localize "str_player_actionslimit" call dayz_rollingMessages;};
dayz_actionInProgress = true;

private ["_code","_obj","_ownerID","_objectID","_objectUID","_packedClass","_text","_playerNear","_finished","_ComboMatch","_typeOf"];

_obj = _this;
_typeOf = typeOf _obj;
_packedClass = getText (configFile >> "CfgVehicles" >> _typeOf >> "packedClass");
_text = getText (configFile >> "CfgVehicles" >> _typeOf >> "displayName");

if (isNull _obj || !(alive _obj)) exitWith {dayz_actionInProgress = false;};

_playerNear = {isPlayer _x} count (([_obj] call FNC_GetPos) nearEntities ["CAManBase", 10]) > 1;
if (_playerNear) exitWith {dayz_actionInProgress = false; localize "str_pickup_limit_5" call dayz_rollingMessages;};

_ownerID = _obj getVariable["CharacterID","0"];
_objectID = _obj getVariable["ObjectID","0"];
_objectUID = _obj getVariable["ObjectUID","0"];
_ComboMatch = (_ownerID == dayz_combination);
if (DZE_permanentPlot) then {_ownerID = _obj getVariable["ownerPUID","0"];};

player removeAction s_player_packvault;
s_player_packvault = 1;

if (_objectID == "0" && _objectUID == "0") exitWith {dayz_actionInProgress = false; s_player_packvault = -1; format[localize "str_epoch_player_118",_text] call dayz_rollingMessages;};

if (!_ComboMatch && (_ownerID != dayz_playerUID)) exitWith {dayz_actionInProgress = false; s_player_packvault = -1; format[localize "str_epoch_player_119",_text] call dayz_rollingMessages;};

if (isNull _obj && {!alive _obj}) exitWith {s_player_packvault = -1;dayz_actionInProgress = false;};
[player,(getPosATL player),20,"tentpack"] spawn fnc_alertZombies;

format[localize "str_epoch_player_121",_text] call dayz_rollingMessages;

_finished = ["Medic",1] call fn_loopAction;
if (isNull _obj || !_finished) exitWith {s_player_packvault = -1;dayz_actionInProgress = false;};

(findDisplay 106) closeDisplay 0; // Close gear

_playerNear = {isPlayer _x} count (([_obj] call FNC_GetPos) nearEntities ["CAManBase", 10]) > 1;
if (_playerNear) exitWith {dayz_actionInProgress = false; localize "str_pickup_limit_5" call dayz_rollingMessages;};

["Working",0,[3,2,4,0]] call dayz_NutritionSystem;

dze_waiting = nil;

[_packedClass,objNull] call fn_waitForObject;

_code = [_obj getVariable["CharacterID","0"],dayz_combination] select (_ComboMatch);

PVDZE_handleSafeGear = [player,_obj,2,_code,dayz_authKey];
publicVariableServer "PVDZE_handleSafeGear";

waitUntil {!isNil "dze_waiting"}; // wait for response from server to verify pack was logged and gear added before proceeding

format[localize "str_epoch_player_123",_text] call dayz_rollingMessages;

s_player_packvault = -1;
dayz_actionInProgress = false;
