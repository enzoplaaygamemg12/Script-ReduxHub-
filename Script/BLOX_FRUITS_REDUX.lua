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
    Character      = c
    Humanoid       = c:WaitForChild("Humanoid")
    HumanoidRootPart = c:WaitForChild("HumanoidRootPart")
end)

-- =====================================================
-- DETECT SEA (1, 2 or 3) by PlaceId
-- =====================================================
local PlaceId = game.PlaceId
local function GetSea()
    -- Sea 1 = 2753915549, Sea 2 = 4442272183, Sea 3 = 7449423635 (common IDs)
    local seaMap = {
        [2753915549] = 1,
        [4442272183] = 2,
        [7449423635] = 3,
    }
    return seaMap[PlaceId] or 1
end
local CurrentSea = GetSea()

-- =====================================================
-- QUEST LIST (Sea 1 → Sea 3)
-- =====================================================
local QuestList = {
    -- SEA 1
    {Level=0,   Sea=1, Name="BanditQuest",     Mob="Bandit",               NPC=CFrame.new(1059,16,1549),    Spawn=CFrame.new(1047,16,1624)},
    {Level=0,   Sea=1, Name="MarineQuest",     Mob="Trainee",              NPC=CFrame.new(-2709,24,2103),   Spawn=CFrame.new(-2777,24,2211)},
    {Level=15,  Sea=1, Name="JungleQuest1",    Mob="Monkey",               NPC=CFrame.new(-1597,36,149),    Spawn=CFrame.new(-1615,36,144)},
    {Level=20,  Sea=1, Name="JungleQuest2",    Mob="Gorilla",              NPC=CFrame.new(-1597,36,149),    Spawn=CFrame.new(-1293,18,-425)},
    {Level=30,  Sea=1, Name="PirateQuest1",    Mob="Pirate",               NPC=CFrame.new(-1138,4,3830),    Spawn=CFrame.new(-1218,4,3909)},
    {Level=40,  Sea=1, Name="PirateQuest2",    Mob="Brute",                NPC=CFrame.new(-1138,4,3830),    Spawn=CFrame.new(-1126,14,4345)},
    {Level=60,  Sea=1, Name="DesertQuest1",    Mob="Desert Bandit",        NPC=CFrame.new(893,6,4391),      Spawn=CFrame.new(1566,10,4368)},
    {Level=75,  Sea=1, Name="DesertQuest2",    Mob="Desert Officer",       NPC=CFrame.new(893,6,4391),      Spawn=CFrame.new(1566,10,4368)},
    {Level=90,  Sea=1, Name="SnowQuest1",      Mob="Snow Bandit",          NPC=CFrame.new(1385,87,-1296),   Spawn=CFrame.new(1360,87,-1352)},
    {Level=100, Sea=1, Name="SnowQuest2",      Mob="Snowman",              NPC=CFrame.new(1385,87,-1296),   Spawn=CFrame.new(1258,105,-1554)},
    {Level=120, Sea=1, Name="MarineQuest2",    Mob="Chief Petty Officer",  NPC=CFrame.new(-5038,28,4323),   Spawn=CFrame.new(-4891,22,4236)},
    {Level=150, Sea=1, Name="SkyQuest",        Mob="Sky Bandit",           NPC=CFrame.new(-4838,717,-2618), Spawn=CFrame.new(-4997,278,-2829)},
    {Level=190, Sea=1, Name="PrisonQuest1",    Mob="Prisoner",             NPC=CFrame.new(5310,1,476),      Spawn=CFrame.new(5161,3,432)},
    {Level=210, Sea=1, Name="PrisonQuest2",    Mob="Dangerous Prisoner",   NPC=CFrame.new(5310,1,476),      Spawn=CFrame.new(5609,1,661)},
    {Level=250, Sea=1, Name="ColosseumQuest",  Mob="Toga Warrior",         NPC=CFrame.new(-1752,7,-2779),   Spawn=CFrame.new(-1752,7,-2779)},
    {Level=300, Sea=1, Name="MagmaQuest",      Mob="Military Soldier",     NPC=CFrame.new(-5344,8,8531),    Spawn=CFrame.new(-5344,8,8531)},
    {Level=375, Sea=1, Name="FishmanQuest",    Mob="Fishman Warrior",      NPC=CFrame.new(61123,18,1564),   Spawn=CFrame.new(61180,-0,1889)},
    {Level=450, Sea=1, Name="SkyExp1Quest",    Mob="God's Guard",          NPC=CFrame.new(-4720,845,-1951), Spawn=CFrame.new(-4715,844,-1963)},
    {Level=625, Sea=1, Name="FountainQuest",   Mob="Galley Pirate",        NPC=CFrame.new(5259,37,4050),    Spawn=CFrame.new(5283,22,3986)},
    -- SEA 2
    {Level=700,  Sea=2, Name="RaiderQuest",    Mob="Raider",               NPC=CFrame.new(-429,73,1836),    Spawn=CFrame.new(-459,73,1836)},
    {Level=725,  Sea=2, Name="MercenaryQuest", Mob="Mercenary",            NPC=CFrame.new(-429,73,1836),    Spawn=CFrame.new(-459,73,1836)},
    {Level=750,  Sea=2, Name="SwanQuest",      Mob="Swan Pirate",          NPC=CFrame.new(-968,73,1836),    Spawn=CFrame.new(-968,73,1836)},
    {Level=875,  Sea=2, Name="GreenZoneQ1",    Mob="Green Zone Bandit",    NPC=CFrame.new(-1020,73,-2490),  Spawn=CFrame.new(-1020,73,-2490)},
    {Level=900,  Sea=2, Name="GreenZoneQ2",    Mob="Green Zone Pirate",    NPC=CFrame.new(-1020,73,-2490),  Spawn=CFrame.new(-1020,73,-2490)},
    {Level=950,  Sea=2, Name="GraveyardQ1",    Mob="Zombie",               NPC=CFrame.new(-5492,48,-794),   Spawn=CFrame.new(-5492,48,-794)},
    {Level=975,  Sea=2, Name="GraveyardQ2",    Mob="Vampire",              NPC=CFrame.new(-5492,48,-794),   Spawn=CFrame.new(-5492,48,-794)},
    {Level=1000, Sea=2, Name="SnowMountainQ1", Mob="Snow Trooper",         NPC=CFrame.new(609,400,-5372),   Spawn=CFrame.new(609,400,-5372)},
    {Level=1050, Sea=2, Name="SnowMountainQ2", Mob="Winter Warrior",       NPC=CFrame.new(609,400,-5372),   Spawn=CFrame.new(609,400,-5372)},
    {Level=1100, Sea=2, Name="HotColdQ1",      Mob="Lab Subordinate",      NPC=CFrame.new(-6438,15,-4601),  Spawn=CFrame.new(-6438,15,-4601)},
    {Level=1125, Sea=2, Name="HotColdQ2",      Mob="Horned Man",           NPC=CFrame.new(-6438,15,-4601),  Spawn=CFrame.new(-6438,15,-4601)},
    {Level=1250, Sea=2, Name="CursedShipQ1",   Mob="Ship Deckhand",        NPC=CFrame.new(-5120,73,-3000),  Spawn=CFrame.new(-5120,73,-3000)},
    {Level=1275, Sea=2, Name="CursedShipQ2",   Mob="Ship Engineer",        NPC=CFrame.new(-5120,73,-3000),  Spawn=CFrame.new(-5120,73,-3000)},
    {Level=1300, Sea=2, Name="IceCastleQ1",    Mob="Arctic Warrior",       NPC=CFrame.new(61123,18,-1564),  Spawn=CFrame.new(61123,18,-1564)},
    {Level=1325, Sea=2, Name="IceCastleQ2",    Mob="Snow Lurker",          NPC=CFrame.new(61123,18,-1564),  Spawn=CFrame.new(61123,18,-1564)},
    -- SEA 3
    {Level=1500, Sea=3, Name="PortTownQ1",     Mob="Pirate Millionaire",   NPC=CFrame.new(-290,44,5374),    Spawn=CFrame.new(-319,73,5621)},
    {Level=1525, Sea=3, Name="PortTownQ2",     Mob="Pistol Billionaire",   NPC=CFrame.new(-290,44,5374),    Spawn=CFrame.new(-268,45,5406)},
    {Level=1575, Sea=3, Name="HydraQ1",        Mob="Dragon Crew Warrior",  NPC=CFrame.new(5740,611,-1330),  Spawn=CFrame.new(5740,611,-1330)},
    {Level=1600, Sea=3, Name="HydraQ2",        Mob="Dragon Crew Archer",   NPC=CFrame.new(5740,611,-1330),  Spawn=CFrame.new(5740,611,-1330)},
    {Level=1625, Sea=3, Name="GreatTreeQ1",    Mob="Islander",             NPC=CFrame.new(-1320,332,-762),  Spawn=CFrame.new(-1320,332,-762)},
    {Level=1650, Sea=3, Name="GreatTreeQ2",    Mob="Island Boy",           NPC=CFrame.new(-1320,332,-762),  Spawn=CFrame.new(-1320,332,-762)},
    {Level=1675, Sea=3, Name="TurtleQ1",       Mob="Marine Commodore",     NPC=CFrame.new(-1320,332,-762),  Spawn=CFrame.new(-1320,332,-762)},
    {Level=1700, Sea=3, Name="TurtleQ2",       Mob="Marine Rear Admiral",  NPC=CFrame.new(-1320,332,-762),  Spawn=CFrame.new(-1320,332,-762)},
    {Level=1725, Sea=3, Name="HauntedQ1",      Mob="Haunted Skeleton",     NPC=CFrame.new(-9500,50,-6000),  Spawn=CFrame.new(-9500,50,-6000)},
    {Level=1750, Sea=3, Name="HauntedQ2",      Mob="Haunted Ghost",        NPC=CFrame.new(-9500,50,-6000),  Spawn=CFrame.new(-9500,50,-6000)},
    {Level=1775, Sea=3, Name="SeaTreatsQ1",    Mob="Cookie Crafter",       NPC=CFrame.new(-2270,90,-12100), Spawn=CFrame.new(-2270,90,-12100)},
    {Level=1800, Sea=3, Name="SeaTreatsQ2",    Mob="Cake Guard",           NPC=CFrame.new(-2270,90,-12100), Spawn=CFrame.new(-2270,90,-12100)},
    {Level=1825, Sea=3, Name="TikiQ1",         Mob="Tiki Warrior",         NPC=CFrame.new(28500,1500,-5000),Spawn=CFrame.new(28500,1500,-5000)},
    {Level=1850, Sea=3, Name="TikiQ2",         Mob="Tiki Chief",           NPC=CFrame.new(28500,1500,-5000),Spawn=CFrame.new(28500,1500,-5000)},
    {Level=1875, Sea=3, Name="SubmergedQ1",    Mob="Reef Bandit",          NPC=CFrame.new(-10000,-100,-10000),Spawn=CFrame.new(-10000,-100,-10000)},
    {Level=1900, Sea=3, Name="SubmergedQ2",    Mob="Coral Pirate",         NPC=CFrame.new(-10000,-100,-10000),Spawn=CFrame.new(-10000,-100,-10000)},
    {Level=1925, Sea=3, Name="SubmergedQ3",    Mob="Sea Chanter",          NPC=CFrame.new(-10000,-100,-10000),Spawn=CFrame.new(-10000,-100,-10000)},
    {Level=1950, Sea=3, Name="SubmergedQ4",    Mob="Ocean Prophet",        NPC=CFrame.new(-10000,-100,-10000),Spawn=CFrame.new(-10000,-100,-10000)},
    {Level=2025, Sea=3, Name="CakePrinceQ",    Mob="Cake Prince Minion",   NPC=CFrame.new(-2270,90,-12100), Spawn=CFrame.new(-2270,90,-12100)},
    {Level=2050, Sea=3, Name="DoughKingQ",     Mob="Dough King Minion",    NPC=CFrame.new(-9500,50,-9500),  Spawn=CFrame.new(-9500,50,-9500)},
    {Level=2350, Sea=3, Name="TyrantQ",        Mob="Elite Tyrant Soldier", NPC=CFrame.new(-12000,-200,-12000),Spawn=CFrame.new(-12000,-200,-12000)},
}

-- Islands per sea (for dropdowns)
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
-- CONFIG STATE
-- =====================================================
local Config = {
    -- Farm
    FarmWeapon          = "Melee",
    FarmAttack          = "Normal",
    AutoFarmLevel       = false,
    AutoFarmNearest     = false,
    FarmIsland          = Islands[CurrentSea][1],
    FlySpeed            = 150,
    AttackDelay         = 0.15,
    BringMob            = true,
    BringDistance       = 300,
    -- Sea 3
    AutoPirateRaid      = false,
    AutoRipIndra        = false,
    AutoTyrantSpawn     = false,
    AutoSoulReaper      = false,
    AutoBigMom          = false,
    AutoFarmBone        = false,
    AutoHakiV2          = false,
    AutoUnlockTemple    = false,
    AutoGodHuman        = false,
    AutoDragonTaylor    = false,
    AutoElectricClaw    = false,
    AutoCakePrince      = false,
    AutoDoughKing       = false,
    -- Sea 2
    AutoSea3            = false,
    AutoFactory         = false,
    AutoRaidLaw         = false,
    AutoBuyChipRaidLaw  = false,
    AutoStartRaidLaw    = false,
    AutoDarkBeard       = false,
    AutoSharkmanV2      = false,
    AutoDeathStep       = false,
    -- Sea 1
    AutoSea2            = false,
    AutoSaber           = false,
    AutoGrayBeard       = false,
    AutoDarkBladeV2     = false,
    -- Extras
    AutoCollectBerry    = false,
    AutoBarista         = false,
    HakiColor           = "White",
    AutoFarmObsHaki     = false,
    -- Boss
    SelectedBoss        = "None",
    AutoFarmBoss        = false,
    AutoFarmAllBoss     = false,
    AutoFarmRaidBoss    = false,
    -- Material
    SelectedMaterial    = Materials[CurrentSea][1],
    AutoFarmMaterial    = false,
    -- Mastery
    MasteryWeapon       = "Gun",
    MasterySkills       = {},
    HealthKillMob       = 30,
    MasteryIsland       = Islands[CurrentSea][1],
    AutoFarmMastery     = false,
    -- Settings
    AutoClick           = true,
    AutoSetSpawn        = false,
    AutoBusoHaki        = true,
    AutoObservation     = false,
    AutoTurnV3          = false,
    AutoTurnV4          = false,
    AutoSpeed           = true,
    Speed               = 20,
    AutoSetJump         = true,
    Jump                = 50,
    DisableGameNotify   = false,
    NoFog               = true,
    NotifyErroScript    = false,
    NoClip              = false,
    -- ESP
    ESPEnabled          = false,
    ESPTeammates        = false,
    -- Local Player
    WalkSpeed           = 16,
    JumpPower           = 50,
    InfiniteJump        = false,
    Noclip              = false,
    AntiAFK             = false,
    -- Script time
    ScriptStartTime     = os.time(),
    KillCount           = 0,
}

-- =====================================================
-- REMOTES
-- =====================================================
local RE_RegisterHit, RE_RegisterAttack, CommF_, EquipEvent
pcall(function()
    local Net         = ReplicatedStorage:WaitForChild("Modules",5):WaitForChild("Net",5)
    RE_RegisterHit    = Net:WaitForChild("RE/RegisterHit",5)
    RE_RegisterAttack = Net:WaitForChild("RE/RegisterAttack",5)
    CommF_            = ReplicatedStorage:WaitForChild("Remotes",5):WaitForChild("CommF_",5)
    EquipEvent        = Player:WaitForChild("EquipEvent",5)
end)

local function RandomHitId()
    local c,id = "0123456789abcdef",""
    for _=1,8 do id=id..c:sub(math.random(1,#c),math.random(1,#c)) end
    return id
end

-- =====================================================
-- UTILITY FUNCTIONS
-- =====================================================
local function FormatTime(secs)
    secs = math.floor(secs)
    return string.format("%02d:%02d:%02d", math.floor(secs/3600), math.floor((secs%3600)/60), secs%60)
end

local function GetNearestMob(filter)
    local nearest, nearestDist = nil, math.huge
    if not HumanoidRootPart then return nil end
    local rootPos = HumanoidRootPart.Position
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= Character then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
            if hum and hrp and hum.Health > 0 then
                local match = (not filter or filter=="") or obj.Name:lower():find(filter:lower(),1,true)
                if match then
                    local dist = (hrp.Position - rootPos).Magnitude
                    if dist < nearestDist then nearest,nearestDist = obj,dist end
                end
            end
        end
    end
    return nearest
end

local function TweenFly(model)
    if not model or not HumanoidRootPart then return end
    local hrp = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
    if not hrp then return end
    local target = hrp.CFrame * CFrame.new(0, 2, -3.5)
    local dist = (hrp.Position - HumanoidRootPart.Position).Magnitude
    local duration = math.clamp(dist / Config.FlySpeed, 0.05, 2)
    local bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
    bp.D = 1000 bp.P = 10000 bp.Position = HumanoidRootPart.Position bp.Parent = HumanoidRootPart
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
    bg.D = 500 bg.CFrame = CFrame.lookAt(HumanoidRootPart.Position, hrp.Position) bg.Parent = HumanoidRootPart
    local tw = TweenService:Create(bp, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = target.Position})
    tw:Play() tw.Completed:Wait()
    bp:Destroy() bg:Destroy()
end

local function GetHitPart(model)
    for _, n in pairs({"LeftUpperArm","RightUpperArm","UpperTorso","HumanoidRootPart"}) do
        local p = model:FindFirstChild(n)
        if p and p:IsA("BasePart") then return p end
    end
    for _, p in pairs(model:GetDescendants()) do
        if p:IsA("BasePart") then return p end
    end
end

local function AttackMob(model)
    if not Config.AutoClick then return end
    if not model or not HumanoidRootPart then return end
    local hrp = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
    if not hrp then return end
    HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position, hrp.Position)
    local hitPart = GetHitPart(model)
    if not hitPart then return end
    pcall(function() EquipEvent:FireServer(true) end)
    task.wait(0.05)
    pcall(function() RE_RegisterHit:FireServer(hitPart, {}, RandomHitId()) end)
    task.wait(0.05)
    pcall(function() RE_RegisterAttack:FireServer(0.4) end)
    task.wait(Config.AttackDelay)
    pcall(function() EquipEvent:FireServer(false) end)
end

local function ActivateBuso()
    pcall(function() CommF_:InvokeServer("Buso") end)
end

-- =====================================================
-- WINDOW
-- =====================================================
local Window = redzlib:MakeWindow({
    Title      = "Redux Hub",
    SubTitle   = "by Redux Studio V1.0",
    SaveFolder = "redux_hub_save"
})

-- Floating orb button (toggle UI visibility)
Window:AddMinimizeButton({
    Button = {
        Size     = UDim2.fromOffset(45, 45),
        Position = UDim2.fromScale(0.05, 0.05),
        Image    = "rbxassetid://135350717440671",
        BackgroundTransparency = 1,
    },
    Corner = { CornerRadius = UDim.new(1, 0) },
})

task.spawn(function()
    task.wait(1)
    redzlib:Notify({
        Title       = "Redux Hub Loaded!",
        Description = "Sea "..CurrentSea.." detected. All systems ready.",
        Image       = "rbxassetid://135350717440671",
        Duration    = 5,
        Type        = "Success"
    })
end)

-- =====================================================
-- PAGE: HOME
-- =====================================================
local Home = Window:MakeTab({ Title = "Home", Icon = "home" })

Home:AddSection("Discord Server")

Home:AddDiscordInvite({
    Title = "Redux Studio",
    Logo  = "rbxassetid://135350717440671",
    Link  = "https://discord.gg/HkB97N772p"
})

Home:AddSection("States Script")

-- Time Zone paragraph (updates every second)
local tzPara = Home:AddParagraph({ Title = "Time Zone", Text = "Loading..." })
local tscrPara = Home:AddParagraph({ Title = "Time Script", Text = "00:00:00" })
local tsrvPara = Home:AddParagraph({ Title = "Time Server", Text = "00:00:00" })

-- Server Events status
local moonPara  = Home:AddParagraph({ Title = "Full Moon",           Text = "Loading..." })
local tyrantPara= Home:AddParagraph({ Title = "Tyrant Eyes",         Text = "0/4" })
local miragePara= Home:AddParagraph({ Title = "Mirage Island Spawn", Text = "Loading..." })
local kitsPara  = Home:AddParagraph({ Title = "Kitsune Island Spawn",Text = "Loading..." })
local prHistPara= Home:AddParagraph({ Title = "Pre-Historic Island Spawn", Text = "Loading..." })
local frozenPara= Home:AddParagraph({ Title = "Frozen Island Spawn", Text = "Loading..." })
local swordDealPara = Home:AddParagraph({ Title = "Sword Dealer Legendy Spawn", Text = "Loading..." })
local fruitPara = Home:AddParagraph({ Title = "Fruit Spawn",         Text = "Loading..." })
local berryPara = Home:AddParagraph({ Title = "Berry Spawn",         Text = "Loading..." })
local baristaPara = Home:AddParagraph({ Title = "Barista Color Haki",Text = "Loading..." })
local ripIndraPara = Home:AddParagraph({ Title = "Rip Indra Spawn",  Text = "Loading..." })

-- Update clock & script time
task.spawn(function()
    while true do
        task.wait(1)
        -- Time zone
        local t = os.date("*t")
        pcall(function()
            tzPara:Set("Time Zone", string.format("%02d/%02d/%04d  %02d:%02d:%02d", t.day, t.month, t.year, t.hour, t.min, t.sec))
        end)
        -- Script time
        pcall(function()
            tscrPara:Set("Time Script", FormatTime(os.time() - Config.ScriptStartTime))
        end)
        -- Server time (workspace.DistributedGameTime)
        pcall(function()
            tsrvPara:Set("Time Server", FormatTime(math.floor(workspace.DistributedGameTime)))
        end)
        -- Spawn checks via workspace scan
        pcall(function()
            local function spawned(name) return workspace:FindFirstChild(name, true) ~= nil end
            miragePara:Set("Mirage Island Spawn",   spawned("MirageIsland") and "Spawned" or "Not Spawned")
            kitsPara:Set("Kitsune Island Spawn",    spawned("KitsuneIsland") and "Spawned" or "Not Spawned")
            prHistPara:Set("Pre-Historic Island Spawn", spawned("PreHistoricIsland") and "Spawned" or "Not Spawned")
            frozenPara:Set("Frozen Island Spawn",   spawned("FrozenIsland") and "Spawned" or "Not Spawned")
            swordDealPara:Set("Sword Dealer Legendy Spawn", spawned("LegendSwordDealer") and "Spawned" or "Not Spawned")
            ripIndraPara:Set("Rip Indra Spawn",     spawned("RipIndra") and "Spawned" or "Not Spawned")
            -- Fruit
            local fruit = workspace:FindFirstChild("Fruits", true) or workspace:FindFirstChild("Fruit", true)
            fruitPara:Set("Fruit Spawn", fruit and ("Spawned  Fruit: "..fruit.Name) or "Not Spawned")
            -- Berry
            local berry = workspace:FindFirstChild("Berry", true)
            berryPara:Set("Berry Spawn", berry and ("Spawned  Berrys: "..berry.Name) or "Not Spawned")
            -- Barista
            local bar = workspace:FindFirstChild("Barista", true)
            baristaPara:Set("Barista Color Haki", bar and ("Spawned  HakiColorSell: "..bar.Name) or "Not Spawned")
        end)
    end
end)

-- =====================================================
-- PAGE: MAIN
-- =====================================================
local Main = Window:MakeTab({ Title = "Main", Icon = "menu" })

Main:AddDropdown({
    Title    = "Farm Weapon",
    Options  = {"Melee","Sword","Gun","BloxFruits"},
    Default  = "Melee",
    Callback = function(v) Config.FarmWeapon = v end
})

Main:AddDropdown({
    Title    = "Farm Attack",
    Options  = {"Normal","FastAttack","SuperFastAttack"},
    Default  = "Normal",
    Callback = function(v)
        Config.FarmAttack = v
        if v == "SuperFastAttack" then
            redzlib:Notify({ Title = "Warning!", Description = "SuperFastAttack may cause bans.", Image = "rbxassetid://114829050051520", Type = "Warning", Duration = 5 })
        end
    end
})

Main:AddSection("Farm Normal")

Main:AddToggle({
    Title    = "Auto Farm Level",
    Default  = false,
    Flag     = "AutoFarmLevel",
    Callback = function(v)
        Config.AutoFarmLevel = v
        redzlib:Notify({ Title = v and "Auto Farm Level ON" or "Auto Farm Level OFF", Image       = "rbxassetid://114829050051520", Type = v and "Success" or "Error", Duration = 3 })
    end
})

Main:AddToggle({
    Title    = "Auto Farm Nearest",
    Default  = false,
    Flag     = "AutoFarmNearest",
    Callback = function(v)
        Config.AutoFarmNearest = v
        redzlib:Notify({ Title = v and "Auto Farm Nearest ON" or "Auto Farm Nearest OFF",Image       = "rbxassetid://114829050051520", Type = v and "Success" or "Error", Duration = 3 })
    end
})

Main:AddDropdown({
    Title    = "Select Island Nearest",
    Options  = Islands[CurrentSea],
    Default  = Islands[CurrentSea][1],
    Callback = function(v) Config.FarmIsland = v end
})

Main:AddSection("Farm Sea 3")

local sea3Toggles = {
    {"Auto Pirate Raid",    "AutoPirateRaid"},
    {"Auto Rip Indra",      "AutoRipIndra"},
    {"Auto Tyrant Spawn",   "AutoTyrantSpawn"},
    {"Auto Soul Reaper",    "AutoSoulRaper"},
    {"Auto Big Mom",        "AutoBigMom"},
    {"Auto Farm Bone",      "AutoFarmBone"},
    {"Auto Haki V2",        "AutoHakiV2"},
    {"Auto Unlock Temple",  "AutoUnlockTemple"},
    {"Auto God Human",      "AutoGodHuman"},
    {"Auto Dragon Taylor",  "AutoDragonTaylor"},
    {"Auto Electric Claw",  "AutoElectricClaw"},
    {"Auto Cake Prince",    "AutoCakePrince"},
    {"Auto Dough King (Fully)", "AutoDoughKing"},
}

for _, t in pairs(sea3Toggles) do
    local label, flag = t[1], t[2]
    local desc = (flag == "AutoRipIndra") and "Request For 3 Haki Legendary" or nil
    Main:AddToggle({
        Title    = label,
        Desc     = desc or "",
        Default  = false,
        Flag     = flag,
        Callback = function(v) Config[flag] = v end
    })
end

Main:AddSection("Farming ( Sea 2 )")

local sea2Toggles = {
    {"Auto Sea 3","AutoSea3"},{"Auto Factory","AutoFactory"},{"Auto Raid Law","AutoRaidLaw"},
    {"Auto Buy Chip Raid Law","AutoBuyChipRaidLaw"},{"Auto Start Raid Law","AutoStartRaidLaw"},
    {"Auto DarkBeard","AutoDarkBeard"},{"Auto Sharkman Karate V2","AutoSharkmanV2"},{"Auto Death Step","AutoDeathStep"},
}
for _, t in pairs(sea2Toggles) do
    Main:AddToggle({ Title=t[1], Default=false, Flag=t[2], Callback=function(v) Config[t[2]]=v end })
end

Main:AddSection("Farming ( Sea 1 )")

local sea1Toggles = {
    {"Auto Sea 2","AutoSea2"},{"Auto Saber","AutoSaber"},
    {"Auto GrayBeard","AutoGrayBeard"},{"Auto DarkBlade V2","AutoDarkBladeV2"},
}
for _, t in pairs(sea1Toggles) do
    Main:AddToggle({ Title=t[1], Default=false, Flag=t[2], Callback=function(v) Config[t[2]]=v end })
end

Main:AddSection("Extras")

Main:AddToggle({ Title="Auto Collect Berry",           Default=false, Flag="AutoCollectBerry",  Callback=function(v) Config.AutoCollectBerry=v end })
Main:AddToggle({ Title="Auto Barista",                 Default=false, Flag="AutoBarista",       Callback=function(v) Config.AutoBarista=v end })

Main:AddDropdown({
    Title   = "Color Haki",
    Options = {"White","Black","Red","Blue","Green","Yellow","Purple","Pink","Orange","Cyan","Gray","Brown","Lime","Teal","Maroon"},
    Default = "White",
    Callback = function(v) Config.HakiColor = v end
})

Main:AddButton({
    Title    = "Buy Haki Color",
    Desc     = "Compra a cor de haki selecionada",
    Callback = function()
        pcall(function() CommF_:InvokeServer("BuyHaki", Config.HakiColor) end)
        redzlib:Notify({ Title = "Haki Color", Description = "Buying: "..Config.HakiColor, Image       = "rbxassetid://114829050051520", Type = "Info", Duration = 3 })
    end
})

Main:AddToggle({ Title="Auto Farm Observation Haki", Default=false, Flag="AutoFarmObsHaki", Callback=function(v) Config.AutoFarmObsHaki=v end })

Main:AddSection("Farming Boss")

Main:AddDropdown({
    Title    = "Boss Selection",
    Options  = Bosses[CurrentSea],
    Default  = Bosses[CurrentSea][1],
    Callback = function(v) Config.SelectedBoss = v end
})

Main:AddToggle({ Title="Auto Farm Boss",      Default=false, Callback=function(v) Config.AutoFarmBoss=v end })
Main:AddToggle({ Title="Auto Farm All Boss",  Default=false, Callback=function(v) Config.AutoFarmAllBoss=v end })
Main:AddToggle({ Title="Auto Farm Raid Boss", Default=false, Callback=function(v) Config.AutoFarmRaidBoss=v end })

Main:AddSection("Farming Material")

Main:AddDropdown({
    Title    = "Material Selection",
    Options  = Materials[CurrentSea],
    Default  = Materials[CurrentSea][1],
    Callback = function(v) Config.SelectedMaterial = v end
})

Main:AddToggle({ Title="Auto Farm Material", Default=false, Callback=function(v) Config.AutoFarmMaterial=v end })

Main:AddSection("Farming Mastery")

Main:AddDropdown({ Title="Selection Weapon", Options={"Gun","BloxFruit"}, Default="Gun",  Callback=function(v) Config.MasteryWeapon=v end })
Main:AddDropdown({ Title="Select Skill",     Options={"Z","X","C","V","F"}, Default="Z",  Callback=function(v) Config.MasterySkills={v} end })
Main:AddSlider({   Title="Health Kill Mob",  Min=1, Max=100, Default=30,                   Callback=function(v) Config.HealthKillMob=v end })
Main:AddDropdown({ Title="Selection Island", Options=Islands[CurrentSea], Default=Islands[CurrentSea][1], Callback=function(v) Config.MasteryIsland=v end })
Main:AddToggle({   Title="Auto Farm Mastery",Default=false, Callback=function(v) Config.AutoFarmMastery=v end })

-- =====================================================
-- FARM LOOP
-- =====================================================
local currentTarget, attacking = nil, false

RunService.Heartbeat:Connect(function()
    if not Config.AutoFarmNearest and not Config.AutoFarmLevel then
        currentTarget = nil attacking = false return
    end
    if not HumanoidRootPart or not Humanoid then return end
    if Humanoid.Health <= 0 then return end
    if attacking then return end
    if currentTarget then
        local hum = currentTarget:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 or not currentTarget.Parent then
            Config.KillCount += 1
            currentTarget = nil
        end
    end
    if not currentTarget then currentTarget = GetNearestMob() end
    if currentTarget then
        attacking = true
        task.spawn(function()
            TweenFly(currentTarget)
            AttackMob(currentTarget)
            attacking = false
        end)
    end
end)

-- =====================================================
-- PAGE: SETTINGS
-- =====================================================
local Settings = Window:MakeTab({ Title = "Settings", Icon = "settings" })

Settings:AddSection("Farming Settings")

Settings:AddToggle({ Title="Auto Click",          Default=true,  Callback=function(v) Config.AutoClick=v end })
Settings:AddToggle({ Title="Bring Mob",           Default=true,  Callback=function(v) Config.BringMob=v end })
Settings:AddDropdown({ Title="Bring Distance",    Options={"200","300","400","500"}, Default="300", Callback=function(v) Config.BringDistance=tonumber(v) end })
Settings:AddToggle({ Title="Auto Set Spawn Point",Default=false, Callback=function(v) Config.AutoSetSpawn=v end })
Settings:AddToggle({ Title="Auto Buso Haki",      Default=true,  Callback=function(v) Config.AutoBusoHaki=v if v then ActivateBuso() end end })
Settings:AddToggle({ Title="Auto Observation",    Default=false, Callback=function(v) Config.AutoObservation=v end })
Settings:AddToggle({ Title="Auto Turn V3",        Default=false, Callback=function(v) Config.AutoTurnV3=v end })
Settings:AddToggle({ Title="Auto Turn V4",        Default=false, Callback=function(v) Config.AutoTurnV4=v end })

Settings:AddSection("Extras")

Settings:AddToggle({ Title="Auto Speed", Default=true, Callback=function(v) Config.AutoSpeed=v end })
Settings:AddSlider({ Title="Speed",      Min=20, Max=100, Default=20, Callback=function(v) Config.Speed=v if Humanoid then Humanoid.WalkSpeed=v end end })
Settings:AddToggle({ Title="Auto Set Jump", Default=true, Callback=function(v) Config.AutoSetJump=v end })
Settings:AddSlider({ Title="Jump",          Min=50, Max=200, Default=50, Callback=function(v) Config.Jump=v if Humanoid then Humanoid.JumpPower=v end end })

Settings:AddSection("Visual")

Settings:AddToggle({ Title="Disable Game Notify", Default=false, Callback=function(v) Config.DisableGameNotify=v end })
Settings:AddToggle({ Title="No Fog", Default=true, Callback=function(v)
    Config.NoFog=v
    Lighting.FogEnd = v and 100000 or 1000
end })

Settings:AddToggle({ Title="Notify Error Script", Default=false, Callback=function(v)
    Config.NotifyErroScript=v
    redzlib:Notify({ Description=v and "Notify erro ativo" or "Notify erro desativado", Image       = "rbxassetid://114829050051520", Type=v and "Success" or "Error", Duration=3 })
end })

Settings:AddButton({ Title="Test Notification", Callback=function()
    redzlib:Notify({ Title="Test", Description="Notificacao funcionando!", Image="rbxassetid://114829050051520", Type="Success", Duration=3 })
end })

Settings:AddToggle({ Title="No Clip", Default=false, Callback=function(v)
    Config.NoClip=v
    redzlib:Notify({ Title=v and "NoClip ON" or "NoClip OFF", Image       = "rbxassetid://114829050051520", Type=v and "Success" or "Info", Duration=2 })
end })

RunService.Stepped:Connect(function()
    if Config.NoClip and Character then
        for _, p in pairs(Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end
end)

-- =====================================================
-- PAGE: FISHING
-- =====================================================
local Fishing = Window:MakeTab({ Title = "Fishing", Icon = "fish" })
Fishing:AddParagraph({ Title = "Fishing", Text = "SOON COMING" })

-- =====================================================
-- PAGE: ITEM / QUEST
-- =====================================================
local ItemQuest = Window:MakeTab({ Title = "Item/Quest", Icon = "swords" })
ItemQuest:AddParagraph({ Title = "Item / Quest", Text = "SOON COMING" })

-- =====================================================
-- PAGE: RACE
-- =====================================================
local Race = Window:MakeTab({ Title = "Race", Icon = "flag" })
Race:AddParagraph({ Title = "Race", Text = "SOON COMING" })

-- =====================================================
-- PAGE: VULCANO ISLAND
-- =====================================================
local Vulcano = Window:MakeTab({ Title = "Vulcano Island", Icon = "flame" })
Vulcano:AddParagraph({ Title = "Vulcano Island", Text = "SOON COMING" })

-- =====================================================
-- PAGE: SEA EVENT
-- =====================================================
local SeaEvent = Window:MakeTab({ Title = "Sea Event", Icon = "waves" })
SeaEvent:AddParagraph({ Title = "Sea Event", Text = "SOON COMING" })

-- =====================================================
-- PAGE: FRUIT / RAID
-- =====================================================
local FruitRaid = Window:MakeTab({ Title = "Fruit/Raid", Icon = "apple" })
FruitRaid:AddParagraph({ Title = "Fruit / Raid", Text = "SOON COMING" })

-- =====================================================
-- PAGE: ESP
-- =====================================================
local Esp = Window:MakeTab({ Title = "Esp", Icon = "eye" })

Esp:AddSection("ESP Settings")

Esp:AddToggle({ Title="ESP Mobs", Default=false, Callback=function(v)
    Config.ESPEnabled=v
    if not v then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("SelectionBox") and obj.Name=="ESP_Redux" then obj:Destroy() end
        end
    end
    redzlib:Notify({ Title=v and "ESP ON" or "ESP OFF", Image       = "rbxassetid://114829050051520",Type=v and "Success" or "Info", Duration=2 })
end })

Esp:AddToggle({ Title="ESP Teammates", Default=false, Callback=function(v) Config.ESPTeammates=v end })

RunService.Heartbeat:Connect(function()
    if not Config.ESPEnabled then return end
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= Character then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and not obj:FindFirstChild("ESP_Redux") then
                local box = Instance.new("SelectionBox")
                box.Name="ESP_Redux" box.Color3=Color3.fromRGB(255,50,50)
                box.LineThickness=0.05 box.Adornee=obj box.Parent=obj
            end
        end
    end
end)

-- =====================================================
-- PAGE: LOCAL PLAYER
-- =====================================================
local LocalPlayer = Window:MakeTab({ Title = "Local Player", Icon = "users" })

LocalPlayer:AddSection("Character Stats")

LocalPlayer:AddSlider({ Title="WalkSpeed", Min=16, Max=500, Default=16, Callback=function(v)
    Config.WalkSpeed=v if Humanoid then Humanoid.WalkSpeed=v end
end })

LocalPlayer:AddSlider({ Title="JumpPower", Min=50, Max=500, Default=50, Callback=function(v)
    Config.JumpPower=v if Humanoid then Humanoid.JumpPower=v end
end })

LocalPlayer:AddToggle({ Title="Infinite Jump", Default=false, Callback=function(v)
    Config.InfiniteJump=v
    redzlib:Notify({ Title=v and "Infinite Jump ON" or "Infinite Jump OFF", Image       = "rbxassetid://114829050051520", Type=v and "Success" or "Info", Duration=2 })
end })

game:GetService("UserInputService").JumpRequest:Connect(function()
    if Config.InfiniteJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

LocalPlayer:AddToggle({ Title="Anti-AFK", Default=false, Callback=function(v)
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
    redzlib:Notify({ Title=v and "Anti-AFK ON" or "Anti-AFK OFF",Image       = "rbxassetid://114829050051520", Type=v and "Success" or "Info", Duration=2 })
end })

LocalPlayer:AddSection("Actions")

LocalPlayer:AddButton({ Title="Check HP", Callback=function()
    if Humanoid then
        redzlib:Notify({ Title="HP", Description=string.format("%d / %d", math.floor(Humanoid.Health), math.floor(Humanoid.MaxHealth)), Image       = "rbxassetid://114829050051520", Type="Info", Duration=4 })
    end
end })

LocalPlayer:AddButton({ Title="Reset Character", Callback=function()
    if Humanoid then Humanoid.Health=0 end
    redzlib:Notify({ Title="Resetting...", Image       = "rbxassetid://114829050051520",Type="Warning", Duration=3 })
end })

LocalPlayer:AddButton({ Title="Copy Position", Callback=function()
    if HumanoidRootPart then
        local p=HumanoidRootPart.Position
        local s=string.format("%.1f,%.1f,%.1f",p.X,p.Y,p.Z)
        pcall(function() setclipboard(s) end)
        redzlib:Notify({ Title="Position Copied!", Description=s, Image       = "rbxassetid://114829050051520", Type="Success", Duration=4 })
    end
end })

-- =====================================================
-- PAGE: TELEPORT
-- =====================================================
local Teleport = Window:MakeTab({ Title = "Teleport", Icon = "mouse" })

Teleport:AddSection("Quick Teleport")

for _, island in pairs(Islands[CurrentSea]) do
    Teleport:AddButton({ Title="Teleport: "..island, Callback=function()
        -- Find quest NPC for that island
        local found = false
        for _, q in pairs(QuestList) do
            if q.Sea == CurrentSea and q.Name:lower():find(island:lower():sub(1,5),1,true) then
                if HumanoidRootPart then HumanoidRootPart.CFrame = q.NPC end
                redzlib:Notify({ Title="Teleported!", Description=island, Image       = "rbxassetid://114829050051520", Type="Success", Duration=3 })
                found = true break
            end
        end
        if not found then
            redzlib:Notify({ Title="Teleport", Description=island.." - CFrame not mapped yet.", Image       = "rbxassetid://114829050051520", Type="Warning", Duration=3 })
        end
    end })
end

Teleport:AddSection("Custom Coordinates")

Teleport:AddTextBox({ Title="X,Y,Z Coordinates", Desc="ex: 100,50,200", Default="", PlaceholderText="X,Y,Z", ClearText=true,
    Callback=function(v)
        if not v or v:gsub(" ","")=="" then return end
        local c={}
        for n in v:gmatch("%-?%d+%.?%d*") do table.insert(c,tonumber(n)) end
        if #c>=3 and HumanoidRootPart then
            HumanoidRootPart.CFrame=CFrame.new(c[1],c[2],c[3])
            redzlib:Notify({ Title="Teleported!", Description=string.format("X:%g Y:%g Z:%g",c[1],c[2],c[3]), Image       = "rbxassetid://114829050051520", Type="Success", Duration=4 })
        else
            redzlib:Notify({ Title="Invalid Format", Description="Use: X,Y,Z", Image       = "rbxassetid://114829050051520", Type="Error", Duration=3 })
        end
    end
})

-- =====================================================
-- PAGE: SHOPPING
-- =====================================================
local Shopping = Window:MakeTab({ Title = "Shopping", Icon = "shoppingbag" })
Shopping:AddParagraph({ Title = "Shopping", Text = "SOON COMING" })

-- =====================================================
-- PAGE: MISC
-- =====================================================
local Misc = Window:MakeTab({ Title = "Misc", Icon = "calendarsearch" })

Misc:AddSection("Utility")

Misc:AddToggle({ Title="FullBright", Default=false, Callback=function(v)
    local L=Lighting
    if v then L.Brightness=10 L.GlobalShadows=false L.Ambient=Color3.fromRGB(255,255,255) L.OutdoorAmbient=Color3.fromRGB(255,255,255)
    else L.Brightness=2 L.GlobalShadows=true L.Ambient=Color3.fromRGB(70,70,70) L.OutdoorAmbient=Color3.fromRGB(128,128,128) end
    redzlib:Notify({ Title=v and "FullBright ON" or "FullBright OFF",  Image       = "rbxassetid://114829050051520", Type=v and "Success" or "Info", Duration=2 })
end })

Misc:AddSlider({ Title="FOV", Min=30, Max=120, Default=70, Callback=function(v) Camera.FieldOfView=v end })

Misc:AddButton({ Title="Reset Visual", Callback=function()
    Camera.FieldOfView=70
    Lighting.Brightness=2 Lighting.GlobalShadows=true
    Lighting.Ambient=Color3.fromRGB(70,70,70) Lighting.OutdoorAmbient=Color3.fromRGB(128,128,128)
    redzlib:Notify({ Title="Visual Reset", Image       = "rbxassetid://114829050051520", Type="Info", Duration=3 })
end })

Misc:AddSection("Script Info")

Misc:AddParagraph({ Title="Redux Hub v1.0", Text="by Redux Studio. Sea "..CurrentSea.." | PlaceId: "..PlaceId })
Misc:AddParagraph({ Title="Compatible Executors", Text="Seliware, Velocity, Bunni, Ronix" })

Misc:AddButton({ Title="Close UI", Callback=function() Window:CloseBtn() end })

redzlib:Notify({ Title="Redux Hub Is loader Sucessefully", Image = "rbxassetid://114829050051520", Type="Sucess", Duration=3})