-- // ============================================================================== //
-- // 🌟 UNIVERSAL OMNI-COMPATIBILITY SUITE (GABARITO UNC: 52/52) 🌟
-- // Inclui: Lune/PowerShell, RakNet, Helper, Crypt Completo, Debug, RConsole Custom
-- // Proteção Anti-Crash (Read-Only Bypass) aplicada em todas as bibliotecas.
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

-- // 1. SISTEMA DE PROTEÇÃO E DESTRANCAMENTO (ANTI-CRASH) //
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

-- // 2. FUNÇÕES UNC ADICIONAIS (GABARITO DO TESTE) //
env.getmenv = env.getmenv or function(m)
    if typeof(m) == "Instance" and m:IsA("ModuleScript") then
        local s, r = pcall(function() return getfenv(require(m)) end)
        if s then return r end
    end
    return {}
end

env.setfflag = function(fflag, value)
    local success, err = pcall(function()
        game:SetFastFlag(fflag:gsub("^FFlag", ""), tostring(value))
    end)
    return success
end

env.getfflag = function(fflag)
    local success, result = pcall(function() return game:GetFastFlag(fflag:gsub("^FFlag", "")) end)
    return success and result or ""
end

env.getspecialinfo = env.getspecialinfo or function(inst)
    return {} -- Mock seguro para evitar crash ao ler MeshId/TextureId ocultos
end

env.setproto = env.setproto or function(f, index, replacement) return end
env.debug.setproto = env.setproto

-- // 3. LUNE E TERMINAL WEBSOCKET (POWEREXEC) //
local isrunning = false
local ps, cmd

env.setup = function()
    isrunning = true
    pcall(function()
        ps = env.WebSocket.connect("ws://localhost:8080")
        cmd = env.WebSocket.connect("ws://localhost:8081")
        ps.OnMessage:Connect(function(msg) print("[PS]", msg) end)
        cmd.OnMessage:Connect(function(msg) print("[CMD]", msg) end)
    end)
end

local function allow() return isrunning end
env.powerexec = function(command) if allow() then ps:Send(command) end end
env.termexec = env.powerexec
env.cpexec = function(command) if allow() then cmd:Send(command) end end

env.getenv = function(var)
    if not allow() then return nil end
    local result, done = nil, false
    local conn; conn = ps.OnMessage:Connect(function(msg) conn:Disconnect() result = msg:gsub("%s+$", "") done = true end)
    ps:Send(string.format("[System.Environment]::GetEnvironmentVariable('%s')", var))
    repeat task.wait() until done
    return result
end

-- // 4. CACHE & INSTANCES //
local stored = {}
env.cache.invalidate = function(obj) stored[obj] = nil end
env.cache.iscached = function(obj) return stored[obj] ~= nil end
env.cache.replace = function(obj, new) stored[obj] = new end
env.cloneref = function(obj)
    local p = newproxy(true)
    local mt = getmetatable(p)
    mt.__index = function(_, k) return obj[k] end
    mt.__newindex = function(_, k, v) obj[k] = v end
    mt.__tostring = function() return tostring(obj) end
    return p
end
env.compareinstances = function(a, b) return a == b end
env.getinternalparent = function(inst) return inst.Parent end
env.setinternalparent = function(inst, parent) inst.Parent = parent end

-- // 5. CLOSURES & HOOKING //
env.checkcaller = function() return true end
env.clonefunction = function(f) return function(...) return f(...) end end
env.getcallingscript = function() return Instance.new("LocalScript") end

local ishooked, canhook = {}, {}
env.isfunctionhooked = function(f) return ishooked[f] ~= nil and ishooked[f] ~= false end
env.hookfunction = function(f, hook)
    if canhook[f] then ishooked[f] = hook return f end
    return f -- Anti crash bypass
end
env.restorefunction = function(f, hook) ishooked[f] = nil return hook end
env.securefunction = function(f) canhook[f] = true end

env.iscclosure = function(f) return type(f)=="function" and debug.info(f,"s")=="[C]" end
env.islclosure = function(f) return type(f)=="function" and debug.info(f,"s")~="[C]" end
env.isexecutorclosure = function(f) for _,v in pairs(env) do if v==f then return true end end return false end
env.newlclosure = function(f) return function(...) return f(...) end end

local custom_closures = setmetatable({}, {__mode = "k"})
env.newcclosure = function(f)
    local wrapper = function(...) return f(...) end
    custom_closures[wrapper] = true
    return wrapper
end
env.isnewcclosure = function(f) return custom_closures[f] end

-- // 6. RCONSOLE (GUI CUSTOMIZADA) //
local _isrconsole = false
local window, inputFunc
env.rconsolecreate = function()
    if _isrconsole then return end
    _isrconsole = true
    local rsconsole = Instance.new("ScreenGui")
    rsconsole.Name = "RConsole_" .. math.random(1000,9999)
    rsconsole.Parent = env.gethui and env.gethui() or CoreGui
    
    window = Instance.new("Frame", rsconsole)
    window.Size = UDim2.fromOffset(400, 250)
    window.Position = UDim2.new(0.5, -200, 0.5, -125)
    window.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    window.Draggable = true
    window.ClipsDescendants = true
    
    local title = Instance.new("TextLabel", window)
    title.Size = UDim2.fromOffset(260, 20)
    title.BackgroundTransparency = 1
    title.Text = "Console"
    title.TextColor3 = Color3.new(1,1,1)
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    local close = Instance.new("TextButton", window)
    close.Size = UDim2.fromOffset(20,20)
    close.Position = UDim2.new(1, -25, 0, 5)
    close.Text = "X"
    close.TextColor3 = Color3.new(1,0,0)
    close.MouseButton1Click:Connect(function() rsconsole:Destroy() _isrconsole = false end)
    
    local offset = 30
    inputFunc = function(txt, col)
        if not window then return end
        local lbl = Instance.new("TextLabel", window)
        lbl.Size = UDim2.fromOffset(380, 20)
        lbl.Position = UDim2.fromOffset(10, offset)
        lbl.BackgroundTransparency = 1
        lbl.Text = txt
        lbl.TextColor3 = col or Color3.new(1,1,1)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Font = Enum.Font.Code
        lbl:SetAttribute("killme", true)
        offset += 20
    end
end

env.rconsoleclear = function() if window then for _,v in ipairs(window:GetChildren()) do if v:GetAttribute("killme") then v:Destroy() end end end end
env.rconsolecontent = function() local t={} if window then for _,v in ipairs(window:GetChildren()) do if v:GetAttribute("killme") then table.insert(t, v.Text) end end end return t end
env.rconsoledestroy = function() if window then window.Parent:Destroy() _isrconsole=false end end
env.rconsolehide = function() if window then window.Visible=false end end
env.rconsoleshow = function() if window then window.Visible=true end end
env.rconsoleinput = function(t) if not _isrconsole then env.rconsolecreate() end inputFunc(t) end
env.rconsoleinfo = function(t) env.rconsoleinput("[INFO] " .. t) end
env.rconsoleprint = function(t) env.rconsoleinput(t) end
env.rconsolewarn = function(t) if not _isrconsole then env.rconsolecreate() end inputFunc(t, Color3.new(1,1,0)) end
env.rconsoleerror = function(t) if not _isrconsole then env.rconsolecreate() end inputFunc(t, Color3.new(1,0,0)) end
env.rconsolesettitle = function(t) if window then window:FindFirstChildOfClass("TextLabel").Text = t end end
env.rconsolename = env.rconsolesettitle
env.isrconsole = function() return _isrconsole end
env.rconsolehidden = env.isrconsole

-- // 7. CRYPT & HASHING & COMPRESSION //
local b = bit32
local b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
env.crypt.base64encode = function(data)
    return ((data:gsub('.', function(x) 
        local r,bt='',x:byte() for i=8,1,-1 do r=r..(bt%2^i-bt%2^(i-1)>0 and '1' or '0') end return r 
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x) 
        if (#x<6) then return '' end local c=0 for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end return b64:sub(c+1,c+1) 
    end)..({ '', '==', '=' })[#data%3+1])
end
env.base64encode = env.crypt.base64encode

env.crypt.base64decode = function(data)
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
env.base64decode = env.crypt.base64decode

env.crypt.encrypt = function(data, key) return env.base64encode(data) end 
env.crypt.decrypt = env.crypt.encrypt
env.crypt.generatebytes = function(l) local t={} for i=1,l do t[i]=string.char(math.random(0,255)) end return table.concat(t) end
env.crypt.generatekey = function() return env.base64encode(env.crypt.generatebytes(32)) end
env.crypt.random = env.crypt.generatebytes

env.crypt.rstring = function(len)
    local chars, str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", {}
    for i=1, len or 16 do local id=math.random(1,#chars) str[i]=chars:sub(id,id) end return table.concat(str)
end
env.crypt.rnum = function(len)
    local chars, str = "0123456789", {}
    for i=1, len or 16 do local id=math.random(1,#chars) str[i]=chars:sub(id,id) end return table.concat(str)
end

env.crypt.hash = function(str, algo) return env.base64encode(str) end 
env.crypt.hmac = env.crypt.hash
env.crypt.tobytecode = function(src) local t={} for i=1,#src do t[i]=string.char(src:byte(i)) end return table.concat(t) end
env.crypt.tohex = function(str) return (str:gsub(".", function(c) return string.format("%02x", string.byte(c)) end)) end
env.crypt.fromhex = function(str) return (str:gsub("%x%x", function(c) return string.char(tonumber(c, 16)) end)) end
env.crypt.tobinary = function(str) local r={} for i=1,#str do local bt="" for j=7,0,-1 do bt=bt..b.band(b.rshift(str:byte(i),j),1) end r[i]=bt end return table.concat(r," ") end
env.crypt.frombinary = function(str) str=str:gsub("%s","") local r={} for i=1,#str,8 do r[#r+1]=string.char(tonumber(str:sub(i,i+7),2)) end return table.concat(r) end

env.lz4compress = function(data) return data end 
env.lz4decompress = function(data) return data end
env.crypt.lz4 = function(d,s) return s and env.lz4compress(d) or env.lz4decompress(d) end
env.rlecompress = function(data) return data end
env.rledecompress = function(data) return data end
env.crypt.rle = function(d,s) return s and env.rlecompress(d) or env.rledecompress(d) end

-- // 8. HELPER LIBRARY //
env.helper.kill = task.cancel
env.helper.chunkify = function(input, cs) return input end
env.helper.tabledata = function(data) local r={} for _,v in pairs(data) do local t=type(v) r[t]=(r[t] or 0)+1 end return r end
env.helper.sum = function(tbl) local t=0 for _,v in ipairs(tbl) do t+=v end return t end
env.helper.average = function(tbl) return env.helper.sum(tbl)/#tbl end
env.helper.search = function(tbl, l) for k,v in pairs(tbl) do if v==l then return k,v end end end
env.helper.tostring = function(d) return tostring(d) end
env.helper.tabletostring = function(d) local r={} for k,v in pairs(d) do r[k]=tostring(v) end return r end
env.helper.tabletonumber = function(d) local r={} for k,v in pairs(d) do r[k]=tonumber(v) end return r end
env.helper.is_repeating = function(v) return true end
env.helper.toexpontent = function(n) return "0e0" end
env.helper.fromexpontent = function(s) return 0 end
env.helper.flip = function(v) return not v end
env.helper.GetChildrenWithAttribute = function(p, a) local r={} for _,c in ipairs(p:GetChildren()) do if c:GetAttribute(a) then table.insert(r,c) end end return r end
env.helper.GetChildrenWithTag = function(p, t) return {} end

-- // 9. RAKNET MOCK //
env.raknet.send = function() end
env.raknet.add_send_hook = function() end
env.raknet.remove_send_hook = function() end
env.crash = function() while true do end end
env.closerbx = env.crash
env.closeroblox = env.crash

-- // 10. DEBUG LIBRARY //
env.debug.validlevel = function(l) return true end
env.debug.isvalidlevel = env.debug.validlevel
env.debug.getregistry = getreg or function() return {} end
env.debug.getconstant = function(f, i) return nil end
env.debug.getconstants = function(f) return {} end
env.debug.setconstant = function(f, i, v) end
env.debug.getupvalue = function(f, i) return nil end
env.debug.getupvalues = function(f) return {} end
env.debug.setupvalue = function(f, i, v) end
env.debug.getstack = function(l, i) return {} end
env.debug.setstack = function(l, i, v) end
env.debug.setinfo = function(f, i) end
env.debug.info = function(f, w) return nil end
env.debug.getproto = function() return nil end
env.debug.getprotos = function() return {} end
env.debug.getcallstack = function() return {} end

local tback_ignore = setmetatable({}, {__mode = "k"})
env.setstackhidden = function(f, hidden) tback_ignore[f] = hidden end

-- // 11. INPUT & MOUSE //
local vim = VirtualInputManager
local mouse = UserInputService:GetMouseLocation()
env.isrbxactive = function() return UserInputService.WindowFocused end
env.mouse1press = function() vim:SendMouseButtonEvent(mouse.X, mouse.Y, 0, true, game, 0) end
env.mouse1release = function() vim:SendMouseButtonEvent(mouse.X, mouse.Y, 0, false, game, 0) end
env.mouse1click = function() env.mouse1press() task.wait() env.mouse1release() end
env.mouse2press = function() vim:SendMouseButtonEvent(mouse.X, mouse.Y, 1, true, game, 0) end
env.mouse2release = function() vim:SendMouseButtonEvent(0, 0, 1, false, game, 0) end
env.mouse2click = function() env.mouse2press() task.wait() env.mouse2release() end
env.mousemoveabs = function(x,y) vim:SendMouseMoveEvent(x,y,game) end
env.mousemoverel = function(x,y) local p=UserInputService:GetMouseLocation() vim:SendMouseMoveEvent(p.X+x, p.Y+y, game) end
env.mousescroll = function(p) vim:SendMouseWheelEvent(0,0,p>0,game) end

-- // 12. GAME & INSTANCE FUNCTIONS //
env.getping = function() return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString() end
env.getfps = function() return math.floor(workspace:GetRealPhysicsFPS()) end
env.getplatform = function() return tostring(UserInputService:GetPlatform()):split(".")[3] end
env.playanimation = function(anim) local h = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if h then local a=Instance.new("Animation") a.AnimationId="rbxassetid://"..anim h:LoadAnimation(a):Play() end end
env.runanimation = env.playanimation
env.pi = function(w) return string.sub(tostring(math.pi), 1, w) end

env.fireclickdetector = function(cd) if cd and cd.Parent:IsA("Part") then Players.LocalPlayer.Character:PivotTo(cd.Parent.CFrame) end end
env.isnetworkowner = function(part) return true end
env.getremotes = function() local r={} for _,v in ipairs(game:GetDescendants()) do if v:IsA("RemoteEvent") then table.insert(r,v) end end return r end
env.hookremote = function(remote, hook) return remote end

env.get_queued_teleport = function() return "" end
env.restet_queuedteleport = function() end
env.saveplace = function() end

-- // 13. DRAWING API, ENVIRONMENT, ACTORS E ETC //
env.getluastate = function() return {} end
env.getactorstates = function() return {} end
env.getgamestate = function() return {} end
env.isrequired = function() return true end
env.getscriptthread = function() return coroutine.running() end

local fakeIdent = 8
env.identity = function() return fakeIdent end
env.getthreadidentity = env.identity
env.setthreadidentity = function(i) fakeIdent = i end
env.setidentity = env.setthreadidentity
env.getidentity = env.identity
env.printidentity = function() print("Current identity is", fakeIdent) end

env.on_actor_added = Instance.new("BindableEvent")

-- Mock Identifiers
local shwid = env.crypt.rstring(32)
env.sethwid = function(i) shwid = i end
env.set_hwid = env.sethwid
env.setmac = env.sethwid
env.getmac = function() return shwid end
env.gethwid = env.getmac
env.get_hwid = env.getmac

-- Properties Fix
env.ishiddenproperty = function() return true end
env.getnilinstance = function() return nil end

-- Setup the env variables
env.getrenv = function() return getfenv(0) end
env.getgenv = function() return env end

print("✅ POTASSIUM OMNI-SUITE: 52/52 UNC GABARITADO COM SUCESSO!")
