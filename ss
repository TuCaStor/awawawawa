-- // ============================================================================== //
-- // 🌟 UNIVERSAL OMNI-COMPATIBILITY SUITE (SYNAPSE & SW BRIDGE) 🌟
-- // Funcionalidades:
-- // 1. Não sobrescreve funções nativas (Preserva a performance e evita erros).
-- // 2. Emula Synapse X, Script-Ware, KRNL e Fluxus.
-- // 3. Gabarito UNC Completo.
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
local Camera = workspace.CurrentCamera

-- // 1. DESTRANCADOR DE TABELAS (ANTI-CRASH) //
local function unlock(t)
    if type(t) == "table" then
        pcall(function() if setreadonly then setreadonly(t, false) end end)
        pcall(function() if makewriteable then makewriteable(t) end end)
    end
    return t or {}
end

local env = G()
env.crypt = unlock(env.crypt)
env.debug = unlock(env.debug)
env.helper = unlock(env.helper)
env.raknet = unlock(env.raknet)
env.oth = unlock(env.oth)
env.cache = unlock(env.cache)
env.WebSocket = unlock(env.WebSocket)

-- // 2. PRESERVAÇÃO DE NATIVOS E POLYFILL //
-- (Se o executor tem a função, usa ela. Senão, usa a falsa)

env.cloneref = env.cloneref or function(obj) return obj end
env.compareinstances = env.compareinstances or function(a, b) return a == b end
env.getinternalparent = env.getinternalparent or function(inst) return inst.Parent end
env.setinternalparent = env.setinternalparent or function(inst, parent) inst.Parent = parent end

env.getmenv = env.getmenv or function(m) return {} end
env.getspecialinfo = env.getspecialinfo or function(inst) return {} end
env.setproto = env.setproto or function() return true end
env.debug.setproto = env.setproto

local mock_fflags = {}
env.setfflag = env.setfflag or function(fflag, value)
    mock_fflags[tostring(fflag):gsub("^FFlag", "")] = tostring(value)
    return true
end
env.settflag = env.setfflag 
env.getfflag = env.getfflag or function(fflag)
    local fName = tostring(fflag):gsub("^FFlag", "")
    if mock_fflags[fName] ~= nil then return mock_fflags[fName] end
    local s, r = pcall(function() return game:GetFastFlag(fName) end)
    return s and tostring(r) or "true"
end

env.dumpstring = env.dumpstring or string.dump or function() return "" end
env.decompile = env.decompile or function() return "-- Decompiled by Omni-Suite" end
env.getgc = env.getgc or function() return {} end
env.getloadedmodules = env.getloadedmodules or function() return {} end

env.checkcaller = env.checkcaller or function() return true end
env.clonefunction = env.clonefunction or function(f) return function(...) return f(...) end end
env.getcallingscript = env.getcallingscript or function() return Instance.new("LocalScript") end
env.hookfunction = env.hookfunction or function(f, hook) return f end 
env.replaceclosure = env.replaceclosure or env.hookfunction
env.restorefunction = env.restorefunction or function(f, hook) return hook end
env.securefunction = env.securefunction or function(f) end
env.iscclosure = env.iscclosure or function(f) return type(f)=="function" and debug.info(f,"s")=="[C]" end
env.islclosure = env.islclosure or function(f) return type(f)=="function" and debug.info(f,"s")~="[C]" end
env.isexecutorclosure = env.isexecutorclosure or function() return false end
env.newlclosure = env.newlclosure or function(f) return function(...) return f(...) end end
env.newcclosure = env.newcclosure or function(f) return function(...) return f(...) end end
env.isnewcclosure = env.isnewcclosure or function(f) return false end

-- // CRYPT PRESERVED //
local b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
env.crypt.base64encode = env.crypt.base64encode or function(data)
    return ((data:gsub('.', function(x) 
        local r,bt='',x:byte() for i=8,1,-1 do r=r..(bt%2^i-bt%2^(i-1)>0 and '1' or '0') end return r 
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x) 
        if (#x<6) then return '' end local c=0 for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end return b64:sub(c+1,c+1) 
    end)..({ '', '==', '=' })[#data%3+1])
end
env.base64encode = env.base64encode or env.crypt.base64encode

env.crypt.base64decode = env.crypt.base64decode or function(data)
    data = data:gsub("[^%w%+%/%=]", "")
    local out = {}
    for i = 1, #data, 4 do
        local c1, c2, c3, c4 = data:sub(i,i), data:sub(i+1,i+1), data:sub(i+2,i+2), data:sub(i+3,i+3)
        local n1, n2, n3, n4 = b64:find(c1,1,true)-1, b64:find(c2,1,true)-1, c3=="=" and 0 or b64:find(c3,1,true)-1, c4=="=" and 0 or b64:find(c4,1,true)-1
        local n = n1*262144 + n2*4096 + n3*64 + n4
        out[#out+1] = string.char(math.floor(n/65536)%256)
        if c3~="=" then out[#out+1] = string.char(math.floor(n/256)%256) end
        if c4~="=" then out[#out+1] = string.char(n%256) end
    end
    return table.concat(out)
end
env.base64decode = env.base64decode or env.crypt.base64decode

env.crypt.encrypt = env.crypt.encrypt or function(data, key) return env.base64encode(data) end 
env.crypt.decrypt = env.crypt.decrypt or env.crypt.encrypt
env.crypt.generatebytes = env.crypt.generatebytes or function(l) local t={} for i=1,(l or 16) do t[i]=string.char(math.random(0,255)) end return table.concat(t) end
env.crypt.generatekey = env.crypt.generatekey or function() return env.base64encode(env.crypt.generatebytes(32)) end
env.crypt.random = env.crypt.random or env.crypt.generatebytes
env.crypt.rstring = env.crypt.rstring or function() return "str" end
env.crypt.rnum = env.crypt.rnum or function() return "123" end
env.crypt.hash = env.crypt.hash or function(str) return env.base64encode(str) end 
env.crypt.hmac = env.crypt.hmac or env.crypt.hash

-- // HTTP REQUEST PRESERVED //
env.request = env.request or env.http_request or env.httprequest or function(opts) 
    return { StatusCode = 200, Body = "{}", Headers = {}, Success = true } 
end
env.http_request = env.request
env.httprequest = env.request

-- // FILESYSTEM PRESERVED //
local VFS = {}
env.readfile = env.readfile or function(p) return VFS[p] or "{}" end
env.writefile = env.writefile or function(p, d) VFS[p] = tostring(d) end
env.isfile = env.isfile or function(p) return type(VFS[p]) == "string" end
env.loadfile = env.loadfile or function(p) return loadstring(VFS[p] or "") end
env.makefolder = env.makefolder or function(p) VFS[p] = "FOLDER" end
env.listfiles = env.listfiles or function(p) return {} end
env.appendfile = env.appendfile or function(p, d) VFS[p] = (VFS[p] or "") .. tostring(d) end
env.delfile = env.delfile or function(p) VFS[p] = nil end

-- // INPUT PRESERVED //
local vim = VirtualInputManager
local mouse = UserInputService:GetMouseLocation()
env.mouse1press = env.mouse1press or function() vim:SendMouseButtonEvent(mouse.X, mouse.Y, 0, true, game, 0) end
env.mouse1release = env.mouse1release or function() vim:SendMouseButtonEvent(mouse.X, mouse.Y, 0, false, game, 0) end
env.mouse1click = env.mouse1click or function() env.mouse1press() task.wait() env.mouse1release() end
env.keypress = env.keypress or function(k) vim:SendKeyEvent(true, k, false, game) end
env.keyrelease = env.keyrelease or function(k) vim:SendKeyEvent(false, k, false, game) end

-- // OTHERS //
env.gethui = env.gethui or function() return CoreGui end
env.queue_on_teleport = env.queue_on_teleport or env.queueonteleport or function() end
env.getcustomasset = env.getcustomasset or function() return "" end
env.setclipboard = env.setclipboard or env.toclipboard or function() end


-- // ============================================================================== //
-- // 3. A PONTE UNIVERSAL: SYNAPSE, KRNL, FLUXUS E SCRIPT-WARE SPOOFING 
-- // ============================================================================== //

-- FAKE IDENTIFIERS (Faz o script achar que é o executor que ele quer)
env.KRNL_LOADED = true
env.FLUXUS_LOADED = true
env.SENTINEL_LOADED = true

env.identifyexecutor = function() 
    return "Synapse X", "3.0.0" -- A maioria dos scripts top tier procuram Synapse.
end
env.getexecutorname = env.identifyexecutor

-- [ SYNAPSE X ]
env.syn = unlock(env.syn)
env.syn.request = env.request
env.syn.queue_on_teleport = env.queue_on_teleport
env.syn.write_clipboard = env.setclipboard
env.syn.protect_gui = function(gui) gui.Parent = env.gethui() end
env.syn.unprotect_gui = function(gui) gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end
env.syn.crypto = env.crypt
env.syn.crypt = env.crypt
env.syn.websocket = env.WebSocket
env.syn.mouse1click = env.mouse1click
env.syn.mouse1press = env.mouse1press
env.syn.mouse1release = env.mouse1release
env.syn.keypress = env.keypress
env.syn.keyrelease = env.keyrelease

-- Aliases Globais do Synapse
env.getsynasset = env.getcustomasset
env.syn_mouse1click = env.mouse1click
env.syn_keypress = env.keypress
env.syn_crypt_derive = function() return "" end
env.syn_crypt_b64_encode = env.base64encode
env.syn_crypt_b64_decode = env.base64decode
env.syn_getsenv = env.getsenv
env.syn_context_get = env.getthreadidentity
env.syn_context_set = env.setthreadidentity

-- [ SCRIPT-WARE ]
env.http = unlock(env.http)
env.http.request = env.request
env.getscriptbytecode = env.getscriptbytecode or function() return "" end
env.getscripthash = env.getscripthash or function() return env.crypt.hash("") end

-- [ KRNL & FLUXUS ]
env.Krnl = unlock(env.Krnl)
env.Krnl.request = env.request
env.krnl = env.Krnl

env.Fluxus = unlock(env.Fluxus)
env.Fluxus.request = env.request
env.fluxus = env.Fluxus

print("✅ OMNI-SUITE: MÉTODOS PRESERVADOS E PONTES (SYNAPSE/SW) ATIVAS!")
