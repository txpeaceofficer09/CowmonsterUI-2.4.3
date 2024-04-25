BINDING_HEADER_ACTIONBAR2 = "ActionBar 2"
BINDING_NAME_ACTIONBAR2BUTTON1 = "ActionBar 2 Button 1"
BINDING_NAME_ACTIONBAR2BUTTON2 = "ActionBar 2 Button 2"
BINDING_NAME_ACTIONBAR2BUTTON3 = "ActionBar 2 Button 3"
BINDING_NAME_ACTIONBAR2BUTTON4 = "ActionBar 2 Button 4"
BINDING_NAME_ACTIONBAR2BUTTON5 = "ActionBar 2 Button 5"
BINDING_NAME_ACTIONBAR2BUTTON6 = "ActionBar 2 Button 6"
BINDING_NAME_ACTIONBAR2BUTTON7 = "ActionBar 2 Button 7"
BINDING_NAME_ACTIONBAR2BUTTON8 = "ActionBar 2 Button 8"
BINDING_NAME_ACTIONBAR2BUTTON9 = "ActionBar 2 Button 9"
BINDING_NAME_ACTIONBAR2BUTTON10 = "ActionBar 2 Button 10"
BINDING_NAME_ACTIONBAR2BUTTON11 = "ActionBar 2 Button 11"
BINDING_NAME_ACTIONBAR2BUTTON12 = "ActionBar 2 Button 12"
--[[
BINDING_NAME_ACTIONBAR_BUTTON13 = "ActionBar 3 Button 1"
BINDING_NAME_ACTIONBAR_BUTTON14 = "ActionBar 3 Button 2"
BINDING_NAME_ACTIONBAR_BUTTON15 = "ActionBar 3 Button 3"
BINDING_NAME_ACTIONBAR_BUTTON16 = "ActionBar 3 Button 4"
BINDING_NAME_ACTIONBAR_BUTTON17 = "ActionBar 3 Button 5"
BINDING_NAME_ACTIONBAR_BUTTON18 = "ActionBar 3 Button 6"
BINDING_NAME_ACTIONBAR_BUTTON19 = "ActionBar 3 Button 7"
BINDING_NAME_ACTIONBAR_BUTTON20 = "ActionBar 3 Button 8"
BINDING_NAME_ACTIONBAR_BUTTON21 = "ActionBar 3 Button 9"
BINDING_NAME_ACTIONBAR_BUTTON22 = "ActionBar 3 Button 10"
BINDING_NAME_ACTIONBAR_BUTTON23 = "ActionBar 3 Button 11"
BINDING_NAME_ACTIONBAR_BUTTON24 = "ActionBar 3 Button 12"
BINDING_NAME_ACTIONBAR_BUTTON25 = "ActionBar 4 Button 1"
BINDING_NAME_ACTIONBAR_BUTTON26 = "ActionBar 4 Button 2"
BINDING_NAME_ACTIONBAR_BUTTON27 = "ActionBar 4 Button 3"
BINDING_NAME_ACTIONBAR_BUTTON28 = "ActionBar 4 Button 4"
BINDING_NAME_ACTIONBAR_BUTTON29 = "ActionBar 4 Button 5"
BINDING_NAME_ACTIONBAR_BUTTON30 = "ActionBar 4 Button 6"
BINDING_NAME_ACTIONBAR_BUTTON31 = "ActionBar 4 Button 7"
BINDING_NAME_ACTIONBAR_BUTTON32 = "ActionBar 4 Button 8"
BINDING_NAME_ACTIONBAR_BUTTON33 = "ActionBar 4 Button 9"
BINDING_NAME_ACTIONBAR_BUTTON34 = "ActionBar 4 Button 10"
BINDING_NAME_ACTIONBAR_BUTTON35 = "ActionBar 4 Button 11"
BINDING_NAME_ACTIONBAR_BUTTON36 = "ActionBar 4 Button 12"
]]

local f = CreateFrame("Frame", nil, UIParent)

local function UpdateBindings()
	for bar=2,4,1 do
		for i=1,12,1 do
			local button = _G[("ActionBar%sButton%s"):format(bar, i)]
			local id = button:GetID()

			local hotkey = _G[button:GetName().."HotKey"]
			local key
			if bar == 2 then
				key = GetBindingKey(("ACTIONBAR%sBUTTON%s"):format(bar, i))
			elseif bar == 3 then
				key = GetBindingKey(("MULTIACTIONBAR4BUTTON%s"):format(i))
			elseif bar == 4 then
				key = GetBindingKey(("MULTIACTIONBAR3BUTTON%s"):format(i))
			end
			local text = GetBindingText(key, "KEY_", 1)

			if text == "" then
				hotkey:SetText(RANGE_INDICATOR)
				hotkey:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -2)
				hotkey:Hide()
			else
				hotkey:SetText(text)
				hotkey:SetPoint("TOPLEFT", button, "TOPLEFT", -2, -2)
				hotkey:Show()
				SetOverrideBindingClick(button, true, key, button:GetName(), "LeftButton")
			end
		end
	end
end

function MoveBars()
	if UnitAffectingCombat("player") then
		f.needMove = true
		return
	end

	if IsAddOnLoaded("CowmonsterUI_InfoBar") then
		MainMenuBar:SetPoint("BOTTOMRIGHT", InfoBarFrame, "TOPRIGHT", 0, 0)
	else
		MainMenuBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
	end

	ShapeshiftBarFrame:ClearAllPoints()
	ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", ActionBar3Button1, "TOPLEFT", 0, 4)

	PetActionBarFrame:ClearAllPoints()

	if ShapeshiftBarFrame:IsVisible() then
		PetActionBarFrame:SetPoint("BOTTOMLEFT", ActionBar4Button1, "TOPLEFT", 0, 4)
	else
		PetActionBarFrame:SetPoint("BOTTOMLEFT", ShapeshiftBarFrame, "BOTTOMLEFT", 0, 0)
	end
end

local function HideBar()
	for i=1,12,1 do
		_G["ExtraBarButton"..i]:Hide()
	end
end

local function ShowBar()
	for i=1,12,1 do
		_G["ExtraBarButton"..i]:Show()
	end
end

local function CreateButton(bar, id)
	local b = CreateFrame("CheckButton", ("ActionBar%sButton%s"):format(bar, id), MainMenuBar, "ActionBarButtonTemplate")

	b:SetFrameLevel(ActionBarUpButton:GetFrameLevel() + 3)

	b:SetWidth(36*UIParent:GetScale())
	b:SetHeight(36*UIParent:GetScale())
	b:SetAttribute("action", ((bar*12)-12)+id)
	b:SetID(((bar*12)-12)+id)
	b:Show()

	if id == 1 then
		if bar == 2 then
			b:SetPoint("LEFT", ActionButton12, "RIGHT", 12, 0)
		elseif bar == 3 then
			b:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton1, "TOPLEFT", 0, 4)
		elseif bar == 4 then
			b:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 0, 4)
		end
	else
		b:SetPoint("LEFT", _G[("ActionBar%sButton%s"):format(bar, id-1)], "RIGHT", 6, 0)
	end

	return b
end

for bar=2,4,1 do
	for id=1,12,1 do
		CreateButton(bar, id)
	end
end

local function OnEvent(self, event, ...)
	if event == "ACTIONBAR_PAGE_CHANGED" then
		if GetActionBarPage() ~= 1 then	ChangeActionBarPage(1) end
	elseif event == "UPDATE_BINDINGS" then
		--UpdateBindings()
	elseif event == "PLAYER_LOGIN" then
	elseif event == "ADDON_LOADED" and ... == addonName then
		ActionBarUpButton:Disable()
		ActionBarDownButton:Disable()

		ActionBarUpButton:Hide()
		ActionBarDownButton:Hide()

		ActionBarUpButton:HookScript("OnShow", function() ActionBarUpButton:Hide() end)
		ActionBarDownButton:HookScript("OnShow", function() ActionBarDownButton:Hide() end)

		PetActionBarFrame:HookScript("OnShow", function() MoveBars() end)
		ShapeshiftBarFrame:HookScript("OnShow", function() MoveBars() end)

		MoveBars()
	elseif event == "PLAYER_GAINS_VEHICLE_DATA" then
		self.hide = true
	elseif event == "PLAYER_LOSES_VEHICLE_DATA" then
		self.hide = false
	else
		MoveBars()
	end
end

f:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UPDATE_BINDINGS")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_LOSES_VEHICLE_DATA")
f:RegisterEvent("PLAYER_GAINS_VEHICLE_DATA")

f:SetScript("OnEvent", OnEvent)
f:SetScript("OnUpdate", function(self, elapsed)
	if self.needMove == true and UnitAffectingCombat("player") == false then
		MoveBars()
		self.needMove = false
	end
	
	if ActionBarUpButton:IsShown() then ActionBarUpButton:Hide() end
	if ActionBarDownButton:IsShown() then ActionBarDownButton:Hide() end

	MoveBars()

	--[[
	for i=1,12,1 do
		if not UnitAffectingCombat("player") then
			if MainMenuBar:IsShown() == 1 and _G["ExtraBarButton"..i]:IsShown() == nil then
				_G["ExtraBarButton"..i]:Show()
			elseif MainMenuBar:IsShown() == nil and _G["ExtraBarButton"..i]:IsShown() == 1 then
				_G["ExtraBarButton"..i]:Hide()
			end
		end
	end
	]]
end)
