local Utils = {}

---------------------------
--------- DUMMIES ---------
---------------------------

function _DummyFunction_()
end
-- the globals bellow are just declared so that vscode lua extension stops complaining about unexisting globals
Debug = Debug or {}
Entity = Entity or {}
InputDeviceKeyboard = InputDeviceKeyboard or {}

ComponentApplicationBus = ComponentApplicationBus or {}
GameEntityContextRequestBus = GameEntityContextRequestBus or {}
RigidBodyRequestBus = RigidBodyRequestBus or {}
TransformBus = TransformBus or {}
InputEventNotificationBus = InputEventNotificationBus or {}
TickBus = TickBus or {}

InputEventNotificationId = InputEventNotificationId or _DummyFunction_
Vector3 = Vector3 or _DummyFunction_

-----------------------------
--------- CONSTANTS ---------
-----------------------------

Utils.INPUT_STATUS_PRESSED = 1
Utils.INPUT_STATUS_HELD = 2
Utils.INPUT_STATUS_RELEASED = 3
Utils.SIN_45 = 0.70710678118654752440084436210485
Utils.PI_HALF = 1.5707963267948966192313216916398
Utils.PI = 3.1415926535897932384626433832795
Utils.TAU = 6.283185307179586476925286766559

-----------------------------
--------- FUNCTIONS ---------
-----------------------------

function Utils:printDebug(x)
	Debug.Log('type: ' .. type(x) .. '; value: ' .. tostring(x))
end

function Utils:print(x)
	Debug.Log(tostring(x))
end

function Utils:printa(x) -- print array
	r = ''
	for k, v in pairs(x) do
		r = r .. tostring(v)
	end
	Debug.Log(r)
end

function Utils:printt(t) -- print table
	if not t then
		print('falsy')
		return
	end
	r = ''
	for k, v in pairs(t) do
		r = r .. tostring(k) .. ': ' .. tostring(v) .. '\n'
	end
	Debug.Log(r)
end

function Utils:tableHasKey(table, key)
	for k, v in pairs(table) do
		if k == key then
			return true
		end
	end
	return false
end

function Utils:endsWith(str, ending)
	return ending == '' or str:sub(-#ending) == ending
end

function Utils:getEntityId(target)
	local t = type(target)
	if t == 'number' then
		return target
	elseif t == 'table' then
		if self:tableHasKey(target, 'entityId') then
			return target.entityId
		end
	elseif t == 'userdata' then
		return target
	elseif t == 'string' then
		self:print('ERROR: argument must be number|table|userdata')
	elseif t == 'boolean' then
		self:print('ERROR: argument must be number|table|userdata')
	elseif t == 'function' then
		self:print('ERROR: argument must be number|table|userdata')
	elseif t == 'thread' then
		self:print('ERROR: argument must be number|table|userdata')
	elseif t == 'nil' then
		self:print('ERROR: argument must be number|table|userdata')
	end
	return nil
end

function Utils:getEntity(target)
	local t = type(target)
	if t == 'number' then
		return Entity(target)
	elseif t == 'table' then
		if self:tableHasKey(target, 'entityId') then
			return Entity(target.entityId)
		end
	elseif t == 'userdata' then
		return target
	elseif t == 'string' then
		self:print('ERROR: argument must be number|table|userdata')
	elseif t == 'boolean' then
		self:print('ERROR: argument must be number|table|userdata')
	elseif t == 'function' then
		self:print('ERROR: argument must be number|table|userdata')
	elseif t == 'thread' then
		self:print('ERROR: argument must be number|table|userdata')
	elseif t == 'nil' then
		self:print('ERROR: argument must be number|table|userdata')
	end
	return nil
end

function Utils:getComponents(target)
	local entity = self:getEntity(target)
	if entity == nil then
		return nil
	end
	return Entity.GetComponents(entity)
end

function Utils:vectorToList(target, func)
	local list = {}
	if type(func) == 'function' then
		for i = 1, #target do
			table.insert(list, func(target[i]))
		end
	else
		for i = 1, #target do
			table.insert(list, target[i])
		end
	end
	return list
end

function Utils:getComponentsList(target)
	local entity = self:getEntity(target)
	if entity == nil then
		return nil
	end
	local comps = Entity.GetComponents(entity)
	local compsTbl = {}
	for i = 1, #comps do
		table.insert(compsTbl, {entity, comps[i]})
	end
	return compsTbl
end

function Utils:hasComponent(target, component)
	local entity = self:getEntity(target)
	if entity == nil then
		return nil
	end
	local comps = Entity.GetComponents(entity)
	for i = 1, #comps do
		if Entity.GetComponentName(entity, comps[i]) == component then
			return true
		end
	end
	return false
end

function Utils:getComponentName(entityComponentPair)
	return Entity.GetComponentName(entityComponentPair[1], entityComponentPair[2])
end

function Utils:getEntityName(target)
	local entityId = self:getEntityId(target)
	-- return ComponentApplicationBus.Broadcast.GetEntityName(entityId)
	return GameEntityContextRequestBus.Broadcast.GetEntityName(entityId)
end

function Utils:getParentId(target, iterations)
	iterations = iterations or 1
	local parentId
	while iterations > 0 do
		local entityId = self:getEntityId(target)
		parentId = TransformBus.Event.GetParentId(entityId)
		target = parentId
		iterations = iterations - 1
	end
	return parentId
end

function Utils:getChildrenIds(target)
	local entityId = self:getEntityId(target)
	return self:vectorToList(TransformBus.Event.GetChildren(entityId))
end

function Utils:getAllDescendantsIds(target)
	local entityId = self:getEntityId(target)
	return TransformBus.Event.GetAllDescendants(entityId)
end

function Utils:getChildId(target, idx)
	local entityId = self:getEntityId(target)
	local children = self:getChildrenIds(entityId)
	if idx > 0 and idx <= #children then
		return children[idx]
	end
	return nil
end

function Utils:moveEntity(target, ammount)
	local entityId = self:getEntityId(target)
	TransformBus.Event.MoveEntity(entityId, ammount)
end

function Utils:moveEntityX(target, ammount)
	local entityId = self:getEntityId(target)
	TransformBus.Event.MoveEntity(entityId, Vector3(ammount, 0, 0))
end

function Utils:moveEntityY(target, ammount)
	local entityId = self:getEntityId(target)
	TransformBus.Event.MoveEntity(entityId, Vector3(0, ammount, 0))
end

function Utils:moveEntityZ(target, ammount)
	local entityId = self:getEntityId(target)
	TransformBus.Event.MoveEntity(entityId, Vector3(0, 0, ammount))
end

function Utils:setLinearVelocity(target, ammount)
	local entityId = self:getEntityId(target)
    RigidBodyRequestBus.Event.SetLinearVelocity(entityId, ammount)
end

function Utils:setLinearVelocityX(target, ammount)
	local entityId = self:getEntityId(target)
    local velocity = RigidBodyRequestBus.Event.GetLinearVelocity(entityId)
    velocity.x = ammount
	RigidBodyRequestBus.Event.SetLinearVelocity(entityId, velocity)
end

function Utils:setLinearVelocityY(target, ammount)
	local entityId = self:getEntityId(target)
    local velocity = RigidBodyRequestBus.Event.GetLinearVelocity(entityId)
    velocity.y = ammount
	RigidBodyRequestBus.Event.SetLinearVelocity(entityId, velocity)
end

function Utils:setLinearVelocityZ(target, ammount)
	local entityId = self:getEntityId(target)
    local velocity = RigidBodyRequestBus.Event.GetLinearVelocity(entityId)
    velocity.z = ammount
	RigidBodyRequestBus.Event.SetLinearVelocity(entityId, velocity)
end

function Utils:isList(target)
	if type(target) ~= 'table' then
		return false
	end
	local i = 1
	for k,v in pairs(target) do
		if k ~= i then
			return false
		end
		i = i + 1
	end
	return true
end

function Utils:createInputHandler(owner, name) -- script, string: dict
	if self:isList(name) then
		local ret = {}
		for k,v in pairs(name) do
			table.insert(ret, self:createInputHandler(owner, v))
		end
		return ret
	end
	-- self:print('creating input handler for "'..name..'"')

	local handler = {owner = owner, name = name}
	function handler:OnAnyInput(floatValue, status)
		local event = {value = floatValue, name = self.name, status = status}
		owner:OnInput(event)
	end
	function handler:OnPressed(floatValue)
		self:OnAnyInput(floatValue, 1)
	end
	function handler:OnHeld(floatValue)
		self:OnAnyInput(floatValue, 2)
	end
	function handler:OnReleased(floatValue)
		self:OnAnyInput(floatValue, 3)
	end
	handler.InputBus = InputEventNotificationBus.Connect(handler, InputEventNotificationId(name))
	return handler
end

function Utils:quickScriptSetup(target)
	-- connect to the tick bus so we can actually do something
	target.Ticking = TickBus.Connect(target)

	-- create handlers for ALL keyboard keys so that, provided we have setupt defult input bindings, we are able setup simple keyboard controls
	local inputHandlers = self:createInputHandler(target, {
		InputDeviceKeyboard.keyboard_key_alphanumeric_0,
		InputDeviceKeyboard.keyboard_key_alphanumeric_1,
		InputDeviceKeyboard.keyboard_key_alphanumeric_2,
		InputDeviceKeyboard.keyboard_key_alphanumeric_3,
		InputDeviceKeyboard.keyboard_key_alphanumeric_4,
		InputDeviceKeyboard.keyboard_key_alphanumeric_5,
		InputDeviceKeyboard.keyboard_key_alphanumeric_6,
		InputDeviceKeyboard.keyboard_key_alphanumeric_7,
		InputDeviceKeyboard.keyboard_key_alphanumeric_8,
		InputDeviceKeyboard.keyboard_key_alphanumeric_9,
		InputDeviceKeyboard.keyboard_key_alphanumeric_A,
		InputDeviceKeyboard.keyboard_key_alphanumeric_B,
		InputDeviceKeyboard.keyboard_key_alphanumeric_C,
		InputDeviceKeyboard.keyboard_key_alphanumeric_D,
		InputDeviceKeyboard.keyboard_key_alphanumeric_E,
		InputDeviceKeyboard.keyboard_key_alphanumeric_F,
		InputDeviceKeyboard.keyboard_key_alphanumeric_G,
		InputDeviceKeyboard.keyboard_key_alphanumeric_H,
		InputDeviceKeyboard.keyboard_key_alphanumeric_I,
		InputDeviceKeyboard.keyboard_key_alphanumeric_J,
		InputDeviceKeyboard.keyboard_key_alphanumeric_K,
		InputDeviceKeyboard.keyboard_key_alphanumeric_L,
		InputDeviceKeyboard.keyboard_key_alphanumeric_M,
		InputDeviceKeyboard.keyboard_key_alphanumeric_N,
		InputDeviceKeyboard.keyboard_key_alphanumeric_O,
		InputDeviceKeyboard.keyboard_key_alphanumeric_P,
		InputDeviceKeyboard.keyboard_key_alphanumeric_Q,
		InputDeviceKeyboard.keyboard_key_alphanumeric_R,
		InputDeviceKeyboard.keyboard_key_alphanumeric_S,
		InputDeviceKeyboard.keyboard_key_alphanumeric_T,
		InputDeviceKeyboard.keyboard_key_alphanumeric_U,
		InputDeviceKeyboard.keyboard_key_alphanumeric_V,
		InputDeviceKeyboard.keyboard_key_alphanumeric_W,
		InputDeviceKeyboard.keyboard_key_alphanumeric_X,
		InputDeviceKeyboard.keyboard_key_alphanumeric_Y,
		InputDeviceKeyboard.keyboard_key_alphanumeric_Z,
		InputDeviceKeyboard.keyboard_key_edit_backspace,
		InputDeviceKeyboard.keyboard_key_edit_capslock,
		InputDeviceKeyboard.keyboard_key_edit_enter,
		InputDeviceKeyboard.keyboard_key_edit_space,
		InputDeviceKeyboard.keyboard_key_edit_tab,
		InputDeviceKeyboard.keyboard_key_function_F01,
		InputDeviceKeyboard.keyboard_key_function_F02,
		InputDeviceKeyboard.keyboard_key_function_F03,
		InputDeviceKeyboard.keyboard_key_function_F04,
		InputDeviceKeyboard.keyboard_key_function_F05,
		InputDeviceKeyboard.keyboard_key_function_F06,
		InputDeviceKeyboard.keyboard_key_function_F07,
		InputDeviceKeyboard.keyboard_key_function_F08,
		InputDeviceKeyboard.keyboard_key_function_F09,
		InputDeviceKeyboard.keyboard_key_function_F10,
		InputDeviceKeyboard.keyboard_key_function_F11,
		InputDeviceKeyboard.keyboard_key_function_F12,
		InputDeviceKeyboard.keyboard_key_function_F13,
		InputDeviceKeyboard.keyboard_key_function_F14,
		InputDeviceKeyboard.keyboard_key_function_F15,
		InputDeviceKeyboard.keyboard_key_function_F16,
		InputDeviceKeyboard.keyboard_key_function_F17,
		InputDeviceKeyboard.keyboard_key_function_F18,
		InputDeviceKeyboard.keyboard_key_function_F19,
		InputDeviceKeyboard.keyboard_key_function_F20,
		InputDeviceKeyboard.keyboard_key_modifier_alt_l,
		InputDeviceKeyboard.keyboard_key_modifier_alt_r,
		InputDeviceKeyboard.keyboard_key_modifier_ctrl_l,
		InputDeviceKeyboard.keyboard_key_modifier_ctrl_r,
		InputDeviceKeyboard.keyboard_key_modifier_shift_l,
		InputDeviceKeyboard.keyboard_key_modifier_shift_r,
		InputDeviceKeyboard.keyboard_key_modifier_super_l,
		InputDeviceKeyboard.keyboard_key_modifier_super_r,
		InputDeviceKeyboard.keyboard_key_navigation_arrow_down,
		InputDeviceKeyboard.keyboard_key_navigation_arrow_left,
		InputDeviceKeyboard.keyboard_key_navigation_arrow_right,
		InputDeviceKeyboard.keyboard_key_navigation_arrow_up,
		InputDeviceKeyboard.keyboard_key_navigation_delete,
		InputDeviceKeyboard.keyboard_key_navigation_end,
		InputDeviceKeyboard.keyboard_key_navigation_home,
		InputDeviceKeyboard.keyboard_key_navigation_insert,
		InputDeviceKeyboard.keyboard_key_navigation_page_down,
		InputDeviceKeyboard.keyboard_key_navigation_page_up,
		InputDeviceKeyboard.keyboard_key_num_lock,
		InputDeviceKeyboard.keyboard_key_numpad_0,
		InputDeviceKeyboard.keyboard_key_numpad_1,
		InputDeviceKeyboard.keyboard_key_numpad_2,
		InputDeviceKeyboard.keyboard_key_numpad_3,
		InputDeviceKeyboard.keyboard_key_numpad_4,
		InputDeviceKeyboard.keyboard_key_numpad_5,
		InputDeviceKeyboard.keyboard_key_numpad_6,
		InputDeviceKeyboard.keyboard_key_numpad_7,
		InputDeviceKeyboard.keyboard_key_numpad_8,
		InputDeviceKeyboard.keyboard_key_numpad_9,
		InputDeviceKeyboard.keyboard_key_numpad_add,
		InputDeviceKeyboard.keyboard_key_numpad_decimal,
		InputDeviceKeyboard.keyboard_key_numpad_divide,
		InputDeviceKeyboard.keyboard_key_numpad_enter,
		InputDeviceKeyboard.keyboard_key_numpad_multiply,
		InputDeviceKeyboard.keyboard_key_numpad_subtract,
		InputDeviceKeyboard.keyboard_key_punctuation_apostrophe,
		InputDeviceKeyboard.keyboard_key_punctuation_backslash,
		InputDeviceKeyboard.keyboard_key_punctuation_bracket_l,
		InputDeviceKeyboard.keyboard_key_punctuation_bracket_r,
		InputDeviceKeyboard.keyboard_key_punctuation_comma,
		InputDeviceKeyboard.keyboard_key_punctuation_equals,
		InputDeviceKeyboard.keyboard_key_punctuation_hyphen,
		InputDeviceKeyboard.keyboard_key_punctuation_period,
		InputDeviceKeyboard.keyboard_key_punctuation_semicolon,
		InputDeviceKeyboard.keyboard_key_punctuation_slash,
		InputDeviceKeyboard.keyboard_key_punctuation_tilde,
		InputDeviceKeyboard.keyboard_key_supplementary_iso,
		InputDeviceKeyboard.keyboard_key_windows_system_pause,
		InputDeviceKeyboard.keyboard_key_windows_system_print,
		InputDeviceKeyboard.keyboard_key_windows_system_scroll_lock,
	})
	return inputHandlers
end

return Utils

-- https://learnxinyminutes.com/docs/lua/
-- https://www.lua.org/manual/5.3/
-- https://docs.aws.amazon.com/lumberyard/latest/userguide/lua-scripting-intro.html
-- https://github.com/o3de/o3de/wiki/%5BLua%5D-Hello-World
-- 