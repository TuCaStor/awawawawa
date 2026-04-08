-- // IRIS COMPATIBILITY SUITE: ULTIMATE EDITION // --
-- (Features: Leak Fix, Drawing API, RAM FileSystem, HWID/Input mocks, Hydroxide Bypass)
if not game:IsLoaded() then
    game.Loaded:Wait()
end

if not getgenv()["Iris"] then getgenv()["Iris"] = {} end

-- [1] Custom Console Wrapper
do
    if not getgenv()["Iris"]["CustomConsole"] then 
        getgenv()["Iris"]["CustomConsole"] = true 
        
        local Exploit;
        local success, Seralize = pcall(function() 
            return loadstring(game:HttpGet('https://api.irisapp.ca/Scripts/SeralizeTable.lua', true))() 
        end)
        
        if not success then Seralize = function(t) return tostring(t) end end
        
        if syn and syn_crypt_derive then
            Exploit = "Synapse" 
        elseif gethui and identifyexecutor() == "ScriptWare" then
            Exploit = "ScriptWare" 
        end

        local CachedFunctions = {
            rconsoleprint = getgenv()["rconsoleprint"],
            rconsolewarn = getgenv()["rconsolewarn"],
            rconsoleerr = getgenv()["rconsoleerr"] or getgenv()["rconsoleerror"],
            rconsoleinfo = getgenv()["rconsoleinfo"],
            rconsoleinput = getgenv()["rconsoleinput"],
        }

        local SWColors = {
            ["Black"] = true, ["red"] = true, ["ured"] = true, ["bred"] = true,
            ["green"] = true, ["ugreen"] = true, ["bgreen"] = true, ["yellow"] = true,
            ["uyellow"] = true, ["byellow"] = true, ["blue"] = true, ["ublue"] = true,
            ["bblue"] = true, ["magenta"] = true, ["umagenta"] = true, ["bmagenta"] = true,
            ["cyan"] = true, ["ucyan"] = true, ["bcyan"] = true, ["white"] = true,
            ["uwhite"] = true, ["bwhite"] = true
        }

        local SynColors = {
            ["@@BLACK@@"] = true, ["@@BLUE@@"] = true, ["@@GREEN@@"] = true, ["@@CYAN@@"] = true,
            ["@@RED@@"] = true, ["@@MAGENTA@@"] = true, ["@@BROWN@@"] = true, ["@@LIGHT_GRAY@@"] = true,
            ["@@DARK_GRAY@@"] = true, ["@@LIGHT_BLUE@@"] = true, ["@@LIGHT_GREEN@@"] = true,
            ["@@LIGHT_CYAN@@"] = true, ["@@LIGHT_RED@@"] = true, ["@@LIGHT_MAGENTA@@"] = true,
            ["@@YELLOW@@"] = true, ["@@WHITE@@"] = true
        }

        local Defaults = {
            rconsoleprint = nil, rconsolewarn = nil, rconsoleerr = nil,
            rconsoleerror = nil, rconsoleinfo = nil, rconsoleclear = nil,
            rconsolewritetable = nil,
        }

        local function FormatData(...)
            local Args = {...}
            for _,Arg in next, Args do 
                if Arg == "\n" then
                    if CachedFunctions.rconsoleprint then CachedFunctions.rconsoleprint("\n") end
                else
                    Args[_] = tostring(Arg) 
                end
            end
            local Coloring = select(#Args, ...)

            if not (isconsoleopen and isconsoleopen()) then
                pcall(rconsolecreate)
                local SWName, SWVer = identifyexecutor and identifyexecutor() or "Executor", "1.0";
                pcall(rconsolesettitle, SWName .. " " .. SWVer)
            end

            if SWColors[Coloring] then
                Coloring = SWColors[Coloring]
                table.remove(Args, #Args)
            else
                Coloring = "white"
            end

            return {table.concat(Args, " "), Coloring}
        end

        local function FormatSynData(...)
            local Args = {...}
            for _,Arg in next, Args do 
                if Arg == "\n" then
                    if CachedFunctions.rconsoleprint then CachedFunctions.rconsoleprint("\n") end
                else
                    Args[_] = tostring(Arg) 
                end
            end

            if #Args == 1 and Args[1]:find("@@") then
                if SynColors[Args[1]] then return Args[1]; end
                return "@@WHITE@@"
            end

            return table.concat(Args, " ")
        end

        local function DoDash(Color)
            if CachedFunctions.rconsoleprint then
                CachedFunctions.rconsoleprint("[", "white")
                CachedFunctions.rconsoleprint("*", Color)
                CachedFunctions.rconsoleprint("] ", "white")
            end
        end

        if Exploit == "Synapse" then
            Defaults.rconsoleprint = function(...) local Formatted = FormatSynData(...) if CachedFunctions.rconsoleprint then CachedFunctions.rconsoleprint(Formatted) end end
            Defaults.rconsolewarn = function(...) local Formatted = FormatSynData(...) if CachedFunctions.rconsolewarn then CachedFunctions.rconsolewarn(Formatted) end end
            Defaults.rconsoleerr = function(...) local Formatted = FormatSynData(...) if CachedFunctions.rconsoleerr then CachedFunctions.rconsoleerr(Formatted) end end
            Defaults.rconsoleerror = Defaults.rconsoleerr;
            Defaults.rconsoleinfo  = function(...) local Formatted = FormatSynData(...) if CachedFunctions.rconsoleinfo then CachedFunctions.rconsoleinfo(Formatted) end end
        elseif Exploit == "ScriptWare" then
            Defaults.rconsoleprint = function(...) local Formatted = FormatData(...) if CachedFunctions.rconsoleprint then CachedFunctions.rconsoleprint(Formatted[1], Formatted[2]) end end
            Defaults.rconsolewarn = function(...) local Formatted = FormatData(...) DoDash("yellow") if CachedFunctions.rconsoleprint then CachedFunctions.rconsoleprint(Formatted[1], Formatted[2]) CachedFunctions.rconsoleprint("\n") end end
            Defaults.rconsoleerr = function(...) local Formatted = FormatData(...) DoDash("red") if CachedFunctions.rconsoleprint then CachedFunctions.rconsoleprint(Formatted[1], Formatted[2]) CachedFunctions.rconsoleprint("\n") end end
            Defaults.rconsoleerror = Defaults.rconsoleerr;
            Defaults.rconsoleinfo  = function(...) local Formatted = FormatData(...) DoDash("blue") if CachedFunctions.rconsoleprint then CachedFunctions.rconsoleprint(Formatted[1], Formatted[2]) CachedFunctions.rconsoleprint("\n") end end
        end

        for FuncName, Function in next, Defaults do
            if Function then getgenv()[tostring(FuncName)] = Function; end
        end
    end
end

-- [2] Custom GetHui / Protect GUI
do
    if not getgenv()["Iris"]["CustomGetHui"] then 
        getgenv()["Iris"]["CustomGetHui"] = true 
        
        local IsSynapse = syn and syn.set_thread_identity and syn.is_beta and syn.protect_gui and (typeof(syn.protect_gui) == "function");
        local original_gethui = gethui 
        local IsGetHui = (typeof(original_gethui) == "function")

        getgenv().hidden_ui = function(...)
            if IsSynapse and typeof(...) == "Instance" then
                return syn.protect_gui(...);
            elseif IsGetHui then
                return original_gethui();
            else
                local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
                return success and coreGui or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
            end
        end
        getgenv().gethui = getgenv().hidden_ui;
        getgenv().protect_gui = getgenv().hidden_ui;
    end
end

-- [3] Custom Cryptography
do
    if not getgenv()["Iris"]["CustomCrypt"] then 
        getgenv()["Iris"]["CustomCrypt"] = true 

        local Crypt = getgenv()["crypt"] or {};
        getgenv()["crypt"] = Crypt

        if setreadonly then pcall(setreadonly, Crypt, false) end

        local CryptFunctions = {
            ["base64"] = {
                ["encode"] = (crypt and crypt.base64encode) or base64encode or function(data) return game:GetService("HttpService"):JSONEncode(data) end,
                ["decode"] = (crypt and crypt.base64decode) or base64decode or function(data) return game:GetService("HttpService"):JSONDecode(data) end,
            },
            ["custom"] = {
                ["hash"]    = (crypt and crypt.hash) or function(...) return "hash_not_supported" end,
                ["encrypt"] = (crypt and crypt.encrypt) or function(data, key) return data end,
                ["decrypt"] = (crypt and crypt.decrypt) or function(data, key) return data end,
            },
            ["lz4compress"]   = (crypt and crypt.lz4compress) or lz4compress or function(data) return data end,
            ["lz4decompress"] = (crypt and crypt.lz4decompress) or lz4decompress or function(data) return data end,
        }

        for FunctionName, Function in next, CryptFunctions do
            getgenv()["crypt"][FunctionName] = Function;
            getgenv()["syn_"..FunctionName] = Function;
        end
    end
end

-- [4] Custom WebSocket (Bypass)
do
    if not getgenv()["WebSocket"] then getgenv()["WebSocket"] = {} end

    if not getgenv()["Iris"]["CustomSocket"] then 
        getgenv()["Iris"]["CustomSocket"] = true 
        if setreadonly then pcall(setreadonly, getgenv()["WebSocket"], false) end

        local dummySocket = { Send = function() end, Close = function() end, OnMessage = {}, OnClose = {} }
        
        local SocketFuncs = {
            ["connect"] = WebSocket.connect or syn_websocket_connect or function(url) return dummySocket end,
            ["send"] = WebSocket.send or function() end,
            ["close"] = WebSocket.close or function() end,
        }

        for FunctionName, Function in next, SocketFuncs do
            getgenv()["WebSocket"][FunctionName] = Function;
            getgenv()["syn_websocket_"..FunctionName] = Function;
        end
    end
end

-- [5] API Functions Padding (Extended with Input & RAM FileSystem)
do
    if not getgenv()["Iris"]["IrisCompat"] then 
        getgenv()["Iris"]["IrisCompat"] = true 

        if not rawget(getgenv(), "syn") then getgenv()["syn"] = {} end

        local function dummyReturnEmpty() return {} end
        local function dummyReturnTrue() return true end
        local function dummyReturnNil() return nil end
        
        -- RAM FileSystem (Impede que configs em JSON crashm por falta de leitura)
        local FakeFileSystem = {}

        local Functions = {
            ["getrawmetatable"] = getrawmetatable or get_raw_metatable or dummyReturnEmpty,
            ["setrawmetatable"] = setrawmetatable or set_raw_metatable or function() end,
            ["setreadonly"] = setreadonly or make_readonly or function() end,
            ["iswriteable"] = iswriteable or is_writeable or dummyReturnTrue,

            -- Mouse & Keyboard Mocks
            ["mouse1release"] = mouse1release or mouse1up or function() end,
            ["mouse1press"] = mouse1press or mouse1click or function() end,
            ["mouse2release"] = mouse2release or mouse2up or function() end,
            ["mouse2press"] = mouse2press or mouse2click or function() end,
            ["keypress"] = keypress or function(key) end,
            ["keyrelease"] = keyrelease or function(key) end,
            ["mousemoverel"] = mousemoverel or function(x, y) 
                local cam = workspace.CurrentCamera
                if cam then cam.CFrame = cam.CFrame * CFrame.Angles(math.rad(-y/5), math.rad(-x/5), 0) end
            end,

            -- Fake RAM FileSystem
            ["isfolder"] = isfolder or function(path) return FakeFileSystem[path] == "folder" end,
            ["isfile"] = isfile or function(path) return type(FakeFileSystem[path]) == "string" end,
            ["makefolder"] = makefolder or function(path) FakeFileSystem[path] = "folder" end,
            ["writefile"] = writefile or function(path, data) FakeFileSystem[path] = tostring(data) end,
            ["readfile"] = readfile or function(path) return FakeFileSystem[path] or "{}" end, -- Return {} prevents JSONDecode errors
            ["delfile"] = delfile or function(path) FakeFileSystem[path] = nil end,
            ["delfolder"] = delfolder or function(path) FakeFileSystem[path] = nil end,
            ["listfiles"] = listfiles or function(folder) 
                local files = {} 
                for k, v in pairs(FakeFileSystem) do if k:find(folder) and v ~= "folder" then table.insert(files, k) end end 
                return files 
            end,

            -- Hooking
            ["hookfunction"] = hookfunction or hookfunc or function(old, new) return old end,
            ["hookmetamethod"] = hookmetamethod or function() return function() end end,
            ["newcclosure"] = newcclosure or function(f) return f end,
            ["islclosure"] = islclosure or function() return false end,
            ["iscclosure"] = iscclosure or function() return false end,
            ["cloneref"] = cloneref or function(obj) return obj end,
            
            ["getconnections"] = getconnections or function() return {} end,
            ["getnamecallmethod"] = getnamecallmethod or function() return "" end,
            ["setnamecallmethod"] = setnamecallmethod or function() end,

            -- Auto-Farm Interactions
            ["getnilinstances"] = getnilinstances or dummyReturnEmpty,
            ["fireclickdetector"] = fireclickdetector or function(cd) if cd and cd.Parent and cd.Parent:IsA("Part") then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cd.Parent.CFrame end end,
            ["fireproximityprompt"] = fireproximityprompt or function(Prompt)
                if typeof(Prompt) == "Instance" and Prompt:IsA("ProximityPrompt") then
                    local oldHold = Prompt.HoldDuration
                    Prompt.HoldDuration = 0
                    Prompt:InputHoldBegin()
                    Prompt:InputHoldEnd()
                    Prompt.HoldDuration = oldHold
                end
            end,
            ["firetouchinterest"] = firetouchinterest or function(Part, Toucher, Toggle) end,

            ["gethiddenproperties"] = gethiddenproperties or dummyReturnEmpty,
            ["sethiddenproperties"] = sethiddenproperties or function() end,
            ["getscripts"] = getscripts or getrunningscripts or dummyReturnEmpty,

            ["setsimulationradius"] = setsimulationradius or function() end,
            ["getthreadcontext"] = getthreadidentity or getthreadcontext or function() return 8 end,
            ["setthreadcontext"] = setthreadidentity or setthreadcontext or function() end,
            ["securecall"] = securecall or function(func, env, ...) return coroutine.wrap(func)(...) end,
            ["checkcaller"] = checkcaller or function() return true end,

            ["http_request"] = request or http_request or httprequest or function() return {Body = "", StatusCode = 404} end,
            ["isrbxactive"] = iswindowactive or isrbxactive or dummyReturnTrue,
            ["writeclipboard"] = setclipboard or toclipboard or writeclipboard or function() end,
            ["queue_on_teleport"] = queue_on_teleport or queueonteleport or function() end,
            ["firesignal"] = firesignal or function() end,
            ["getcustomasset"] = getcustomasset or getsynasset or function() return "" end
        }

        for FuncName, Function in next, Functions do getgenv()[FuncName] = Function; end
        
        getgenv().syn.request = Functions["http_request"]
        getgenv().syn.queue_on_teleport = Functions["queue_on_teleport"]
        getgenv().syn.secure_call = Functions["securecall"]
        getgenv().syn.write_clipboard = Functions["writeclipboard"]
    end
end

-- [6] HTTP & HYDROXIDE FIXES
do
    local RequestFunc = getgenv().request or getgenv().http_request
    if RequestFunc then
        -- Apenas recria a função HttpPost globalmente, sem injetar no metatable do jogo (Evita banimentos/kicks)
        getgenv().HttpPost = function(self, url, body, contentType)
             local response = RequestFunc({ 
                 Url = url, 
                 Method = "POST", 
                 Headers = {["Content-Type"] = contentType or "application/json"}, 
                 Body = body 
             })
            return response.Body or ""
        end
        
        getgenv().HttpPostAsync = getgenv().HttpPost
    end
end

-- [7] DEBUG LIBRARY POLYFILL
do
    if not getgenv().debug then getgenv().debug = {} end
    
    local d_funcs = {
        getupvalue = debug.getupvalue or getupvalue or function() return nil end,
        setupvalue = debug.setupvalue or setupvalue or function() end,
        getupvalues = debug.getupvalues or getupvalues or function() return {} end,
        getconstant = debug.getconstant or getconstant or function() return nil end,
        setconstant = debug.setconstant or setconstant or function() end,
        getconstants = debug.getconstants or getconstants or function() return {} end,
        getinfo = debug.getinfo or getinfo or function() return {} end,
        getproto = debug.getproto or getproto or function() return nil end,
        getprotos = debug.getprotos or getprotos or function() return {} end,
        getstack = debug.getstack or getstack or function() return {} end,
        setstack = debug.setstack or setstack or function() end,
        getregistry = debug.getregistry or getregistry or getreg or function() return {} end,
    }

    for k, v in pairs(d_funcs) do
        getgenv().debug[k] = v
        if not getgenv()[k] then getgenv()[k] = v end
    end
end

-- [8] DRAWING API POLYFILL (ULTIMATE)
do
    if not getgenv().Drawing or not getgenv().Drawing.new then
        local CoreGui = game:GetService("CoreGui")
        local RunService = game:GetService("RunService")
        local Camera = workspace.CurrentCamera
        
        local DrawGui = Instance.new("ScreenGui")
        DrawGui.Name = "Iris_DrawingPolyfill"
        DrawGui.IgnoreGuiInset = true
        DrawGui.DisplayOrder = 2147483647
        
        local success = pcall(function() DrawGui.Parent = CoreGui end)
        if not success then DrawGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end

        getgenv().Drawing = {}
        getgenv().Drawing.Fonts = { UI = 0, System = 1, Plex = 2, Monospace = 3 }
        
        local DrawCache = {}
        getgenv().cleardrawcache = function()
            for _, obj in pairs(DrawCache) do pcall(function() obj:Remove() end) end
            DrawCache = {}
        end

        getgenv().Drawing.new = function(classType)
            local obj = {}
            obj.Visible = false
            obj.ZIndex = 1
            obj.Transparency = 1
            obj.Color = Color3.new(1, 1, 1)

            local renderObj = nil
            local connection = nil

            if classType == "Line" then
                renderObj = Instance.new("Frame", DrawGui)
                renderObj.AnchorPoint = Vector2.new(0.5, 0.5)
                renderObj.BorderSizePixel = 0
                obj.From = Vector2.new(0, 0)
                obj.To = Vector2.new(0, 0)
                obj.Thickness = 1
                
                connection = RunService.RenderStepped:Connect(function()
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
                    elseif renderObj then
                        renderObj.Visible = false
                    end
                end)

            elseif classType == "Text" then
                renderObj = Instance.new("TextLabel", DrawGui)
                renderObj.BackgroundTransparency = 1
                obj.Text = ""
                obj.Size = 16
                obj.Center = false
                obj.Outline = false
                obj.OutlineColor = Color3.new(0, 0, 0)
                obj.Position = Vector2.new(0, 0)
                obj.Font = 0

                local FontMapping = {
                    [0] = Enum.Font.SourceSans,
                    [1] = Enum.Font.Arial,
                    [2] = Enum.Font.IBMPlexSans,
                    [3] = Enum.Font.Code
                }

                local stroke = Instance.new("UIStroke", renderObj)
                
                connection = RunService.RenderStepped:Connect(function()
                    if obj.Visible and renderObj then
                        renderObj.Visible = true
                        renderObj.Text = obj.Text
                        renderObj.TextSize = obj.Size
                        renderObj.Position = UDim2.new(0, obj.Position.X, 0, obj.Position.Y)
                        renderObj.TextColor3 = obj.Color
                        renderObj.TextTransparency = 1 - obj.Transparency
                        renderObj.ZIndex = obj.ZIndex
                        renderObj.Font = FontMapping[obj.Font] or Enum.Font.SourceSans
                        
                        if obj.Center then
                            renderObj.AnchorPoint = Vector2.new(0.5, 0)
                        else
                            renderObj.AnchorPoint = Vector2.new(0, 0)
                        end
                        
                        stroke.Enabled = obj.Outline
                        stroke.Color = obj.OutlineColor
                        stroke.Transparency = 1 - obj.Transparency
                    elseif renderObj then
                        renderObj.Visible = false
                    end
                end)

            elseif classType == "Circle" then
                renderObj = Instance.new("Frame", DrawGui)
                local corner = Instance.new("UICorner", renderObj)
                corner.CornerRadius = UDim.new(1, 0)
                local stroke = Instance.new("UIStroke", renderObj)
                
                obj.Position = Vector2.new(0, 0)
                obj.Radius = 0
                obj.Thickness = 1
                obj.Filled = false

                connection = RunService.RenderStepped:Connect(function()
                    if obj.Visible and renderObj then
                        renderObj.Visible = true
                        renderObj.Position = UDim2.new(0, obj.Position.X - obj.Radius, 0, obj.Position.Y - obj.Radius)
                        renderObj.Size = UDim2.new(0, obj.Radius * 2, 0, obj.Radius * 2)
                        renderObj.ZIndex = obj.ZIndex
                        
                        if obj.Filled then
                            renderObj.BackgroundTransparency = 1 - obj.Transparency
                            renderObj.BackgroundColor3 = obj.Color
                            stroke.Enabled = false
                        else
                            renderObj.BackgroundTransparency = 1
                            stroke.Enabled = true
                            stroke.Thickness = obj.Thickness
                            stroke.Color = obj.Color
                            stroke.Transparency = 1 - obj.Transparency
                        end
                    elseif renderObj then
                        renderObj.Visible = false
                    end
                end)

            elseif classType == "Square" then
                renderObj = Instance.new("Frame", DrawGui)
                local stroke = Instance.new("UIStroke", renderObj)
                
                obj.Size = Vector2.new(0, 0)
                obj.Position = Vector2.new(0, 0)
                obj.Thickness = 1
                obj.Filled = false
                
                connection = RunService.RenderStepped:Connect(function()
                    if obj.Visible and renderObj then
                        renderObj.Visible = true
                        renderObj.Position = UDim2.new(0, obj.Position.X, 0, obj.Position.Y)
                        renderObj.Size = UDim2.new(0, obj.Size.X, 0, obj.Size.Y)
                        renderObj.ZIndex = obj.ZIndex
                        
                        if obj.Filled then
                            renderObj.BackgroundTransparency = 1 - obj.Transparency
                            renderObj.BackgroundColor3 = obj.Color
                            stroke.Enabled = false
                        else
                            renderObj.BackgroundTransparency = 1
                            stroke.Enabled = true
                            stroke.Thickness = obj.Thickness
                            stroke.Color = obj.Color
                            stroke.Transparency = 1 - obj.Transparency
                        end
                    elseif renderObj then
                        renderObj.Visible = false
                    end
                end)
                
            elseif classType == "Triangle" or classType == "Quad" then
                -- Polyfill Fake (Evita Crash de ESPs que usam linhas 3D complexas)
                obj.PointA = Vector2.new(0,0)
                obj.PointB = Vector2.new(0,0)
                obj.PointC = Vector2.new(0,0)
                if classType == "Quad" then obj.PointD = Vector2.new(0,0) end
                obj.Thickness = 1
                obj.Filled = false
                -- Como não desenha na tela (mock de dados), não usamos RenderStepped.
            end

            obj.Remove = function()
                if connection then connection:Disconnect() end 
                if renderObj then renderObj:Destroy() renderObj = nil end
                obj.Visible = false
            end
            obj.Destroy = obj.Remove
            
            table.insert(DrawCache, obj)
            return obj
        end
        
        getgenv().isrenderobj = function(obj) return type(obj) == "table" and obj.Remove ~= nil end
    end
end

print("Iris Compat ULTIMATE Loaded Successfully!")
