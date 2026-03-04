-- =====================================================
--         Redux Hub - Blox Fruits Script (Melhorado)
--         by Redux Studio V1.0 + Integrações
-- =====================================================

local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/enzoplaaygamemg12/GUI123/refs/heads/main/RedzUiLib.lua"))()

-- =====================================================
-- SERVIÇOS
-- =====================================================
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local VirtualUser       = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService       = game:GetService("HttpService")
local Lighting          = game:GetService("Lighting")
local UserInputService  = game:GetService("UserInputService")

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
-- REMOTES (do Scripts.txt)
-- =====================================================
local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local RE_RegisterHit = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterHit")
local RE_RegisterAttack = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack")
local EquipEvent = Player:WaitForChild("EquipEvent")

-- =====================================================
-- VARIÁVEIS GLOBAIS (do Scripts.txt)
-- =====================================================
First_Sea = (game.PlaceId == 2753915549)
Second_Sea = (game.PlaceId == 4442272183)
Third_Sea = (game.PlaceId == 7449423635)
CurrentSea = First_Sea and 1 or Second_Sea and 2 or 3

-- =====================================================
-- FUNÇÕES AUXILIARES
-- =====================================================
local function RandomHitId()
    local chars = "0123456789abcdef"
    local id = ""
    for i = 1, 8 do
        id = id .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    return id
end

local function isnil(val) return val == nil end

local function round(num)
    return math.floor(tonumber(num) + 0.5)
end

-- =====================================================
-- FUNÇÕES DE TWEEN E TELEPORT (do Scripts.txt)
-- =====================================================
local Speed = 300
local tween = nil
local function toTarget(targetCF)
    -- targetCF deve ser um CFrame
    if not HumanoidRootPart then return end
    if Humanoid.Health <= 0 then
        if tween then tween:Cancel() end
        repeat task.wait() until Humanoid.Health > 0
        task.wait(0.2)
    end
    local distance = (targetCF.Position - HumanoidRootPart.Position).Magnitude
    local speed = distance < 1000 and 315 or 300
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = targetCF})
    tween:Play()
    if tween then tween.Completed:Wait() end
end

local function Tween(targetCF)
    -- Similar ao toTarget, mas sem wait interno (pode ser usado em paralelo)
    if not HumanoidRootPart then return end
    local distance = (targetCF.Position - HumanoidRootPart.Position).Magnitude
    local speed = 300
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = targetCF})
    tween:Play()
end

local function BTP(cf)
    -- Teleporte bruto (bypass)
    pcall(function() Character.Head:Destroy() end)
    HumanoidRootPart.CFrame = cf
    task.wait(0.5)
    HumanoidRootPart.CFrame = cf
    CommF_:InvokeServer("SetSpawnPoint")
end

-- =====================================================
-- SISTEMA DE QUESTS (do Scripts.txt)
-- =====================================================
local Ms, NameQuest, QuestLv, NameMon, CFrameQ, CFrameMon

function CheckLevel()
    local lvl = Player.Data.Level.Value
    if First_Sea then
        if lvl <= 9 then
            Ms = "Bandit"
            NameQuest = "BanditQuest1"
            QuestLv = 1
            NameMon = "Bandit"
            CFrameQ = CFrame.new(1060.9383544922, 16.455066680908, 1547.7841796875)
            CFrameMon = CFrame.new(1038.5533447266, 41.296249389648, 1576.5098876953)
        elseif lvl <= 14 then
            Ms = "Monkey"
            NameQuest = "JungleQuest"
            QuestLv = 1
            NameMon = "Monkey"
            CFrameQ = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
            CFrameMon = CFrame.new(-1448.1446533203, 50.851993560791, 63.60718536377)
        elseif lvl <= 29 then
            Ms = "Gorilla"
            NameQuest = "JungleQuest"
            QuestLv = 2
            NameMon = "Gorilla"
            CFrameQ = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
            CFrameMon = CFrame.new(-1142.6488037109, 40.462348937988, -515.39227294922)
        elseif lvl <= 39 then
            Ms = "Pirate"
            NameQuest = "BuggyQuest1"
            QuestLv = 1
            NameMon = "Pirate"
            CFrameQ = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
            CFrameMon = CFrame.new(-1201.0881347656, 40.628940582275, 3857.5966796875)
        elseif lvl <= 59 then
            Ms = "Brute"
            NameQuest = "BuggyQuest1"
            QuestLv = 2
            NameMon = "Brute"
            CFrameQ = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
            CFrameMon = CFrame.new(-1387.5324707031, 24.592035293579, 4100.9575195313)
        elseif lvl <= 74 then
            Ms = "Desert Bandit"
            NameQuest = "DesertQuest"
            QuestLv = 1
            NameMon = "Desert Bandit"
            CFrameQ = CFrame.new(896.51721191406, 6.4384617805481, 4390.1494140625)
            CFrameMon = CFrame.new(984.99896240234, 16.109552383423, 4417.91015625)
        elseif lvl <= 89 then
            Ms = "Desert Officer"
            NameQuest = "DesertQuest"
            QuestLv = 2
            NameMon = "Desert Officer"
            CFrameQ = CFrame.new(896.51721191406, 6.4384617805481, 4390.1494140625)
            CFrameMon = CFrame.new(1547.1510009766, 14.452038764954, 4381.8002929688)
        elseif lvl <= 99 then
            Ms = "Snow Bandit"
            NameQuest = "SnowQuest"
            QuestLv = 1
            NameMon = "Snow Bandit"
            CFrameQ = CFrame.new(1386.8073730469, 87.272789001465, -1298.3576660156)
            CFrameMon = CFrame.new(1356.3028564453, 105.76865386963, -1328.2418212891)
        elseif lvl <= 119 then
            Ms = "Snowman"
            NameQuest = "SnowQuest"
            QuestLv = 2
            NameMon = "Snowman"
            CFrameQ = CFrame.new(1386.8073730469, 87.272789001465, -1298.3576660156)
            CFrameMon = CFrame.new(1218.7956542969, 138.01184082031, -1488.0262451172)
        elseif lvl <= 149 then
            Ms = "Chief Petty Officer"
            NameQuest = "MarineQuest2"
            QuestLv = 1
            NameMon = "Chief Petty Officer"
            CFrameQ = CFrame.new(-5035.49609375, 28.677835464478, 4324.1840820313)
            CFrameMon = CFrame.new(-4931.1552734375, 65.793113708496, 4121.8393554688)
        elseif lvl <= 174 then
            Ms = "Sky Bandit"
            NameQuest = "SkyQuest"
            QuestLv = 1
            NameMon = "Sky Bandit"
            CFrameQ = CFrame.new(-4842.1372070313, 717.69543457031, -2623.0483398438)
            CFrameMon = CFrame.new(-4955.6411132813, 365.46365356445, -2908.1865234375)
        elseif lvl <= 189 then
            Ms = "Dark Master"
            NameQuest = "SkyQuest"
            QuestLv = 2
            NameMon = "Dark Master"
            CFrameQ = CFrame.new(-4842.1372070313, 717.69543457031, -2623.0483398438)
            CFrameMon = CFrame.new(-5148.1650390625, 439.04571533203, -2332.9611816406)
        elseif lvl <= 209 then
            Ms = "Prisoner"
            NameQuest = "PrisonerQuest"
            QuestLv = 1
            NameMon = "Prisoner"
            CFrameQ = CFrame.new(5310.60547, 0.350014925, 474.946594)
            CFrameMon = CFrame.new(4937.31885, 0.332031399, 649.574524)
        elseif lvl <= 249 then
            Ms = "Dangerous Prisoner"
            NameQuest = "PrisonerQuest"
            QuestLv = 2
            NameMon = "Dangerous Prisoner"
            CFrameQ = CFrame.new(5310.60547, 0.350014925, 474.946594)
            CFrameMon = CFrame.new(5099.6626, 0.351562679, 1055.7583)
        elseif lvl <= 274 then
            Ms = "Toga Warrior"
            NameQuest = "ColosseumQuest"
            QuestLv = 1
            NameMon = "Toga Warrior"
            CFrameQ = CFrame.new(-1577.7890625, 7.4151420593262, -2984.4838867188)
            CFrameMon = CFrame.new(-1872.5166015625, 49.080215454102, -2913.810546875)
        elseif lvl <= 299 then
            Ms = "Gladiator"
            NameQuest = "ColosseumQuest"
            QuestLv = 2
            NameMon = "Gladiator"
            CFrameQ = CFrame.new(-1577.7890625, 7.4151420593262, -2984.4838867188)
            CFrameMon = CFrame.new(-1521.3740234375, 81.203170776367, -3066.3139648438)
        elseif lvl <= 324 then
            Ms = "Military Soldier"
            NameQuest = "MagmaQuest"
            QuestLv = 1
            NameMon = "Military Soldier"
            CFrameQ = CFrame.new(-5316.1157226563, 12.262831687927, 8517.00390625)
            CFrameMon = CFrame.new(-5369.0004882813, 61.24352645874, 8556.4921875)
        elseif lvl <= 374 then
            Ms = "Military Spy"
            NameQuest = "MagmaQuest"
            QuestLv = 2
            NameMon = "Military Spy"
            CFrameQ = CFrame.new(-5316.1157226563, 12.262831687927, 8517.00390625)
            CFrameMon = CFrame.new(-5787.00293, 75.8262634, 8651.69922)
        elseif lvl <= 399 then
            Ms = "Fishman Warrior"
            NameQuest = "FishmanQuest"
            QuestLv = 1
            NameMon = "Fishman Warrior"
            CFrameQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            CFrameMon = CFrame.new(60844.10546875, 98.462875366211, 1298.3985595703)
        elseif lvl <= 449 then
            Ms = "Fishman Commando"
            NameQuest = "FishmanQuest"
            QuestLv = 2
            NameMon = "Fishman Commando"
            CFrameQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            CFrameMon = CFrame.new(61738.3984375, 64.207321166992, 1433.8375244141)
        elseif lvl <= 474 then
            Ms = "God's Guard"
            NameQuest = "SkyExp1Quest"
            QuestLv = 1
            NameMon = "God's Guard"
            CFrameQ = CFrame.new(-4721.8603515625, 845.30297851563, -1953.8489990234)
            CFrameMon = CFrame.new(-4628.0498046875, 866.92877197266, -1931.2352294922)
        elseif lvl <= 524 then
            Ms = "Shanda"
            NameQuest = "SkyExp1Quest"
            QuestLv = 2
            NameMon = "Shanda"
            CFrameQ = CFrame.new(-7863.1596679688, 5545.5190429688, -378.42266845703)
            CFrameMon = CFrame.new(-7685.1474609375, 5601.0751953125, -441.38876342773)
        elseif lvl <= 549 then
            Ms = "Royal Squad"
            NameQuest = "SkyExp2Quest"
            QuestLv = 1
            NameMon = "Royal Squad"
            CFrameQ = CFrame.new(-7903.3828125, 5635.9897460938, -1410.923828125)
            CFrameMon = CFrame.new(-7654.2514648438, 5637.1079101563, -1407.7550048828)
        elseif lvl <= 624 then
            Ms = "Royal Soldier"
            NameQuest = "SkyExp2Quest"
            QuestLv = 2
            NameMon = "Royal Soldier"
            CFrameQ = CFrame.new(-7903.3828125, 5635.9897460938, -1410.923828125)
            CFrameMon = CFrame.new(-7760.4106445313, 5679.9077148438, -1884.8112792969)
        elseif lvl <= 649 then
            Ms = "Galley Pirate"
            NameQuest = "FountainQuest"
            QuestLv = 1
            NameMon = "Galley Pirate"
            CFrameQ = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
            CFrameMon = CFrame.new(5557.1684570313, 152.32717895508, 3998.7758789063)
        else
            Ms = "Galley Captain"
            NameQuest = "FountainQuest"
            QuestLv = 2
            NameMon = "Galley Captain"
            CFrameQ = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
            CFrameMon = CFrame.new(5677.6772460938, 92.786109924316, 4966.6323242188)
        end
    elseif Second_Sea then
        -- (adicione as faixas do Second Sea do Scripts.txt)
        -- Por brevidade, manteremos apenas o essencial, mas você pode expandir
        if lvl <= 724 then
            Ms = "Raider"
            NameQuest = "Area1Quest"
            QuestLv = 1
            NameMon = "Raider"
            CFrameQ = CFrame.new(-427.72567749023, 72.99634552002, 1835.9426269531)
            CFrameMon = CFrame.new(68.874565124512, 93.635643005371, 2429.6752929688)
        else
            Ms = "Mercenary"
            NameQuest = "Area1Quest"
            QuestLv = 2
            NameMon = "Mercenary"
            CFrameQ = CFrame.new(-427.72567749023, 72.99634552002, 1835.9426269531)
            CFrameMon = CFrame.new(-864.85009765625, 122.47104644775, 1453.1505126953)
        end
    elseif Third_Sea then
        -- Exemplo resumido
        if lvl <= 1524 then
            Ms = "Pirate Millionaire"
            NameQuest = "PiratePortQuest"
            QuestLv = 1
            NameMon = "Pirate Millionaire"
            CFrameQ = CFrame.new(-289.61752319336, 43.819011688232, 5580.0903320313)
            CFrameMon = CFrame.new(-435.68109130859, 189.69866943359, 5551.0756835938)
        else
            Ms = "Pistol Billionaire"
            NameQuest = "PiratePortQuest"
            QuestLv = 2
            NameMon = "Pistol Billionaire"
            CFrameQ = CFrame.new(-289.61752319336, 43.819011688232, 5580.0903320313)
            CFrameMon = CFrame.new(-236.53652954102, 217.46676635742, 6006.0883789063)
        end
    end
end

-- =====================================================
-- FUNÇÃO DE ATAQUE
-- =====================================================
local function GetHitPart(model)
    for _, partName in pairs({"LeftUpperArm", "RightUpperArm", "UpperTorso", "HumanoidRootPart", "Head"}) do
        local part = model:FindFirstChild(partName)
        if part and part:IsA("BasePart") then return part end
    end
    for _, part in pairs(model:GetDescendants()) do
        if part:IsA("BasePart") then return part end
    end
    return nil
end

local function AttackMob(mob)
    if not Config.AutoClick then return end
    local hrp = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart
    if not hrp then return end

    -- Olha para o mob
    HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position, hrp.Position)

    -- Ativa Buso se necessário
    if Config.AutoBusoHaki then
        pcall(function() CommF_:InvokeServer("Buso") end)
    end

    -- Equipa arma (simplificado, pode melhorar)
    if Config.FarmWeapon ~= "Melee" then
        local tool = Player.Backpack:FindFirstChild(Config.FarmWeapon)
        if tool then
            pcall(function() Humanoid:EquipTool(tool) end)
        end
    end

    -- Registra hit
    local hitPart = GetHitPart(mob) or hrp
    pcall(function() RE_RegisterHit:FireServer(hitPart, {}, RandomHitId()) end)
    task.wait(Config.AttackDelay)
    pcall(function() RE_RegisterAttack:FireServer(0.4) end)
end

-- =====================================================
-- CONFIGURAÇÕES
-- =====================================================
Config = {
    AutoClick = false,
    AutoFarmLevel = false,
    AutoFarmNearest = false,
    FarmWeapon = "Melee",
    AttackDelay = 0.15,
    AutoBusoHaki = true,
    BringMob = true,
    BringDistance = 300,
    -- (outras configs do Redux podem ser mantidas)
}

-- =====================================================
-- VARIÁVEIS DE CONTROLE
-- =====================================================
local attacking = false
local currentTarget = nil
local questActive = false
local questTargetMonster = nil

-- =====================================================
-- FUNÇÃO PARA ENCONTRAR MOB MAIS PRÓXIMO (FILTRO OPCIONAL)
-- =====================================================
local function GetNearestMob(filterName)
    local nearest, nearestDist = nil, math.huge
    if not HumanoidRootPart then return nil end
    local myPos = HumanoidRootPart.Position
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        local hum = mob:FindFirstChildOfClass("Humanoid")
        local hrp = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart
        if hum and hrp and hum.Health > 0 then
            if not filterName or mob.Name:lower():find(filterName:lower(), 1, true) then
                local dist = (hrp.Position - myPos).Magnitude
                if dist < nearestDist then
                    nearest = mob
                    nearestDist = dist
                end
            end
        end
    end
    return nearest
end

-- =====================================================
-- FUNÇÃO PARA TRAZER MOB (BÁSICA)
-- =====================================================
local function BringMob(mob, distance)
    if not Config.BringMob then return end
    local hrp = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart
    if not hrp then return end
    if (hrp.Position - HumanoidRootPart.Position).Magnitude > distance then
        hrp.CFrame = HumanoidRootPart.CFrame * CFrame.new(0,0,5)
    end
end

-- =====================================================
-- LOOP PRINCIPAL (AUTO CLICK + AUTO FARM)
-- =====================================================
RunService.Heartbeat:Connect(function()
    if not Humanoid or Humanoid.Health <= 0 then return end

    -- 1. AUTO CLICK INDEPENDENTE (quando nenhum farm ativo)
    if Config.AutoClick and not Config.AutoFarmLevel and not Config.AutoFarmNearest then
        if not attacking then
            local target = GetNearestMob()
            if target then
                attacking = true
                task.spawn(function()
                    toTarget(target:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,0,3))
                    AttackMob(target)
                    attacking = false
                end)
            end
        end
        return
    end

    -- 2. AUTO FARM POR NÍVEL (com quests)
    if Config.AutoFarmLevel then
        -- Atualiza dados da quest conforme nível
        pcall(CheckLevel)

        if not questActive then
            -- Vai até o NPC e aceita a quest
            if (HumanoidRootPart.Position - CFrameQ.Position).Magnitude > 10 then
                toTarget(CFrameQ)
            else
                local args = {"StartQuest", NameQuest, QuestLv}
                local success = pcall(function() return CommF_:InvokeServer(unpack(args)) end)
                if success then
                    questActive = true
                    questTargetMonster = Ms
                end
            end
            return
        end

        -- Se quest ativa, verifica progresso
        local progress = pcall(function() return CommF_:InvokeServer("GetQuestProgress") end)
        if progress and progress >= QuestLv * 10 then
            -- Entrega a quest
            toTarget(CFrameQ)
            task.wait(1)
            pcall(function() CommF_:InvokeServer("EndQuest") end)
            questActive = false
            return
        end

        -- Vai para área dos monstros
        if (HumanoidRootPart.Position - CFrameMon.Position).Magnitude > 10 then
            toTarget(CFrameMon)
        else
            -- Ataca monstros da quest
            if not attacking then
                local target = GetNearestMob(questTargetMonster)
                if target then
                    attacking = true
                    task.spawn(function()
                        if Config.BringMob then BringMob(target, Config.BringDistance) end
                        AttackMob(target)
                        attacking = false
                    end)
                end
            end
        end
        return
    end

    -- 3. AUTO FARM POR PROXIMIDADE (sem quest)
    if Config.AutoFarmNearest then
        if not attacking then
            local target = GetNearestMob()
            if target then
                attacking = true
                task.spawn(function()
                    toTarget(target:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,0,3))
                    if Config.BringMob then BringMob(target, Config.BringDistance) end
                    AttackMob(target)
                    attacking = false
                end)
            end
        end
    end
end)

-- =====================================================
-- SISTEMA DE LINGUAGEM (do Redux)
-- =====================================================
local LANG_URL = "https://raw.githubusercontent.com/enzoplaaygamemg12/Script-ReduxHub-/refs/heads/main/Script/Language.json"
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
-- CRIAÇÃO DA INTERFACE (Reduzida, focada no essencial)
-- =====================================================
local IMG = "rbxassetid://135350717440671"
local Window = redzlib:MakeWindow({ Title="Redux Hub Melhorado", SubTitle="by Redux Studio", SaveFolder="redux_hub_melhorado" })

Window:AddMinimizeButton({
    Button = { Size=UDim2.fromOffset(45,45), Position=UDim2.fromScale(0.05,0.05), Image=IMG, BackgroundTransparency=1 },
    Corner  = { CornerRadius=UDim.new(1,0) },
})

-- Aba Principal
local Main = Window:MakeTab({ Title="Principal", Icon="menu" })
Main:AddSection("Configurações de Farm")
Main:AddToggle({ Title="Auto Click", Default=false, Flag="AutoClick", Callback=function(v) Config.AutoClick = v end })
Main:AddToggle({ Title="Auto Farm por Nível", Default=false, Flag="AutoFarmLevel", Callback=function(v) Config.AutoFarmLevel = v end })
Main:AddToggle({ Title="Auto Farm por Proximidade", Default=false, Flag="AutoFarmNearest", Callback=function(v) Config.AutoFarmNearest = v end })
Main:AddDropdown({ Title="Arma", Options={"Melee","Sword","Gun","BloxFruits"}, Default="Melee", Callback=function(v) Config.FarmWeapon = v end })
Main:AddSlider({ Title="Delay de Ataque (s)", Min=0.05, Max=0.5, Default=0.15, Callback=function(v) Config.AttackDelay = v end })
Main:AddToggle({ Title="Auto Buso Haki", Default=true, Flag="AutoBusoHaki", Callback=function(v) Config.AutoBusoHaki = v end })

Main:AddSection("Opções de Bring")
Main:AddToggle({ Title="Trazer Mob", Default=true, Flag="BringMob", Callback=function(v) Config.BringMob = v end })
Main:AddDropdown({ Title="Distância do Bring", Options={"200","300","400","500"}, Default="300", Callback=function(v) Config.BringDistance = tonumber(v) end })

-- Aba de Status (simples)
local Home = Window:MakeTab({ Title="Status", Icon="home" })
Home:AddParagraph({ Title="Nível", Text=Player.Data.Level.Value })
Home:AddParagraph({ Title="Mar", Text=CurrentSea })

-- Notify de início
redzlib:Notify({ Title="Redux Hub", Description="Script carregado com sucesso!", Image=IMG, Duration=3, Type="Success" })
