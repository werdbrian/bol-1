local EnemyHeroes = GetEnemyHeroes()

 -- updater
local version = 1.00
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/can he kill me.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."Yours Teemo.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>can he kill me:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/can he kill me.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available"..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end
--

function OnLoad()
 
Variables()
menu()

end
 
function Variables()
ChampionCount = 0
    ChampionTable = {}
 
    for i = 1, heroManager.iCount do
        local champ = heroManager:GetHero(i)
               
        if champ.team ~= player.team then
            ChampionCount = ChampionCount + 1
            ChampionTable[ChampionCount] = { player = champ, indicatorText = "", damageGettingText = "", ultAlert = false, ready = true}
        end
    end
end
 
function OnTick()
	DmgCalc()
end
 
 
function menu()
	myConfig = scriptConfig("Can he kill me?","can he kill me?")
 
	myConfig:addSubMenu("Drawing Settings", "drawing")
	myConfig.drawing:addParam("drawText", "Draw Champion Text", SCRIPT_PARAM_ONOFF, true)
	local i, Champion
	for i, Champion in ipairs(EnemyHeroes) do
		myConfig.drawing:addParam(Champion.charName,"Draw for: " .. Champion.charName .. "?", SCRIPT_PARAM_LIST, 1, {"YES", "NO"})
	end
end
 
 
 
function DmgCalc()
    for i = 1, ChampionCount do
        local Champion = ChampionTable[i].player
        if ValidTarget(Champion) and Champion.visible then
               
               
        SpellQ = getDmg("Q", myHero, Champion)
        SpellW = getDmg("W", myHero, Champion)
        SpellE = getDmg("E", myHero, Champion)
        SpellR = getDmg("R", myHero, Champion)
        SpellI = getDmg("IGNITE", myHero, Champion)
 

        if myHero.health < SpellR then
            ChampionTable[i].indicatorText = "Killed with: R"

        elseif myHero.health < SpellQ then
            ChampionTable[i].indicatorText = "Killed with: Q"

        elseif myHero.health < SpellW then
            ChampionTable[i].indicatorText = "Killed with: W"

        elseif myHero.health < SpellE then
            ChampionTable[i].indicatorText = "Killed with: E"

        elseif myHero.health < SpellQ + SpellR then
            ChampionTable[i].indicatorText = "Killed with: Q + R"

        elseif myHero.health < SpellW + SpellR then
            ChampionTable[i].indicatorText = "Killed with: W + R"

        elseif myHero.health < SpellE + SpellR then
            ChampionTable[i].indicatorText = "Killed with: E + R"

        elseif myHero.health < SpellQ + SpellW + SpellR then
            ChampionTable[i].indicatorText = "Killed  with: Q + W + R"

        elseif myHero.health < SpellQ + SpellE + SpellR then
            ChampionTable[i].indicatorText = "Killed with: Q + E + R"

        else
            local dmgTotal = (SpellQ + SpellW + SpellE + SpellR)
            local hpLeft = math.round(myHero.health - dmgTotal)
            local percentLeft = math.round(hpLeft / myHero.maxHealth * 100)
                ChampionTable[i].indicatorText = "Cant kill me ( " .. percentLeft .. "% )"
        end
 
            local ChampionAD = getDmg("AD", myHero, Champion)  
            ChampionTable[i].damageGettingText = Champion.charName .. " kills me with " .. math.ceil(myHero.health / ChampionAD) .. " hits"
        end
    end
end
 
 
 
function OnDraw()                                                                                                
    if myConfig.drawing.drawText then                
        for i = 1, ChampionCount do
            local Champion = ChampionTable[i].player
 
			if ValidTarget(Champion) and Champion.visible and myConfig.drawing[Champion.charName] == 1 then
				local barPos = WorldToScreen(D3DXVECTOR3(Champion.x, Champion.y, Champion.z))
				local pos = { X = barPos.x - 35, Y = barPos.y - 50 }

				DrawText(ChampionTable[i].indicatorText, 15, pos.X + 20, pos.Y, (ChampionTable[i].ready and ARGB(255, 0, 255, 0)) or ARGB(255, 255, 220, 0))
				DrawText(ChampionTable[i].damageGettingText, 15, pos.X + 20, pos.Y + 15, ARGB(255, 255, 0, 0))
			end
        end
    end            
 end
