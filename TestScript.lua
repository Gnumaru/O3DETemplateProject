local _ = require('Utils')

TestScript = {
	TRANSFORM_TO_VELOCITY_MULTIPLIER = 60.1,
	scriptName = 'TestScript',
	frame = 1,
	upHeld = false,
	downHeld = false,
	leftHeld = false,
	rightHeld = false,
	Properties = {
		moveTransform = false,
		moveBody = false,
		moveSpeed = 1.0
		-- _number = 1.1,
		-- _bool = false,
		-- _string = '',
		-- _array = {1, 2, 3},
		-- _dict = {a = 0, b = 1, c = 2}, -- cannot change dictionary keys from inspector
		-- _complex = {default = 0.1, min = -1.0, max = 1.0, step = 0.1, description = 'mouse over tooltip', suffix = ' m/s'}
	}
}

function TestScript:OnDeactivate()
	-- _:printa({self, ': TestScript:OnDeactivate()'})
	-- print(os.clock())
	-- self.Ticking:Disconnect()
end

function TestScript:OnActivate() -- this only works because the script is, by default, connected to the 'EntityBus' which has the notifications
	_:print('.\n\n\n\n\n\n\n\n\n\n.')
	self.inputHandlers = _:quickScriptSetup(self)

	_:print('===== OnActivate FINISH')
end

function TestScript:firstFrame(deltaTime, ScriptTimePoint)
	local comps = _:getComponents(self)
	_:print('Hi! My name is "' .. _:getEntityName(self) .. '"')
	_:print('My Parent name is "' .. _:getEntityName(_:getParentId(self)) .. '"')
	_:print('My GrandParent name is "' .. _:getEntityName(_:getParentId(self, 2)) .. '"')
	_:print('My GrandGrandParent name is "' .. _:getEntityName(_:getParentId(self, 3)) .. '"')
	local comps = _:getComponentsList(self)
	_:print('I have "' .. #comps .. '" components')
	_:print('They are named:')
	for k, v in pairs(comps) do
		_:print('    "' .. _:getComponentName(v) .. '"')
	end
	_:print('Beware that they are unordered. the order I printed them is exaclty the order the engine gave them to me, but it may or may not be the same order they appear in the entity inspector')
	_:print('I have "' .. #_:getChildrenIds(self) .. '" children entities')
	_:print('They are:')
	for k, v in pairs(_:getChildrenIds(self)) do
		_:print('    "' .. _:getEntityName(v) .. '"')
	end
	_:print('Beware that they are also unordered, so you must search them by name rather than position')

	_:print(RigidBodyRequestBus.Event.GetLinearVelocity(self.entityId))

end

function TestScript:OnTick(deltaTime, ScriptTimePoint)
	if self.frame == 1 then
		self:firstFrame()
	end
	self.frame = self.frame + 1
	self.deltaTime = deltaTime

	if self.Properties.moveTransform then
		self:moveTransform(deltaTime)
	end
	if self.Properties.moveBody then
		self:moveBody(deltaTime)
	end
end

function TestScript:moveBody(deltaTime)
	local dir = self:getInputDir()
	_:setLinearVelocity(self, dir * self.Properties.moveSpeed * deltaTime * self.TRANSFORM_TO_VELOCITY_MULTIPLIER)
end

function TestScript:moveTransform(deltaTime)
	local dir = self:getInputDir()
	_:moveEntity(self, dir * self.Properties.moveSpeed * deltaTime)
end

function TestScript:getInputDir()
	local dir = Vector3()

	if self.upHeld and self.rightHeld then
		dir.x = _.SIN_45
		dir.y = _.SIN_45
	elseif self.rightHeld and self.downHeld then
		dir.x = _.SIN_45
		dir.y = -_.SIN_45
	elseif self.downHeld and self.leftHeld then
		dir.x = -_.SIN_45
		dir.y = -_.SIN_45
	elseif self.leftHeld and self.upHeld then
		dir.x = -_.SIN_45
		dir.y = _.SIN_45
	elseif self.upHeld then
		dir.y = 1
	elseif self.rightHeld then
		dir.x = 1
	elseif self.downHeld then
		dir.y = -1
	elseif self.leftHeld then
		dir.x = -1
	end

	return dir
end

function TestScript:OnInput(event)
	if event.status == _.INPUT_STATUS_HELD then
		return
	end
	-- _:printa({event.status, ': ', event.name, ' ', event.value})

	if event.name == InputDeviceKeyboard.keyboard_key_navigation_arrow_up then
		self.upHeld = (event.status == _.INPUT_STATUS_PRESSED)
	elseif event.name == InputDeviceKeyboard.keyboard_key_navigation_arrow_down then
		self.downHeld = (event.status == _.INPUT_STATUS_PRESSED)
	elseif event.name == InputDeviceKeyboard.keyboard_key_navigation_arrow_left then
		self.leftHeld = (event.status == _.INPUT_STATUS_PRESSED)
	elseif event.name == InputDeviceKeyboard.keyboard_key_navigation_arrow_right then
		self.rightHeld = (event.status == _.INPUT_STATUS_PRESSED)
	else
		_:print('unhandled input event: ' .. event.name)
	end
end

return TestScript
