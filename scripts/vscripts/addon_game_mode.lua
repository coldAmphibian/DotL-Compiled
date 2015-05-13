-- load required LUA files
require('spell_shop_UI')
require('util')

-- Generated from template
if CAddonLeagueOfLegends == nil then
	CAddonLeagueOfLegends = class({})
end

function Precache(context)
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource("model", "*.vmdl", context)
			PrecacheResource("soundfile", "*.vsndevts", context)
			PrecacheResource("particle", "*.vpcf", context)
			PrecacheResource("particle_folder", "particles/folder", context)
	]]
end

-- Runs on startup
function Activate()
	GameRules.AddonTemplate = CAddonLeagueOfLegends()
	GameRules.AddonTemplate:InitGameMode()
	SelectTowerLogic()
end

--Selects tower logic to use
function SelectTowerLogic()
	MapName = GetMapName()
	if MapName == "brush_test" or MapName == "summoners_rift" then
		file = "summoners_rift_tower_logic"
	end

	if MapName == "howling_abyss" or MapName == "howling_abyss_45" then
		file = "howling_abyss_tower_logic"
	end

	if file == nil then
		print("no tower logic loaded")
	else
		require(file)
	end
end

--Game Rules
function CAddonLeagueOfLegends:InitGameMode()
	SpellShopUI:InitGameMode();
	GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)
	GameRules:GetGameModeEntity():SetCameraDistanceOverride(1134)
	GameRules:SetPreGameTime(0)
	GameRules:SetGoldPerTick(100000)

	print("GameMode Initialised")
end

-- Evaluate the state of the game
function CAddonLeagueOfLegends:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print("Template addon script is running.")
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function CAddonLeagueOfLegends:OnHeroInGame(hero)
  --print("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

  --[[ Multiteam configuration, currently unfinished

  local team = "team1"
  local playerID = hero:GetPlayerID()
  if playerID > 3 then
    team = "team2"
  end
  print("setting " .. playerID .. " to team: " .. team)
  MultiTeam:SetPlayerTeam(playerID, team)]]

  -- This line for example will set the starting gold of every hero to 500 unreliable gold
  hero:SetGold(500, false)

  -- These lines will create an item and add it to the player, effectively ensuring they start with the item
  --local item = CreateItem("item_multiteam_action", hero, hero)
  --hero:AddItem(item)

  --[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
    --with the "example_ability" ability

  local abil = hero:GetAbilityByIndex(1)
  hero:RemoveAbility(abil:GetAbilityName())
  hero:AddAbility("example_ability")]]

  --[[Move to this system after
  local kvpairs = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
  PrintTable(kvpairs)
  ]]
  for i=1,24 do
    hero:HeroLevelUp(false)
  end

  local i = 0
  local ability = hero:GetAbilityByIndex(i)

  repeat
    if ability:GetSpecialValueFor("champion_passive") == 1 then
        ability:SetLevel(1)
        print("Detected champion passive: " .. ability:GetAbilityName())
    end

    i = i + 1
    ability = hero:GetAbilityByIndex(i)
  until ability == nil
end