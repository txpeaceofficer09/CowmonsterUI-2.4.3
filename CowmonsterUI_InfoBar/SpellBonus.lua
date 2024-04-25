function InfoBarSpellBonus_OnEnter(self)
	if UnitAffectingCombat("player") then return end

	InfoBarTooltip:ClearLines()
	InfoBarTooltip:SetOwner(self, "ANCHOR_TOPLEFT")

	InfoBarTooltip:AddLine("Spell Bonus:")
	InfoBarTooltip:AddLine(" ")

	InfoBarTooltip:AddDoubleLine("Physical", GetSpellBonusDamage(1))
	InfoBarTooltip:AddDoubleLine("Holy", GetSpellBonusDamage(2))
	InfoBarTooltip:AddDoubleLine("Fire", GetSpellBonusDamage(3))
	InfoBarTooltip:AddDoubleLine("Nature", GetSpellBonusDamage(4))
	InfoBarTooltip:AddDoubleLine("Frost", GetSpellBonusDamage(5))
	InfoBarTooltip:AddDoubleLine("Shadow", GetSpellBonusDamage(6))
	InfoBarTooltip:AddDoubleLine("Arcane", GetSpellBonusDamage(7))

	InfoBarTooltip:Show()
end

function InfoBarSpellBonus_OnLeave(self)
	InfoBarTooltip:Hide()
	InfoBarTooltip:ClearLines()
end

--[[
function InfoBarMoney_OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_MONEY" then
		InfoBarSetText("InfoBarMoney", nil, CowmonsterUI.GetCoinTextureString(GetMoney()))

		CowmonsterUIDB[GetRealmName()][UnitName("player")].Money = GetMoney()
	end
end

function InfoBarMoney_OnClick(self, button)
	ToggleAllBags()
end
]]

function InfoBarSpellBonus_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 0.2 then
		local physical = GetSpellBonusDamage(1)
		local holy = GetSpellBonusDamage(2)
		local fire = GetSpellBonusDamage(3)
		local nature = GetSpellBonusDamage(4)
		local frost = GetSpellBonusDamage(5)
		local shadow = GetSpellBonusDamage(6)
		local arcane = GetSpellBonusDamage(7)
		local bonus = GetSpellBonusDamage(1)
		local bonusType = "Physical"

		if holy > bonus then
			bonus = holy
			bonusType = "Holy"
		end

		if fire > bonus then
			bonus = fire
			bonusType = "Fire"
		end

		if nature > bonus then
			bonus = nature
			bonusType = "Nature"
		end

		if frost > bonus then
			bonus = frost
			bonusType = "Frost"
		end

		if shadow > bonus then
			bonus = shadow
			bonusType = "Shadow"
		end

		if arcane > bonus then
			bonus = arcane
			bonusType = "Arcane"
		end

		InfoBarSetText("InfoBarSpellBonus", "Spell Bonus: %d (%s)", bonus, bonusType)

		self.timer = 0
	end
end
