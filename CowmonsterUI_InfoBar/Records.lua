local RecordsDisplay = "dmg"

local f = CreateFrame("Frame", "InfoBarRecordsList", InfoBarFrame)
f.columns = 5 -- spell, normal, critical, target, zone
--f:SetFrameLevel(99)
f:SetFrameStrata("FULLSCREEN")
f:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

local function count(table)
	local count = 0

	for _, _ in pairs(table) do
		count = count + 1
	end

	return count
end

local function CreateBar(index)
	local bar = CreateFrame("Frame", ("InfoBarRecordsListBar%s"):format(index), InfoBarRecordsList)

	InfoBarRecordsList.numRows = index

	if index == 0 then
		bar:SetPoint("TOPLEFT", InfoBarRecordsList, "TOPLEFT", 4, -4)
		bar:SetPoint("TOPRIGHT", InfoBarRecordsList, "TOPRIGHT", -4, -4)
	else
		bar:SetPoint("TOPLEFT", _G["InfoBarRecordsListBar"..(index-1)], "BOTTOMLEFT", 0, -2)
		bar:SetPoint("TOPRIGHT", _G["InfoBarRecordsListBar"..(index-1)], "BOTTOMRIGHT", 0, -2)
	end

	bar:SetHeight(16)
	--bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")

	for i=1,InfoBarRecordsList.columns,1 do
		--Add labels to the bar
		--ctl:SetFont("Fonts\\ARIALN.ttf", FontSize, "OUTLINE")
		--local t = bar:CreateFontString(("InfoBarRecordsListBar%sText%s"):format(index, i), "OVERLAY", "NumberFont_Outline_Med")
		local t = bar:CreateFontString(("InfoBarRecordsListBar%sText%s"):format(index, i), "OVERLAY")
		t:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
		if i == 1 then
			t:SetPoint("LEFT", bar, "LEFT", 2, 0)
		else
			t:SetPoint("LEFT", _G[("InfoBarRecordsListBar%sText%s"):format(index, (i-1))], "RIGHT", 0, 0)
		end

		t:SetJustifyH("LEFT")
	end

	return bar
end

local function ResizeColumn(index)
	local max = 0

	for i=0,count(RecordsDB[UnitName("player")][RecordsDisplay]),1 do
		--local bar = _G[("InfoBarRecordsListBar%s"):format(i)] or CreateBar(i)
		local label = _G[("InfoBarRecordsListBar%sText%s"):format(i, index)]

		if label == nil then ChatFrame:AddMessage(("InfoBarRecordsListBar%sText%s not found."):format(i, index)) end

		if label:GetStringWidth() > max then max = label:GetStringWidth() end
		--label:SetWidth(label:GetStringWidth()+30)
	end

	for i=0,count(RecordsDB[UnitName("player")][RecordsDisplay]),1 do
		--local bar = _G[("InfoBarRecordsListBar%s"):format(i)] or CreateBar(i)
		local label = _G[("InfoBarRecordsListBar%sText%s"):format(i, index)]
		
		label:SetWidth(max+30)
	end
end

local function ResizeList()
	local width = 0
	InfoBarRecordsList:SetHeight((count(RecordsDB[UnitName("player")][RecordsDisplay])*18)+18)

	for i=1,InfoBarRecordsList.columns,1 do
		local lbl = _G[("InfoBarRecordsListBar1Text%s"):format(i)]
		if lbl ~= nil then
			--width = width + _G[("InfoBarRecordsListBar1Text%s"):format(i)]:GetWidth() + 2
			width = width + lbl:GetWidth() + 2
		end
	end

	InfoBarRecordsList:SetWidth(width)
end

function InfoBarRecords_Refresh()
	--[[
	sort(RecordsDB[UnitName("player")].dmg, function(a,b)
		if a.crit == b.crit then
			return a.norm<b.norm
		else
			return a.crit<b.crit
		end
	end)
	]]

	local tbl = {}

	for k,v in pairs(RecordsDB[UnitName("player")][RecordsDisplay]) do
		tinsert(tbl, {["name"] = k, ["norm"] = v.norm, ["crit"] = v.crit, ["target"] = v.target, ["zone"] = v.zone})
	end

	sort(tbl, function(a,b)
		if a.crit==b.crit then
			return a.norm>b.norm
		else
			return a.crit>b.crit
		end
	end)

	local index = 1

	_G[("InfoBarRecordsListBar%sText1"):format(0)]:SetText("SPELL")
	_G[("InfoBarRecordsListBar%sText2"):format(0)]:SetText("NORMAL")
	_G[("InfoBarRecordsListBar%sText3"):format(0)]:SetText("CRITICAL")
	_G[("InfoBarRecordsListBar%sText4"):format(0)]:SetText("TARGET")
	_G[("InfoBarRecordsListBar%sText5"):format(0)]:SetText("ZONE")

	for k,v in ipairs(tbl) do
		if index == 1 then
			InfoBarSetText("InfoBarRecords", "%s: %s / %s", v.name, CowmonsterUI.AddComma(v.norm), CowmonsterUI.AddComma(v.crit))
		end

		local bar = _G[("InfoBarRecordsListBar%s"):format(index)] or CreateBar(index)

		_G[("InfoBarRecordsListBar%sText1"):format(index)]:SetText(v.name)
		_G[("InfoBarRecordsListBar%sText2"):format(index)]:SetText(CowmonsterUI.AddComma(v.norm))
		_G[("InfoBarRecordsListBar%sText3"):format(index)]:SetText(CowmonsterUI.AddComma(v.crit))
		_G[("InfoBarRecordsListBar%sText4"):format(index)]:SetText(v.target or "")
		_G[("InfoBarRecordsListBar%sText5"):format(index)]:SetText(v.zone or "")

		index = index + 1

		bar:Show()
	end

	for i=index,InfoBarRecordsList.numRows,1 do
		_G[("InfoBarRecordsListBar%s"):format(i)]:Hide()
	end

	for i=1,InfoBarRecordsList.columns,1 do
		ResizeColumn(i)
	end

	ResizeList()
end

CreateBar(0)

function InfoBarRecords_OnEnter(self)
	if UnitAffectingCombat("player") then return end

	InfoBarRecords_Refresh()
	InfoBarRecordsList:SetPoint("BOTTOMRIGHT", InfoBarRecords, "TOPRIGHT", 0, 0)
	InfoBarRecordsList:Show()
end

function InfoBarRecords_OnLeave(self)
	InfoBarRecordsList:Hide()
end

function InfoBarRecords_OnClick(self, button)
	if RecordsDisplay == "dmg" then
		RecordsDisplay = "heal"
	elseif RecordsDisplay == "heal" then
		RecordsDisplay = "absorb"
	elseif RecordsDisplay == "absorb" then
		RecordsDisplay = "dmg"
	end
	InfoBarRecords_Refresh()
end

function InfoBarRecords_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 1 then
		InfoBarRecords_Refresh()
		self.timer = 0
	end
end

function InfoBarRecords_OnEvent(self, event, ...)
	if event == "ADDON_LOADED" and select(1, ...) == "CowmonsterUI_InfoBar" or event == "VARIABLES_LOADED" then
		if RecordsDB == nil then RecordsDB = {} end
		if RecordsDB[UnitName("player")] == nil then
			RecordsDB[UnitName("player")] = {["dmg"] = {}, ["heal"] = {}, ["absorb"] = {}}
		end
		InfoBarSetText("InfoBarRecords", "Records")
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, combatEvent, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellID, spellName, spellSchool, amount, overkill, resisted, blocked, absorbed, critical, glancing, crushing, multistrike, extraAttacks = ...

		if RecordsDB[UnitName("player")].dmg == nil then RecordsDB[UnitName("player")].dmg = {} end
		if RecordsDB[UnitName("player")].heal == nil then RecordsDB[UnitName("player")].heal = {} end
		if RecordsDB[UnitName("player")].absorb == nil then RecordsDB[UnitName("player")].absorb = {} end

		if sourceName == UnitName("player") then
			if string.find(combatEvent, "SWING") then
				local spell = "Auto Attack"
				local amount = spellID or 0
				local crit = spellName or 0

				RecordsDB[UnitName("player")].dmg[spell] = RecordsDB[UnitName("player")].dmg[spell] or {["norm"] = 0, ["crit"] = 0, ["target"] = destName}
				if crit == 1 then
					local record = RecordsDB[UnitName("player")].dmg[spell].crit or 0
					
					if record < amount then
						RecordsDB[UnitName("player")].dmg[spell].crit = amount
						RecordsDB[UnitName("player")].dmg[spell].target = destName
						RecordsDB[UnitName("player")].dmg[spell].spellID = spellID
						RecordsDB[UnitName("player")].dmg[spell].zone = GetRealZoneText()
						--ChatFrame:AddMessage(("New %s critical record (%s)"):format(spell, amount))
					end
				else
					local record = RecordsDB[UnitName("player")].dmg[spell].norm or 0

					if record < amount then
						RecordsDB[UnitName("player")].dmg[spell].norm = amount
						RecordsDB[UnitName("player")].dmg[spell].target = destName
						RecordsDB[UnitName("player")].dmg[spell].spellID = spellID
						RecordsDB[UnitName("player")].dmg[spell].zone = GetRealZoneText()
						--ChatFrame:AddMessage(("New %s normal record (%s)"):format(spell, amount))
					end
				end
			elseif string.find(combatEvent, "_DAMAGE") then
				local spell = spellName
				local amount = amount or 0
				--local crit = critDmg or 0
				local crit = critical or 0

				if spell and type(spell) == "string" then
					RecordsDB[UnitName("player")].dmg[spell] = RecordsDB[UnitName("player")].dmg[spell] or {["norm"] = 0, ["crit"] = 0, ["target"] = destName}
					if crit == 1 then
						local record = RecordsDB[UnitName("player")].dmg[spell].crit or 0
	
						if record < amount then
							RecordsDB[UnitName("player")].dmg[spell].crit = amount
							RecordsDB[UnitName("player")].dmg[spell].target = destName
							RecordsDB[UnitName("player")].dmg[spell].spellID = spellID
							RecordsDB[UnitName("player")].dmg[spell].zone = GetRealZoneText()
							--ChatFrame:AddMessage(("New %s critical record (%s)"):format(spell, amount))
						end
					else
						local record = RecordsDB[UnitName("player")].dmg[spell].norm or 0
	
						if record < amount then
							RecordsDB[UnitName("player")].dmg[spell].norm = amount
							RecordsDB[UnitName("player")].dmg[spell].target = destName
							RecordsDB[UnitName("player")].dmg[spell].spellID = spellID
							RecordsDB[UnitName("player")].dmg[spell].zone = GetRealZoneText()
							--ChatFrame:AddMessage(("New %s normal record (%s)"):format(spell, amount))
						end
					end
				end
			elseif string.find(combatEvent, "_HEAL") then
				local spell = spellName
				local amount = amount or 0
				local crit = critHeal or 0
	
				if spell and type(spell) == "string" then
					RecordsDB[UnitName("player")].heal[spell] = RecordsDB[UnitName("player")].heal[spell] or {["norm"] = 0, ["crit"] = 0, ["target"] = destName}
	
					if crit == 1 then
						local record = RecordsDB[UnitName("player")].heal[spell].crit or 0
	
						if record < amount then
							RecordsDB[UnitName("player")].heal[spell].crit = amount
							RecordsDB[UnitName("player")].heal[spell].target = destName
							RecordsDB[UnitName("player")].heal[spell].spellID = spellID
							RecordsDB[UnitName("player")].heal[spell].zone = GetRealZoneText()
						end
					else
						local record = RecordsDB[UnitName("player")].heal[spell].norm or 0
	
						if record < amount then
							RecordsDB[UnitName("player")].heal[spell].norm = amount
							RecordsDB[UnitName("player")].heal[spell].target = destName
							RecordsDB[UnitName("player")].heal[spell].spellID = spellID
							RecordsDB[UnitName("player")].heal[spell].zone = GetRealZoneText()
						end
					end
				end
			elseif string.find(combatEvent, "_ABSORBED") then
				local spell = spellName
				local amount = amount or 0
				local crit = critHeal or 0
				
				if spell and type(spell) == "string" then
					RecordsDB[UnitName("player")].absorb[spell] = RecordsDB[UnitName("player")].absorb[spell] or {["norm"] = 0, ["crit"] = 0, ["target"] = destName}
					
					if crit == 1 then
						local record = RecordsDB[UnitName("player")].absorb[spell].crit or 0
						
						if record < amount then
							RecordsDB[UnitName("player")].absorb[spell].crit = amount
							RecordsDB[UnitName("player")].absorb[spell].target = destName
							RecordsDB[UnitName("player")].absorb[spell].spellID = spellID
							RecordsDB[UnitName("player")].absorb[spell].zone = GetRealZoneText()
						end
					else
						local record = RecordsDB[UnitName("player")].absorb[spell].norm or 0
						
						if record < amount then
							RecordsDB[UnitName("player")].absorb[spell].norm = amount
							RecordsDB[UnitName("player")].absorb[spell].target = destName
							RecordsDB[UnitName("player")].absorb[spell].spellID = spellID
							RecordsDB[UnitName("player")].absorb[spell].zone = GetRealZoneText()
						end
					end
				end
			end
		end
	end
end

SLASH_RECORDS1 = "/records"
SlashCmdList["RECORDS"] = function(input)
	if input == "reset" then
		RecordsDB = {["dmg"] = {}, ["heal"] = {}, ["absorb"] = {}};
		DEFAULT_CHAT_FRAME:AddMessage("Records have been reset.")
	else
		DEFAULT_CHAT_FRAME:AddMessage("Records: "..input)
	end
end
