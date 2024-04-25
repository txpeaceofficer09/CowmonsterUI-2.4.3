local f = CreateFrame("Frame", "CowmonsterUIiLvlFrame", UIParent)

LoadAddOn("Blizzard_InspectUI")

local slots = {
    "CharacterHeadSlot",
    "CharacterNeckSlot",
    "CharacterShoulderSlot",
    "CharacterBackSlot",
    "CharacterChestSlot",
    "CharacterShirtSlot",
    "CharacterTabardSlot",
    "CharacterWristSlot",
    "CharacterMainHandSlot",
    "CharacterSecondaryHandSlot",
    "CharacterTrinket0Slot",
    "CharacterTrinket1Slot",
    "CharacterFinger0Slot",
    "CharacterFinger1Slot",
    "CharacterFeetSlot",
    "CharacterLegsSlot",
    "CharacterWaistSlot",
    "CharacterHandsSlot",
	"CharacterRangedSlot",
}

local invSlots = {
    [1] = "Head",
    [2] = "Neck",
    [3] = "Shoulder",
    [4] = "Tabard",
    [5] = "Chest",
    [6] = "Waist",
    [7] = "Legs",
    [8] = "Feet",
    [9] = "Wrist",
    [10] = "Hands",
    [11] = "Finger0",
    [12] = "Finger1",
    [13] = "Trinket0",
    [14] = "Trinket1",
    [15] = "Back",
    [16] = "MainHand",
    [17] = "SecondaryHand",
	[18] = "Ranged",
}

local leftStrings = {6,7,8,10,11,12,13,14}
local rightStrings = {1,2,3,5,9,15}
local topStrings = {16,17,18}

local function inArray(tbl, str)
    for k,v in pairs(tbl) do
        if v == str then
            return true
        end
    end

    return false
end

local function UpdateInspectionItemLevel()
	local totalItemLevel = 0
	local totalItems = 0

    local unit = InspectFrame.Unit
    if unit == nil or unit == false then unit = "target" end

    for i=1,18,1 do
        local link = GetInventoryItemLink(unit, i)
        local name, _, quality, itemLevel = GetItemInfo(link or 0)
        local r, g, b, color = GetItemQualityColor(quality or 1)
        local slot = _G[("Inspect%sSlot"):format(invSlots[i])]

        if not slot.glowBorder then
            slot.glowBorder = slot:CreateTexture(nil, "OVERLAY")
            slot.glowBorder:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
            slot.glowBorder:SetBlendMode("ADD")
            slot.glowBorder:SetAlpha(0.8)
            slot.glowBorder:SetWidth(70)
		slot.glowBorder:SetHeight(70)
            slot.glowBorder:SetPoint("CENTER", slot, "CENTER", 0, 0)
        end

        if not slot.ilvl then
            slot.ilvl = slot:CreateFontString(invSlots[i].."ItemLevel", "ARTWORK", "GameFontHighlightLarge")
            slot.ilvl:SetShadowColor(0, 0, 0, 1)
            slot.ilvl:SetShadowOffset(-1, -1)
            
            if inArray(leftStrings, i) then
                slot.ilvl:SetPoint("RIGHT", slot, "LEFT", -5, 0)
                slot.ilvl:SetJustifyH("RIGHT")
            elseif inArray(rightStrings, i) then
                slot.ilvl:SetPoint("LEFT", slot, "RIGHT", 5, 0)
                slot.ilvl:SetJustifyH("LEFT")
            elseif inArray(topStrings, i) then
                slot.ilvl:SetPoint("BOTTOM", slot, "TOP", 0, 5)
                slot.ilvl:SetJustifyH("CENTER")
            end

            slot.ilvl:SetJustifyV("CENTER")
        end

        if itemLevel ~= nil then
            slot.glowBorder:SetVertexColor(r, g, b)
            slot.glowBorder:Show()
            --slot.ilvl:SetText(("|c%s%s"):format(color, itemLevel))
            slot.ilvl:SetText(("%s%s"):format(color, itemLevel))
            slot.ilvl:Show()
            totalItemLevel = (totalItemLevel or 0) + itemLevel
            totalItems = (totalItems or 0) + 1
        else
            slot.ilvl:Hide()
            slot.glowBorder:Hide()
        end
    end

    if not _G["InspectEAIL"] then
        InspectFrame:CreateFontString("InspectEAIL", "ARTWORK", "GameFontHighlightLarge")
        InspectEAIL:SetJustifyH("CENTER") 
        InspectEAIL:SetPoint("CENTER", InspectFrame, "TOP", 0, -64)
        InspectEAIL:SetShadowColor(0, 0, 0, 1)
        InspectEAIL:SetShadowOffset(-1, -1)        
    end
	InspectEAIL:SetText(("Avg iLvl: %.2f"):format(totalItemLevel/totalItems))
end

local function UpdatePlayerItemLevel()
	local totalItemLevel = 0
	local totalItems = 0

    for i=1,18,1 do
        local link = GetInventoryItemLink("player", i)
        local name, _, quality, itemLevel = GetItemInfo(link or 0)
        local r, g, b, color = GetItemQualityColor(quality or 1)
        local slot = _G[("Character%sSlot"):format(invSlots[i])]

        if not slot.glowBorder then
            slot.glowBorder = slot:CreateTexture(nil, "OVERLAY")
            slot.glowBorder:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
            slot.glowBorder:SetBlendMode("ADD")
            slot.glowBorder:SetAlpha(0.8)
            slot.glowBorder:SetWidth(70)
            slot.glowBorder:SetHeight(70)
            slot.glowBorder:SetPoint("CENTER", slot, "CENTER", 0, 0)
        end

        if not slot.ilvl then
            slot.ilvl = slot:CreateFontString(invSlots[i].."ItemLevel", "ARTWORK", "GameFontHighlightLarge")
            slot.ilvl:SetShadowColor(0, 0, 0, 1)
            slot.ilvl:SetShadowOffset(-1, -1)
            
            if inArray(leftStrings, i) then
                slot.ilvl:SetPoint("RIGHT", slot, "LEFT", -5, 0)
            elseif inArray(rightStrings, i) then
                slot.ilvl:SetPoint("LEFT", slot, "RIGHT", 5, 0)
            elseif inArray(topStrings, i) then
                slot.ilvl:SetPoint("BOTTOM", slot, "TOP", 0, 5)
            end

            slot.ilvl:SetJustifyH("CENTER")
            slot.ilvl:SetJustifyV("CENTER")
        end

        if itemLevel ~= nil then
            slot.glowBorder:SetVertexColor(r, g, b)
            slot.glowBorder:Show()
            slot.ilvl:SetText(("%s%s"):format(color, itemLevel))
            slot.ilvl:Show()
            totalItemLevel = (totalItemLevel or 0) + itemLevel
            totalItems = (totalItems or 0) + 1
        else
            slot.ilvl:Hide()
            slot.glowBorder:Hide()
        end
    end

    if not _G["PlayerEAIL"] then
        PaperDollFrame:CreateFontString("PlayerEAIL", "ARTWORK", "GameFontHighlightLarge")
        PlayerEAIL:SetJustifyH("CENTER")
        PlayerEAIL:SetPoint("CENTER", PaperDollFrame, "TOP", 0, -64)
        PlayerEAIL:SetShadowColor(0, 0, 0, 1)
        PlayerEAIL:SetShadowOffset(-1, -1)
    end
    PlayerEAIL:SetText(("Avg iLvl: %.2f"):format(totalItemLevel/totalItems))

    --local eail = _G["PlayerEAIL"] or PaperDollFrame:CreateFontString("PlayerEAIL", "ARTWORK", "GameFontHighlightLarge")
    --eail:SetJustifyH("CENTER")
    --eail:SetPoint("CENTER", PaperDollFrame, "TOP", 0, -64)
    --eail:SetShadowColor(0, 0, 0, 1)
    --eail:SetShadowOffset(-1, -1)
	--eail:SetText(("Avg iLvl: %.2f"):format(totalItemLevel/totalItems))
end

-- Atempt to determine the unit based on the GUID
local function GetUnitByGUID(guid)
	local units = {"player", "target", "focus", "targettarget", "focustarget", "pet", "pettarget", "targetpet", "targetpettarget", "focuspet", "focuspettarget"}

	for _,v in ipairs(units) do
		if UnitGUID(v) == guid then return v end
	end

	if GetNumRaidMembers() > 0 then
		for i=1,GetNumRaidMembers(),1 do
			if UnitExists("raid"..i) and UnitGUID("raid"..i) == guid then
				return "raid"..i
            elseif UnitExists("raid"..i.."pet") and UnitGUID("raid"..i.."pet") == guid then
                return "raid"..i.."pet"
            elseif UnitExists("raid"..i.."pettarget") and UnitGUID("raid"..i.."pettarget") == guid then
                return "raid"..i.."pettarget"
			end
		end
	elseif GetNumPartyMembers() > 0 then
		for i=1,GetNumPartyMembers(),1 do
			if UnitExists("party"..i) and UnitGUID("party"..i) == guid then
				return "party"..i
            elseif UnitExists("party"..i.."pet") and UnitGUID("party"..i.."pet") == guid then
                return "party"..i.."pet"
            elseif UnitExists("party"..i.."pettarget") and UnitGUID("party"..i.."pettarget") == guid then
                return "party"..i.."pettarget"
			end
		end
	end

	return false -- GUID did not match any conceivable unit reference
end

InspectFrame:HookScript("OnShow", function(self)
	InspectModelRotateLeftButton:Hide()
	InspectModelRotateRightButton:Hide()

	UpdateInspectionItemLevel()
end)

CharacterFrame:HookScript("OnShow", function(self)
	UpdatePlayerItemLevel()

	for i=1,5,1 do
		local frame = _G["MagicResFrame"..i]
		frame:ClearAllPoints()

		if i==1 then
			frame:SetPoint("TOPLEFT", PaperDollFrame, "TOPLEFT", 100, -80)
		else
			frame:SetPoint("LEFT", _G["MagicResFrame"..(i-1)], "RIGHT", 2, 0)
		end
	end

	CharacterAttributesFrame:ClearAllPoints()
	CharacterAttributesFrame:SetPoint("TOPLEFT", MagicResFrame2, "BOTTOMLEFT", -8, -24)
	PlayerStatRightTop:ClearAllPoints()
	PlayerStatRightTop:SetPoint("TOP", PlayerStatLeftBottom, "BOTTOM", 0, -24)

	CharacterModelFrameRotateLeftButton:Hide()
	CharacterModelFrameRotateRightButton:Hide()
	CharacterModelFrame:Hide()
end)

local function OnEvent(self, event, ...)
    if event == "INSPECT_READY" then
        local guid = ...
        local unit = GetUnitByGUID(guid)
        if unit ~= false then
            InspectFrame.Unit = GetUnitByGUID(guid)
        end
        UpdateInspectionItemLevel()
    end
    UpdatePlayerItemLevel()
end

f:RegisterEvent("INSPECT_READY")
f:RegisterEvent("UNIT_INVENTORY_CHANGED")
f:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_READY")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

f:SetScript("OnEvent", OnEvent)
