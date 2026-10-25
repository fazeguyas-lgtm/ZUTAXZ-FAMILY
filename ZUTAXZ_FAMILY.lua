
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local VirtualUser       = game:GetService("VirtualUser")
local HttpService       = game:GetService("HttpService")
local UserInputService  = game:GetService("UserInputService")
local Workspace         = game:GetService("Workspace")
local TeleportService   = game:GetService("TeleportService")
local StarterGui        = game:GetService("StarterGui")
local Lighting          = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats             = game:GetService("Stats")

local LP    = Players.LocalPlayer
local PGui  = LP:WaitForChild("PlayerGui")

-- ═══════════════════════════════════════════════════════════
-- ICON TABLE — ID gambar lu
-- ═══════════════════════════════════════════════════════════

local ICONS = {
    Main    = { image = "rbxassetid://6031075936", glyph = "⌂" },
    Steal   = { image = "rbxassetid://6035047409", glyph = "⚡" },
    Auto    = { image = "rbxassetid://6034684930", glyph = "◈" },
    Pets    = { image = "rbxassetid://6023426926", glyph = "✦" },
    Events  = { image = "rbxassetid://6035047409", glyph = "✧" },
    Players = { image = "rbxassetid://6031075936", glyph = "☰" },
    Bypass  = { image = "rbxassetid://6034281935", glyph = "⛨" },
    Misc    = { image = "rbxassetid://6034684930", glyph = "⚙" },
    Visual  = { image = "rbxassetid://6031075936", glyph = "◉" },
    
    -- GAMBAR LU BOS!
    Profile = { image = "rbxassetid://113318807648626", glyph = "⛁" },
    Logo    = { image = "rbxassetid://113318807648626", glyph = "S" },
    
    Close   = { image = "rbxassetid://6023426926", glyph = "X" },
    Minimize= { image = "rbxassetid://6034684930", glyph = "—" },
    Check   = { image = "rbxassetid://6035047409", glyph = "✓" },
    Pattern = { image = "rbxassetid://7379790940", glyph = "" },
}

-- ═══════════════════════════════════════════════════════════
-- CONFIG  (ALL OFF BY DEFAULT)
-- ═══════════════════════════════════════════════════════════

local CONFIG = {
    AutoSteal = false, InstantGrab = false, StealPriority = "Rarest",
    StealSpeed = 250, TweenSpeed = 400, RefreshRate = 0.08,
    MultiFireBurst = 3, Humanize = false, HumanizeJitter = 0.05,
    VelocityMove = false, SpawnPredictor = false,

    AutoPlace = false, AutoHatch = false, AutoSellEgg = false, AutoSellPet = false,
    AutoFuse = false, AutoEquipBest = false, AutoUpgradeBase = false,
    AutoUpgradeTreadmill = false, AutoTreadmill = false, CollectOffline = false,
    AutoClaimAlmanac = false, AutoDaily = false, AutoQuest = false, AutoRebirth = false,
    AuctionMinValue = 5000,

    AutoCatch = false, ButterflyESP = false, AutoTradeUp = false,
    AutoCraftEssence = false, AutoBuyShop = false, AutoTradeIn = false,
    AutoFreeReroll = false, AutoBoss = false, AutoEggRain = false,
    AutoGift = false, AutoAuctionSnipe = false, BossDodge = false,

    AutoStealFromPlayers = false, StealFromPlayerName = "", PlayerWhitelist = {},

    AutoHop = false, HopWhenNothingMatches = false, HopCooldown = 8,
    AutoReconnect = false, AutoRejoinOnKick = false,

    BoostFPS = false, UncapFPS = false, FPSBoost = 60, AdaptiveFPS = false,
    BottingMode = false, AntiCutscene = false,

    AntiTreadmill = false, AntiAFK = false, AntiGuardKnockback = false,
    AntiHitGuard = false, AntiDetection = false, DetectionThreshold = 50,
    AntiKick = false, AntiBan = false, AntiCrash = false, AntiLog = false,
    AntiTeleport = false,

    Bypass = false, BypassRemote = false, BypassSimRadius = false,
    BypassFocus = false, BypassHeartbeat = false, BypassStringScan = false,

    Noclip = false, InfiniteJump = false, Fly = false, FlySpeed = 80,

    EggChecker = false, RarityESP = false, DistanceESP = false,

    StealWebhook = false, WebhookURL = "", WebhookMinRarity = "Legendary",
    WebhookBatch = false, WebhookBatchSize = 5,

    AutoSaveConfig = true, ConfigPath = "SENA_v10_config.json",
    ProfilePath = "SENA_v10_profiles.json",

    RarityList = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","Divine","Secret","Eternal"},
}

local RARITY_COLORS = {
    Common = Color3.fromRGB(180,180,180), Uncommon = Color3.fromRGB(90,220,90),
    Rare = Color3.fromRGB(80,150,255), Epic = Color3.fromRGB(190,100,255),
    Legendary = Color3.fromRGB(255,185,60), Mythic = Color3.fromRGB(255,70,130),
    Divine = Color3.fromRGB(255,255,120), Secret = Color3.fromRGB(255,60,255),
    Eternal = Color3.fromRGB(200,255,255),
}

local THEME = {
    bg = Color3.fromRGB(6,8,12), panel = Color3.fromRGB(12,16,22),
    panel2 = Color3.fromRGB(18,24,32), card = Color3.fromRGB(22,28,36),
    cardHover = Color3.fromRGB(30,40,50), accent = Color3.fromRGB(0,255,180),
    accent2 = Color3.fromRGB(0,180,255), danger = Color3.fromRGB(255,70,90),
    warn = Color3.fromRGB(255,180,60), success = Color3.fromRGB(80,255,120),
    text = Color3.fromRGB(220,240,235), textDim = Color3.fromRGB(120,140,150),
    stroke = Color3.fromRGB(0,255,180), knob = Color3.fromRGB(245,255,252),
}

local STATE = {
    Running = true, GUI = nil, ESPGui = nil, ToastGui = nil,
    BaseCFrame = nil, TreadmillCFrame = nil,
    LastSteal = 0, LastHop = 0, LastBaseReturn = 0, SessionStart = tick(),
    EggsStolen = 0, PetsHatched = 0, PetsSold = 0, EggsSold = 0,
    FusesDone = 0, UpgradesDone = 0, Rebirths = 0, PromptsFired = 0,
    AuctionsSniped = 0, BossDodges = 0, KicksBlocked = 0, RemotesBlocked = 0,
    StealHistory = {}, ESPObjects = {}, VisualItems = {},
    CurrentTab = "Main", Logger = {}, ActiveTween = nil,
    EggCache = {}, EggCacheTime = 0, WebhookQueue = {},
    DetectionScore = 0, FPS = 60, Ping = 0, FlyBV = nil,
    BypassInstalled = false,
}

-- ═══════════════════════════════════════════════════════════
-- UTILS
-- ═══════════════════════════════════════════════════════════

local function safeCall(fn, ...)
    local ok, r = pcall(fn, ...)
    return ok and r or nil
end

local function log(msg)
    table.insert(STATE.Logger, string.format("[%s] %s", os.date("%H:%M:%S"), msg))
    if #STATE.Logger > 200 then table.remove(STATE.Logger, 1) end
end

local function getHui()
    local ok, h = pcall(function() return gethui() end)
    if ok and h then return h end
    local ok2, core = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and core then return core end
    return PGui
end

local function notify(text, dur)
    safeCall(function()
        StarterGui:SetCore("SendNotification", { Title = "SENA v10", Text = text, Duration = dur or 3 })
    end)
end

local function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart") or nil
end

local function getHum()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid") or nil
end

local function humanWait()
    if CONFIG.Humanize then task.wait(math.random() * CONFIG.HumanizeJitter) end
end

local function tweenTo(cframe, speed)
    local root = getRoot()
    if not root or not cframe then return false end
    if STATE.ActiveTween then
        pcall(function() STATE.ActiveTween:Cancel() end)
        STATE.ActiveTween = nil
    end
    local dist = (root.Position - cframe.Position).Magnitude
    if dist < 0.5 then root.CFrame = cframe return true end
    local dur = math.max(dist / (speed or CONFIG.TweenSpeed), 0.03)
    local tw = TweenService:Create(root, TweenInfo.new(dur, Enum.EasingStyle.Linear), { CFrame = cframe })
    STATE.ActiveTween = tw
    tw:Play()
    tw.Completed:Wait()
    if STATE.ActiveTween == tw then STATE.ActiveTween = nil end
    return true
end

local function velocityTo(cframe, speed)
    local root = getRoot()
    if not root or not cframe then return false end
    local delta = cframe.Position - root.Position
    local dist = delta.Magnitude
    if dist < 1 then root.CFrame = cframe return true end
    local dur = math.clamp(dist / ((speed or CONFIG.TweenSpeed) * 1.8), 0.03, 0.35)
    root.AssemblyLinearVelocity = delta / dur
    task.wait(dur)
    if root then root.AssemblyLinearVelocity = Vector3.zero end
    return true
end

local function moveTo(cframe, speed)
    if CONFIG.VelocityMove then return velocityTo(cframe, speed) end
    return tweenTo(cframe, speed)
end

local function rarityIndex(r)
    for i, v in ipairs(CONFIG.RarityList) do
        if v:lower() == tostring(r):lower() then return i end
    end
    return 0
end

local function matchesRarity(r, f)
    if not f or f == "All" then return true end
    return rarityIndex(r) >= rarityIndex(f)
end

local fpsFrames, fpsTime = 0, tick()
RunService.RenderStepped:Connect(function()
    fpsFrames = fpsFrames + 1
    if tick() - fpsTime >= 1 then
        STATE.FPS = fpsFrames
        fpsFrames, fpsTime = 0, tick()
    end
end)

task.spawn(function()
    while STATE.Running do
        local ok, v = pcall(function()
            return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        if ok and v then STATE.Ping = math.floor(v) end
        task.wait(2)
    end
end)

-- ═══════════════════════════════════════════════════════════
-- PERSISTENCE
-- ═══════════════════════════════════════════════════════════

local function saveConfig()
    if not CONFIG.AutoSaveConfig or not writefile then return end
    local data = {}
    for k, v in pairs(CONFIG) do
        if type(v) ~= "table" then data[k] = v end
    end
    pcall(writefile, CONFIG.ConfigPath, HttpService:JSONEncode(data))
end

local function loadConfig()
    if not isfile or not readfile or not isfile(CONFIG.ConfigPath) then return end
    local ok, data = pcall(readfile, CONFIG.ConfigPath)
    if not ok then return end
    local ok2, dec = pcall(function() return HttpService:JSONDecode(data) end)
    if not ok2 or type(dec) ~= "table" then return end
    for k, v in pairs(dec) do
        if CONFIG[k] ~= nil and type(CONFIG[k]) ~= "table" then CONFIG[k] = v end
    end
end

local function saveProfile(name)
    if not writefile then return end
    local profiles = {}
    if isfile and isfile(CONFIG.ProfilePath) then
        local ok, raw = pcall(readfile, CONFIG.ProfilePath)
        if ok then
            local ok2, dec = pcall(function() return HttpService:JSONDecode(raw) end)
            if ok2 and type(dec) == "table" then profiles = dec end
        end
    end
    local snap = {}
    for k, v in pairs(CONFIG) do
        if type(v) ~= "table" then snap[k] = v end
    end
    profiles[name] = snap
    pcall(writefile, CONFIG.ProfilePath, HttpService:JSONEncode(profiles))
end

local function loadProfile(name)
    if not isfile or not readfile or not isfile(CONFIG.ProfilePath) then return false end
    local ok, raw = pcall(readfile, CONFIG.ProfilePath)
    if not ok then return false end
    local ok2, dec = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok2 or type(dec) ~= "table" or not dec[name] then return false end
    for k, v in pairs(dec[name]) do
        if CONFIG[k] ~= nil and type(CONFIG[k]) ~= "table" then CONFIG[k] = v end
    end
    return true
end

-- ═══════════════════════════════════════════════════════════
-- BYPASS SUITE
-- ═══════════════════════════════════════════════════════════

local BLOCK_KEYWORDS = {
    "detect","flag","report","suspic","antich","anticheat",
    "hack","cheat","exploit","securitycheck",
}

local function hasBlockedKeyword(s)
    s = tostring(s):lower()
    for _, kw in ipairs(BLOCK_KEYWORDS) do
        if s:find(kw, 1, true) then return true end
    end
    return false
end

local function installBypass()
    if STATE.BypassInstalled then return end
    if not (CONFIG.Bypass or CONFIG.BypassRemote or CONFIG.BypassSimRadius
            or CONFIG.BypassFocus or CONFIG.AntiKick) then return end

    if (CONFIG.BypassSimRadius or CONFIG.Bypass) and sethiddenproperty then
        pcall(function() sethiddenproperty(LP, "SimulationRadius", 0) end)
        log("sim radius hidden")
    end

    if CONFIG.BypassStringScan and getgenv then
        pcall(function()
            local env = getgenv()
            env.fireproximityprompt = env.fireproximityprompt or fireproximityprompt
            env.firetouchinterest = env.firetouchinterest or firetouchinterest
        end)
    end

    local mt = getrawmetatable and getrawmetatable(game)
    if mt and setreadonly then
        pcall(setreadonly, mt, false)
        local oldNC = mt.__namecall
        local wrapper = function(self, ...)
            local method = getnamecallmethod and getnamecallmethod() or ""
            local lower = tostring(self):lower()

            if (method == "Kick" or method == "kick") and CONFIG.AntiKick then
                STATE.KicksBlocked = STATE.KicksBlocked + 1
                if CONFIG.AutoRejoinOnKick then
                    task.spawn(function()
                        task.wait(0.5)
                        pcall(function() TeleportService:Teleport(game.PlaceId, LP) end)
                    end)
                end
                return nil
            end

            if (method == "FireServer" or method == "InvokeServer")
                and (CONFIG.BypassRemote or CONFIG.Bypass) then
                if hasBlockedKeyword(lower) or hasBlockedKeyword(tostring((...))) then
                    STATE.RemotesBlocked = STATE.RemotesBlocked + 1
                    return nil
                end
            end

            return oldNC(self, ...)
        end
        mt.__namecall = (newcclosure and newcclosure(wrapper)) or wrapper
        pcall(setreadonly, mt, true)
    end

    if (CONFIG.BypassFocus or CONFIG.Bypass) and hookmetamethod then
        pcall(function()
            local oldIdx
            oldIdx = hookmetamethod(game, "__index", function(self, key)
                if key == "WindowFocused" and (CONFIG.BypassFocus or CONFIG.Bypass) then
                    return true
                end
                return oldIdx(self, key)
            end)
        end)
    end

    STATE.BypassInstalled = true
end

-- ═══════════════════════════════════════════════════════════
-- SCANNERS
-- ═══════════════════════════════════════════════════════════

local function findEggs(force)
    local now = tick()
    if not force and (now - STATE.EggCacheTime) < 0.15 then return STATE.EggCache end
    local eggs, root = {}, getRoot()
    if not root then return eggs end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local n = obj.Name:lower()
        if n:find("egg") and not n:find("esp") and not n:find("gui") and not n:find("hatch") then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
            if part and part.Position then
                table.insert(eggs, {
                    obj = obj, part = part,
                    rarity = safeCall(function() return obj:GetAttribute("Rarity") end) or "Common",
                    value = safeCall(function() return obj:GetAttribute("Value") end) or 0,
                    mutation = safeCall(function() return obj:GetAttribute("Mutation") end) or "None",
                    distance = (root.Position - part.Position).Magnitude,
                })
            end
        end
    end
    if CONFIG.StealPriority == "Rarest" then
        table.sort(eggs, function(a,b) return rarityIndex(a.rarity) > rarityIndex(b.rarity) end)
    elseif CONFIG.StealPriority == "Nearest" then
        table.sort(eggs, function(a,b) return a.distance < b.distance end)
    elseif CONFIG.StealPriority == "HighestValue" then
        table.sort(eggs, function(a,b) return a.value > b.value end)
    end
    STATE.EggCache = eggs
    STATE.EggCacheTime = now
    return eggs
end

local function findPrompts(kws)
    local list = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local pn = obj.Parent and obj.Parent.Name:lower() or ""
            for _, kw in ipairs(kws) do
                if pn:find(kw) then table.insert(list, obj) break end
            end
        end
    end
    return list
end

local function findBase()
    local strong = {"mybase","myplot","yourbase","playerbase", LP.Name:lower()}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local n = obj.Name:lower()
        for _, kw in ipairs(strong) do
            if kw ~= "" and n:find(kw, 1, true) then
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
                if part and part.Position.Magnitude > 5 then STATE.BaseCFrame = part.CFrame return end
            end
        end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local n = obj.Name:lower()
        if n:find("plot") or n:find("base") then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
            if part and part.Position.Magnitude > 5 then STATE.BaseCFrame = part.CFrame return end
        end
    end
end

local function findTreadmill()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local n = obj.Name:lower()
        if n:find("treadmill") or n:find("tread") then
            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
            if part then STATE.TreadmillCFrame = part.CFrame return end
        end
    end
end

local function returnToBase(force)
    if not force and (tick() - STATE.LastBaseReturn) < 0.7 then return end
    STATE.LastBaseReturn = tick()
    if not STATE.BaseCFrame then findBase() end
    if STATE.BaseCFrame then moveTo(STATE.BaseCFrame, CONFIG.TweenSpeed) end
end

-- ═══════════════════════════════════════════════════════════
-- CORE
-- ═══════════════════════════════════════════════════════════

local function grabEgg(egg)
    if not egg or not egg.part or not egg.part.Parent then return false end
    local root = getRoot()
    if not root then return false end
    humanWait()
    if CONFIG.InstantGrab then
        root.CFrame = egg.part.CFrame + Vector3.new(0,0.3,0)
    else
        moveTo(egg.part.CFrame, CONFIG.StealSpeed)
    end
    task.wait(0.03)
    local burst = math.max(1, CONFIG.MultiFireBurst or 1)
    for i = 1, burst do
        if egg.part and egg.part.Parent then
            local prompt = egg.obj:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then
                pcall(fireproximityprompt, prompt)
                STATE.PromptsFired = STATE.PromptsFired + 1
            else
                pcall(firetouchinterest, root, egg.part, 0)
                task.wait(0.02)
                pcall(firetouchinterest, root, egg.part, 1)
            end
        end
        if i < burst then task.wait(0.02) end
    end
    task.wait(0.02)
    STATE.EggsStolen = STATE.EggsStolen + 1
    STATE.LastSteal = tick()
    table.insert(STATE.StealHistory, {
        time = os.date("%H:%M:%S"), name = egg.obj.Name,
        rarity = egg.rarity, mutation = egg.mutation, value = egg.value,
    })
    if #STATE.StealHistory > 100 then table.remove(STATE.StealHistory, 1) end
    log(string.format("steal %s (%s)", egg.obj.Name, egg.rarity))
    if CONFIG.StealWebhook and CONFIG.WebhookURL ~= "" and matchesRarity(egg.rarity, CONFIG.WebhookMinRarity) then
        local line = string.format("`%s` | %s | %s | %d", egg.obj.Name, egg.rarity, egg.mutation, egg.value)
        if CONFIG.WebhookBatch then table.insert(STATE.WebhookQueue, line)
        else pcall(request, { Url=CONFIG.WebhookURL, Method="POST",
            Headers={["Content-Type"]="application/json"},
            Body=HttpService:JSONEncode({content="**SENA v10** "..line}) }) end
    end
    return true
end

local function firePrompt(p)
    if not p then return false end
    pcall(fireproximityprompt, p)
    STATE.PromptsFired = STATE.PromptsFired + 1
    return true
end

local function clickButtonByNames(patterns)
    local clicked = 0
    for _, gui in ipairs(PGui:GetDescendants()) do
        if gui:IsA("TextButton") or gui:IsA("ImageButton") then
            local txt = ((gui.Text or "").." "..(gui.Name or "")):lower()
            local vis = true
            local p = gui.Parent
            while p and p ~= PGui do
                if p:IsA("GuiObject") and p.Visible == false then vis = false break end
                p = p.Parent
            end
            if vis and gui.Active ~= false then
                for _, pat in ipairs(patterns) do
                    if txt:find(pat,1,true) then
                        pcall(function() gui:Activate() end)
                        clicked = clicked + 1
                        break
                    end
                end
            end
        end
    end
    return clicked
end

-- ═══════════════════════════════════════════════════════════
-- LOOPS
-- ═══════════════════════════════════════════════════════════

local function loopAutoSteal()
    while STATE.Running do
        if CONFIG.AutoSteal then
            local eggs = findEggs()
            if #eggs > 0 then
                grabEgg(eggs[1])
                if CONFIG.BottingMode then returnToBase() end
            elseif CONFIG.HopWhenNothingMatches and CONFIG.AutoHop then
                if tick() - STATE.LastHop > CONFIG.HopCooldown then
                    STATE.LastHop = tick()
                    safeCall(function() TeleportService:Teleport(game.PlaceId, LP) end)
                end
            end
        end
        task.wait(CONFIG.RefreshRate)
    end
end

local function loopAutoPlace()
    while STATE.Running do
        if CONFIG.AutoPlace then
            for _, p in ipairs(findPrompts({"egg","incubator","place"})) do firePrompt(p) end
        end
        task.wait(0.4)
    end
end

local function loopAutoHatch()
    while STATE.Running do
        if CONFIG.AutoHatch then
            for _, p in ipairs(findPrompts({"incubator","hatch"})) do
                if firePrompt(p) then STATE.PetsHatched = STATE.PetsHatched + 1 end
            end
        end
        task.wait(0.8)
    end
end

local function loopAutoSell()
    while STATE.Running do
        if CONFIG.AutoSellEgg then
            if clickButtonByNames({"sell egg","sellegg","sell all egg"}) > 0 then
                STATE.EggsSold = STATE.EggsSold + 1
            end
        end
        if CONFIG.AutoSellPet then
            if clickButtonByNames({"sell pet","sellpet","sell all pet"}) > 0 then
                STATE.PetsSold = STATE.PetsSold + 1
            end
        end
        task.wait(2)
    end
end

local function loopAutoFuse()
    while STATE.Running do
        if CONFIG.AutoFuse then
            if clickButtonByNames({"fuse pet","combine pet","fuse"}) > 0 then
                STATE.FusesDone = STATE.FusesDone + 1
            end
        end
        task.wait(3)
    end
end

local function loopAutoEquip()
    while STATE.Running do
        if CONFIG.AutoEquipBest then clickButtonByNames({"equip best","equipbest","best equip"}) end
        task.wait(5)
    end
end

local function loopAutoClaim()
    while STATE.Running do
        if CONFIG.CollectOffline then clickButtonByNames({"collect offline","offline reward","offline"}) end
        if CONFIG.AutoClaimAlmanac then clickButtonByNames({"claim almanac","almanac"}) end
        task.wait(4)
    end
end

local function loopAutoUpgrade()
    while STATE.Running do
        if CONFIG.AutoUpgradeBase then
            if clickButtonByNames({"upgrade base","upgradebase"}) > 0 then
                STATE.UpgradesDone = STATE.UpgradesDone + 1
            end
        end
        if CONFIG.AutoUpgradeTreadmill then
            if clickButtonByNames({"upgrade treadmill","upgradetread"}) > 0 then
                STATE.UpgradesDone = STATE.UpgradesDone + 1
            end
        end
        task.wait(6)
    end
end

local function loopAutoTreadmill()
    while STATE.Running do
        if CONFIG.AutoTreadmill and not CONFIG.BottingMode and not CONFIG.AutoSteal then
            if not STATE.TreadmillCFrame then findTreadmill() end
            if STATE.TreadmillCFrame then moveTo(STATE.TreadmillCFrame, CONFIG.TweenSpeed) end
        end
        task.wait(1)
    end
end

local function loopAutoQuest()
    while STATE.Running do
        if CONFIG.AutoQuest then clickButtonByNames({"claim quest","quest reward","daily quest"}) end
        task.wait(6)
    end
end

local function loopAutoDaily()
    while STATE.Running do
        if CONFIG.AutoDaily then clickButtonByNames({"daily reward","claim daily","daily login","spin"}) end
        task.wait(10)
    end
end

local function loopAutoRebirth()
    while STATE.Running do
        if CONFIG.AutoRebirth then
            if clickButtonByNames({"rebirth","ascend","prestige"}) > 0 then
                STATE.Rebirths = STATE.Rebirths + 1
            end
        end
        task.wait(15)
    end
end

local function loopAutoEvents()
    while STATE.Running do
        if CONFIG.AutoCatch then clickButtonByNames({"catch","butterfly"}) end
        if CONFIG.AutoTradeUp then clickButtonByNames({"trade up","tradeup"}) end
        if CONFIG.AutoCraftEssence then clickButtonByNames({"craft essence","craft"}) end
        if CONFIG.AutoBuyShop then clickButtonByNames({"buy"}) end
        if CONFIG.AutoTradeIn then clickButtonByNames({"trade in","tradein"}) end
        if CONFIG.AutoFreeReroll then clickButtonByNames({"reroll","free reroll"}) end
        if CONFIG.AutoBoss then
            for _, p in ipairs(findPrompts({"boss","defeat","fight"})) do firePrompt(p) end
        end
        if CONFIG.AutoEggRain then
            for _, p in ipairs(findPrompts({"rain","event","gift"})) do firePrompt(p) end
        end
        if CONFIG.AutoGift then clickButtonByNames({"claim gift","gift"}) end
        task.wait(2)
    end
end

local function loopAuction()
    while STATE.Running do
        if CONFIG.AutoAuctionSnipe then
            for _, gui in ipairs(PGui:GetDescendants()) do
                if gui:IsA("TextButton") then
                    local txt = (gui.Text or ""):lower()
                    if txt:find("bid") or txt:find("buy now") then
                        local parent = gui.Parent
                        local value = 0
                        if parent then
                            for _, lbl in ipairs(parent:GetDescendants()) do
                                if lbl:IsA("TextLabel") then
                                    local num = lbl.Text and tonumber(lbl.Text:match("%d+"))
                                    if num and num > value then value = num end
                                end
                            end
                        end
                        if value >= CONFIG.AuctionMinValue then
                            pcall(function() gui:Activate() end)
                            STATE.AuctionsSniped = STATE.AuctionsSniped + 1
                        end
                    end
                end
            end
        end
        task.wait(1.5)
    end
end

local function loopBossDodge()
    while STATE.Running do
        if CONFIG.BossDodge then
            local root = getRoot()
            if root then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    local n = obj.Name:lower()
                    if n:find("indicator") or n:find("aoe") or n:find("telegraph") then
                        local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
                        if part and (root.Position - part.Position).Magnitude < 12 then
                            local away = (root.Position - part.Position).Unit * 20
                            tweenTo(CFrame.new(root.Position + away), 500)
                            STATE.BossDodges = STATE.BossDodges + 1
                            break
                        end
                    end
                end
            end
        end
        task.wait(0.15)
    end
end

local function loopAntiGuard()
    while STATE.Running do
        if CONFIG.AntiGuardKnockback or CONFIG.AntiHitGuard then
            local char = LP.Character
            if char then
                for _, obj in ipairs(char:GetChildren()) do
                    local n = obj.Name:lower()
                    if (n:find("guard") and (n:find("hit") or n:find("knock") or n:find("stun"))) or n:find("knockback") then
                        pcall(function() obj:Destroy() end)
                    end
                end
                local hum = getHum()
                if hum and CONFIG.AntiTreadmill then
                    if hum.WalkSpeed < 16 then hum.WalkSpeed = 16 end
                    if hum.JumpPower < 50 then hum.JumpPower = 50 end
                end
            end
        end
        task.wait(0.5)
    end
end

local function loopAntiCutscene()
    while STATE.Running do
        if CONFIG.AntiCutscene then
            local cam = Workspace.CurrentCamera
            if cam and cam.CameraType == Enum.CameraType.Scriptable then
                cam.CameraType = Enum.CameraType.Custom
            end
        end
        task.wait(0.2)
    end
end

local function loopNoclip()
    while STATE.Running do
        if CONFIG.Noclip then
            local char = LP.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                end
            end
        end
        task.wait(1)
    end
end

local function loopFly()
    while STATE.Running do
        if CONFIG.Fly then
            local root, hum = getRoot(), getHum()
            if root and hum then
                if not STATE.FlyBV then
                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
                    bv.Velocity = Vector3.zero
                    bv.Parent = root
                    STATE.FlyBV = bv
                    hum.PlatformStand = true
                end
                local dir = Vector3.zero
                local cam = Workspace.CurrentCamera
                if cam then
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
                end
                STATE.FlyBV.Velocity = dir.Magnitude > 0 and dir.Unit * CONFIG.FlySpeed or Vector3.zero
            end
        else
            if STATE.FlyBV then
                pcall(function() STATE.FlyBV:Destroy() end)
                STATE.FlyBV = nil
                local hum = getHum()
                if hum then hum.PlatformStand = false end
            end
        end
        task.wait(0.05)
    end
end

local function loopPerformance()
    while STATE.Running do
        if CONFIG.BoostFPS then
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
        end
        if CONFIG.UncapFPS then
            if CONFIG.AdaptiveFPS and STATE.DetectionScore > CONFIG.DetectionThreshold then
                safeCall(function() setfpscap(60) end)
            else
                safeCall(function() setfpscap(9999) end)
            end
        elseif CONFIG.BoostFPS then
            safeCall(function() setfpscap(CONFIG.FPSBoost) end)
        end
        task.wait(10)
    end
end

local function loopReconnect()
    while STATE.Running do
        if CONFIG.AutoReconnect then
            local alive = pcall(function() return LP.Parent ~= nil end)
            if not alive or not LP.Parent then
                pcall(function() TeleportService:Teleport(game.PlaceId, LP) end)
            end
        end
        task.wait(3)
    end
end

local function loopBotting()
    while STATE.Running do
        if CONFIG.BottingMode and not CONFIG.AutoSteal then returnToBase() end
        task.wait(1)
    end
end

local function loopDetection()
    while STATE.Running do
        if CONFIG.AntiDetection then
            local warns = 0
            for _, obj in ipairs(LP:GetChildren()) do
                local n = obj.Name:lower()
                if n:find("warn") or n:find("kick") or n:find("ban") then warns += 1 end
            end
            if warns > 0 then
                STATE.DetectionScore = math.min(STATE.DetectionScore + warns, 100)
                if STATE.DetectionScore > CONFIG.DetectionThreshold then
                    CONFIG.RefreshRate = math.min(CONFIG.RefreshRate * 1.3, 0.5)
                end
            else
                STATE.DetectionScore = math.max(STATE.DetectionScore - 1, 0)
                if STATE.DetectionScore == 0 and CONFIG.RefreshRate > 0.08 then
                    CONFIG.RefreshRate = math.max(CONFIG.RefreshRate - 0.05, 0.08)
                end
            end
        end
        task.wait(2)
    end
end

local function loopWebhookFlush()
    while STATE.Running do
        if CONFIG.WebhookBatch and #STATE.WebhookQueue > 0 and CONFIG.WebhookURL ~= "" then
            local batch = {}
            local n = math.min(#STATE.WebhookQueue, CONFIG.WebhookBatchSize)
            for i = 1, n do table.insert(batch, table.remove(STATE.WebhookQueue, 1)) end
            pcall(request, {
                Url = CONFIG.WebhookURL, Method = "POST",
                Headers = {["Content-Type"]="application/json"},
                Body = HttpService:JSONEncode({
                    content = "**SENA v10 — Batch ("..n..")**\n"..table.concat(batch,"\n"),
                }),
            })
        end
        task.wait(5)
    end
end

local function loopHeartbeat()
    while STATE.Running do
        if CONFIG.BypassHeartbeat or CONFIG.Bypass then
            safeCall(function()
                LP:SetAttribute("_hb", 0)
                if LP.Character then LP.Character:SetAttribute("_hb", 0) end
            end)
        end
        task.wait(5)
    end
end

-- ═══════════════════════════════════════════════════════════
-- ANTI-AFK / JUMP
-- ═══════════════════════════════════════════════════════════

local function setupAntiAFK()
    LP.Idled:Connect(function()
        if not CONFIG.AntiAFK then return end
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

local function setupInfiniteJump()
    UserInputService.JumpRequest:Connect(function()
        if CONFIG.InfiniteJump then
            local hum = getHum()
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
-- ESP
-- ═══════════════════════════════════════════════════════════

local function buildESP()
    local parent = getHui()
    if STATE.ESPGui then STATE.ESPGui:Destroy() end
    local esp = Instance.new("ScreenGui")
    esp.Name = "SENA_ESP"
    esp.ResetOnSpawn = false
    esp.DisplayOrder = 998
    esp.Parent = parent
    STATE.ESPGui = esp
    task.spawn(function()
        while STATE.Running and esp.Parent do
            local seen, root = {}, getRoot()
            for _, obj in ipairs(Workspace:GetDescendants()) do
                local n = obj.Name:lower()
                local want = (n:find("egg") and CONFIG.EggChecker)
                          or (n:find("butterfly") and CONFIG.ButterflyESP)
                          or n:find("guardian") or n:find("boss")
                if want and not n:find("esp") then
                    local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
                    if part then
                        local key = tostring(obj)
                        seen[key] = true
                        local rar = safeCall(function() return obj:GetAttribute("Rarity") end) or "Common"
                        local dist = root and math.floor((root.Position - part.Position).Magnitude) or 0
                        local label = obj.Name
                        if CONFIG.RarityESP then label = "["..rar.."] "..label end
                        if CONFIG.DistanceESP then label = label.." ("..dist.."m)" end
                        local color = RARITY_COLORS[rar] or THEME.accent
                        if not STATE.ESPObjects[key] then
                            local bb = Instance.new("BillboardGui")
                            bb.Size = UDim2.new(0,140,0,30)
                            bb.StudsOffset = Vector3.new(0,3,0)
                            bb.AlwaysOnTop = true
                            bb.Adornee = part
                            bb.Parent = esp
                            local lbl = Instance.new("TextLabel")
                            lbl.Size = UDim2.new(1,0,1,0)
                            lbl.BackgroundTransparency = 1
                            lbl.TextColor3 = color
                            lbl.Font = Enum.Font.Code
                            lbl.TextSize = 10
                            lbl.TextStrokeTransparency = 0.4
                            lbl.Text = label
                            lbl.Parent = bb
                            STATE.ESPObjects[key] = { billboard = bb, part = part, label = lbl }
                        else
                            local o = STATE.ESPObjects[key]
                            o.billboard.Adornee = part
                            o.label.Text = label
                            o.label.TextColor3 = color
                        end
                    end
                end
            end
            for k, v in pairs(STATE.ESPObjects) do
                if not seen[k] then
                    pcall(function() v.billboard:Destroy() end)
                    STATE.ESPObjects[k] = nil
                end
            end
            task.wait(1)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
-- TOAST
-- ═══════════════════════════════════════════════════════════

local Toast = {}

local function initToast()
    local parent = getHui()
    if STATE.ToastGui then STATE.ToastGui:Destroy() end
    local tg = Instance.new("ScreenGui")
    tg.Name = "SENA_Toast"
    tg.ResetOnSpawn = false
    tg.DisplayOrder = 1000
    tg.Parent = parent
    STATE.ToastGui = tg
end

function Toast.show(text, kind)
    if not STATE.ToastGui then return end
    local color = THEME.accent
    if kind == "off" then color = THEME.danger end
    if kind == "warn" then color = THEME.warn end
    if kind == "success" then color = THEME.success end

    local t = Instance.new("Frame")
    t.Size = UDim2.new(0, 260, 0, 46)
    t.Position = UDim2.new(1, 20, 1, -60)
    t.BackgroundColor3 = THEME.panel
    t.BorderSizePixel = 0
    t.Parent = STATE.ToastGui
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = t
    local s = Instance.new("UIStroke"); s.Color = color; s.Thickness = 1.5; s.Parent = t

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.BackgroundColor3 = color
    bar.BorderSizePixel = 0
    bar.Parent = t
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 4); bc.Parent = bar

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = THEME.text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.Parent = t

    TweenService:Create(t, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
        Position = UDim2.new(1, -280, 1, -60)
    }):Play()

    task.spawn(function()
        task.wait(2.5)
        if t.Parent then
            TweenService:Create(t, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Position = UDim2.new(1, 20, 1, -60)
            }):Play()
            task.wait(0.3)
            t:Destroy()
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
-- UI BUILDERS
-- ═══════════════════════════════════════════════════════════

local function makeCorner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 6); c.Parent = p; return c
end

local function makeStroke(p, color, thick)
    local s = Instance.new("UIStroke")
    s.Color = color or THEME.stroke; s.Thickness = thick or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = p; return s
end

local function makeGradient(p, c1, c2, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c1, c2); g.Rotation = rot or 0; g.Parent = p; return g
end

local function makePadding(p, t, b, l, r)
    local pl = Instance.new("UIPadding")
    pl.PaddingTop = UDim.new(0, t or 0); pl.PaddingBottom = UDim.new(0, b or 0)
    pl.PaddingLeft = UDim.new(0, l or 0); pl.PaddingRight = UDim.new(0, r or 0)
    pl.Parent = p; return pl
end

local buildToggleSwitch

local function buildGUI()
    local parent = getHui()
    local old = parent:FindFirstChild("SENA_Main")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "SENA_Main"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = parent
    STATE.GUI = gui

    -- WINDOW
    local main = Instance.new("Frame")
    main.Name = "Window"
    main.Size = UDim2.new(0, 810, 0, 550)
    main.Position = UDim2.new(0.5, -405, 0.5, -275)
    main.BackgroundColor3 = THEME.bg
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.ClipsDescendants = true
    main.Parent = gui
    makeCorner(main, 14)
    makeStroke(main, Color3.fromRGB(0,200,140), 1.5)
    makeGradient(main, Color3.fromRGB(8,10,14), Color3.fromRGB(4,6,10), 90)

    -- BACKGROUND PATTERN
    local bgPattern = Instance.new("ImageLabel")
    bgPattern.Name = "BgPattern"
    bgPattern.Size = UDim2.new(1, 0, 1, 0)
    bgPattern.BackgroundTransparency = 1
    bgPattern.Image = ICONS.Pattern.image
    bgPattern.ImageTransparency = 0.95
    bgPattern.ScaleType = Enum.ScaleType.Tile
    bgPattern.TileSize = UDim2.new(0, 120, 0, 120)
    bgPattern.ZIndex = 0
    bgPattern.Parent = main

    -- TITLEBAR
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 62)
    titleBar.BackgroundColor3 = THEME.panel
    titleBar.BorderSizePixel = 0
    titleBar.Parent = main
    makeCorner(titleBar, 14)
    makeGradient(titleBar, Color3.fromRGB(0,95,75), Color3.fromRGB(0,60,110), 0)

    local mask = Instance.new("Frame")
    mask.Size = UDim2.new(1,0,0,12)
    mask.Position = UDim2.new(0,0,1,-12)
    mask.BackgroundColor3 = THEME.panel
    mask.BorderSizePixel = 0
    mask.Parent = titleBar
    makeGradient(mask, Color3.fromRGB(0,72,98), Color3.fromRGB(0,60,110), 0)

    -- LOGO (image + glyph fallback)
    local logo = Instance.new("Frame")
    logo.Size = UDim2.new(0, 44, 0, 44)
    logo.Position = UDim2.new(0, 14, 0.5, -22)
    logo.BackgroundColor3 = THEME.bg
    logo.Parent = titleBar
    makeCorner(logo, 10)
    makeStroke(logo, THEME.accent, 1.5)

    local logoImg = Instance.new("ImageLabel")
    logoImg.Size = UDim2.new(1, -8, 1, -8)
    logoImg.Position = UDim2.new(0, 4, 0, 4)
    logoImg.BackgroundTransparency = 1
    logoImg.Image = ICONS.Logo.image
    logoImg.ImageColor3 = Color3.fromRGB(255,255,255) -- Biar warna asli gambar lu keluar
    logoImg.ScaleType = Enum.ScaleType.Crop -- Crop biar penuh
    logoImg.Parent = logo

    local logoGlyph = Instance.new("TextLabel")
    logoGlyph.Size = UDim2.new(1,0,1,0)
    logoGlyph.BackgroundTransparency = 1
    logoGlyph.Text = ICONS.Logo.glyph
    logoGlyph.TextColor3 = THEME.accent
    logoGlyph.Font = Enum.Font.GothamBold
    logoGlyph.TextSize = 26
    logoGlyph.Parent = logo

    task.spawn(function()
        task.wait(2.5)
        if logoImg.IsLoaded then
            logoGlyph.Visible = false
        else
            logoImg.Visible = false
        end
    end)

    -- TITLE TEXT
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -330, 0, 24)
    titleLbl.Position = UDim2.new(0, 66, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "SENA VISION"
    titleLbl.TextColor3 = THEME.accent
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 18
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = titleBar

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -330, 0, 18)
    subLbl.Position = UDim2.new(0, 66, 0, 36)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = "v10.2 • IMAGE UI • STEAL AN EGG 2026"
    subLbl.TextColor3 = THEME.textDim
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextSize = 10
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.Parent = titleBar

    -- STATUS DOT
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.Position = UDim2.new(1, -210, 0.5, -5)
    dot.BackgroundColor3 = THEME.warn
    dot.Parent = titleBar
    makeCorner(dot, 5)
    task.spawn(function()
        local t = 0
        while dot.Parent do
            t = t + 0.05
            local s = 10 + math.sin(t) * 2
            dot.Size = UDim2.new(0, s, 0, s)
            dot.Position = UDim2.new(1, -210 + (10-s)/2, 0.5, -s/2)
            task.wait(0.05)
        end
    end)

    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(0, 120, 0, 20)
    statusLbl.Position = UDim2.new(1, -195, 0.5, -10)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = "STANDBY"
    statusLbl.TextColor3 = THEME.warn
    statusLbl.Font = Enum.Font.GothamBold
    statusLbl.TextSize = 11
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.Parent = titleBar

    -- MIN BUTTON
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -88, 0.5, -15)
    minBtn.BackgroundColor3 = Color3.fromRGB(60,50,20)
    minBtn.Text = ""
    minBtn.AutoButtonColor = false
    minBtn.Parent = titleBar
    makeCorner(minBtn, 6)

    local minImg = Instance.new("ImageLabel")
    minImg.Size = UDim2.new(0, 14, 0, 14)
    minImg.Position = UDim2.new(0.5, -7, 0.5, -7)
    minImg.BackgroundTransparency = 1
    minImg.Image = ICONS.Minimize.image
    minImg.ImageColor3 = THEME.warn
    minImg.ScaleType = Enum.ScaleType.Fit
    minImg.Parent = minBtn

    local minGlyph = Instance.new("TextLabel")
    minGlyph.Size = UDim2.new(1,0,1,0)
    minGlyph.BackgroundTransparency = 1
    minGlyph.Text = ICONS.Minimize.glyph
    minGlyph.TextColor3 = THEME.warn
    minGlyph.Font = Enum.Font.GothamBold
    minGlyph.TextSize = 14
    minGlyph.Parent = minBtn

    task.spawn(function()
        task.wait(2.5)
        if minImg.IsLoaded then minGlyph.Visible = false else minImg.Visible = false end
    end)

    -- CLOSE BUTTON
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -52, 0.5, -15)
    closeBtn.BackgroundColor3 = Color3.fromRGB(90,25,30)
    closeBtn.Text = ""
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = titleBar
    makeCorner(closeBtn, 6)

    local closeImg = Instance.new("ImageLabel")
    closeImg.Size = UDim2.new(0, 14, 0, 14)
    closeImg.Position = UDim2.new(0.5, -7, 0.5, -7)
    closeImg.BackgroundTransparency = 1
    closeImg.Image = ICONS.Close.image
    closeImg.ImageColor3 = THEME.danger
    closeImg.ScaleType = Enum.ScaleType.Fit
    closeImg.Parent = closeBtn

    local closeGlyph = Instance.new("TextLabel")
    closeGlyph.Size = UDim2.new(1,0,1,0)
    closeGlyph.BackgroundTransparency = 1
    closeGlyph.Text = ICONS.Close.glyph
    closeGlyph.TextColor3 = THEME.danger
    closeGlyph.Font = Enum.Font.GothamBold
    closeGlyph.TextSize = 13
    closeGlyph.Parent = closeBtn

    task.spawn(function()
        task.wait(2.5)
        if closeImg.IsLoaded then closeGlyph.Visible = false else closeImg.Visible = false end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        STATE.Running = false
        saveConfig()
        gui:Destroy()
    end)

    -- SIDEBAR
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 180, 1, -134)
    sidebar.Position = UDim2.new(0, 12, 0, 74)
    sidebar.BackgroundColor3 = THEME.panel
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main
    makeCorner(sidebar, 10)
    makeStroke(sidebar, Color3.fromRGB(40,60,60), 1)
    local sideLayout = Instance.new("UIListLayout")
    sideLayout.Padding = UDim.new(0, 3)
    sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sideLayout.Parent = sidebar
    makePadding(sidebar, 8, 8, 6, 6)

    -- CONTENT WRAP
    local contentWrap = Instance.new("Frame")
    contentWrap.Size = UDim2.new(1, -216, 1, -134)
    contentWrap.Position = UDim2.new(0, 204, 0, 74)
    contentWrap.BackgroundColor3 = THEME.panel
    contentWrap.BorderSizePixel = 0
    contentWrap.Parent = main
    makeCorner(contentWrap, 10)
    makeStroke(contentWrap, Color3.fromRGB(40,60,60), 1)

    -- SEARCH
    local searchWrap = Instance.new("Frame")
    searchWrap.Size = UDim2.new(1, -20, 0, 36)
    searchWrap.Position = UDim2.new(0, 10, 0, 10)
    searchWrap.BackgroundColor3 = THEME.card
    searchWrap.BorderSizePixel = 0
    searchWrap.Parent = contentWrap
    makeCorner(searchWrap, 8)
    makeStroke(searchWrap, Color3.fromRGB(40,55,60), 1)

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -20, 1, 0)
    searchBox.Position = UDim2.new(0, 12, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Text = ""
    searchBox.PlaceholderText = "search toggles..."
    searchBox.PlaceholderColor3 = THEME.textDim
    searchBox.TextColor3 = THEME.text
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 12
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = searchWrap

    -- CONTENT SCROLL
    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Size = UDim2.new(1, -16, 1, -62)
    contentScroll.Position = UDim2.new(0, 8, 0, 54)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.ScrollBarThickness = 4
    contentScroll.ScrollBarImageColor3 = THEME.accent
    contentScroll.CanvasSize = UDim2.new(0,0,0,0)
    contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentScroll.Parent = contentWrap

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 5)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = contentScroll

    -- FOOTER
    local footer = Instance.new("Frame")
    footer.Size = UDim2.new(1, -24, 0, 46)
    footer.Position = UDim2.new(0, 12, 1, -58)
    footer.BackgroundColor3 = THEME.panel
    footer.BorderSizePixel = 0
    footer.Parent = main
    makeCorner(footer, 10)
    makeStroke(footer, Color3.fromRGB(40,60,60), 1)

    local statsLbl = Instance.new("TextLabel")
    statsLbl.Size = UDim2.new(1, -20, 1, 0)
    statsLbl.Position = UDim2.new(0, 12, 0, 0)
    statsLbl.BackgroundTransparency = 1
    statsLbl.Text = "idle"
    statsLbl.TextColor3 = THEME.textDim
    statsLbl.Font = Enum.Font.Code
    statsLbl.TextSize = 11
    statsLbl.TextXAlignment = Enum.TextXAlignment.Left
    statsLbl.Parent = footer

    -- TABS
    local tabButtons = {}
    local tabs = {
        { id="Main", label="Main" },
        { id="Steal", label="Steal" },
        { id="Auto", label="Auto" },
        { id="Pets", label="Pets" },
        { id="Events", label="Events" },
        { id="Players", label="Players" },
        { id="Bypass", label="Bypass" },
        { id="Misc", label="Misc" },
        { id="Visual", label="Visual" },
        { id="Profile", label="Profile" },
        { id="Log", label="Log" },
    }

    local function clearContent()
        for _, c in ipairs(contentScroll:GetChildren()) do
            if c:IsA("TextButton") or c:IsA("TextLabel") or c:IsA("Frame") then c:Destroy() end
        end
    end

    local function addSection(t)
        local wrap = Instance.new("Frame")
        wrap.Size = UDim2.new(1, 0, 0, 26)
        wrap.BackgroundTransparency = 1
        wrap.Parent = contentScroll
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = "▸ " .. t
        l.TextColor3 = THEME.accent
        l.Font = Enum.Font.GothamBold
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = wrap
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.new(0, 0, 1, -1)
        line.BackgroundColor3 = Color3.fromRGB(0,80,60)
        line.BorderSizePixel = 0
        line.Parent = wrap
        makeGradient(line, THEME.accent, Color3.fromRGB(0,80,60), 0)
    end

    buildToggleSwitch = function(name, key)
        local card = Instance.new("TextButton")
        card.Size = UDim2.new(1, 0, 0, 42)
        card.BackgroundColor3 = CONFIG[key] and Color3.fromRGB(0,50,38) or THEME.card
        card.BorderSizePixel = 0
        card.Text = ""
        card.AutoButtonColor = false
        card:SetAttribute("ToggleKey", key)
        card:SetAttribute("ToggleName", name:lower())
        card.Parent = contentScroll
        makeCorner(card, 8)
        local stroke = makeStroke(card, CONFIG[key] and THEME.accent or Color3.fromRGB(38,48,55), 1)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -90, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = name
        lbl.TextColor3 = THEME.text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = card

        local pill = Instance.new("Frame")
        pill.Size = UDim2.new(0, 40, 0, 20)
        pill.Position = UDim2.new(1, -54, 0.5, -10)
        pill.BackgroundColor3 = CONFIG[key] and THEME.accent or Color3.fromRGB(45,55,60)
        pill.BorderSizePixel = 0
        pill.Parent = card
        makeCorner(pill, 10)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 16, 0, 16)
        knob.Position = CONFIG[key] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        knob.BackgroundColor3 = THEME.knob
        knob.BorderSizePixel = 0
        knob.Parent = pill
        makeCorner(knob, 8)

        card.MouseEnter:Connect(function()
            if not CONFIG[key] then
                TweenService:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = THEME.cardHover}):Play()
            end
        end)
        card.MouseLeave:Connect(function()
            if not CONFIG[key] then
                TweenService:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = THEME.card}):Play()
            end
        end)

        card.MouseButton1Click:Connect(function()
            CONFIG[key] = not CONFIG[key]
            local on = CONFIG[key]
            TweenService:Create(card, TweenInfo.new(0.2), {
                BackgroundColor3 = on and Color3.fromRGB(0,50,38) or THEME.card
            }):Play()
            TweenService:Create(pill, TweenInfo.new(0.2), {
                BackgroundColor3 = on and THEME.accent or Color3.fromRGB(45,55,60)
            }):Play()
            TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Position = on and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            }):Play()
            stroke.Color = on and THEME.accent or Color3.fromRGB(38,48,55)
            Toast.show(name .. " " .. (on and "ENABLED" or "DISABLED"), on and "on" or "off")
            if on and (key:find("Bypass") or key == "AntiKick") then installBypass() end
            saveConfig()
        end)
    end

    local function addButton(text, cb, danger)
        local card = Instance.new("TextButton")
        card.Size = UDim2.new(1, 0, 0, 36)
        card.BackgroundColor3 = THEME.card
        card.BorderSizePixel = 0
        card.Text = ""
        card.AutoButtonColor = false
        card:SetAttribute("ToggleName", text:lower())
        card.Parent = contentScroll
        makeCorner(card, 8)
        makeStroke(card, danger and THEME.danger or Color3.fromRGB(38,48,55), 1)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -20, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = danger and THEME.danger or THEME.text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = card
        card.MouseEnter:Connect(function()
            TweenService:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = THEME.cardHover}):Play()
        end)
        card.MouseLeave:Connect(function()
            TweenService:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = THEME.card}):Play()
        end)
        card.MouseButton1Click:Connect(function() safeCall(cb) end)
    end

    local function addInfo(text)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 0, 24)
        l.BackgroundColor3 = THEME.card
        l.Text = "  " .. text
        l.TextColor3 = THEME.textDim
        l.Font = Enum.Font.Code
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = contentScroll
        makeCorner(l, 6)
    end

    local renderTab
    local function applySearch()
        local q = (searchBox.Text or ""):lower()
        for _, c in ipairs(contentScroll:GetChildren()) do
            if c:IsA("TextButton") then
                local tn = c:GetAttribute("ToggleName") or ""
                c.Visible = (q == "" or tn:find(q, 1, true) ~= nil)
            end
        end
    end
    searchBox:GetPropertyChangedSignal("Text"):Connect(applySearch)

    renderTab = function(name)
        clearContent()
        for _, b in ipairs(tabButtons) do
            local isActive = b:GetAttribute("TabId") == name
            TweenService:Create(b, TweenInfo.new(0.15), {
                BackgroundColor3 = isActive and Color3.fromRGB(0,70,55) or THEME.panel2
            }):Play()
            local lbl = b:FindFirstChildOfClass("TextLabel")
            if lbl then lbl.TextColor3 = isActive and THEME.accent or THEME.textDim end
            local ic = b:FindFirstChild("Icon")
            if ic then
                ic.ImageColor3 = isActive and THEME.accent or THEME.textDim
            end
            local gl = b:FindFirstChild("IconGlyph")
            if gl then
                gl.TextColor3 = isActive and THEME.accent or THEME.textDim
            end
        end

        if name == "Main" then
            addSection("QUICK ACTIONS")
            buildToggleSwitch("Auto Steal", "AutoSteal")
            buildToggleSwitch("Auto Hatch", "AutoHatch")
            buildToggleSwitch("Auto Sell Egg", "AutoSellEgg")
            buildToggleSwitch("Auto Fuse", "AutoFuse")
            buildToggleSwitch("Botting Mode", "BottingMode")
            addSection("SAFETY")
            buildToggleSwitch("Anti Kick", "AntiKick")
            buildToggleSwitch("Anti Crash", "AntiCrash")
            buildToggleSwitch("Anti AFK", "AntiAFK")
            addSection("SERVER")
            buildToggleSwitch("Auto Hop", "AutoHop")
            buildToggleSwitch("Auto Reconnect", "AutoReconnect")
            buildToggleSwitch("Auto Rejoin on Kick", "AutoRejoinOnKick")
            addButton("Force Rejoin Server", function()
                TeleportService:Teleport(game.PlaceId, LP)
            end, true)
        elseif name == "Steal" then
            addSection("STEAL ENGINE")
            buildToggleSwitch("Auto Steal", "AutoSteal")
            buildToggleSwitch("Instant Grab", "InstantGrab")
            buildToggleSwitch("Velocity Move", "VelocityMove")
            buildToggleSwitch("Humanize", "Humanize")
            buildToggleSwitch("Spawn Predictor", "SpawnPredictor")
            addSection("PRIORITY")
            addButton("Priority: " .. CONFIG.StealPriority, function()
                local l = {"Rarest","Nearest","HighestValue"}
                for i, v in ipairs(l) do
                    if v == CONFIG.StealPriority then CONFIG.StealPriority = l[(i%#l)+1] break end
                end
                renderTab("Steal")
            end)
            addButton("Speed: " .. CONFIG.StealSpeed, function()
                CONFIG.StealSpeed = CONFIG.StealSpeed >= 300 and 120 or (CONFIG.StealSpeed + 60)
                renderTab("Steal")
            end)
            addButton("Burst: " .. CONFIG.MultiFireBurst, function()
                CONFIG.MultiFireBurst = (CONFIG.MultiFireBurst % 5) + 1
                renderTab("Steal")
            end)
            addSection("ANTI-GUARD")
            buildToggleSwitch("Anti Guard Knockback", "AntiGuardKnockback")
            buildToggleSwitch("Anti Hit Guard", "AntiHitGuard")
            buildToggleSwitch("Anti Treadmill", "AntiTreadmill")
        elseif name == "Auto" then
            addSection("BASE")
            buildToggleSwitch("Auto Place", "AutoPlace")
            buildToggleSwitch("Auto Hatch", "AutoHatch")
            buildToggleSwitch("Auto Sell Egg", "AutoSellEgg")
            buildToggleSwitch("Auto Sell Pet", "AutoSellPet")
            buildToggleSwitch("Auto Fuse", "AutoFuse")
            buildToggleSwitch("Auto Equip Best", "AutoEquipBest")
            addSection("GRIND")
            buildToggleSwitch("Auto Quest", "AutoQuest")
            buildToggleSwitch("Auto Daily", "AutoDaily")
            buildToggleSwitch("Auto Rebirth", "AutoRebirth")
            buildToggleSwitch("Auto Upgrade Base", "AutoUpgradeBase")
            buildToggleSwitch("Auto Upgrade Treadmill", "AutoUpgradeTreadmill")
            buildToggleSwitch("Collect Offline", "CollectOffline")
            buildToggleSwitch("Auto Claim Almanac", "AutoClaimAlmanac")
        elseif name == "Pets" then
            addSection("PET MANAGEMENT")
            buildToggleSwitch("Auto Equip Best", "AutoEquipBest")
            buildToggleSwitch("Auto Fuse", "AutoFuse")
            buildToggleSwitch("Auto Sell Pet", "AutoSellPet")
            addSection("UPGRADE")
            buildToggleSwitch("Auto Upgrade Base", "AutoUpgradeBase")
            buildToggleSwitch("Auto Upgrade Treadmill", "AutoUpgradeTreadmill")
        elseif name == "Events" then
            addSection("EVENTS")
            buildToggleSwitch("Auto Catch", "AutoCatch")
            buildToggleSwitch("Butterfly ESP", "ButterflyESP")
            buildToggleSwitch("Auto Trade Up", "AutoTradeUp")
            buildToggleSwitch("Auto Craft Essence", "AutoCraftEssence")
            buildToggleSwitch("Auto Buy Shop", "AutoBuyShop")
            buildToggleSwitch("Auto Trade-In", "AutoTradeIn")
            buildToggleSwitch("Auto Free Reroll", "AutoFreeReroll")
            buildToggleSwitch("Auto Boss", "AutoBoss")
            buildToggleSwitch("Boss Dodge", "BossDodge")
            buildToggleSwitch("Auto Egg Rain", "AutoEggRain")
            buildToggleSwitch("Auto Gift", "AutoGift")
            addSection("AUCTION")
            buildToggleSwitch("Auction Sniper", "AutoAuctionSnipe")
            addButton("Min Value: " .. CONFIG.AuctionMinValue, function()
                local l = {1000,2500,5000,10000,25000,50000,100000}
                for i, v in ipairs(l) do
                    if v == CONFIG.AuctionMinValue then CONFIG.AuctionMinValue = l[(i%#l)+1] break end
                end
                renderTab("Events")
            end)
        elseif name == "Players" then
            addSection("PLAYER STEAL")
            buildToggleSwitch("Auto Steal From Players", "AutoStealFromPlayers")
            addSection("HISTORY ("..#STATE.StealHistory..")")
            for i = math.max(1, #STATE.StealHistory - 15), #STATE.StealHistory do
                local h = STATE.StealHistory[i]
                if h then addInfo(string.format("[%s] %s (%s)", h.time, h.name, h.rarity)) end
            end
        elseif name == "Bypass" then
            addSection("ANTI-CHEAT BYPASS")
            buildToggleSwitch("Bypass Master", "Bypass")
            buildToggleSwitch("Bypass Remote Filter", "BypassRemote")
            buildToggleSwitch("Bypass Sim Radius", "BypassSimRadius")
            buildToggleSwitch("Bypass Focus Check", "BypassFocus")
            buildToggleSwitch("Bypass Heartbeat", "BypassHeartbeat")
            buildToggleSwitch("Bypass String Scan", "BypassStringScan")
            addSection("PROTECTION")
            buildToggleSwitch("Anti Kick", "AntiKick")
            buildToggleSwitch("Anti Ban", "AntiBan")
            buildToggleSwitch("Anti Crash", "AntiCrash")
            buildToggleSwitch("Anti Log", "AntiLog")
            buildToggleSwitch("Anti Detection", "AntiDetection")
            buildToggleSwitch("Anti Teleport Trap", "AntiTeleport")
            addSection("STATS")
            addInfo("Kicks Blocked: " .. STATE.KicksBlocked)
            addInfo("Remotes Blocked: " .. STATE.RemotesBlocked)
            addInfo("Detection: " .. math.floor(STATE.DetectionScore) .. "%")
            addInfo("Hook Installed: " .. tostring(STATE.BypassInstalled))
            addButton("Force Install Bypass", function()
                installBypass()
                Toast.show("Bypass re-installed", "success")
                renderTab("Bypass")
            end)
        elseif name == "Misc" then
            addSection("PERFORMANCE")
            buildToggleSwitch("Boost FPS", "BoostFPS")
            buildToggleSwitch("Uncap FPS", "UncapFPS")
            buildToggleSwitch("Adaptive FPS", "AdaptiveFPS")
            buildToggleSwitch("Anti Cutscene", "AntiCutscene")
            addSection("MOVEMENT")
            buildToggleSwitch("Noclip", "Noclip")
            buildToggleSwitch("Infinite Jump", "InfiniteJump")
            buildToggleSwitch("Fly", "Fly")
            addButton("Fly Speed: " .. CONFIG.FlySpeed, function()
                CONFIG.FlySpeed = CONFIG.FlySpeed >= 200 and 50 or (CONFIG.FlySpeed + 30)
                renderTab("Misc")
            end)
            addSection("CONFIG")
            addButton("Save Config", saveConfig)
            addButton("Load Config", loadConfig)
            addButton("Reset to Defaults", function()
                CONFIG.RefreshRate = 0.08
                CONFIG.StealSpeed = 250
                CONFIG.MultiFireBurst = 3
            end)
        elseif name == "Visual" then
            addSection("ESP")
            buildToggleSwitch("Egg Checker", "EggChecker")
            buildToggleSwitch("Rarity ESP", "RarityESP")
            buildToggleSwitch("Distance ESP", "DistanceESP")
            buildToggleSwitch("Butterfly ESP", "ButterflyESP")
            addSection("VISUAL")
            addButton("Spawn Visual Egg", function()
                local p = Instance.new("Part")
                p.Shape = Enum.PartType.Ball
                p.Size = Vector3.new(2,3,2)
                p.Color = THEME.accent
                p.Material = Enum.Material.Neon
                p.Anchored = true
                local r = getRoot()
                if r then p.CFrame = r.CFrame * CFrame.new(0,0,-5) end
                p.Parent = Workspace
                table.insert(STATE.VisualItems, p)
            end)
            addButton("Clear Visuals", function()
                for _, v in ipairs(STATE.VisualItems) do safeCall(function() v:Destroy() end) end
                STATE.VisualItems = {}
            end)
        elseif name == "Profile" then
            addSection("SAVE PROFILE")
            addButton("Save as 'farm'", function()
                saveProfile("farm")
                Toast.show("Profile 'farm' saved", "success")
            end)
            addButton("Save as 'safe'", function()
                saveProfile("safe")
                Toast.show("Profile 'safe' saved", "success")
            end)
            addButton("Save as 'aggressive'", function()
                saveProfile("aggressive")
                Toast.show("Profile 'aggressive' saved", "success")
            end)
            addSection("LOAD PROFILE")
            addButton("Load 'farm'", function()
                if loadProfile("farm") then
                    Toast.show("Profile 'farm' loaded", "success")
                    renderTab("Profile")
                else
                    Toast.show("Profile 'farm' not found", "warn")
                end
            end)
            addButton("Load 'safe'", function()
                if loadProfile("safe") then
                    Toast.show("Profile 'safe' loaded", "success")
                    renderTab("Profile")
                else
                    Toast.show("Profile 'safe' not found", "warn")
                end
            end)
            addButton("Load 'aggressive'", function()
                if loadProfile("aggressive") then
                    Toast.show("Profile 'aggressive' loaded", "success")
                    renderTab("Profile")
                else
                    Toast.show("Profile 'aggressive' not found", "warn")
                end
            end)
        elseif name == "Log" then
            addSection("EVENT LOG")
            for i = #STATE.Logger, math.max(1, #STATE.Logger - 30), -1 do
                addInfo(STATE.Logger[i])
            end
        end

        applySearch()
    end

    -- BUILD SIDEBAR TABS WITH IMAGE ICONS
    for _, tab in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Name = "Tab_" .. tab.id
        btn:SetAttribute("TabId", tab.id)
        btn.Size = UDim2.new(1, 0, 0, 42)
        btn.BackgroundColor3 = THEME.panel2
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Parent = sidebar
        makeCorner(btn, 7)

        local iconData = ICONS[tab.id] or { image = "", glyph = "•" }

        -- IMAGE ICON
        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 22, 0, 22)
        icon.Position = UDim2.new(0, 12, 0.5, -11)
        icon.BackgroundTransparency = 1
        icon.Image = iconData.image or ""
        icon.ImageColor3 = THEME.textDim
        icon.ScaleType = Enum.ScaleType.Fit
        icon.Parent = btn

        -- GLYPH FALLBACK
        local iconGlyph = Instance.new("TextLabel")
        iconGlyph.Name = "IconGlyph"
        iconGlyph.Size = UDim2.new(0, 22, 0, 22)
        iconGlyph.Position = UDim2.new(0, 12, 0.5, -11)
        iconGlyph.BackgroundTransparency = 1
        iconGlyph.Text = iconData.glyph or "•"
        iconGlyph.TextColor3 = THEME.textDim
        iconGlyph.Font = Enum.Font.GothamBold
        iconGlyph.TextSize = 15
        iconGlyph.Parent = btn

        task.spawn(function()
            task.wait(2.5)
            if icon.IsLoaded then iconGlyph.Visible = false else icon.Visible = false end
        end)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -50, 1, 0)
        lbl.Position = UDim2.new(0, 44, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = tab.label
        lbl.TextColor3 = THEME.textDim
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = btn

        btn.MouseEnter:Connect(function()
            if btn:GetAttribute("TabId") ~= STATE.CurrentTab then
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = THEME.cardHover}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if btn:GetAttribute("TabId") ~= STATE.CurrentTab then
                TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = THEME.panel2}):Play()
            end
        end)
        btn.MouseButton1Click:Connect(function()
            STATE.CurrentTab = tab.id
            renderTab(tab.id)
        end)
        table.insert(tabButtons, btn)
    end

    renderTab("Main")

    local minimized = false
    local savedSize = main.Size
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            savedSize = main.Size
            TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 810, 0, 62)
            }):Play()
            sidebar.Visible = false; contentWrap.Visible = false; footer.Visible = false
        else
            TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Size = savedSize
            }):Play()
            sidebar.Visible = true; contentWrap.Visible = true; footer.Visible = true
        end
    end)

    task.spawn(function()
        while STATE.GUI and STATE.GUI.Parent do
            local up = math.floor(tick() - STATE.SessionStart)
            local anyOn = false
            for k, v in pairs(CONFIG) do
                if type(v) == "boolean" and v and k ~= "AutoSaveConfig" then anyOn = true break end
            end
            if anyOn then
                statusLbl.Text = "ACTIVE"
                statusLbl.TextColor3 = THEME.accent
                dot.BackgroundColor3 = THEME.accent
            else
                statusLbl.Text = "STANDBY"
                statusLbl.TextColor3 = THEME.warn
                dot.BackgroundColor3 = THEME.warn
            end
            statsLbl.Text = string.format(
                "up %ds  |  %dfps  |  %dms  |  %d stolen  |  %d sold  |  %d hatch  |  %d kicks  |  %d remotes  |  det %d%%",
                up, STATE.FPS, STATE.Ping, STATE.EggsStolen, STATE.EggsSold,
                STATE.PetsHatched, STATE.KicksBlocked, STATE.RemotesBlocked, math.floor(STATE.DetectionScore)
            )
            task.wait(1)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
-- INIT
-- ═══════════════════════════════════════════════════════════

local function init()
    loadConfig()
    findBase()
    findTreadmill()
    initToast()
    setupAntiAFK()
    setupInfiniteJump()
    buildESP()
    buildGUI()
    notify("ZUTAXZ v1 Vision loaded — all toggles OFF.")

    task.spawn(loopAutoSteal)
    task.spawn(loopAutoPlace)
    task.spawn(loopAutoHatch)
    task.spawn(loopAutoSell)
    task.spawn(loopAutoFuse)
    task.spawn(loopAutoEquip)
    task.spawn(loopAutoClaim)
    task.spawn(loopAutoUpgrade)
    task.spawn(loopAutoTreadmill)
    task.spawn(loopAutoQuest)
    task.spawn(loopAutoDaily)
    task.spawn(loopAutoRebirth)
    task.spawn(loopAutoEvents)
    task.spawn(loopAuction)
    task.spawn(loopBossDodge)
    task.spawn(loopAntiGuard)
    task.spawn(loopAntiCutscene)
    task.spawn(loopNoclip)
    task.spawn(loopFly)
    task.spawn(loopPerformance)
    task.spawn(loopReconnect)
    task.spawn(loopBotting)
    task.spawn(loopDetection)
    task.spawn(loopWebhookFlush)
    task.spawn(loopHeartbeat)

    LP.CharacterAdded:Connect(function()
        task.wait(1.5)
        findBase()
        if CONFIG.BottingMode then returnToBase(true) end
    end)

    log("v1 Vision initialized")
    saveConfig()
end

init()
