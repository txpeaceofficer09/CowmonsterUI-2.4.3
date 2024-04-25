local ChatFramePlayerData = {}

local function BetterDate(timestamp)
	local timestamp = time()
	--timestamp = tonumber(timestamp)
	local year = math.floor(timestamp / 31556926) + 1970
	local month = math.floor((timestamp % 31556926) / 2629743) + 1
	local day = math.floor((timestamp % 2629743) / 86400) + 1
	local hour = math.floor((timestamp % 86400) / 3600)
	local minute = math.floor((timestamp % 3600) / 60)
	local second = timestamp % 60

	return ("%02d:%02d:%02d"):format(hour, minute, second)
end

local TabsPerRow = 5
local ButtonHeight = 16
local FontSize = 12

local ToastEvents = {
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_INSTANCE_CHAT",
	"CHAT_MSG_INSTANCE_CHAT_LEADER",
	"CHAT_MSG_BATTLEGROUND",
	"CHAT_MSG_BATTLEGROUND_LEADER",
}

local ChatTabs = {
	{
		["title"] = "Chat",
		["frame"] = "ChatFrame",
		["events"] = {
			"PLAYER_ENTERING_WORLD",
			"UPDATE_CHAT_COLOR",
			"UPDATE_CHAT_WINDOWS",
			"UPDATE_INSTANCE_INFO",
			"UPDATE_CHAT_COLOR_NAME_BY_CLASS",
			"CHAT_SERVER_DISCONNECTED",
			"CHAT_SERVER_RECONNECTED",
			"VARIABLES_LOADED",
			"CHAT_MSG_CHANNEL",
			"CHAT_MSG_SAY",
			"CHAT_MSG_YELL",
			"CHAT_MSG_EMOTE",
			"CHAT_MSG_TEXT_EMOTE",
			"CHAT_MSG_TARGETICONS",
			"CHAT_MSG_DND",
			"CHAT_MSG_AFK",
			"CHAT_MSG_CHANNEL_JOIN",
			"CHAT_MSG_CHANNEL_LEAVE",
			--"LFG_LIST_UPDATE",
			"CHAT_MSG_SYSTEM",
			"CHAT_MSG_IGNORED",
			"CVAR_UPDATE",
			"NEW_TITLE_EARNED",
			"OLD_TITLE_LOST",
			"ZONE_UNDER_ATTACK",
		},
	},
	{
		["title"] = "Guild",
		["frame"] = "GuildChatFrame",
		["events"] = {
			"CHAT_MSG_GUILD",
			"CHAT_MSG_GUILD_ACHIEVEMENT",
			"CHAT_MSG_OFFICER",
			"CHAT_MSG_GUILD_ITEM_LOOTED",
		},
	},
	{
		["title"] = "Group",
		["frame"] = "GroupChatFrame",
		["events"] = {
			"CHAT_MSG_RAID",
			"CHAT_MSG_RAID_LEADER",
			"CHAT_MSG_RAID_WARNING",
			"CHAT_MSG_PARTY",
			"CHAT_MSG_PARTY_LEADER",
			"CHAT_MSG_INSTANCE_CHAT",
			"CHAT_MSG_INSTANCE_CHAT_LEADER",
			"CHAT_MSG_BATTLEGROUND",
			"CHAT_MSG_BATTLEGROUND_LEADER",
		},
	},
	{
		["title"] = "Whisper",
		["frame"] = "WhisperChatFrame",
		["events"] = {
			"CHAT_MSG_WHISPER",
			"CHAT_MSG_WHISPER_INFORM",
		},
	},
	{
		["title"] = "Who",
		["frame"] = "WhoChatFrame",
		["events"] = {
			"WHO_LIST_UPDATE",
		},
	},
	{
		["title"] = "Monster",
		["frame"] = "MonsterChatFrame",
		["events"] = {
			"CHAT_MSG_MONSTER_SAY",
			"CHAT_MSG_MONSTER_WHISPER",
			"CHAT_MSG_RAID_BOSS_EMOTE",
			"CHAT_MSG_RAID_BOSS_WHISPER",
			"QUEST_BOSS_EMOTE",
			"RAID_BOSS_EMOTE",
			"RAID_BOSS_WHISPER",
		},
	},
	{
		["title"] = "Loot",
		["frame"] = "LootChatFrame",
		["events"] = {
			"CHAT_MSG_LOOT",
			"CHAT_MSG_MONEY",
			"CHAT_MSG_CURRENCY",
		},
	},
	{
		["title"] = "Misc",
		["frame"] = "MiscChatFrame",
		["events"] = {
			--"CHAT_MSG_ADDON",
			--"CHAT_MSG_LOOT",
			"CHAT_MSG_TRADESKILLS",
			--"CHAT_MSG_MONEY",
			--"CHAT_MSG_CURRENCY",
			"CHAT_MSG_PING",
			"CHAT_MSG_SKILL",
			"UNIT_ENTERED_VEHICLE",
			"PLAYER_GAINS_VEHICLE_DATA",
			"PLAYER_LOSES_VEHICLE_DATA",
			"UNIT_ENTERING_VEHICLE",
			"UNIT_EXITED_VEHICLE",
			"UNIT_EXITING_VEHICLE",
			"VEHICLE_UPDATE",
			"OPENING",
			"TRADESKILLS",
			"PET_INFO",
			"COMBAT_MISC_INFO",
			"COMBAT_XP_GAIN",
			"COMBAT_HONOR_GAIN",
			"COMBAT_FACTION_CHANGE",
		},
	},
	{
		["title"] = "CombatLog",
		["frame"] = "CombatLogChatFrame",
		["events"] = {
			"COMBATLOG_EVENT_UNFILTERED",
		},
	},
}

local chatColors = {
	["CHAT_MSG_MONSTER_SAY"] = {
		["r"] = 0.5,
		["g"] = 0.5,
		["b"] = 0.5,
		["a"] = 1,
	},
	["CHAT_MSG_MONSTER_WHISPER"] = {
		["r"] = 1,
		["g"] = 0.8,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_AFK"] = {
		["r"] = 1,
		["g"] = 1,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_DND"] = {
		["r"] = 1,
		["g"] = 1,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_ADDON"] = {
		["r"] = 1,
		["g"] = 1,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_CHANNEL"] = {
		["r"] = 0.992157,
		["g"] = 0.752941,
		["b"] = 0.752941,
		["a"] = 1,
	},
	["CHAT_MSG_CHANNEL_JOIN"] = {
		["r"] = 0.992157,
		["g"] = 0.752941,
		["b"] = 0.752941,
		["a"] = 1,
	},
	["CHAT_MSG_CHANNEL_LEAVE"] = {
		["r"] = 0.992157,
		["g"] = 0.752941,
		["b"] = 0.752941,
		["a"] = 1,
	},
	["CHAT_MSG_EMOTE"] = {
		["r"] = 1,
		["g"] = 0.5,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_TEXT_EMOTE"] = {
		["r"] = 1,
		["g"] = 0.5,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_GUILD"] = {
		["r"] = 0.235294,
		["g"] = 0.886275,
		["b"] = 0.247059,
		["a"] = 1,
	},
	["CHAT_MSG_GUILD_ACHIEVEMENT"] = {
		["r"] = 1,
		["g"] = 1,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_OFFICER"] = {
		["r"] = 0.250980,
		["g"] = 0.737255,
		["b"] = 0.250980,
		["a"] = 1,
	},
	["CHAT_MSG_MONSTER_SAY"] = {
		["r"] = 1,
		["g"] = 0.6,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_MONSTER_WHISPER"] = {
		["r"] = 1,
		["g"] = 0,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_PARTY"] = {
		["r"] = 0.666667,
		["g"] = 0.670588,
		["b"] = 1,
		["a"] = 1,
	},
	["CHAT_MSG_PARTY_LEADER"] = {
		["r"] = 0.4,
		["g"] = 0.4,
		["b"] = 0.8,
		["a"] = 1,
	},
	["CHAT_MSG_RAID"] = {
		["r"] = 1,
		["g"] = 0.5,
		["b"] = 0.039216,
		["a"] = 1,
	},
	["CHAT_MSG_RAID_LEADER"] = {
		["r"] = 1,
		["g"] = 0.282353,
		["b"] = 0.035294,
		["a"] = 1,
	},
	["CHAT_MSG_SAY"] = {
		["r"] = 1,
		["g"] = 1,
		["b"] = 1,
		["a"] = 1,
	},
	["CHAT_MSG_WHISPER"] = {
		["r"] = 1,
		["g"] = 0.4,
		["b"] = 0.7,
		["a"] = 1,
	},
	["CHAT_MSG_WHISPER_INFORM"] = {
		["r"] = 0.8,
		["g"] = 0.2,
		["b"] = 0.5,
		["a"] = 1,
	},
	["CHAT_MSG_YELL"] = {
		["r"] = 1,
		["g"] = 0,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_BATTLEGROUND"] = {
		["r"] = 1,
		["g"] = 0.5,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_BATTLEGROUND_LEADER"] = {
		["r"] = 1,
		["g"] = 0.862745,
		["b"] = 0.717647,
		["a"] = 1,
	},
	["CHAT_MSG_SYSTEM"] = {
		["r"] = 1,
		["g"] = 1,
		["b"] = 0,
		["a"] = 1,
	},
}

function AddMessageAll(text, r, g, b, a)
	for k,v in ipairs(ChatTabs) do
		_G[v.frame]:AddMessage(text, r, g, b, a)
	end
end

function AddMessageActive(text, r, g, b, a)
	for k,v in ipairs(ChatTabs) do
		local cf = _G[v.frame]

		if cf:IsVisible() then
			cf:AddMessage(text, r, g, b, a)
		end
	end
end

function GetActiveChatFrame()
	for k,v in ipairs(ChatTabs) do
		local cf = _G[v.frame]

		if cf:IsVisible() then
			return cf
		end
	end
end

function GetPublicNote(charName)
	if not IsInGuild() then return end

	local tmp = GetGuildRosterShowOffline()
	SetGuildRosterShowOffline(false)

	for i=1,GetNumGuildMembers(),1 do
		local name, _, _, _, _, _, note = GetGuildRosterInfo(i)

		if name == charName or charName == name:sub(1, -4) and note ~= "" then
			return note
		end
	end

	return false
end

function ChatPublicNotes_AddNote(self, event, msg, author, ...)
	if GetPublicNote(author) then msg = string.format("(|cffffff00%s|r) %s", GetPublicNote(author), msg) end

	return false, msg, author, ...
end

local function AddPlayerData(name, rank, level, class, note)
	--if not ChatFramePlayerData[name] then ChatFramePlayerData[name] = {} end
	ChatFramePlayerData[name] = ChatFramePlayerData[name] or {}

	if name ~= nil then ChatFramePlayerData[name].name = name end
	if level ~= nil then ChatFramePlayerData[name].level = level end
	if class ~= nil then ChatFramePlayerData[name].class = strupper(class) end
	if rank ~= nil then ChatFramePlayerData[name].rank = rank end
	if note ~= nil then ChatFramePlayerData[name].note = note end
end

local function GetPlayerLink(playerName, lineID)
	if strlen(playerName) == 0 then return end

	local link = ""
	local name, rank, _, level, class, note = GetGuildInfoByName(playerName)

	if name == playerName then
		AddPlayerData(playerName, rank, level, class, note)
		--AddMessageActive(("%s %s %s %s %s"):format(playerName or "playerName", rank or "rank", level or "level", class or "class", note or "note"))
		return ("|cff%02x%02x%02x|Hplayer:%s:%s|h%s|h|r"):format((RAID_CLASS_COLORS[strupper(class)].r * 255), (RAID_CLASS_COLORS[strupper(class)].g * 255), (RAID_CLASS_COLORS[strupper(class)].b * 255), playerName, lineID, playerName)
	elseif GetNumRaidMembers() > 0 then
		for i=1,GetNumRaidMembers(),1 do
			if UnitExists("raid"..i) and UnitName("raid"..i) == playerName then
				class = select(2, UnitClass("raid"..i))
				level = UnitLevel("raid"..i)
				AddPlayerData(playerName, nil, level, class, nil)
				return ("|cff%02x%02x%02x|Hplayer:%s:%s|h%s|h|r"):format(( RAID_CLASS_COLORS[strupper(class)].r * 255), ( RAID_CLASS_COLORS[strupper(class)].g * 255), ( RAID_CLASS_COLORS[strupper(class)].b * 255), playerName, lineID, playerName)
			end
		end
	elseif GetNumPartyMembers() > 0 then
		for i=1,GetNumPartyMembers(),1 do
			if UnitExists("party"..i) and UnitName("party"..i) == playerName then
				class = select(2, UnitClass("party"..i))
				level = UnitLevel("party"..i)
				AddPlayerData(playerName, nil, level, class, nil)
				return ("|cff%02x%02x%02x|Hplayer:%s:%s|h%s|h|r"):format(( RAID_CLASS_COLORS[strupper(class)].r * 255), ( RAID_CLASS_COLORS[strupper(class)].g * 255), ( RAID_CLASS_COLORS[strupper(class)].b * 255), playerName, lineID, playerName)
			end
		end
	elseif ChatFramePlayerData[playerName] ~= nil then
		class = ChatFramePlayerData[playerName].class
		level = ChatFramePlayerData[playerName].level
		return ("|cff%02x%02x%02x|Hplayer:%s:%s|h%s|h|r"):format(( RAID_CLASS_COLORS[strupper(class)].r * 255), ( RAID_CLASS_COLORS[strupper(class)].g * 255), ( RAID_CLASS_COLORS[strupper(class)].b * 255), playerName, lineID, playerName)
	else
		return ("|Hplayer:%s:%s|h%s|h|r"):format(playerName, lineID, playerName)
	end
end

local function ChatTabExists(name)
	for k, v in pairs(ChatTabs) do
		if v.frame == name then return k end
	end

	return false
end

local function SwitchChatTab(parent)
	if not ChatTabExists(parent:GetName()) then return end

	for k,v in pairs(ChatTabs) do
		if v.frame == parent:GetName() then
			--_G[v.frame.."Tab"]:SetAlpha(1)
			--_G[v.frame.."TabText"]:SetTextColor(1, 1, 1, 1)
			_G[v.frame.."Tab"].alerting = 0
			_G[v.frame]:Show()
			--_G[v.frame.."Tab"].glowBorder:Show()
			_G[v.frame.."Tab"].glowBorder:SetVertexColor(1, 1, 0)
		else
			--_G[v.frame.."Tab"]:SetAlpha(0.5)
			--_G[v.frame.."TabText"]:SetTextColor(0.5, 0.5, 0.5, 1)
			_G[v.frame]:Hide()
			--_G[v.frame.."Tab"].glowBorder:Hide()
			_G[v.frame.."Tab"].glowBorder:SetVertexColor(0, 0, 0)
		end
	end
end

local function OnEvent(self, event, ...)
	local text, playerName, languageName, channelName, _, specialFlags, zoneChannelID, channelIndex, channelBaseName, languageID, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, suppressRaidIcons = ...

	local r, g, b, a = 1, 1, 0, 1

	if chatColors[event] ~= nil then
		r = chatColors[event].r
		g = chatColors[event].g
		b = chatColors[event].b
		a = chatColors[event].a
	end

	local term
	if type(text) == "string" then
		for tag in string.gmatch(text, "%b{}") do
			term = strlower(string.gsub(tag, "[{}]", ""))
			if ( ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]] ) then
				text = string.gsub(text, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t")
			end
		end
	end

	local chanData = "["..BetterDate("%H:%M:%S", time()).."]"

	if channelBaseName ~= nil and channelIndex ~= 0 then
		chanData = chanData.."["..channelIndex.." - "..channelBaseName.."]"
		if channelBaseName:sub(1,3) == "Crb" then return end
	end

	if playerName ~= nil and type(playerName) == "string" and strlen(playerName) > 0 then
		local name, rank, _, level, class, note = GetGuildInfoByName(playerName)

		playerName = GetPlayerLink(playerName, lineID) or playerName
		--local note = GetPublicNote(playerName)

		--if strlen(playerName) > 0 then
		--	playerName = ("|Hplayer:%s:%s|h%s|h"):format(playerName, lineID, playerName)
		--end

		--[[
		if class ~= nil then
			class = strupper(class)
			playerName = ("|cff%02x%02x%02x|Hplayer:%s:%s|h%s|h|r"):format(( RAID_CLASS_COLORS[strupper(class)].r * 255), ( RAID_CLASS_COLORS[strupper(class)].g * 255), ( RAID_CLASS_COLORS[strupper(class)].b * 255), playerName, lineID, playerName)
		elseif GetNumRaidMembers() > 0 then
			for i=1,GetNumRaidMembers(),1 do
				if UnitName("raid"..i) == playerName then
					_, class = UnitClass("raid"..i)
					level = UnitLevel("raid"..i)
					ChatFramePlayerData[playerName].class = class
					ChatFramePlayerData[playerName].level = level
					playerName = ("|cff%02x%02x%02x|Hplayer:%s:%s|h%s|h|r"):format(( RAID_CLASS_COLORS[strupper(class)].r * 255), ( RAID_CLASS_COLORS[strupper(class)].g * 255), ( RAID_CLASS_COLORS[strupper(class)].b * 255), playerName, lineID, playerName)
					break
				end
			end
		elseif GetNumPartyMembers() > 0 then
			for i=1,GetNumPartyMembers(),1 do
				if UnitName("party"..i) == playerName then
					_, class = UnitClass("party"..i)
					level = UnitLevel("party"..i)
					ChatFramePlayerData[playerName].class = class
					ChatFramePlayerData[playerName].level = level
					playerName = ("|cff%02x%02x%02x|Hplayer:%s:%s|h%s|h|r"):format(( RAID_CLASS_COLORS[strupper(class)].r * 255), ( RAID_CLASS_COLORS[strupper(class)].g * 255), ( RAID_CLASS_COLORS[strupper(class)].b * 255), playerName, lineID, playerName)
					break
				end
			end
		elseif ChatFramePlayerData[playerName] then
			local player = ChatFramePlayerData[playerName]
			class = player.class
			level = player.level

			playerName = ("|cff%02x%02x%02x|Hplayer:%s:%s|h%s|h|r"):format((RAID_CLASS_COLORS[player.class].r * 255), (RAID_CLASS_COLORS[player.class].g * 255), (RAID_CLASS_COLORS[player.class].b * 255), playerName, lineID, playerName)
		else
			playerName = ("|Hplayer:%s:%s|h%s|h"):format(playerName, lineID, playerName)
		end
		]]

		if strlen(playerName) > 0 then
			chanData = chanData.."["..playerName.."]"
		end

		if name ~= false then
			chanData = ("%s[%s:%s]"):format(chanData, rank, level)
		elseif level ~= nil then
			chanData = ("%s[%s]"):format(chanData, level)
		end

		if note ~= "" and note ~= nil and note ~= false then
			chanData = chanData.."(|cffffffff"..note.."|r)"
		end

		if specialFlags ~= nil and strlen(specialFlags) > 0 then
			if specialFlags == "GM" then
				chanData = chanData.."|TInterface\\ChatFrame\\UI-ChatIcon-Blizz.blp:0:2:0:-3|t "
			else
				if getglobal("CHAT_FLAG_"..specialFlags) ~= nil then
					chanData = chanData..getglobal("CHAT_FLAG_"..specialFlags).." "
				end
			end
		end
	end

	if event == "PLAYER_ENTERING_WORLD" then
		self.defaultLanguage = GetDefaultLanguage()
		--SetCVar("colorChatNamesByClass", 1, true)
		--ChatFrame1ButtonFrame:HookScript("OnShow", function(self) self:Hide() end)
		--ChatFrame1ButtonFrame:Hide()
		--ChatFrameButtonFrame:HookScript("OnShow", function(self) self:Hide() end)
		--ChatFrameButtonFrame:Hide()
		--ChatFrameMenuButton:HookScript("OnShow", function(self) self:Hide() end)
		--ChatFrameMenuButton:Hide()

		ChatFrame1UpButton:Hide()
		ChatFrame1UpButton:HookScript("OnShow", function(self) self:Hide() end)
		ChatFrame1DownButton:Hide()
		ChatFrame1DownButton:HookScript("OnShow", function(self) self:Hide() end)
		ChatFrame1BottomButton:Hide()
		ChatFrame1BottomButton:HookScript("OnShow", function(self) self:Hide() end)
		ChatFrameMenuButton:Hide()
		ChatFrameMenuButton:HookScript("OnShow", function(self) self:Hide() end)

		--GuildChatFrame:AddMessageEventFilter("CHAT_MSG_GUILD", AddPlayerLevel)
	end

	if event == "UPDATE_CHAT_WINDOWS" or event == "VARIABLES_LOADED" or event == "PLAYER_ENTERING_WORLD" then
		--DEFAULT_CHAT_FRAME = ChatFrame

		for k,v in pairs(ChatTypeInfo) do
			v.colorNameByClass = true
		end

		--[[
		for k,v in ipairs(ChatTabs) do
			local cf = _G[v.frame]

			--if IsAddOnLoaded("CowmonsterUI_ActionBars") then
			--	cf:SetPoint("BOTTOMRIGHT", ActionBar1, "BOTTOMLEFT", 0, 0)
			--else
				cf:SetWidth((UIParent:GetWidth()-MainMenuBar:GetWidth())/2)
			--end
		end
		]]
		--ChatTabsFrame:SetWidth((UIParent:GetWidth()-MainMenuBar:GetWidth())/2)
		ChatTabsFrame:SetWidth(UIParent:GetWidth()-MainMenuBar:GetWidth())
		--ChatFrame1EditBox:ClearAllPoints()
		--ChatFrame1EditBox:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -5, -5)
		--ChatFrame1EditBox:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 5, -5)

		--ChatFrame1EditBox:SetBackdrop(nil)
		--ChatFrame1EditBoxLeft:Hide()
		--ChatFrame1EditBoxRight:Hide()
		--ChatFrame1EditBoxMid:Hide()
		--ChatFrame1EditBox:Hide()

		ChatFrameEditBox:ClearAllPoints()
		ChatFrameEditBox:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -5, -5)
		ChatFrameEditBox:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 5, -5)

		ChatFrameEditBox:SetBackdrop(nil)
		ChatFrameEditBoxLeft:Hide()
		ChatFrameEditBoxRight:Hide()
		--ChatFrameEditBoxMid:Hide()
		ChatFrameEditBox:Hide()

		for i=1, NUM_CHAT_WINDOWS, 1 do
			local n = _G["ChatFrame"..i]
			local t = _G["ChatFrame"..i.."Tab"]

			t:Hide()

			t:SetScript("OnShow", function(self) self:Hide() end)

			n:ClearAllPoints()
			n:SetClampedToScreen(false)
			n:SetPoint("RIGHT", UIParent, "LEFT", -500, 0)
		end
	elseif event == "UPDATE_CHAT_COLOR" then
		local arg1, arg2, arg3, arg4 = ...
		local info = ChatTypeInfo[strupper(arg1)]

		if ( info ) then
			info.r = arg2;
			info.g = arg3;
			info.b = arg4;
			self:UpdateColorByID(info.id, info.r, info.g, info.b);

			if ( strupper(arg1) == "WHISPER" ) then
				info = ChatTypeInfo["REPLY"];
				if ( info ) then
					info.r = arg2;
					info.g = arg3;
					info.b = arg4;
					self:UpdateColorByID(info.id, info.r, info.g, info.b);
				end
			end
		end
	elseif event == "UPDATE_CHAT_COLOR_NAME_BY_CLASS" then
		local arg1 = ...
		local info = ChatTypeInfo[strupper(arg1)]

		if ( info ) then
			info.colorNameByClass = true;
			if ( strupper(arg1) == "WHISPER" ) then
				info = ChatTypeInfo["REPLY"];
				if ( info ) then
					info.colorNameByClass = true;
				end
			end
		end
	elseif event == "UPDATE_INSTANCE_INFO" then

	elseif event == "CHAT_SERVER_DISCONNECTED" then

	elseif event == "CHAT_SERVER_RECONNECTED" then

	elseif event == "CHAT_MSG_LOOT" then
		self:AddMessage(text, r, g, b, a)
	elseif event == "CHAT_MSG_MONEY" then
		self:AddMessage(text, r, g, b, a)
	elseif event == "CHAT_MSG_TRADESKILL" then
		self:AddMessage(text, r, g, b, a)
	elseif event == "CHAT_MSG_SYSTEM" then
		--[[
		local text = ...
		if string.find(text, "come online") then
			--local s = string.find(text, '[')
			--local e = string.find(text, ']')
			--print(string.sub(text, s, e))
			GuildChatFrame:AddMessage(text, r, g, b, a)
		elseif string.find(text, "gone offline") then
			GuildChatFrame:AddMessage(text, r, g, b, a)
		elseif string.find(text, "joined the guild") then
			GuildChatFrame:AddMessage(text, r, g, b, a)
		elseif string.find(text, "left the guild") then
			GuildChatFrame:AddMessage(text, r, g, b, a)
		elseif string.find(text, "Guild") then
			GuildChatFrame:AddMessage(text, r, g, b, a)
		else
			self:AddMessage(text, r, g, b, a)
		end
		]]
		--AddMessageActive(text, r, g, b, a)
		AddMessageAll(text, r, g, b, a)
	elseif event == "CHAT_MSG_ACHIEVEMENT" then
		AddMessageActive(text:format(chanData), r, g, b, a)
	elseif event == "CHAT_MSG_GUILD_ACHIEVEMENT" then
		AddMessageActive(text:format(chanData), r, g, b, a)
	elseif event == "CHAT_MSG_EMOTE" then
		AddMessageActive(("%s: %s"):format(chanData, text), r, g, b, a)
	elseif event == "CHAT_MSG_TEXT_EMOTE" then
		AddMessageActive(text, r, g, b, a)
	elseif event == "WHO_LIST_UPDATE" then
		--[[
		if self:IsVisible() == nil then
			_G[self:GetName().."Tab"].alerting = 1
		end

		local total = GetNumWhoResults()

		if total > 0 then
			for i=1,total,1 do
				local name, guild, level, race, class, zone = GetWhoInfo(i)
				--if guild == "" or guild == nil then
					--GuildInvite(name)
					--GuildInvites[#(GuildInvites)] = name
				--end
				name = ("|cff%02x%02x%02x%s|r"):format((RAID_CLASS_COLORS[strupper(class)].r * 255), (RAID_CLASS_COLORS[strupper(class)].g * 255), (RAID_CLASS_COLORS[strupper(class)].b * 255), name)

				WhoChatFrame:AddMessage(("%s <%s> level %s %s %s in %s"):format(name, guild, level, race, class, zone), r, g, b, a)
			end
		end
		]]

		local total = GetNumWhoResults()

		if total > 0 then
			for i=1,total,1 do
				local name, guild, level, race, class, zone = GetWhoInfo(i)

				AddPlayerData(name, rank, level, class, nil)
			end
		end
	elseif event == "CHAT_MSG_WHISPER" then
		if self:IsVisible() == nil then
			_G[self:GetName().."Tab"].alerting = 1
		end

		self:AddMessage(("%s: %s"):format(chanData, (text or "")), r, g, b, a)	
	elseif event == "CHAT_MSG_WHISPER_INFORM" then
		if self:IsVisible() == nil then
			_G[self:GetName().."Tab"].alerting = 1
		end

		self:AddMessage(("To %s: %s"):format(chanData, (text or "")), r, g, b, a)	

	elseif event == "UNIT_ENTERED_VEHICLE" then
		local unitTarget, showVehicleFrame, isControlSeat, vehicleUIIndicatorID, vehicleGUID, mayChooseExit, hasPitch = ...

		self:AddMessage(("%s %s"):format(event, unitTarget), r, g, b, a)
	elseif event == "PLAYER_GAINS_VEHICLE_DATA" then
		local unitTarget, vehicleUIIndicatorID = ...

		self:AddMessage(("%s %s"):format(unitTarget, vehicleUIIndicatorID), r, g, b, a)
	elseif event == "PLAYER_LOSES_VEHICLE_DATA" then
		local unitTarget = ...

		self:AddMessage(unitTarget, r, g, b, a)		
	elseif event == "UNIT_ENTERING_VEHICLE" then
		local unitTarget, showVehicleFrame, isControlSeat, vehicleUIIndicatorID, vehicleGUID, mayChooseExit, hasPitch = ...

		self:AddMessage(event.." "..unitTarget, r, g, b, a)
	elseif event == "UNIT_EXITED_VEHICLE" then
		local unitTarget = ...

		self:AddMessage(event.." "..unitTarget, r, g, b, a)
	elseif event == "UNIT_EXITING_VEHICLE" then
		local unitTarget = ...

		self:AddMessage(event.." "..unitTarget, r, g, b, a)
	elseif event == "VEHICLE_UPDATE" then
		self:AddMessage(event, r, g, b, a)
	else
		if self:IsVisible() == nil then
			_G[self:GetName().."Tab"].alerting = 1
		end

		--[[
		if specialFlags ~= nil then
			msg = msg.."("..specialFlags..")"
		end
		]]

		self:AddMessage(("%s: %s"):format(chanData, (text or "")), r, g, b, a)	
	end

	--[[
	for _,v in ipairs(ToastEvents) do
		if v == event then
			UIErrorsFrame:AddMessage(("%s: %s"):format(chanData, (text or "")), r, g, b, a);
			ToastChatFrame:AddMessage(("%s: %s"):format(chanData, (text or "")), r, g, b, a);
		end
	end
	]]
end

local function ChatTab_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed
	self.colorIndex = (self.colorIndex or 1)

	if self.timer >= 0.1 then
		if self.alerting == 1 then
			if self.colorIndex < 20 then
				if self.colorIndex <= 10 then
					self.glowBorder:SetAlpha(self.colorIndex/10)
				else
					self.glowBorder:SetAlpha(1-((self.colorIndex-10)/10))
				end

				self.glowBorder:SetVertexColor(1, 0.5, 0)
				self.colorIndex = self.colorIndex + 1
			else
				self.glowBorder:SetAlpha(0)
				self.colorIndex = 1
			end
		end

		self.timer = 0
	end
end

local function OnHyperlinkEnter(self, link)
	for i=1,#(ChatTabs),1 do
		_G[ChatTabs[i].frame].action = "grow"
	end

	local type = strmatch(link, "^(.-):")
	if(type == "item" or type == "enchant" or type == "spell" or type == "quest") then
		ShowUIPanel(GameTooltip)
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
		GameTooltip:SetHyperlink(link)
		GameTooltip:Show()
	end
end

local function OnHyperlinkLeave(self, link)
	local type = strmatch(link, "^(.-):")
	if(type == "item" or type == "enchant" or type == "spell" or type == "quest") then
		HideUIPanel(GameTooltip)
	end
end

local ctf = CreateFrame("Frame", "ChatTabsFrame", UIParent)
ctf:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )
ctf:SetScript("OnEnter", function(self)
	for i=1,#(ChatTabs),1 do
		_G[ChatTabs[i].frame].action = "grow"
	end
end)
ctf:SetScript("OnLeave", function(self)
	for i=1,#(ChatTabs),1 do
		_G[ChatTabs[i].frame].action = "shrink"
	end
end)
ctf:Show()

if IsAddOnLoaded("CowmonsterUI_InfoBar") then
	ChatTabsFrame:SetPoint("BOTTOMLEFT", InfoBarFrame, "TOPLEFT", 0, 0)
else
	ChatTabsFrame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
end

local cf = CreateFrame("ScrollingMessageFrame", "ToastChatFrame", UIParent)
cf:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
cf:EnableMouse(false)
cf:SetWidth(500)
cf:SetHeight(300)

cf:EnableKeyboard(false)
cf:EnableMouseWheel(false)
cf:SetFading(true)
cf:SetTimeVisible(10)
cf:SetFadeDuration(3)

cf:SetFont("Fonts\\ARIALN.TTF", FontSize+2, "OUTLINE")
cf:SetTextColor(1, 1, 1, 1)
cf:SetJustifyH("LEFT")
cf:SetMaxLines(64)

--cf:AddMessage("ToastChatFrame loaded.")

for _,event in ipairs(ToastEvents) do
	cf:RegisterEvent(event)
	--cf:AddMessage(event.." registered with ToastChatFrame.")
end
cf:SetScript("OnEvent", OnEvent)

for i=1,#(ChatTabs),1 do
	local cf = _G[ChatTabs[i].frame] or CreateFrame("ScrollingMessageFrame", ChatTabs[i].frame, UIParent)

	--local ct = CreateFrame("Button", cf:GetName().."Tab", UIParent)
	local ct = CreateFrame("Button", cf:GetName().."Tab", ChatTabsFrame)

	ChatFrame.topOffset = 19

	if i == 1 then
		ct:SetPoint("BOTTOMLEFT", ChatTabsFrame, "BOTTOMLEFT", 0, 0)
	elseif i % TabsPerRow == 1 then
		ChatFrame.topOffset = (19 * ceil(i / TabsPerRow))
		ct:SetPoint("BOTTOMLEFT", _G[ChatTabs[(i-TabsPerRow)].frame.."Tab"], "TOPLEFT", 0, 0)
	else
		ChatFrame.topOffset = (19 * ceil(i / TabsPerRow))
		ct:SetPoint("LEFT", _G[ChatTabs[(i-1)].frame.."Tab"], "RIGHT", 2, 0)
	end

	ChatTabsFrame:SetHeight(ChatFrame.topOffset)

	--ct:SetAlpha(0.5)
	ct:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

	local ctl = ct:CreateFontString(ct:GetName().."Text", "OVERLAY")
	ctl:SetFont("Fonts\\ARIALN.ttf", FontSize, "OUTLINE")
	ctl:SetAllPoints(ct)
	ctl:SetJustifyH("CENTER")
	ctl:SetText(ChatTabs[i].title)
	--ct:SetSize(ctl:GetStringWidth()+30, 18)
	ct:SetWidth(ctl:GetStringWidth()+30)
	--ct:SetHeight(18)
	ct:SetHeight(ButtonHeight)
	--ctl:SetTextColor(0.5, 0.5, 0.5, 1)
	ctl:SetTextColor(1, 1, 1, 1)
	ctl:Show()
	ct:Show()
	ct:SetScript("OnClick", function(self, button)
		SwitchChatTab(_G[(self:GetName()):sub(1, -4)])
	end)
	ct:SetScript("OnEnter", function(self)
		for i=1,#(ChatTabs),1 do
			_G[ChatTabs[i].frame].action = "grow"
		end
	end)
	ct:SetScript("OnLeave", function(self)
		for i=1,#(ChatTabs),1 do
			_G[ChatTabs[i].frame].action = "shrink"
		end
	end)
	ct.timer = 0
	ct.colorIndex = 1
	ct.alerting = 0

	ct.glowBorder = ct:CreateTexture(nil, "OVERLAY")
	ct.glowBorder:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
	ct.glowBorder:SetBlendMode("ADD")
	ct.glowBorder:SetAlpha(0.8)
	ct.glowBorder:SetVertexColor(1, 1, 0)
	--ct.glowBorder:SetWidth(ct:GetWidth()+16)
	ct.glowBorder:SetWidth(ct:GetWidth()+32)
	ct.glowBorder:SetHeight(ct:GetHeight()+16)
	ct.glowBorder:SetPoint("CENTER", ct, "CENTER", 0, 0)

	ct:SetScript("OnUpdate", ChatTab_OnUpdate)

	cf:EnableKeyboard(true)
	cf:EnableMouse(true)
	cf:EnableMouseWheel(true)
	cf:SetFading(false)

	--cf:SetFont("Fonts\\ARIALN.TTF", 16, "OUTLINE")
	cf:SetFont("Fonts\\ARIALN.TTF", FontSize, "OUTLINE")
	cf:SetTextColor(1, 1, 1, 1)
	cf:SetJustifyH("LEFT")
	cf:SetMaxLines(4096)
	cf:SetID(i)
	cf:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

	cf:SetHeight(150)

	--cf:SetPoint("BOTTOMLEFT", _G[ChatTabs[1].frame.."Tab"], "TOPLEFT", 0, ChatFrame.topOffset)
	cf:SetPoint("BOTTOMLEFT", ChatTabsFrame, "TOPLEFT", 0, 0)
	cf:SetPoint("BOTTOMRIGHT", ChatTabsFrame, "TOPRIGHT", 0, 0)

	--if i == 1 then
		--[[
		if IsAddOnLoaded("CowmonsterUI_InfoBar") then
			cf:SetPoint("BOTTOMLEFT", InfoBarFrame, "TOPLEFT", 0, 0)
		else
			cf:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
		end
		]]
	--else
	--	cf:SetAllPoints(_G[ChatTabs[1].frame])
	--end
	--if IsAddOnLoaded("CowmonsterUI_ActionBars") then
	--	cf:SetPoint("BOTTOMRIGHT", ActionBar1, "BOTTOMLEFT", 0, 0)
	--else
		--cf:SetWidth((UIParent:GetWidth()-MainMenuBar:GetWidth())/2)
		--ChatTabsFrame:SetWidth(cf:GetWidth())
		--cf:SetWidth(500)
	--end

	for k,v in pairs(ChatTabs[i].events) do
		cf:RegisterEvent(v)
		ChatFrame1:UnregisterEvent(v)
	end

	cf.show = {
		["achievement"] = true,
		["enchant"] = true,
		["glyph"] = true,
		["item"] = true,
		["instancelock"] = true,
		["quest"] = true,
		["spell"] = true,
		["talent"] = true,
		["unit"] = true,
	}

	cf.flashTimer = 0
	cf.tellTimer = GetTime()
	cf.channelList = {}
	cf.zoneCHannelList = {}
	cf.messageTypeList = {}
	cf.defaultLanguage = GetDefaultLanguage()

	cf:SetScript("OnEnter", function(self)
		for i=1,#(ChatTabs),1 do
			local cf = _G[ChatTabs[i].frame]

			--cf:SetHeight(450)
			cf.action = "grow"
		end
	end)

	cf:SetScript("OnLeave", function(self)
		for i=1,#(ChatTabs),1 do
			local cf = _G[ChatTabs[i].frame]

			--cf:SetHeight(150)
			cf.action = "shrink"
		end
	end)

	cf:SetScript("OnUpdate", function(self, elapsed)
		self.timer = (self.timer or 0) + elapsed

		if self.timer >= 0.01 then
			for i=1,#(ChatTabs),1 do
				if self.action == "shrink" and self:GetHeight() > 150 then
					local newHeight = self:GetHeight() - 50

					if newHeight < 150 then
						_G[ChatTabs[i].frame]:SetHeight(150)
					else
						_G[ChatTabs[i].frame]:SetHeight(newHeight)
					end
				elseif self.action == "grow" and self:GetHeight() < 600 then
					local newHeight = self:GetHeight() + 50

					if newHeight > 600 then
						_G[ChatTabs[i].frame]:SetHeight(600)
					else
						_G[ChatTabs[i].frame]:SetHeight(newHeight)
					end
				end
			end

			self.timer = 0
		end
	end)

	cf:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)
	cf:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)

	cf:SetScript("OnEvent", OnEvent)

	cf:SetScript("OnHyperlinkClick", function() ChatFrame_OnHyperlinkShow(arg1, arg2, arg3); end);

	cf:SetScript("OnMouseWheel", function(self, delta)
		if delta > 0 then
			self:ScrollUp()
		else
			self:ScrollDown()
		end
	end)
end

--[[
DEFAULT_CHAT_FRAME:AddMessage = function (...)
	GetActiveChatFrame():AddMessage(...)
end
]]

function DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b, a)
	GetActiveChatFrame():AddMessage(msg, r, g, b, a)
end

function print(...)
	local msg = ""
	for _,v in ipairs(...) do
		if msg == "" then
			msg = v
		else
			msg = msg.." "..v
		end
	end
	GetActiveChatFrame():AddMessage(msg)
end

--[[
print = function (...)
	local msg = ""

	for _,v in ipairs(...) do
		msg = msg.." "..v
	end

	GetActiveChatFrame():AddMessage(trim(msg))
end
]]

--function ChatFrame_BNOnlineAddNameFilter(self, event, presenceID)
--	local _, _, _, toonName, _, client = BNGetFriendInfoByID(presenceID)
--
--	if client == "WoW" then
--		DEFAULT_CHAT_FRAME:AddMessage("|Hplayer:"..toonName.."|h["..toonName.."]|h has come online.", 1, 1, 0, 1)
--		return true
--	else
--		return false
--	end
--end

--function ChatFrame_BNChatAddNameFilter(self, event, msg, author, ...)
--	local presenceID = select(11, ...)
--
--	local _, _, _, toonName, _, client = BNGetFriendInfoByID(presenceID)
--
--	if client == "WoW" then
--		return false, string.format("|Hplayer:%s|h(%s)|h %s", toonName, toonName, msg), author, ...
--	else
--		return false
--	end
--end


function IsChatEvent(event)
	if event:sub(1, 9) == "CHAT_MSG_" then
		return true
	else
		return false
	end
end

local function IsInCity()
	if select(2, EnumerateServerChannels()) == "Trade" then
		return true
	else
		return false
	end
end

function GetGuildInfoByName(memberName)
	for i=1,GetNumGuildMembers(),1 do
		local name, rank, rankIndex, level, class, _, note = GetGuildRosterInfo(i)

		if name == memberName then
			return name, rank, rankIndex, level, class, note
		end
	end
	return false
end

local function AddPlayerLevel(self, event, msg, author, ...)
	local name, rank, rankIndex, level, class = GetGuildInfoByName(author)

	if name ~= false then
		return false, "["..level.."]"..msg, author, ...
	end
end

--[[
ChatFrame1EditBox:HookScript("OnShow", function(self)
	ChatFrame1EditBox:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 10, right = 10, top = 10, bottom = 10 } } )
end)

ChatFrame1EditBox:HookScript("OnHide", function(self)
	ChatFrame1EditBox:SetBackdrop(nil)
	ChatFrame1EditBoxLeft:Hide()
	ChatFrame1EditBoxRight:Hide()
	ChatFrame1EditBoxMid:Hide()
	ChatFrame1EditBox:Hide()
end)
]]

ChatFrameEditBox:HookScript("OnShow", function(self)
	ChatFrameEditBoxLeft:Show()
	ChatFrameEditBoxRight:Show()
	--self:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 10, right = 10, top = 10, bottom = 10 } } )
	self:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 10, right = 10, top = 10, bottom = 10 } } )
	--self:SetBackdrop( { bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 10, right = 10, top = 10, bottom = 10 } } )
end)

ChatFrameEditBox:HookScript("OnHide", function(self)
	self:SetBackdrop(nil)
	ChatFrameEditBoxLeft:Hide()
	ChatFrameEditBoxRight:Hide()
	--ChatFrameEditBoxMid:Hide()
	--ChatFrameEditBox:Hide()
end)

SwitchChatTab(_G[ChatTabs[1].frame])
