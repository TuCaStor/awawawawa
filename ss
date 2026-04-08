-- // ============================================================================== //
-- // 🌟 UNIVERSAL OMNI-COMPATIBILITY SUITE (POTASSIUM ULTIMATE UPDATE) 🌟
-- // Atualizado com: OTH Lib, RakNet Lib, Regex, Novos Aliases, Crypt Avançado e mais!
-- // ============================================================================== //

if not game:IsLoaded() then game.Loaded:Wait() end
local getgenv = getgenv or function() return _G end
if getgenv().OmniCompatLoaded then return end
getgenv().OmniCompatLoaded = true

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera

-- Utilitários Internos
local function returnEmpty() return {} end
local function returnTrue() return true end
local function returnFalse() return false end
local function returnNil() return nil end
local function returnArg(arg) return arg end

-- ==========================================
-- 1. FAKE IDENTIFIERS & ENVIRONMENT
-- ==========================================
getgenv().identifyexecutor = getgenv().identifyexecutor or function() return "Potassium", "2.0.0" end
getgenv().getexecutorname = getgenv().identifyexecutor
getgenv().getthreadidentity = getgenv().getthreadidentity or getgenv().getthreadcontext or function() return 8 end
getgenv().setthreadidentity = getgenv().setthreadidentity or getgenv().setthreadcontext or returnNil
getgenv().KRNL_LOADED = true
getgenv().syn = getgenv().syn or {}

-- ==========================================
-- 2. NEW LIBRARIES (POTASSIUM 2025/2026)
-- ==========================================
-- [RakNet Library]
getgenv().RakNet = getgenv().RakNet or {
    send = returnNil,
    hook = returnNil,
    unhook = returnNil,
    getconnections = returnEmpty
}

-- [OTH Library - Hooking avançado de offsets]
getgenv().oth = getgenv().oth or {
    hook = function(f, hook) return f end,
    unhook = returnNil,
    gethooks = returnEmpty
}

-- [Regex Library] (Simulação básica com Lua nativo)
getgenv().Regex = getgenv().Regex or {
    match = function(s, p) return string.match(s, p) end,
    gmatch = function(s, p) return string.gmatch(s, p) end,
    gsub = function(s, p, r) return string.gsub(s, p, r) end
}
getgenv().regex = getgenv().Regex

-- [PsmSignal / Signal Library]
getgenv().Signal = getgenv().Signal or {
    new = function() return Instance.new("BindableEvent") end
}
getgenv().PsmSignal = getgenv().Signal

-- ==========================================
-- 3. CRYPT & HASHING (UPDATED)
-- ==========================================
getgenv().crypt = getgenv().crypt or {}
local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function b64encode(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte() for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end return r 
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x) 
        if (#x<6) then return '' end local c=0 for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end return b64chars:sub(c+1,c+1) 
    end)..({ '', '==', '=' })[#data%3+1])
end
getgenv().base64encode = getgenv().base64encode or b64encode
getgenv().base64decode = getgenv().base64decode or returnArg
getgenv().crypt.base64encode = getgenv().base64encode
getgenv().crypt.base64decode = getgenv().base64decode
getgenv().crypt.encrypt = getgenv().crypt.encrypt or function(d, k) return b64encode(d), b64encode("iv") end
getgenv().crypt.decrypt = getgenv().crypt.decrypt or returnArg
getgenv().crypt.generatebytes = getgenv().crypt.generatebytes or function() return b64encode(tostring(math.random(1000,9999))) end
getgenv().crypt.generatekey = getgenv().crypt.generatekey or function() return b64encode("key") end
getgenv().crypt.hash = getgenv().crypt.hash or function(d) return b64encode(d) end
getgenv().crypt.hmac = getgenv().crypt.hmac or function(d) return b64encode(d) end
getgenv().crypt.random = getgenv().crypt.random or getgenv().crypt.generatebytes
getgenv().crypt.lz4compress = getgenv().crypt.lz4compress or getgenv().lz4compress or returnArg
getgenv().crypt.lz4decompress = getgenv().crypt.lz4decompress or getgenv().lz4decompress or returnArg
getgenv().lz4compress = getgenv().crypt.lz4compress
getgenv().lz4decompress = getgenv().crypt.lz4decompress

-- ==========================================
-- 4. CONSOLE & ALIASES (UPDATED)
-- ==========================================
local function safePrint(...) print(...) end
getgenv().rconsoleprint = getgenv().rconsoleprint or safePrint
getgenv().rconsolewarn = getgenv().rconsolewarn or function(...) warn(...) end
getgenv().rconsoleerror = getgenv().rconsoleerror or getgenv().rconsoleerr or function(...) warn("[ERR]", ...) end
getgenv().rconsoleerr = getgenv().rconsoleerror
getgenv().rconsoleinfo = getgenv().rconsoleinfo or safePrint
getgenv().rconsoleclear = getgenv().rconsoleclear or returnNil
getgenv().rconsolename = getgenv().rconsolename or returnNil
getgenv().rconsolesettitle = getgenv().rconsolesettitle or returnNil
getgenv().rconsoledestroy = getgenv().rconsoledestroy or returnNil
getgenv().rconsoleinput = getgenv().rconsoleinput or function() return "" end
getgenv().messagebox = getgenv().messagebox or function(txt, cap) safePrint("["..(cap or "Box").."]: "..txt) return 1 end
getgenv().messageboxasync = getgenv().messageboxasync or function(t, c) task.spawn(getgenv().messagebox, t, c) end

-- ==========================================
-- 5. INPUT SIMULATION & KEYTAP
-- ==========================================
getgenv().isrbxactive = getgenv().isrbxactive or returnTrue
getgenv().mouse1press = getgenv().mouse1press or function() VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0) end
getgenv().mouse1release = getgenv().mouse1release or function() VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0) end
getgenv().mouse1click = getgenv().mouse1click or function() getgenv().mouse1press() task.wait() getgenv().mouse1release() end
getgenv().mouse2press = getgenv().mouse2press or function() VirtualInputManager:SendMouseButtonEvent(0,0,1,true,game,0) end
getgenv().mouse2release = getgenv().mouse2release or function() VirtualInputManager:SendMouseButtonEvent(0,0,1,false,game,0) end
getgenv().mouse2click = getgenv().mouse2click or function() getgenv().mouse2press() task.wait() getgenv().mouse2release() end
getgenv().keypress = getgenv().keypress or function(k) VirtualInputManager:SendKeyEvent(true,k,false,game) end
getgenv().keyrelease = getgenv().keyrelease or function(k) VirtualInputManager:SendKeyEvent(false,k,false,game) end
getgenv().keytap = getgenv().keytap or function(k) getgenv().keypress(k) task.wait() getgenv().keyrelease(k) end
getgenv().mousemoverel = getgenv().mousemoverel or function(x,y) if Camera then Camera.CFrame = Camera.CFrame * CFrame.Angles(math.rad(-y/5), math.rad(-x/5), 0) end end

-- ==========================================
-- 6. CACHE, METATABLES & ENVIRONMENT (NEW ALIASES)
-- ==========================================
getgenv().getrawmetatable = getgenv().getrawmetatable or function(obj) return setmetatable({}, {__index = function() return {} end}) end
getgenv().setrawmetatable = getgenv().setrawmetatable or function(obj, meta) setmetatable(obj, meta) end
getgenv().setreadonly = getgenv().setreadonly or returnNil
getgenv().isreadonly = getgenv().isreadonly or returnTrue
getgenv().makewriteable = getgenv().makewriteable or returnNil
getgenv().makereadonly = getgenv().makereadonly or returnNil
getgenv().hookmetamethod = getgenv().hookmetamethod or function(obj, method, hook) return function(...) return hook(...) end end
getgenv().cloneref = getgenv().cloneref or returnArg
getgenv().clonereference = getgenv().cloneref -- Novo Alias

getgenv().cache = getgenv().cache or { replace = returnNil, invalidate = returnNil }
getgenv().setsafeenv = getgenv().setsafeenv or returnNil
getgenv().setuntouched = getgenv().setsafeenv -- Novo Alias
getgenv().getsafeenv = getgenv().getsafeenv or returnEmpty
getgenv().isuntouched = getgenv().isuntouched or returnFalse
getgenv().saveinstance = getgenv().saveinstance or returnNil
getgenv().getpcd = getgenv().getpcd or returnNil
getgenv().getpcdprop = getgenv().getpcd -- Novo Alias
getgenv().getbspval = getgenv().getbspval or returnNil

-- ==========================================
-- 7. GAME INTERACTIONS & PHYSICS
-- ==========================================
getgenv().gethui = getgenv().gethui or function() local s, cg = pcall(function() return CoreGui end) return s and cg or Players.LocalPlayer:WaitForChild("PlayerGui") end
getgenv().hidden_ui = getgenv().gethui
getgenv().get_hidden_gui = getgenv().gethui -- Novo Alias

getgenv().isnetworkowner = getgenv().isnetworkowner or returnTrue
getgenv().getsimulationradius = getgenv().getsimulationradius or function() return 1000 end
getgenv().setsimulationradius = getgenv().setsimulationradius or returnNil
getgenv().gethiddenproperty = getgenv().gethiddenproperty or function(obj, prop) pcall(function() return obj[prop] end) return nil, true end
getgenv().sethiddenproperty = getgenv().sethiddenproperty or function(obj, prop, val) pcall(function() obj[prop] = val end) return true end
getgenv().gethiddenprop = getgenv().gethiddenproperty -- Novo Alias
getgenv().sethiddenprop = getgenv().sethiddenproperty -- Novo Alias
getgenv().gethiddenproperties = getgenv().gethiddenproperties or returnEmpty
getgenv().getproperties = getgenv().getproperties or returnEmpty

getgenv().setproximitypromptduration = getgenv().setproximitypromptduration or function(p, d) if p:IsA("ProximityPrompt") then p.HoldDuration = d end end
getgenv().getproximitypromptduration = getgenv().getproximitypromptduration or function(p) return p:IsA("ProximityPrompt") and p.HoldDuration or 0 end
getgenv().fireproximityprompt = getgenv().fireproximityprompt or function(p) p:InputHoldBegin() task.wait(0.1) p:InputHoldEnd() end
-- Suporte ao 3º arg de mode do fireclickdetector
getgenv().fireclickdetector = getgenv().fireclickdetector or function(cd, dist, mode)
    if cd and cd.Parent and cd.Parent:IsA("Part") then Players.LocalPlayer.Character:PivotTo(cd.Parent.CFrame) end
end

-- Signals
getgenv().firesignal = getgenv().firesignal or returnNil
getgenv().replicatesignal = getgenv().replicatesignal or returnNil -- Suporta ints e floats via ...
getgenv().getconnections = getgenv().getconnections or returnEmpty
getgenv().getsignalwhitelist = getgenv().getsignalwhitelist or returnEmpty
getgenv().getsignalarguments = getgenv().getsignalarguments or returnEmpty
getgenv().getsignalargumentsinfo = getgenv().getsignalargumentsinfo or returnEmpty
getgenv().setfpscap = getgenv().setfpscap or function(fps) setfpscap(fps) end

-- ==========================================
-- 8. DEBUG & CLOSURES (NEW POTASSIUM FUNCS)
-- ==========================================
getgenv().checkcaller = getgenv().checkcaller or returnTrue
getgenv().hookfunction = getgenv().hookfunction or getgenv().replaceclosure or function(o, n) return o end
getgenv().restorefunction = getgenv().restorefunction or returnNil
getgenv().restorefunc = getgenv().restorefunction -- Novo Alias
getgenv().clonefunction = getgenv().clonefunction or returnArg
getgenv().newcclosure = getgenv().newcclosure or returnArg
getgenv().newlclosure = getgenv().newlclosure or returnArg -- Adicionado
getgenv().iscclosure = getgenv().iscclosure or returnFalse
getgenv().islclosure = getgenv().islclosure or returnTrue
getgenv().getfunctionhash = getgenv().getfunctionhash or function(f) return "hash_mock" end
getgenv().filtergc = getgenv().filtergc or returnEmpty
getgenv().getscriptfromthread = getgenv().getscriptfromthread or returnNil
getgenv().setstackhidden = getgenv().setstackhidden or returnNil

getgenv().debug = getgenv().debug or {}
local dbg = {
    getinfo = function() return {source="mock", short_src="mock", currentline=1, name="mock"} end,
    setinfo = returnNil,
    getupvalue = returnNil, getupvalues = returnEmpty, setupvalue = returnNil,
    getconstant = returnNil, getconstants = returnEmpty, setconstant = returnNil,
    getproto = returnNil, getprotos = returnEmpty, 
    getstack = returnEmpty, setstack = returnNil, getcallstack = returnEmpty,
    getregistry = returnEmpty, setname = returnNil,
    getmetatable = getmetatable, setmetatable = setmetatable
}
for k, v in pairs(dbg) do getgenv().debug[k] = getgenv().debug[k] or v getgenv()[k] = getgenv().debug[k] end

-- ==========================================
-- 9. PARALLEL LUA (ACTORS MOCK)
-- ==========================================
getgenv().create_comm_channel = getgenv().create_comm_channel or function() return 1, Instance.new("BindableEvent") end
getgenv().get_comm_channel = getgenv().get_comm_channel or function(id) return Instance.new("BindableEvent") end
getgenv().run_on_actor = getgenv().run_on_actor or function(actor, scriptStr, ...)
    task.spawn(function(...) local f = loadstring(scriptStr) if f then f(...) end end, ...)
end
getgenv().run_on_thread = getgenv().run_on_thread or getgenv().run_on_actor
getgenv().getactors = getgenv().getactors or returnEmpty
getgenv().getactorthreads = getgenv().getactorthreads or returnEmpty
getgenv().getdeletedactors = getgenv().getdeletedactors or returnEmpty
getgenv().is_parallel = getgenv().is_parallel or returnFalse
getgenv().isparallel = getgenv().is_parallel -- Novo Alias

-- ==========================================
-- 10. NETWORK, WEBSOCKETS & FILES
-- ==========================================
local function dummyRequest(opts) return { StatusCode = 404, Body = "{}", Headers = {}, Success = false } end
getgenv().request = getgenv().request or getgenv().http_request or dummyRequest
getgenv().http_request = getgenv().request

getgenv().WebSocket = getgenv().WebSocket or {}
getgenv().websocket = getgenv().WebSocket -- Novo Alias
getgenv().WebSocket.connect = getgenv().WebSocket.connect or function(url)
    local wsMock = {}
    local msgEvent = Instance.new("BindableEvent")
    local closeEvent = Instance.new("BindableEvent")
    wsMock.OnMessage = msgEvent.Event
    wsMock.OnClose = closeEvent.Event
    wsMock.Send = returnNil
    wsMock.Close = function() closeEvent:Fire() end
    return wsMock
end

local VFS = {}
getgenv().readfile = getgenv().readfile or function(p) return VFS[p] or "{}" end
getgenv().writefile = getgenv().writefile or function(p, d) VFS[p] = tostring(d) end
getgenv().isfile = getgenv().isfile or function(p) return type(VFS[p]) == "string" end
getgenv().loadfile = getgenv().loadfile or function(p) return loadstring(VFS[p] or "") end

getgenv().getfflag = getgenv().getfflag or returnNil
getgenv().setfflag = getgenv().setfflag or returnNil
getgenv().getfflagtype = getgenv().getfflagtype or function() return "string" end
getgenv().clearqueueonteleport = getgenv().clearqueueonteleport or returnNil

-- ==========================================
-- 11. DRAWING API (NOW WITH "Font" SUPPORT)
-- ==========================================
if not getgenv().Drawing or type(getgenv().Drawing.new) ~= "function" then
    getgenv().Drawing = { Fonts = { UI = 0, System = 1, Plex = 2, Monospace = 3 } }
    local DrawGui = Instance.new("ScreenGui")
    DrawGui.Name = "OmniDrawingPolyfill"
    DrawGui.IgnoreGuiInset = true
    DrawGui.DisplayOrder = 2147483647
    DrawGui.Parent = getgenv().gethui()

    local DrawCache = {}
    getgenv().cleardrawcache = function() for _, o in pairs(DrawCache) do pcall(function() o:Remove() end) end DrawCache = {} end

    getgenv().Drawing.new = function(classType)
        local obj = { Visible = false, ZIndex = 1, Transparency = 1, Color = Color3.new(1,1,1) }
        local renderObj, conn

        if classType == "Line" then
            renderObj = Instance.new("Frame", DrawGui)
            renderObj.AnchorPoint = Vector2.new(0.5, 0.5)
            renderObj.BorderSizePixel = 0
            obj.From = Vector2.new(0, 0)
            obj.To = Vector2.new(0, 0)
            obj.Thickness = 1
            
            conn = RunService.RenderStepped:Connect(function()
                if obj.Visible and renderObj then
                    renderObj.Visible = true
                    local center = (obj.From + obj.To) / 2
                    local dist = (obj.From - obj.To).Magnitude
                    local angle = math.atan2(obj.To.Y - obj.From.Y, obj.To.X - obj.From.X)
                    renderObj.Position = UDim2.new(0, center.X, 0, center.Y)
                    renderObj.Size = UDim2.new(0, dist, 0, obj.Thickness)
                    renderObj.Rotation = math.deg(angle)
                    renderObj.BackgroundColor3 = obj.Color
                    renderObj.BackgroundTransparency = 1 - obj.Transparency
                    renderObj.ZIndex = obj.ZIndex
                elseif renderObj then renderObj.Visible = false end
            end)

        elseif classType == "Text" or classType == "Font" then -- Potassium Update 05/27/25
            renderObj = Instance.new("TextLabel", DrawGui)
            renderObj.BackgroundTransparency = 1
            local stroke = Instance.new("UIStroke", renderObj)
            obj.Text = ""
            obj.Size = 16
            obj.Center = false
            obj.Outline = false
            obj.OutlineColor = Color3.new(0,0,0)
            obj.Position = Vector2.new(0, 0)
            obj.Font = 0
            
            conn = RunService.RenderStepped:Connect(function()
                if obj.Visible and renderObj then
                    renderObj.Visible = true
                    renderObj.Text = obj.Text
                    renderObj.TextSize = obj.Size
                    renderObj.Position = UDim2.new(0, obj.Position.X, 0, obj.Position.Y)
                    renderObj.TextColor3 = obj.Color
                    renderObj.TextTransparency = 1 - obj.Transparency
                    renderObj.ZIndex = obj.ZIndex
                    renderObj.AnchorPoint = obj.Center and Vector2.new(0.5, 0) or Vector2.new(0, 0)
                    stroke.Enabled = obj.Outline
                    stroke.Color = obj.OutlineColor
                    stroke.Transparency = 1 - obj.Transparency
                elseif renderObj then renderObj.Visible = false end
            end)
        else
            -- Previne crash de classes 3D/Quad
            obj.PointA = Vector2.new(0,0) obj.PointB = Vector2.new(0,0) obj.PointC = Vector2.new(0,0)
            obj.Thickness = 1 obj.Filled = false
        end

        obj.Remove = function()
            if conn then conn:Disconnect() end 
            if renderObj then renderObj:Destroy() end
            obj.Visible = false
        end
        obj.Destroy = obj.Remove
        table.insert(DrawCache, obj)
        return obj
    end
end

print("✅ POTASSIUM OMNI-COMPATIBILITY CARREGADO! (By GPT)")
