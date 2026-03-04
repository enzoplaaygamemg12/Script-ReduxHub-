-- =====================================================
--         Redux Hub - Blox Fruits Script
--         by Redux Studio V1.0
--         Compatible with: Seliware, Velocity, Ronix
-- =====================================================

local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/enzoplaaygamemg12/GUI123/refs/heads/main/RedzUiLib.lua"))()

-- =====================================================
-- SERVICES
-- =====================================================
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local VirtualUser       = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService       = game:GetService("HttpService")
local Lighting          = game:GetService("Lighting")

local Player            = Players.LocalPlayer
local Character         = Player.Character or Player.CharacterAdded:Wait()
local Humanoid          = Character:WaitForChild("Humanoid")
local HumanoidRootPart  = Character:WaitForChild("HumanoidRootPart")
local Camera            = workspace.CurrentCamera

Player.CharacterAdded:Connect(function(c)
    Character        = c
    Humanoid         = c:WaitForChild("Humanoid")
    HumanoidRootPart = c:WaitForChild("HumanoidRootPart")
end)

-- =====================================================
-- LANGUAGE SYSTEM
-- =====================================================
local LANG_URL = "https://raw.githubusercontent.com/enzoplaaygamemg12/GUI123/refs/heads/main/Language.json"
local LangData = {}
local CurrentLang = "English"

local function LoadLanguage()
    local ok, raw = pcall(function() return game:HttpGet(LANG_URL, true) end)
    if ok and raw then
        local ok2, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
        if ok2 and decoded then LangData = decoded end
    end
end
LoadLanguage()

local function T(key, vars)
    local lang = LangData[CurrentLang] or LangData["English"] or {}
    local str = lang[key] or (LangData["English"] and LangData["English"][key]) or key
    if vars then
        for k, v in pairs(vars) do str = str:gsub("{"..k.."}", tostring(v)) end
    end
    return str
end

-- =====================================================
-- DETECT SEA
-- =====================================================
local PlaceId = game.PlaceId
local function GetSea()
    local seaMap = { [2753915549]=1, [4442272183]=2, [7449423635]=3 }
    return seaMap[PlaceId] or 1
end
local CurrentSea = GetSea()

-- =====================================================
-- DATA TABLES
-- =====================================================
local QuestList = {
    {Level=0,   Sea=1, Name="BanditQuest",     NPC=CFrame.new(1059,16,1549)},
    {Level=0,   Sea=1, Name="MarineQuest",      NPC=CFrame.new(-2709,24,2103)},
    {Level=15,  Sea=1, Name="JungleQuest1",     NPC=CFrame.new(-1597,36,149)},
    {Level=20,  Sea=1, Name="JungleQuest2",     NPC=CFrame.new(-1597,36,149)},
    {Level=30,  Sea=1, Name="PirateQuest1",     NPC=CFrame.new(-1138,4,3830)},
    {Level=40,  Sea=1, Name="PirateQuest2",     NPC=CFrame.new(-1138,4,3830)},
    {Level=60,  Sea=1, Name="DesertQuest1",     NPC=CFrame.new(893,6,4391)},
    {Level=75,  Sea=1, Name="DesertQuest2",     NPC=CFrame.new(893,6,4391)},
    {Level=90,  Sea=1, Name="SnowQuest1",       NPC=CFrame.new(1385,87,-1296)},
    {Level=100, Sea=1, Name="SnowQuest2",       NPC=CFrame.new(1385,87,-1296)},
    {Level=120, Sea=1, Name="MarineQuest2",     NPC=CFrame.new(-5038,28,4323)},
    {Level=150, Sea=1, Name="SkyQuest",         NPC=CFrame.new(-4838,717,-2618)},
    {Level=190, Sea=1, Name="PrisonQuest1",     NPC=CFrame.new(5310,1,476)},
    {Level=210, Sea=1, Name="PrisonQuest2",     NPC=CFrame.new(5310,1,476)},
    {Level=250, Sea=1, Name="ColosseumQuest",   NPC=CFrame.new(-1752,7,-2779)},
    {Level=300, Sea=1, Name="MagmaQuest",       NPC=CFrame.new(-5344,8,8531)},
    {Level=375, Sea=1, Name="FishmanQuest",     NPC=CFrame.new(61123,18,1564)},
    {Level=450, Sea=1, Name="SkyExp1Quest",     NPC=CFrame.new(-4720,845,-1951)},
    {Level=625, Sea=1, Name="FountainQuest",    NPC=CFrame.new(5259,37,4050)},
    {Level=700,  Sea=2, Name="RaiderQuest",     NPC=CFrame.new(-429,73,1836)},
    {Level=725,  Sea=2, Name="MercenaryQuest",  NPC=CFrame.new(-429,73,1836)},
    {Level=750,  Sea=2, Name="SwanQuest",       NPC=CFrame.new(-968,73,1836)},
    {Level=875,  Sea=2, Name="GreenZoneQ1",     NPC=CFrame.new(-1020,73,-2490)},
    {Level=900,  Sea=2, Name="GreenZoneQ2",     NPC=CFrame.new(-1020,73,-2490)},
    {Level=950,  Sea=2, Name="GraveyardQ1",     NPC=CFrame.new(-5492,48,-794)},
    {Level=975,  Sea=2, Name="GraveyardQ2",     NPC=CFrame.new(-5492,48,-794)},
    {Level=1000, Sea=2, Name="SnowMountainQ1",  NPC=CFrame.new(609,400,-5372)},
    {Level=1050, Sea=2, Name="SnowMountainQ2",  NPC=CFrame.new(609,400,-5372)},
    {Level=1100, Sea=2, Name="HotColdQ1",       NPC=CFrame.new(-6438,15,-4601)},
    {Level=1125, Sea=2, Name="HotColdQ2",       NPC=CFrame.new(-6438,15,-4601)},
    {Level=1250, Sea=2, Name="CursedShipQ1",    NPC=CFrame.new(-5120,73,-3000)},
    {Level=1275, Sea=2, Name="CursedShipQ2",    NPC=CFrame.new(-5120,73,-3000)},
    {Level=1300, Sea=2, Name="IceCastleQ1",     NPC=CFrame.new(61123,18,-1564)},
    {Level=1325, Sea=2, Name="IceCastleQ2",     NPC=CFrame.new(61123,18,-1564)},
    {Level=1500, Sea=3, Name="PortTownQ1",      NPC=CFrame.new(-290,44,5374)},
    {Level=1525, Sea=3, Name="PortTownQ2",      NPC=CFrame.new(-290,44,5374)},
    {Level=1575, Sea=3, Name="HydraQ1",         NPC=CFrame.new(5740,611,-1330)},
    {Level=1600, Sea=3, Name="HydraQ2",         NPC=CFrame.new(5740,611,-1330)},
    {Level=1625, Sea=3, Name="GreatTreeQ1",     NPC=CFrame.new(-1320,332,-762)},
    {Level=1650, Sea=3, Name="GreatTreeQ2",     NPC=CFrame.new(-1320,332,-762)},
    {Level=1675, Sea=3, Name="TurtleQ1",        NPC=CFrame.new(-1320,332,-762)},
    {Level=1700, Sea=3, Name="TurtleQ2",        NPC=CFrame.new(-1320,332,-762)},
    {Level=1725, Sea=3, Name="HauntedQ1",       NPC=CFrame.new(-9500,50,-6000)},
    {Level=1750, Sea=3, Name="HauntedQ2",       NPC=CFrame.new(-9500,50,-6000)},
    {Level=1775, Sea=3, Name="SeaTreatsQ1",     NPC=CFrame.new(-2270,90,-12100)},
    {Level=1800, Sea=3, Name="SeaTreatsQ2",     NPC=CFrame.new(-2270,90,-12100)},
    {Level=1825, Sea=3, Name="TikiQ1",          NPC=CFrame.new(28500,1500,-5000)},
    {Level=1850, Sea=3, Name="TikiQ2",          NPC=CFrame.new(28500,1500,-5000)},
    {Level=1875, Sea=3, Name="SubmergedQ1",     NPC=CFrame.new(-10000,-100,-10000)},
    {Level=1900, Sea=3, Name="SubmergedQ2",     NPC=CFrame.new(-10000,-100,-10000)},
    {Level=1925, Sea=3, Name="SubmergedQ3",     NPC=CFrame.new(-10000,-100,-10000)},
    {Level=1950, Sea=3, Name="SubmergedQ4",     NPC=CFrame.new(-10000,-100,-10000)},
    {Level=2025, Sea=3, Name="CakePrinceQ",     NPC=CFrame.new(-2270,90,-12100)},
    {Level=2050, Sea=3, Name="DoughKingQ",      NPC=CFrame.new(-9500,50,-9500)},
    {Level=2350, Sea=3, Name="TyrantQ",         NPC=CFrame.new(-12000,-200,-12000)},
}

local Islands = {
    [1] = {"Starter Island","Middle Town","Jungle","Pirate Village","Desert","Frozen Village","Marineford","Skylands","Prison","Colosseum","Magma Village","Underwater City","Fountain City"},
    [2] = {"Kingdom of Rose","Green Zone","Graveyard","Snow Mountain","Hot and Cold","Cursed Ship","Ice Castle","Forgotten Island","Dark Arena","Factory"},
    [3] = {"Port Town","Hydra Island","Great Tree","Floating Turtle","Haunted Castle","Sea of Treats","Cake Land","Tiki Outpost","Submerged Island"},
}

local Materials = {
    [1] = {"Scrap Metal","Leather","Angel Wings","Magma Ore","Fish Tail"},
    [2] = {"Scrap Metal","Leather","Fish Tail","Magma Ore","Radioactive Material","Mystic Droplet","Dragon Scale"},
    [3] = {"Scrap Metal","Leather","Fish Tail","Magma Ore","Dragon Scale","Mini Tusk","Vampire Fang","Conjured Cocoa","Gunpowder","Sea Artifact","Ancient Core"},
}

local Bosses = {
    [1] = {"Gorilla King","Vice Admiral","Warden","Chief Warden","Swan","Magma Admiral","Fishman Lord","Wysper","Thunder God","Cyborg"},
    [2] = {"Diamond","Jeremy","Fajita","Don Swan","Smoke Admiral","Awakened Ice Admiral","Tide Keeper","Darkbeard"},
    [3] = {"Stone","Island Empress","Kilo Admiral","Captain Elephant","Beautiful Pirate","Longma","Soul Reaper","Dough King","Cake Prince","Rip Indra","Tyrant"},
}

-- =====================================================
-- CONFIG
-- =====================================================
local Config = {
    FarmWeapon=false, FarmAttack="Normal", AutoFarmLevel=false, AutoFarmNearest=false,
    FarmIsland=Islands[CurrentSea][1], FlySpeed=150, AttackDelay=0.15,
    BringMob=true, BringDistance=300,
    AutoPirateRaid=false, AutoRipIndra=false, AutoTyrantSpawn=false, AutoSoulReaper=false,
    AutoBigMom=false, AutoFarmBone=false, AutoHakiV2=false, AutoUnlockTemple=false,
    AutoGodHuman=false, AutoDragonTaylor=false, AutoElectricClaw=false, AutoCakePrince=false, AutoDoughKing=false,
    AutoSea3=false, AutoFactory=false, AutoRaidLaw=false, AutoBuyChipRaidLaw=false,
    AutoStartRaidLaw=false, AutoDarkBeard=false, AutoSharkmanV2=false, AutoDeathStep=false,
    AutoSea2=false, AutoSaber=false, AutoGrayBeard=false, AutoDarkBladeV2=false,
    AutoCollectBerry=false, AutoBarista=false, HakiColor="White", AutoFarmObsHaki=false,
    SelectedBoss="None", AutoFarmBoss=false, AutoFarmAllBoss=false, AutoFarmRaidBoss=false,
    SelectedMaterial=Materials[CurrentSea][1], AutoFarmMaterial=false,
    MasteryWeapon="Gun", MasterySkills={}, HealthKillMob=30,
    MasteryIsland=Islands[CurrentSea][1], AutoFarmMastery=false,
    AutoClick=true, AutoSetSpawn=false, AutoBusoHaki=true, AutoObservation=false,
    AutoTurnV3=false, AutoTurnV4=false, AutoSpeed=true, Speed=20,
    AutoSetJump=true, Jump=50, DisableGameNotify=false, NoFog=true,
    NotifyErroScript=false, NoClip=false,
    ESPEnabled=false, ESPTeammates=false,
    WalkSpeed=16, JumpPower=50, InfiniteJump=false, AntiAFK=false,
    ScriptStartTime=os.time(), KillCount=0,
}

-- =====================================================
-- REMOTES
-- =====================================================
local RE_RegisterHit, RE_RegisterAttack, CommF_, EquipEvent
pcall(function()
    local Net = ReplicatedStorage:WaitForChild("Modules",5):WaitForChild("Net",5)
    RE_RegisterHit    = Net:WaitForChild("RE/RegisterHit",5)
    RE_RegisterAttack = Net:WaitForChild("RE/RegisterAttack",5)
    CommF_            = ReplicatedStorage:WaitForChild("Remotes",5):WaitForChild("CommF_",5)
    EquipEvent        = Player:WaitForChild("EquipEvent",5)
end)

local function RandomHitId()
    local c,id="0123456789abcdef",""
    for _=1,8 do id=id..c:sub(math.random(1,#c),math.random(1,#c)) end
    return id
end

-- =====================================================
-- UTILITY
-- =====================================================
local function FormatTime(secs)
    secs=math.floor(secs)
    return string.format("%02d:%02d:%02d",math.floor(secs/3600),math.floor((secs%3600)/60),secs%60)
end

local function GetNearestMob(filter)
    local nearest,nearestDist=nil,math.huge
    if not HumanoidRootPart then return nil end
    local rootPos=HumanoidRootPart.Position
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj~=Character then
            local hum=obj:FindFirstChildOfClass("Humanoid")
            local hrp=obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
            if hum and hrp and hum.Health>0 then
                local match=(not filter or filter=="") or obj.Name:lower():find(filter:lower(),1,true)
                if match then
                    local dist=(hrp.Position-rootPos).Magnitude
                    if dist<nearestDist then nearest,nearestDist=obj,dist end
                end
            end
        end
    end
    return nearest
end

local function TweenFly(model)
    if not model or not HumanoidRootPart then return end
    local hrp=model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
    if not hrp then return end
    local target=hrp.CFrame*CFrame.new(0,2,-3.5)
    local dist=(hrp.Position-HumanoidRootPart.Position).Magnitude
    local duration=math.clamp(dist/Config.FlySpeed,0.05,2)
    local bp=Instance.new("BodyPosition")
    bp.MaxForce=Vector3.new(math.huge,math.huge,math.huge) bp.D=1000 bp.P=10000
    bp.Position=HumanoidRootPart.Position bp.Parent=HumanoidRootPart
    local bg=Instance.new("BodyGyro")
    bg.MaxTorque=Vector3.new(math.huge,math.huge,math.huge) bg.D=500
    bg.CFrame=CFrame.lookAt(HumanoidRootPart.Position,hrp.Position) bg.Parent=HumanoidRootPart
    local tw=TweenService:Create(bp,TweenInfo.new(duration,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=target.Position})
    tw:Play() tw.Completed:Wait() bp:Destroy() bg:Destroy()
end

local function GetHitPart(model)
    for _,n in pairs({"LeftUpperArm","RightUpperArm","UpperTorso","HumanoidRootPart"}) do
        local p=model:FindFirstChild(n)
        if p and p:IsA("BasePart") then return p end
    end
    for _,p in pairs(model:GetDescendants()) do
        if p:IsA("BasePart") then return p end
    end
end

local function AttackMob(model)
    if not Config.AutoClick then return end
    if not model or not HumanoidRootPart then return end
    local hrp=model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
    if not hrp then return end
    HumanoidRootPart.CFrame=CFrame.lookAt(HumanoidRootPart.Position,hrp.Position)
    local hitPart=GetHitPart(model)
    if not hitPart then return end
    pcall(function() EquipEvent:FireServer(true) end) task.wait(0.05)
    pcall(function() RE_RegisterHit:FireServer(hitPart,{},RandomHitId()) end) task.wait(0.05)
    pcall(function() RE_RegisterAttack:FireServer(0.4) end) task.wait(Config.AttackDelay)
    pcall(function() EquipEvent:FireServer(false) end)
end

local function ActivateBuso()
    pcall(function() CommF_:InvokeServer("Buso") end)
end

local IMG = "rbxassetid://135350717440671"

-- =====================================================
-- WINDOW  (notify #1)
-- =====================================================
redzlib:Notify({ Title=T("notify_starting_title"), Description=T("notify_starting_desc"), Image=IMG, Duration=4, Type="Info" })

local Window = redzlib:MakeWindow({ Title="Redux Hub", SubTitle="by Redux Studio V1.0", SaveFolder="redux_hub_save" })

Window:AddMinimizeButton({
    Button = { Size=UDim2.fromOffset(45,45), Position=UDim2.fromScale(0.05,0.05), Image=IMG, BackgroundTransparency=1 },
    Corner  = { CornerRadius=UDim.new(1,0) },
})

-- =====================================================
-- PAGE: HOME
-- =====================================================
local Home = Window:MakeTab({ Title=T("tab_home"), Icon="home" })
Home:AddSection(T("sec_discord"))
Home:AddDiscordInvite({ Title="Redux Studio", Logo=IMG, Link="https://discord.gg/HkB97N772p" })
Home:AddSection(T("sec_states"))

local tzPara     = Home:AddParagraph({ Title=T("lbl_time_zone"),    Text=T("loading") })
local tscrPara   = Home:AddParagraph({ Title=T("lbl_time_script"),  Text="00:00:00" })
local tsrvPara   = Home:AddParagraph({ Title=T("lbl_time_server"),  Text="00:00:00" })
local moonPara   = Home:AddParagraph({ Title=T("lbl_full_moon"),    Text=T("loading") })
local tyrantPara = Home:AddParagraph({ Title=T("lbl_tyrant_eyes"),  Text="0/4" })
local miragePara = Home:AddParagraph({ Title=T("lbl_mirage"),       Text=T("loading") })
local kitsPara   = Home:AddParagraph({ Title=T("lbl_kitsune"),      Text=T("loading") })
local prHistPara = Home:AddParagraph({ Title=T("lbl_prehistoric"),  Text=T("loading") })
local frozenPara = Home:AddParagraph({ Title=T("lbl_frozen"),       Text=T("loading") })
local swordDealPara = Home:AddParagraph({ Title=T("lbl_sword_dealer"), Text=T("loading") })
local fruitPara  = Home:AddParagraph({ Title=T("lbl_fruit"),        Text=T("loading") })
local berryPara  = Home:AddParagraph({ Title=T("lbl_berry"),        Text=T("loading") })
local baristaPara= Home:AddParagraph({ Title=T("lbl_barista"),      Text=T("loading") })
local ripIndraPara=Home:AddParagraph({ Title=T("lbl_rip_indra"),    Text=T("loading") })

task.spawn(function()
    while true do
        task.wait(1)
        local t=os.date("*t")
        pcall(function() tzPara:Set(T("lbl_time_zone"), string.format("%02d/%02d/%04d  %02d:%02d:%02d",t.day,t.month,t.year,t.hour,t.min,t.sec)) end)
        pcall(function() tscrPara:Set(T("lbl_time_script"), FormatTime(os.time()-Config.ScriptStartTime)) end)
        pcall(function() tsrvPara:Set(T("lbl_time_server"), FormatTime(math.floor(workspace.DistributedGameTime))) end)
        pcall(function()
            local function sp(name) return workspace:FindFirstChild(name,true)~=nil end
            local yes,no=T("lbl_spawned"),T("lbl_not_spawned")
            miragePara:Set(T("lbl_mirage"),          sp("MirageIsland")      and yes or no)
            kitsPara:Set(T("lbl_kitsune"),           sp("KitsuneIsland")     and yes or no)
            prHistPara:Set(T("lbl_prehistoric"),     sp("PreHistoricIsland") and yes or no)
            frozenPara:Set(T("lbl_frozen"),          sp("FrozenIsland")      and yes or no)
            swordDealPara:Set(T("lbl_sword_dealer"), sp("LegendSwordDealer") and yes or no)
            ripIndraPara:Set(T("lbl_rip_indra"),     sp("RipIndra")          and yes or no)
            local fruit=workspace:FindFirstChild("Fruits",true) or workspace:FindFirstChild("Fruit",true)
            fruitPara:Set(T("lbl_fruit"), fruit and (yes.." - "..fruit.Name) or no)
            local berry=workspace:FindFirstChild("Berry",true)
            berryPara:Set(T("lbl_berry"), berry and (yes.." - "..berry.Name) or no)
            local bar=workspace:FindFirstChild("Barista",true)
            baristaPara:Set(T("lbl_barista"), bar and (yes.." - "..bar.Name) or no)
        end)
    end
end)

-- =====================================================
-- PAGE: MAIN
-- =====================================================
local Main = Window:MakeTab({ Title=T("tab_main"), Icon="menu" })

Main:AddDropdown({ Title=T("ui_farm_weapon"),  Options={"Melee","Sword","Gun","BloxFruits"}, Default="Melee", Callback=function(v) Config.FarmWeapon=v end })
Main:AddDropdown({ Title=T("ui_farm_attack"), Options={"Normal","FastAttack","SuperFastAttack"}, Default="Normal", Callback=function(v)
    Config.FarmAttack=v
    if v=="SuperFastAttack" then redzlib:Notify({ Title=T("warning"), Description=T("superfastattack_warn"), Image=IMG, Type="Warning", Duration=5 }) end
end })

Main:AddSection(T("sec_farm_normal"))
Main:AddToggle({ Title=T("ui_autofarm_level"), Default=false, Flag="AutoFarmLevel", Callback=function(v)
    Config.AutoFarmLevel=v
    redzlib:Notify({ Title=T(v and "autofarm_level_on" or "autofarm_level_off"), Image=IMG, Type=v and "Success" or "Error", Duration=3 })
end })
Main:AddToggle({ Title=T("ui_autofarm_nearest"), Default=false, Flag="AutoFarmNearest", Callback=function(v)
    Config.AutoFarmNearest=v
    redzlib:Notify({ Title=T(v and "autofarm_nearest_on" or "autofarm_nearest_off"), Image=IMG, Type=v and "Success" or "Error", Duration=3 })
end })
Main:AddDropdown({ Title=T("ui_select_island"), Options=Islands[CurrentSea], Default=Islands[CurrentSea][1], Callback=function(v) Config.FarmIsland=v end })

Main:AddSection(T("sec_farm_sea3"))
local sea3Toggles = {
    {"ui_auto_pirate_raid","AutoPirateRaid"},{"ui_auto_rip_indra","AutoRipIndra"},
    {"ui_auto_tyrant","AutoTyrantSpawn"},{"ui_auto_soul_reaper","AutoSoulRaper"},
    {"ui_auto_big_mom","AutoBigMom"},{"ui_auto_farm_bone","AutoFarmBone"},
    {"ui_auto_haki_v2","AutoHakiV2"},{"ui_auto_temple","AutoUnlockTemple"},
    {"ui_auto_god_human","AutoGodHuman"},{"ui_auto_dragon","AutoDragonTaylor"},
    {"ui_auto_electric_claw","AutoElectricClaw"},{"ui_auto_cake_prince","AutoCakePrince"},
    {"ui_auto_dough_king","AutoDoughKing"},
}
for _,t in pairs(sea3Toggles) do
    Main:AddToggle({ Title=T(t[1]), Desc=(t[2]=="AutoRipIndra") and T("ui_auto_rip_indra_desc") or "", Default=false, Flag=t[2], Callback=function(v) Config[t[2]]=v end })
end

Main:AddSection(T("sec_farm_sea2"))
local sea2Toggles = {
    {"ui_auto_sea3","AutoSea3"},{"ui_auto_factory","AutoFactory"},{"ui_auto_raid_law","AutoRaidLaw"},
    {"ui_auto_buy_chip","AutoBuyChipRaidLaw"},{"ui_auto_start_raid","AutoStartRaidLaw"},
    {"ui_auto_darkbeard","AutoDarkBeard"},{"ui_auto_sharkman","AutoSharkmanV2"},{"ui_auto_death_step","AutoDeathStep"},
}
for _,t in pairs(sea2Toggles) do
    Main:AddToggle({ Title=T(t[1]), Default=false, Flag=t[2], Callback=function(v) Config[t[2]]=v end })
end

Main:AddSection(T("sec_farm_sea1"))
local sea1Toggles = {
    {"ui_auto_sea2","AutoSea2"},{"ui_auto_saber","AutoSaber"},
    {"ui_auto_graybeard","AutoGrayBeard"},{"ui_auto_darkblade","AutoDarkBladeV2"},
}
for _,t in pairs(sea1Toggles) do
    Main:AddToggle({ Title=T(t[1]), Default=false, Flag=t[2], Callback=function(v) Config[t[2]]=v end })
end

Main:AddSection(T("sec_extras"))
Main:AddToggle({ Title=T("ui_auto_berry"),   Default=false, Flag="AutoCollectBerry", Callback=function(v) Config.AutoCollectBerry=v end })
Main:AddToggle({ Title=T("ui_auto_barista"), Default=false, Flag="AutoBarista",      Callback=function(v) Config.AutoBarista=v end })
Main:AddDropdown({ Title=T("ui_haki_color"), Options={"White","Black","Red","Blue","Green","Yellow","Purple","Pink"}, Default="White", Callback=function(v)
    Config.HakiColor=v
    redzlib:Notify({ Title=T("haki_color_buying",{color=v}), Image=IMG, Type="Info", Duration=3 })
end })
Main:AddToggle({ Title=T("ui_auto_obs_haki"), Default=false, Flag="AutoFarmObsHaki", Callback=function(v) Config.AutoFarmObsHaki=v end })

Main:AddSection(T("sec_boss"))
Main:AddDropdown({ Title=T("ui_select_boss"), Options=Bosses[CurrentSea], Default=Bosses[CurrentSea][1], Callback=function(v) Config.SelectedBoss=v end })
Main:AddToggle({ Title=T("ui_auto_farm_boss"),      Default=false, Callback=function(v) Config.AutoFarmBoss=v end })
Main:AddToggle({ Title=T("ui_auto_farm_all_boss"),  Default=false, Callback=function(v) Config.AutoFarmAllBoss=v end })
Main:AddToggle({ Title=T("ui_auto_farm_raid_boss"), Default=false, Callback=function(v) Config.AutoFarmRaidBoss=v end })

Main:AddSection(T("sec_material"))
Main:AddDropdown({ Title=T("ui_select_material"), Options=Materials[CurrentSea], Default=Materials[CurrentSea][1], Callback=function(v) Config.SelectedMaterial=v end })
Main:AddToggle({ Title=T("ui_auto_material"), Default=false, Callback=function(v) Config.AutoFarmMaterial=v end })

Main:AddSection(T("sec_mastery"))
Main:AddDropdown({ Title=T("ui_mastery_weapon"), Options={"Gun","Sword","Melee","BloxFruits"}, Default="Gun", Callback=function(v) Config.MasteryWeapon=v end })
Main:AddSlider({ Title=T("ui_health_kill"), Min=1, Max=100, Default=30, Callback=function(v) Config.HealthKillMob=v end })
Main:AddDropdown({ Title=T("ui_selection_island"), Options=Islands[CurrentSea], Default=Islands[CurrentSea][1], Callback=function(v) Config.MasteryIsland=v end })
Main:AddToggle({ Title=T("ui_auto_mastery"), Default=false, Callback=function(v) Config.AutoFarmMastery=v end })

-- =====================================================
-- FARM LOOP
-- =====================================================
local currentTarget,attacking=nil,false
RunService.Heartbeat:Connect(function()
    if not Config.AutoFarmNearest and not Config.AutoFarmLevel then currentTarget=nil attacking=false return end
    if not HumanoidRootPart or not Humanoid then return end
    if Humanoid.Health<=0 then return end
    if attacking then return end
    if currentTarget then
        local hum=currentTarget:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health<=0 or not currentTarget.Parent then Config.KillCount+=1 currentTarget=nil end
    end
    if not currentTarget then currentTarget=GetNearestMob() end
    if currentTarget then
        attacking=true
        task.spawn(function() TweenFly(currentTarget) AttackMob(currentTarget) attacking=false end)
    end
end)

-- =====================================================
-- PAGE: SETTINGS
-- =====================================================
local Settings = Window:MakeTab({ Title=T("tab_settings"), Icon="settings" })

Settings:AddSection(T("sec_farming_settings"))
Settings:AddToggle({ Title=T("ui_auto_click"),  Default=true,  Callback=function(v) Config.AutoClick=v end })
Settings:AddToggle({ Title=T("ui_bring_mob"),   Default=true,  Callback=function(v) Config.BringMob=v end })
Settings:AddDropdown({ Title=T("ui_bring_dist"), Options={"200","300","400","500"}, Default="300", Callback=function(v) Config.BringDistance=tonumber(v) end })
Settings:AddToggle({ Title=T("ui_auto_spawn"),  Default=false, Callback=function(v) Config.AutoSetSpawn=v end })
Settings:AddToggle({ Title=T("ui_auto_buso"),   Default=true,  Callback=function(v) Config.AutoBusoHaki=v if v then ActivateBuso() end end })
Settings:AddToggle({ Title=T("ui_auto_obs"),    Default=false, Callback=function(v) Config.AutoObservation=v end })
Settings:AddToggle({ Title=T("ui_auto_turn_v3"),Default=false, Callback=function(v) Config.AutoTurnV3=v end })
Settings:AddToggle({ Title=T("ui_auto_turn_v4"),Default=false, Callback=function(v) Config.AutoTurnV4=v end })

Settings:AddSection(T("sec_extras"))
Settings:AddToggle({ Title=T("ui_auto_speed"), Default=true,  Callback=function(v) Config.AutoSpeed=v end })
Settings:AddSlider({ Title=T("ui_speed"), Min=20, Max=100, Default=20, Callback=function(v) Config.Speed=v if Humanoid then Humanoid.WalkSpeed=v end end })
Settings:AddToggle({ Title=T("ui_auto_jump"),  Default=true,  Callback=function(v) Config.AutoSetJump=v end })
Settings:AddSlider({ Title=T("ui_jump"), Min=50, Max=200, Default=50, Callback=function(v) Config.Jump=v if Humanoid then Humanoid.JumpPower=v end end })

Settings:AddSection(T("sec_visual"))
Settings:AddToggle({ Title=T("ui_disable_notify"), Default=false, Callback=function(v) Config.DisableGameNotify=v end })
Settings:AddToggle({ Title=T("ui_no_fog"), Default=true, Callback=function(v) Config.NoFog=v Lighting.FogEnd=v and 100000 or 1000 end })
Settings:AddToggle({ Title=T("ui_notify_error"), Default=false, Callback=function(v)
    Config.NotifyErroScript=v
    redzlib:Notify({ Description=T(v and "notify_error_on" or "notify_error_off"), Image=IMG, Type=v and "Success" or "Error", Duration=3 })
end })
Settings:AddButton({ Title=T("ui_test_notify"), Callback=function()
    redzlib:Notify({ Title=T("test_notify_title"), Description=T("test_notify_desc"), Image=IMG, Type="Success", Duration=3 })
end })
Settings:AddToggle({ Title=T("ui_noclip"), Default=false, Callback=function(v)
    Config.NoClip=v
    redzlib:Notify({ Title=T(v and "noclip_on" or "noclip_off"), Image=IMG, Type=v and "Success" or "Info", Duration=2 })
end })

RunService.Stepped:Connect(function()
    if Config.NoClip and Character then
        for _,p in pairs(Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end
end)

-- =====================================================
-- PAGE: LANGUAGE
-- =====================================================
local LangTab = Window:MakeTab({ Title=T("tab_language"), Icon="globe" })
LangTab:AddSection(T("sec_select_lang"))
LangTab:AddDropdown({
    Title    = T("ui_lang_dropdown"),
    Options  = {"English","Portugues_Brazil","Portugues_Portugal","Espanol","Vietnam"},
    Default  = "English",
    Callback = function(v)
        CurrentLang=v
        redzlib:Notify({ Title=T("language_changed"), Image=IMG, Type="Success", Duration=3 })
    end
})
LangTab:AddParagraph({ Title=T("tab_language"), Text=T("ui_lang_list") })

-- =====================================================
-- SOON COMING PAGES
-- =====================================================
local function SoonTab(title, icon)
    local tab=Window:MakeTab({ Title=T(title), Icon=icon })
    tab:AddParagraph({ Title=T(title), Text=T("soon_coming") })
end
SoonTab("tab_fishing",   "fish")
SoonTab("tab_itemquest", "swords")
SoonTab("tab_race",      "flag")
SoonTab("tab_vulcano",   "flame")
SoonTab("tab_seaevent",  "waves")
SoonTab("tab_fruitraid", "apple")
SoonTab("tab_shopping",  "shoppingbag")

-- =====================================================
-- PAGE: ESP
-- =====================================================
local Esp = Window:MakeTab({ Title=T("tab_esp"), Icon="eye" })
Esp:AddSection(T("sec_esp_settings"))
Esp:AddToggle({ Title=T("ui_esp_mobs"), Default=false, Callback=function(v)
    Config.ESPEnabled=v
    if not v then for _,obj in pairs(workspace:GetDescendants()) do if obj:IsA("SelectionBox") and obj.Name=="ESP_Redux" then obj:Destroy() end end end
    redzlib:Notify({ Title=T(v and "esp_on" or "esp_off"), Image=IMG, Type=v and "Success" or "Info", Duration=2 })
end })
Esp:AddToggle({ Title=T("ui_esp_teammates"), Default=false, Callback=function(v) Config.ESPTeammates=v end })

RunService.Heartbeat:Connect(function()
    if not Config.ESPEnabled then return end
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj~=Character then
            local hum=obj:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health>0 and not obj:FindFirstChild("ESP_Redux") then
                local box=Instance.new("SelectionBox")
                box.Name="ESP_Redux" box.Color3=Color3.fromRGB(255,50,50)
                box.LineThickness=0.05 box.Adornee=obj box.Parent=obj
            end
        end
    end
end)

-- =====================================================
-- PAGE: LOCAL PLAYER
-- =====================================================
local LocalPlayer = Window:MakeTab({ Title=T("tab_localplayer"), Icon="users" })
LocalPlayer:AddSection(T("sec_char_stats"))
LocalPlayer:AddSlider({ Title=T("ui_walkspeed"), Min=16, Max=500, Default=16, Callback=function(v) Config.WalkSpeed=v if Humanoid then Humanoid.WalkSpeed=v end end })
LocalPlayer:AddSlider({ Title=T("ui_jumppower"), Min=50, Max=500, Default=50, Callback=function(v) Config.JumpPower=v if Humanoid then Humanoid.JumpPower=v end end })
LocalPlayer:AddToggle({ Title=T("ui_infinite_jump"), Default=false, Callback=function(v)
    Config.InfiniteJump=v
    redzlib:Notify({ Title=T(v and "infinitejump_on" or "infinitejump_off"), Image=IMG, Type=v and "Success" or "Info", Duration=2 })
end })
game:GetService("UserInputService").JumpRequest:Connect(function()
    if Config.InfiniteJump and Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
LocalPlayer:AddToggle({ Title=T("ui_anti_afk"), Default=false, Callback=function(v)
    Config.AntiAFK=v
    if v then
        task.spawn(function()
            while Config.AntiAFK do
                pcall(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end)
                if Humanoid then Humanoid.Jump=true end
                task.wait(55)
            end
        end)
    end
    redzlib:Notify({ Title=T(v and "antiafk_on" or "antiafk_off"), Image=IMG, Type=v and "Success" or "Info", Duration=2 })
end })

LocalPlayer:AddSection(T("sec_actions"))
LocalPlayer:AddButton({ Title=T("ui_check_hp"), Callback=function()
    if Humanoid then redzlib:Notify({ Title=T("hp_title"), Description=string.format("%d / %d",math.floor(Humanoid.Health),math.floor(Humanoid.MaxHealth)), Image=IMG, Type="Info", Duration=4 }) end
end })
LocalPlayer:AddButton({ Title=T("ui_reset_char"), Callback=function()
    if Humanoid then Humanoid.Health=0 end
    redzlib:Notify({ Title=T("resetting"), Image=IMG, Type="Warning", Duration=3 })
end })
LocalPlayer:AddButton({ Title=T("ui_copy_pos"), Callback=function()
    if HumanoidRootPart then
        local p=HumanoidRootPart.Position
        local s=string.format("%.1f,%.1f,%.1f",p.X,p.Y,p.Z)
        pcall(function() setclipboard(s) end)
        redzlib:Notify({ Title=T("position_copied"), Description=s, Image=IMG, Type="Success", Duration=4 })
    end
end })

-- =====================================================
-- PAGE: TELEPORT
-- =====================================================
local Teleport = Window:MakeTab({ Title=T("tab_teleport"), Icon="mouse" })
Teleport:AddSection(T("sec_quick_tp"))
for _,island in pairs(Islands[CurrentSea]) do
    Teleport:AddButton({ Title=T("ui_tp_prefix")..island, Callback=function()
        local found=false
        for _,q in pairs(QuestList) do
            if q.Sea==CurrentSea and q.Name:lower():find(island:lower():sub(1,5),1,true) then
                if HumanoidRootPart then HumanoidRootPart.CFrame=q.NPC end
                redzlib:Notify({ Title=T("teleported"), Description=island, Image=IMG, Type="Success", Duration=3 })
                found=true break
            end
        end
        if not found then redzlib:Notify({ Title=T("teleported"), Description=island.." - "..T("teleport_not_mapped"), Image=IMG, Type="Warning", Duration=3 }) end
    end })
end
Teleport:AddSection(T("sec_custom_coords"))
Teleport:AddTextBox({ Title=T("ui_xyz_coords"), Desc=T("ui_xyz_desc"), Default="", PlaceholderText="X,Y,Z", ClearText=true,
    Callback=function(v)
        if not v or v:gsub(" ","")=="" then return end
        local c={}
        for n in v:gmatch("%-?%d+%.?%d*") do table.insert(c,tonumber(n)) end
        if #c>=3 and HumanoidRootPart then
            HumanoidRootPart.CFrame=CFrame.new(c[1],c[2],c[3])
            redzlib:Notify({ Title=T("teleported"), Description=string.format("X:%g Y:%g Z:%g",c[1],c[2],c[3]), Image=IMG, Type="Success", Duration=4 })
        else
            redzlib:Notify({ Title=T("teleport_invalid"), Image=IMG, Type="Error", Duration=3 })
        end
    end
})

-- =====================================================
-- PAGE: MISC
-- =====================================================
local Misc = Window:MakeTab({ Title=T("tab_misc"), Icon="calendarsearch" })
Misc:AddSection(T("sec_utility"))
Misc:AddToggle({ Title=T("ui_fullbright"), Default=false, Callback=function(v)
    local L=Lighting
    if v then L.Brightness=10 L.GlobalShadows=false L.Ambient=Color3.fromRGB(255,255,255) L.OutdoorAmbient=Color3.fromRGB(255,255,255)
    else L.Brightness=2 L.GlobalShadows=true L.Ambient=Color3.fromRGB(70,70,70) L.OutdoorAmbient=Color3.fromRGB(128,128,128) end
    redzlib:Notify({ Title=T(v and "fullbright_on" or "fullbright_off"), Image=IMG, Type=v and "Success" or "Info", Duration=2 })
end })
Misc:AddSlider({ Title=T("ui_fov"), Min=30, Max=120, Default=70, Callback=function(v) Camera.FieldOfView=v end })
Misc:AddButton({ Title=T("ui_reset_visual"), Callback=function()
    Camera.FieldOfView=70
    Lighting.Brightness=2 Lighting.GlobalShadows=true
    Lighting.Ambient=Color3.fromRGB(70,70,70) Lighting.OutdoorAmbient=Color3.fromRGB(128,128,128)
    redzlib:Notify({ Title=T("visual_reset"), Image=IMG, Type="Info", Duration=3 })
end })
Misc:AddSection(T("sec_script_info"))
Misc:AddParagraph({ Title="Redux Hub v1.0", Text="by Redux Studio. Sea "..CurrentSea.." | PlaceId: "..PlaceId })
Misc:AddParagraph({ Title="Compatible Executors", Text=T("ui_compatible_exec") })
Misc:AddButton({ Title=T("ui_close_ui"), Callback=function() Window:CloseBtn() end })

-- =====================================================
-- notify #2: fully loaded
-- =====================================================
redzlib:Notify({
    Title       = T("notify_loaded_title"),
    Description = T("notify_loaded_desc", {sea=CurrentSea}),
    Image       = IMG,
    Duration    = 5,
    Type        = "Success"
})