-- // ============================================================================== //
-- // 🌟 UNIVERSAL OMNI-COMPATIBILITY SUITE (sUNC + Potassium) v4.1 🌟
-- // Objetivo: Máxima compatibilidade com Synapse X, Script-Ware, Krnl, Fluxus, etc.
-- // Atualizações v4.1: Incorporadas funções/aliases do changelog do Potassium.
-- // ============================================================================== //

if not game:IsLoaded() then game.Loaded:Wait() end
local G = getgenv or function() return _G end
if G().OmniCompatLoaded then return end
G().OmniCompatLoaded = true

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera

local env = G()
local function unlock(t)
    if type(t) == "table" then
        pcall(function() if setreadonly then setreadonly(t, false) end end)
        pcall(function() if makewriteable then makewriteable(t) end end)
    end
    return t or {}
end

local VFS = {}

-- // ============================================================================== //
-- // 1. FUNÇÕES DE AMBIENTE (ENVIRONMENT)
-- // ============================================================================== //

env.getgenv = env.getgenv or G
env.getrenv = env.getrenv or function() return _G end
env.getsenv = env.getsenv or function(script) return getfenv(script) or {} end
env.getmenv = env.getmenv or function(module) return getfenv(module) or {} end
env.gettenv = env.gettenv or function(thread) return getfenv(thread) or {} end

env.getfenv = env.getfenv or getfenv
env.setfenv = env.setfenv or setfenv

-- // ============================================================================== //
-- // 2. FUNÇÕES DE INTROSPECÇÃO E MANIPULAÇÃO DE MEMÓRIA
-- // ============================================================================== //

-- getgc: tratando argumento false/true de forma segura
if env.getgc then
    local originalGetGC = env.getgc
    env.getgc = function(...)
        local success, result = pcall(originalGetGC, ...)
        if success then return result end
        success, result = pcall(originalGetGC)
        if success then return result end
        return {}
    end
else
    env.getgc = function() return {} end
end

env.getinstances = env.getinstances or function() return {} end
env.getnilinstances = env.getnilinstances or function() return {} end
env.getloadedmodules = env.getloadedmodules or function() return {} end
env.getscripts = env.getscripts or env.getloadedmodules

-- Funções especializadas para atores (Phantom Forces, etc.)
env.getdeletedactors = env.getdeletedactors or function() return {} end
env.getactorthreads = env.getactorthreads or function() return {} end
env.run_on_thread = env.run_on_thread or function(thread, f, ...) pcall(f, ...) end
env.run_on_actor = env.run_on_actor or env.run_on_thread

-- debug.getconstant e outros
env.getconstants = env.getconstants or function(f) return {} end
env.getconstant = env.getconstant or function(f, idx) return nil end
env.setconstant = env.setconstant or function(f, idx, val) end
env.getupvalues = env.getupvalues or function(f) return {} end
env.getupvalue = env.getupvalue or function(f, idx) return nil end
env.setupvalue = env.setupvalue or function(f, idx, val) end
env.getproto = env.getproto or function(f) return {} end
env.setproto = env.setproto or function(f, proto) return f end

env.getinfo = env.getinfo or function(f) return debug.info(f, "slL") end
env.getstack = env.getstack or function(thread, level) return debug.traceback(thread, "", level) end
env.getreg = env.getreg or function() return debug.getregistry() end
env.getregistry = env.getregistry or env.getreg

-- Novas adições baseadas no Potassium
env.makewriteable = env.makewriteable or function(t) return t end
env.makereadonly = env.makereadonly or function(t) return t end
env.filtergc = env.filtergc or function(filter) return {} end
env.getfunctionhash = env.getfunctionhash or function(f) return "" end
env.getscriptfromthread = env.getscriptfromthread or function(thread) return nil end
env.getscriptthread = env.getscriptthread or function(script) return nil end
env.getpcd = env.getpcd or function(obj, prop) return nil end
env.getbspval = env.getbspval or function(obj, prop) return nil end
env.getfflagtype = env.getfflagtype or function(fflag) return "bool" end
env.gethiddenproperties = env.gethiddenproperties or function(obj) return {} end
env.getproperties = env.getproperties or function(obj) return {} end

-- Aliases
env.getpcdprop = env.getpcdprop or env.getpcd
env.gethiddenprop = env.gethiddenprop or env.gethiddenproperties
env.sethiddenprop = env.sethiddenprop or function(obj, prop, value) end

-- // ============================================================================== //
-- // 3. FUNÇÕES DE CLOSURE (HOOKING E MANIPULAÇÃO)
-- // ============================================================================== //

env.checkcaller = env.checkcaller or function() return true end
env.clonefunction = env.clonefunction or function(f) return f end
env.clonereference = env.clonereference or env.cloneref or function(obj) return obj end
env.iscclosure = env.iscclosure or function(f) return type(f) == "function" and debug.info(f, "s") == "[C]" end
env.islclosure = env.islclosure or function(f) return type(f) == "function" and debug.info(f, "s") ~= "[C]" end
env.isexecutorclosure = env.isexecutorclosure or function() return false end
env.newcclosure = env.newcclosure or function(f) return f end
env.newlclosure = env.newlclosure or function(f, debugname) return f end

if env.isclosure then
    local originalIsClosure = env.isclosure
    env.isclosure = function(f)
        local success, result = pcall(originalIsClosure, f)
        if success then return result end
        return type(f) == "function"
    end
else
    env.isclosure = function(f) return type(f) == "function" end
end

env.hookfunction = env.hookfunction or function(f, hook) return f end
env.hookfunc = env.hookfunc or env.hookfunction
env.replaceclosure = env.replaceclosure or env.hookfunction
env.restorefunction = env.restorefunction or function(f, hook) return hook end
env.restorefunc = env.restorefunc or env.restorefunction
env.loadstring = env.loadstring or loadstring

-- // ============================================================================== //
-- // 4. FUNÇÕES DE REDE (NETWORK)
-- // ============================================================================== //

env.getnamecallmethod = env.getnamecallmethod or function() return "" end
env.setnamecallmethod = env.setnamecallmethod or function(method) end
env.isreadonly = env.isreadonly or function(t) return false end
env.isnetworkowner = env.isnetworkowner or function(part) return true end
env.setsimulationradius = env.setsimulationradius or function(radius) end
env.getsimulationradius = env.getsimulationradius or function() return 1000 end
env.setproximitypromptduration = env.setproximitypromptduration or function(prompt, duration) end
env.getproximitypromptduration = env.getproximitypromptduration or function(prompt) return 5 end

-- // ============================================================================== //
-- // 5. FUNÇÕES DE SISTEMA DE ARQUIVOS (FILESYSTEM)
-- // ============================================================================== //

env.readfile = env.readfile or function(p) return VFS[p] or "" end
env.writefile = env.writefile or function(p, d) VFS[p] = tostring(d) end
env.appendfile = env.appendfile or function(p, d) VFS[p] = (VFS[p] or "") .. tostring(d) end
env.loadfile = env.loadfile or function(p) return loadstring(VFS[p] or "") end
env.isfile = env.isfile or function(p) return type(VFS[p]) == "string" end
env.isfolder = env.isfolder or function(p) return VFS[p] == "FOLDER" end
env.makefolder = env.makefolder or function(p) VFS[p] = "FOLDER" end
env.listfiles = env.listfiles or function(p) return {} end
env.delfile = env.delfile or function(p) VFS[p] = nil end
env.delfolder = env.delfolder or function(p) VFS[p] = nil end

env.saveinstance = env.saveinstance or function(opts) return {} end

-- // ============================================================================== //
-- // 6. FUNÇÕES DE ENTRADA (INPUT)
-- // ============================================================================== //

local function getMousePos()
    local pos = UserInputService:GetMouseLocation()
    return pos.X, pos.Y
end

env.mouse1press = env.mouse1press or function()
    local x, y = getMousePos()
    pcall(function() VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0) end)
end
env.mouse1release = env.mouse1release or function()
    local x, y = getMousePos()
    pcall(function() VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0) end)
end
env.mouse1click = env.mouse1click or function() env.mouse1press(); task.wait(); env.mouse1release() end
env.mouse2press = env.mouse2press or function()
    local x, y = getMousePos()
    pcall(function() VirtualInputManager:SendMouseButtonEvent(x, y, 1, true, game, 0) end)
end
env.mouse2release = env.mouse2release or function()
    local x, y = getMousePos()
    pcall(function() VirtualInputManager:SendMouseButtonEvent(x, y, 1, false, game, 0) end)
end
env.mouse2click = env.mouse2click or function() env.mouse2press(); task.wait(); env.mouse2release() end

env.keypress = env.keypress or function(k) pcall(function() VirtualInputManager:SendKeyEvent(true, k, false, game) end) end
env.keyrelease = env.keyrelease or function(k) pcall(function() VirtualInputManager:SendKeyEvent(false, k, false, game) end) end
env.keyclick = env.keyclick or function(k) env.keypress(k); task.wait(); env.keyrelease(k) end
env.keytap = env.keytap or env.keyclick

-- // ============================================================================== //
-- // 7. FUNÇÕES DE TELETRANSPORTE (QUEUE ON TELEPORT)
-- // ============================================================================== //

local teleportQueue = {}
env.queue_on_teleport = env.queue_on_teleport or function(f)
    table.insert(teleportQueue, f)
    pcall(function()
        local gc = getgc or function() return {} end
        for _, v in pairs(gc()) do
            if typeof(v) == "function" and getfenv(v).script == nil then
                local ok, err = pcall(v)
            end
        end
    end)
end
env.queueonteleport = env.queueonteleport or env.queue_on_teleport
env.clearqueueonteleport = env.clearqueueonteleport or function() teleportQueue = {} end

-- // ============================================================================== //
-- // 8. FUNÇÕES DE CRIPTOGRAFIA (CRYPT)
-- // ============================================================================== //

env.crypt = unlock(env.crypt)

local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function base64_encode(data)
    local bytes = {data:byte(1, -1)}
    local result = {}
    for i = 1, #bytes, 3 do
        local b1, b2, b3 = bytes[i], bytes[i+1] or 0, bytes[i+2] or 0
        local n = b1 * 0x10000 + b2 * 0x100 + b3
        for j = 3, 0, -1 do
            local idx = math.floor(n / (64 ^ j)) % 64 + 1
            result[#result+1] = b64chars:sub(idx, idx)
        end
    end
    local padding = #bytes % 3
    if padding == 1 then
        result[#result-1] = "="
        result[#result] = "="
    elseif padding == 2 then
        result[#result] = "="
    end
    return table.concat(result)
end

local function base64_decode(data)
    data = data:gsub("[^"..b64chars.."=]", "")
    local function char_value(c)
        if c == "=" then return 0 end
        return (b64chars:find(c, 1, true) - 1)
    end
    local bytes = {}
    for i = 1, #data, 4 do
        local c1, c2, c3, c4 = data:sub(i,i), data:sub(i+1,i+1), data:sub(i+2,i+2), data:sub(i+3,i+3)
        local n = char_value(c1)*262144 + char_value(c2)*4096 + char_value(c3)*64 + char_value(c4)
        bytes[#bytes+1] = string.char(math.floor(n/65536)%256)
        if c3 ~= "=" then bytes[#bytes+1] = string.char(math.floor(n/256)%256) end
        if c4 ~= "=" then bytes[#bytes+1] = string.char(n%256) end
    end
    return table.concat(bytes)
end

env.base64encode = env.base64encode or base64_encode
env.base64decode = env.base64decode or base64_decode
env.crypt.base64encode = env.crypt.base64encode or env.base64encode
env.crypt.base64decode = env.crypt.base64decode or env.base64decode
env.crypt.encrypt = env.crypt.encrypt or function(data, key) return base64_encode(data) end
env.crypt.decrypt = env.crypt.decrypt or env.crypt.encrypt
env.crypt.generatebytes = env.crypt.generatebytes or function(l) return HttpService:GenerateGUID(false):sub(1, l) end
env.crypt.generatekey = env.crypt.generatekey or function() return env.crypt.generatebytes(32) end
env.crypt.hash = env.crypt.hash or function(str) return base64_encode(str) end
env.crypt.hmac = env.crypt.hmac or env.crypt.hash
env.crypt.random = env.crypt.random or function(l) return env.crypt.generatebytes(l or 16) end
env.crypt.rstring = env.crypt.rstring or function() return HttpService:GenerateGUID(false) end
env.crypt.rnum = env.crypt.rnum or function() return tostring(math.random(100000, 999999)) end
env.crypt.lz4_compress = env.crypt.lz4_compress or function(data) return data end
env.crypt.lz4_decompress = env.crypt.lz4_decompress or function(data) return data end

-- // ============================================================================== //
-- // 9. BIBLIOTECA SYN (SYNAPSE X) - EXPANDIDA
-- // ============================================================================== //

env.syn = unlock(env.syn)
env.syn.request = env.request or env.syn.request or function() end
env.syn.queue_on_teleport = env.queue_on_teleport
env.syn.write_clipboard = env.setclipboard or function() end
env.syn.protect_gui = function(gui) gui.Parent = env.gethui() end
env.syn.unprotect_gui = function(gui) gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end
env.syn.crypto = env.crypt
env.syn.crypt = env.crypt
env.syn.websocket = env.WebSocket
env.syn.mouse1click = env.mouse1click
env.syn.mouse1press = env.mouse1press
env.syn.mouse1release = env.mouse1release
env.syn.mouse2click = env.mouse2click
env.syn.mouse2press = env.mouse2press
env.syn.mouse2release = env.mouse2release
env.syn.keypress = env.keypress
env.syn.keyrelease = env.keyrelease
env.syn.keyclick = env.keyclick

env.syn.get_thread_identity = env.getthreadidentity or function() return 8 end
env.syn.set_thread_identity = env.setthreadidentity or function() end
env.syn.getsenv = env.getsenv
env.syn.getmenv = env.getmenv
env.syn.gettenv = env.gettenv
env.syn.getfenv = env.getfenv
env.syn.setfenv = env.setfenv

env.syn.getloadedmodules = env.getloadedmodules
env.syn.getscripts = env.getscripts
env.syn.getinstances = env.getinstances
env.syn.getnilinstances = env.getnilinstances
env.syn.getconstants = env.getconstants
env.syn.getconstant = env.getconstant
env.syn.setconstant = env.setconstant
env.syn.getupvalues = env.getupvalues
env.syn.getupvalue = env.getupvalue
env.syn.setupvalue = env.setupvalue
env.syn.getproto = env.getproto
env.syn.setproto = env.setproto
env.syn.getinfo = env.getinfo
env.syn.getstack = env.getstack
env.syn.getreg = env.getreg
env.syn.getregistry = env.getregistry

env.syn.iscclosure = env.iscclosure
env.syn.islclosure = env.islclosure
env.syn.isexecutorclosure = env.isexecutorclosure
env.syn.newcclosure = env.newcclosure
env.syn.newlclosure = env.newlclosure
env.syn.clonefunction = env.clonefunction
env.syn.hookfunction = env.hookfunction
env.syn.hookfunc = env.hookfunc
env.syn.replaceclosure = env.replaceclosure
env.syn.restorefunction = env.restorefunction
env.syn.securefunction = env.securefunction or function(f) end

env.syn.isreadonly = env.isreadonly
env.syn.getnamecallmethod = env.getnamecallmethod
env.syn.setnamecallmethod = env.setnamecallmethod
env.syn.getthreadcontext = env.getthreadcontext or env.getthreadidentity
env.syn.setthreadcontext = env.setthreadcontext or env.setthreadidentity
env.syn.getrunningscripts = env.getrunningscripts
env.syn.getlocalplayer = env.getlocalplayer
env.syn.getplayer = env.getplayer

env.syn.getconnections = env.getconnections
env.syn.firesignal = env.firesignal
env.syn.getsignal = env.getsignal
env.syn.getcallbackvalue = env.getcallbackvalue
env.syn.getcallbackfunction = env.getcallbackfunction

-- // ============================================================================== //
-- // 10. FUNÇÕES DE UI E MISCELÂNEA
-- // ============================================================================== //

env.gethui = env.gethui or function() return CoreGui end
env.get_hidden_gui = env.get_hidden_gui or env.gethui
env.getexecutorname = env.getexecutorname or function() return "OmniSuite", "4.1.0" end
env.identifyexecutor = env.identifyexecutor or env.getexecutorname
env.getexecutor = env.getexecutor or env.getexecutorname

if env.getconnections then
    local originalGetConnections = env.getconnections
    env.getconnections = function(signal)
        local success, result = pcall(originalGetConnections, signal)
        if success then return result end
        return {}
    end
else
    env.getconnections = function(signal) return {} end
end

if env.firetouchinterest and not env.firetouchtransmitter then
    local originalFireTouchInterest = env.firetouchinterest
    env.firetouchinterest = function(...)
        local success, result = pcall(originalFireTouchInterest, ...)
        return result
    end
end

env.firesignal = env.firesignal or function(signal, ...) end
env.getsignal = env.getsignal or function(inst, signalName) return nil end
env.getcallbackvalue = env.getcallbackvalue or function(obj, prop) return nil end
env.getcallbackfunction = env.getcallbackfunction or function() return function() end end

env.getscriptclosure = env.getscriptclosure or function(script) return function() end end
env.getscriptfunction = env.getscriptfunction or function(script) return function() end end
env.getscripthash = env.getscripthash or function(script) return env.crypt.hash(script) end
env.getscriptbytecode = env.getscriptbytecode or function(script) return "" end

env.iswindowactive = env.iswindowactive or function() return true end
env.isrbxactive = env.isrbxactive or function() return true end
env.isparallel = env.isparallel or function(thread) return false end

env.getthreadidentity = env.getthreadidentity or function() return 8 end
env.setthreadidentity = env.setthreadidentity or function(identity) end
env.getthreadcontext = env.getthreadcontext or env.getthreadidentity
env.setthreadcontext = env.setthreadcontext or env.setthreadidentity

env.getrunningscripts = env.getrunningscripts or function() return {} end
env.getlocalplayer = env.getlocalplayer or function() return Players.LocalPlayer end
env.getplayer = env.getplayer or env.getlocalplayer

env.fireclickdetector = env.fireclickdetector or function(detector, distance, mode) end
env.isscriptable = env.isscriptable or function(obj, prop) return true end

env.setclipboard = env.setclipboard or function(text) end
env.toclipboard = env.toclipboard or env.setclipboard
env.getcustomasset = env.getcustomasset or function(path) return "" end
env.getsynasset = env.getsynasset or env.getcustomasset

env.messagebox = env.messagebox or function(msg, title) print(title, msg) end
env.messageboxasync = env.messageboxasync or env.messagebox

env.setsafeenv = env.setsafeenv or function(env, state) end
env.getsafeenv = env.getsafeenv or function(env) return false end
env.setstackhidden = env.setstackhidden or function(level, hidden) end

env.getsignalwhitelist = env.getsignalwhitelist or function(signal) return {} end
env.getsignalarguments = env.getsignalarguments or function(signal) return {} end
env.getsignalargumentsinfo = env.getsignalargumentsinfo or function(signal) return {} end

-- // ============================================================================== //
-- // 11. BIBLIOTECA OTH (POTASSIUM)
-- // ============================================================================== //

env.oth = unlock(env.oth) or {}

-- // ============================================================================== //
-- // 12. PONTES DE EXECUTORES ESPECÍFICOS
-- // ============================================================================== //

env.http = unlock(env.http)
env.http.request = env.request or function() end

env.Krnl = unlock(env.Krnl)
env.Krnl.request = env.request or function() end
env.krnl = env.Krnl

env.Fluxus = unlock(env.Fluxus)
env.Fluxus.request = env.request or function() end
env.fluxus = env.Fluxus

env.RakNet = unlock(env.RakNet) or {}
env.PsmSignal = env.PsmSignal or {}
env.Signal = env.Signal or env.PsmSignal

-- // ============================================================================== //
-- // 13. IDENTIFICADORES FALSOS PARA COMPATIBILIDADE
-- // ============================================================================== //

env.KRNL_LOADED = true
env.FLUXUS_LOADED = true
env.SYNAPSE_LOADED = true
env.SCRIPTWARE_LOADED = true
env.SYNAPSE_X_LOADED = true
env.SENTINEL_LOADED = true

print("✅ OMNI-SUITE v4.1: ATUALIZADO COM FUNÇÕES DO POTASSIUM!")
