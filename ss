-- // IRIS COMPATIBILITY SUITE MERGED & EXTENDED (FIXED 3.0 + DEBUG + DRAWING API + LEAK FIX) // --
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

-- [5] API Functions Padding (Alias)
do
    if not getgenv()["Iris"]["IrisCompat"] then 
        getgenv()["Iris"]["IrisCompat"] = true 

        if not rawget(getgenv(), "syn") then getgenv()["syn"] = {} end

        local function dummyReturnEmpty() return {} end
        local function dummyReturnTrue() return true end
        local function dummyReturnNil() return nil end

        local Functions = {
            ["getrawmetatable"] = getrawmetatable or get_raw_metatable or dummyReturnEmpty,
            ["setrawmetatable"] = setrawmetatable or set_raw_metatable or function() end,
            ["setreadonly"] = setreadonly or make_readonly or function() end,
            ["iswriteable"] = iswriteable or is_writeable or dummyReturnTrue,

            ["mouse1release"] = mouse1release or mouse1up or function() end,
            ["mouse1press"] = mouse1press or mouse1click or function() end,
            ["mouse2release"] = mouse2release or mouse2up or function() end,
            ["mouse2press"] = mouse2press or mouse2click or function() end,

            ["isfolder"] = isfolder or function() return false end,
            ["isfile"] = isfile or function() return false end,
            ["makefolder"] = makefolder or function() end,
            ["writefile"] = writefile or function() end,
            ["readfile"] = readfile or function() return "" end,
            ["delfile"] = delfile or function() end,
            ["delfolder"] = delfolder or function() end,

            ["hookfunction"] = hookfunction or hookfunc or function(old, new) return old end,
            ["hookmetamethod"] = hookmetamethod or function() return function() end end,
            ["newcclosure"] = newcclosure or function(f) return f end,
            ["islclosure"] = islclosure or function() return false end,
            ["iscclosure"] = iscclosure or function() return false end,
            ["cloneref"] = cloneref or function(obj) return obj end,
            
            ["getconnections"] = getconnections or function() return {} end,
            ["getnamecallmethod"] = getnamecallmethod or function() return "" end,
            ["setnamecallmethod"] = setnamecallmethod or function() end,

            ["getnilinstances"] = getnilinstances or dummyReturnEmpty,
            ["fireclickdetector"] = fireclickdetector or function(cd) if cd and cd.Parent then if cd.Parent:IsA("Part") then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cd.Parent.CFrame end end end,
            ["gethiddenproperties"] = gethiddenproperties or dummyReturnEmpty,
            ["sethiddenproperties"] = sethiddenproperties or function() end,
            ["getscripts"] = getscripts or getrunningscripts or dummyReturnEmpty,

            ["setsimulationradius"] = setsimulationradius or function() end,
            ["getthreadcontext"] = getthreadidentity or getthreadcontext or function() return 8 end,
            ["setthreadcontext"] = setthreadidentity or setthreadcontext or function() end,
            ["securecall"] = securecall or function(func, env, ...) return coroutine.wrap(func)(...) end,

            ["http_request"] = request or http_request or httprequest or function() return {Body = "", StatusCode = 404} end,
            ["isrbxactive"] = iswindowactive or isrbxactive or dummyReturnTrue,
            ["writeclipboard"] = setclipboard or toclipboard or writeclipboard or function() end,
            ["queue_on_teleport"] = queue_on_teleport or queueonteleport or function() end,
            ["firesignal"] = firesignal or function() end,
            ["getcustomasset"] = getcustomasset or getsynasset or function() return "" end,
            ["checkcaller"] = checkcaller or function() return true end -- ADICIONADO PARA EVITAR ERROS
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
        getgenv().HttpPost = function(self, url, body, contentType)
             local response = RequestFunc({ Url = url, Method = "POST", Headers = {["Content-Type"] = contentType or "application/json"}, Body = body })
            return response.Body or ""
        end

        local mt = getrawmetatable(game)
        if mt and mt.__namecall then
            local old_namecall = mt.__namecall
            if setreadonly then setreadonly(mt, false) end

            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                local args = {...}

                if checkcaller and checkcaller() then
                    if method == "HttpPost" or method == "HttpPostAsync" then
                        return getgenv().HttpPost(self, args[1], args[2])
                    end
                    if method == "HttpGet" or method == "HttpGetAsync" then
                        if tostring(args[1]):find("Upbolt/Hydroxide/commits") then
                            return '[{"commit": {"message": "Bypassed by Iris Compat"}}]'
                        end
                    end
                end
                return old_namecall(self, ...)
            end)
            if setreadonly then setreadonly(mt, true) end
        end
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

-- [8] DRAWING API POLYFILL (COM LEAK FIX E CLASSE SQUARE)
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
            local connection = nil -- Variável para prevenir Memory Leak

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
                renderObj.Font = Enum.Font.Code
                obj.Text = ""
                obj.Size = 16
                obj.Center = false
                obj.Outline = false
                obj.OutlineColor = Color3.new(0, 0, 0)
                obj.Position = Vector2.new(0, 0)

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
            end

            -- Função de remoção com Leak Fix
            obj.Remove = function()
                if connection then connection:Disconnect() end -- Desconecta o loop (Prevenção de Lag)
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

print("Iris Compat + Debug + Drawing API Loaded Successfully!")
