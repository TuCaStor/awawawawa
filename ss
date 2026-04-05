-- // IRIS COMPATIBILITY SUITE MERGED (FIXED 3.0 + MISSING FUNCTIONS + HYDROXIDE SUPPORT) // --
if not game:IsLoaded() then
    game.Loaded:Wait()
end

if not getgenv()["Iris"] then getgenv()["Iris"] = {} end

-- [1] Custom Console Wrapper
do
    if getgenv()["Iris"]["CustomConsole"] then 
        -- Já carregado
    else 
        getgenv()["Iris"]["CustomConsole"] = true 
        
        local Exploit;
        local success, Seralize = pcall(function() 
            return loadstring(game:HttpGet('https://api.irisapp.ca/Scripts/SeralizeTable.lua', true))() 
        end)
        
        if not success then Seralize = function(t) return tostring(t) end end -- Fallback caso a API falhe
        
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
                    CachedFunctions.rconsoleprint("\n")
                else
                    Args[_] = tostring(Arg) 
                end
            end
            local Coloring = select(#Args, ...)

            if not (isconsoleopen and isconsoleopen()) then
                pcall(rconsolecreate)
                local SWName, SWVer = identifyexecutor();
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
                    CachedFunctions.rconsoleprint("\n")
                else
                    Args[_] = tostring(Arg) 
                end
            end

            if #Args == 1 and Args[1]:find("@@") then
                if SynColors[Args[1]] then
                    return Args[1];
                end
                return "@@WHITE@@"
            end

            return table.concat(Args, " ")
        end

        local function DoDash(Color)
            CachedFunctions.rconsoleprint("[", "white")
            CachedFunctions.rconsoleprint("*", Color)
            CachedFunctions.rconsoleprint("] ", "white")
        end

        if Exploit == "Synapse" then
            Defaults.rconsoleprint = function(...)
                local Formatted = FormatSynData(...)
                CachedFunctions.rconsoleprint(Formatted)
            end
            Defaults.rconsolewarn = function(...)
                local Formatted = FormatSynData(...)
                CachedFunctions.rconsolewarn(Formatted)
            end
            Defaults.rconsoleerr = function(...)
                local Formatted = FormatSynData(...)
                CachedFunctions.rconsoleerr(Formatted)
            end
            Defaults.rconsoleerror = Defaults.rconsoleerr;
            Defaults.rconsoleinfo  = function(...)
                local Formatted = FormatSynData(...)
                CachedFunctions.rconsoleinfo(Formatted)
            end

        elseif Exploit == "ScriptWare" then
            Defaults.rconsoleprint = function(...)
                local Formatted = FormatData(...)
                CachedFunctions.rconsoleprint(Formatted[1], Formatted[2])
            end
            Defaults.rconsolewarn = function(...)
                local Formatted = FormatData(...)
                DoDash("yellow")
                CachedFunctions.rconsoleprint(Formatted[1], Formatted[2])
                CachedFunctions.rconsoleprint("\n")
            end
            Defaults.rconsoleerr = function(...)
                local Formatted = FormatData(...)
                DoDash("red")
                CachedFunctions.rconsoleprint(Formatted[1], Formatted[2])
                CachedFunctions.rconsoleprint("\n")
            end
            Defaults.rconsoleerror = Defaults.rconsoleerr;
            Defaults.rconsoleinfo  = function(...)
                local Formatted = FormatData(...)
                DoDash("blue")
                CachedFunctions.rconsoleprint(Formatted[1], Formatted[2])
                CachedFunctions.rconsoleprint("\n")
            end
        end

        for Cache, Literal in next, CachedFunctions do
            Cache = Literal;
        end

        for FuncName, Function in next, Defaults do
            getgenv()[tostring(FuncName)] = Function;
        end

        getgenv()["rconsolewritetable"] = function(Table)
            if typeof(Table) ~= "table" then
                return warn("You mus provide a table as the first argument!")
            end
            rconsolewarn(("Table ID: %s "):format(tostring(Table)))
            rconsoleprint(Seralize(Table) or "Failure to seralize")
            rconsoleprint("\n")
        end
    end
end

-- [2] Custom GetHui / Protect GUI
do
    if getgenv()["Iris"]["CustomGetHui"] then 
        -- Já carregado
    else 
        getgenv()["Iris"]["CustomGetHui"] = true 
        
        local IsSynapse = syn and syn.set_thread_identity and syn.is_beta and syn.protect_gui and (typeof(syn.protect_gui) == "function");
        
        local original_gethui = gethui 
        local IsGetHui = (typeof(original_gethui) == "function")

        getgenv().hidden_ui = newcclosure(function(...)
            if IsSynapse and typeof(...) == "Instance" then
                return syn.protect_gui(...);
            elseif IsGetHui then
                return original_gethui();
            end
        end)
        getgenv().gethui = hidden_ui;
        getgenv().protect_gui = hidden_ui;
        if getgenv().syn and getgenv().syn.protect_gui then
            setreadonly(getgenv().syn, false);
            getgenv().syn.protect_gui = hidden_ui;
            setreadonly(getgenv().syn, true);
        end
    end
end

-- [3] Custom Cryptography
do
    if getgenv()["Iris"]["CustomCrypt"] then 
        -- Já carregado
    else 
        getgenv()["Iris"]["CustomCrypt"] = true 

        local Crypt = getgenv()["crypt"];
        if not Crypt then 
            getgenv()["crypt"] = {} 
            Crypt = getgenv()["crypt"]
        end

        if setreadonly then 
            setreadonly(Crypt, false) 
        end

        local CryptFunctions = {
            ["base64"] = {
                ["encode"] = crypt.base64encode or (crypt.base64 and crpyt.base64.encode) or (base64 and typeof(base64) == "table" and base64.encode) or base64encode or (syn and syn.crypt.base64.encode) or function(...) return "base64encode not found in exploit environment" end,
                ["decode"] = crypt.base64decode or (crypt.base64 and crypt.base64.decode) or (base64 and typeof(base64) == "table"  and base64.decode) or base64decode or (syn and syn.crypt.base64.decode) or function(...) return "base64decode not found in exploit environment" end,
            },
            ["custom"] = {
                ["hash"]    = crypt.hash or (crypt.custom and crypt.custom.hash) or (syn and syn.crypt.custom.hash) or function(...) return "hash not found in exploit environment" end,
                ["encrypt"] = crypt.encrypt or (crypt.custom and crypt.custom.encrypt) or (syn and syn.crypt.custom.encrypt) or function(...) return "encrypt not found in exploit environment" end,
                ["decrypt"] = crypt.decrypt or (crypt.custom and crypt.custom.decrypt) or (syn and syn.crypt.custom.decrypt) or function(...) return "decrypt not found in exploit environment" end,
            },
            ["lz4compress"]   = crypt.lz4compress or (crypt.lz4 and crypt.lz4.compress) or (syn and syn.crypt.lz4.compress) or function(...) return "lz4compress not found in exploit environment" end,
            ["lz4decompress"] = crypt.lz4decompress or (crypt.lz4 and crypt.lz4.decompress) or (syn and syn.crypt.lz4.decompress) or function(...) return "lz4decompress not found in exploit environment" end,
        }

        for FunctionName, Function in next, CryptFunctions do
            getgenv()["crypt"][FunctionName] = Function;
            getgenv()["syn_"..FunctionName] = Function;
        end

        local GodDamnSyn = {
            ["syn_crypt_encrypt"] = crypt.custom.encrypt,
            ["syn_crypt_hash"] = crypt.custom.hash,
            ["syn_crypt_decrypt"] = crypt.custom.decrypt,
            ["syn_crypt_b64_decode"] = crypt.base64.decode,
            ["syn_crypt_b64_encode"] = crypt.base64.encode
        }

        for FunctionName, Function in next, GodDamnSyn do
            getgenv()[FunctionName] = Function;
        end
    end
end

-- [4] Custom WebSocket
do
    if not getgenv()["WebSocket"] then getgenv()["WebSocket"] = {} end

    if getgenv()["Iris"]["CustomSocket"] then 
        -- Já carregado
    else 
        getgenv()["Iris"]["CustomSocket"] = true 
        
        if setreadonly then setreadonly(getgenv()["WebSocket"], false) end

        local SocketFuncs = {
            ["ClassName"] = "WebSocket",

            ["Send"] = WebSocket.send or syn_websocket_send or websocketsend or websocket_send or function(...) return "Send not found in exploit environment." end,
            ["Close"] = WebSocket.close or syn_websocket_close or websocketclose or websocket_close or function(...) return "Close not found in exploit environment." end,
            ["Connect"] = WebSocket.Connect or syn_websocket_connect or websocketconnect or websocket_connect or function(...) return "Connect not found in exploit environment." end,

            ["connect"] = WebSocket.connect or syn_websocket_connect or websocketconnect or websocket_connect or function(...) return "connect not found in exploit environment." end,
            ["send"] = WebSocket.send or syn_websocket_send or websocketsend or websocket_send or function(...) return "send not found in exploit environment." end,
            ["close"] = WebSocket.close or syn_websocket_close or websocketclose or websocket_close or function(...) return "close not found in exploit environment." end,
        }

        for FunctionName, Function in next, SocketFuncs do
            getgenv()["WebSocket"][FunctionName] = Function;
            getgenv()["syn_"..FunctionName] = Function;
        end

        local GodDamnSyn = {
            ["syn_websocket_close"] = WebSocket.close,
            ["syn_websocket_connect"] = WebSocket.connect,
            ["syn_websocket_send"] = WebSocket.send,
        }

        for FunctionName, Function in next, GodDamnSyn do
            getgenv()[FunctionName] = Function;
        end
    end
end

-- [5] Iris Script Base / Compatibility Layer
do
    if getgenv()["Iris"]["IrisCompat"] then 
        -- Já carregado
    else 
        getgenv()["Iris"]["IrisCompat"] = true 

        local LoadStrings = {
            "IrisBetterConsole.lua",
            "IrisHiddenUiFix.lua",
            "IrisCryptLibraryFix.lua",
            "IrisWebSocketFix.lua"
        }

        for _, ExternalScript in next, LoadStrings do
            pcall(function()
                loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/"..ExternalScript))();
            end)
        end

        if rawget(getgenv(), "syn") then
            for FuncName, Function in next, syn do
                getgenv()[FuncName] = getgenv()["syn"][FuncName]
            end
        else
            getgenv()["syn"] = {};
        end

        local Functions = {
            --// Meta Table Functions \\--
            ["getrawmetatable"] = get_raw_metatable or getrawmetatable or function(...) return "getrawmetatable was not found in exploit environment" end,
            ["setrawmetatable"] = set_raw_metatable or setrawmetatable or function(...) return "setrawmetatable was not found in exploit environment" end,
            ["setreadonly"] = setreadonly or make_readonly or makereadonly or function(...) return "setreadonly was not found in exploit environment" end,
            ["iswriteable"] = iswriteable or writeable or is_writeable or function(...) return "iswriteable was not found in exploit environment" end,

            --// Mouse Inputs \\--
            ["mouse1release"] = mouse1release or syn_mouse1release or m1release or m1rel or mouse1up or function(...) return "mouse1release was not found in exploit environment" end,
            ["mouse1press"] = mouse1press or mouse1press or m1press or mouse1click or function(...) return "mouse1press was not found in exploit environment" end,
            ["mouse2release"] = mouse2release or syn_mouse2release or m2release or m1rel or mouse2up or function(...) return "mouse2release was not found in exploit environment" end,
            ["mouse2press"] = mouse2press or mouse2press or m2press or mouse2click or function(...) return "mouse2press was not found in exploit environment" end,

            --// IO Functions \\--
            ["isfolder"] = isfolder or syn_isfolder or is_folder or function(...) return "isfolder was not found in exploit environment" end,
            ["isfile"] = isfile or syn_isfile or is_file or function(...) return "isfile was not found in exploit environment" end,
            ["delfolder"] = delfolder or syn_delsfolder or del_folder or function(...) return "delfolder was not found in exploit environment" end,
            ["delfile"] = delfile or syn_delfile or del_file or function(...) return "delfile was not found in exploit environment" end,
            ["deletefile"] = delfile or syn_delfile or del_file or removefile or function(...) return "deletefile was not found in exploit environment" end, 
            ["appendfile"] = appendfile or syn_io_append or append_file or function(...) return "appendfile was not found in exploit environment" end,
            ["makefolder"] = makefolder or make_folder or createfolder or create_folder or function(...) return "makefolder was not found in exploit environment" end,

            --// Environment Manipulation Functions \\--
            ["hookfunction"] = hookfunction or hookfunc or detour_function or function(...) return "hookfunction was not found in exploit environment" end,
            ["hookmetamethod"] = hookmetamethod or hook_meta_method or function(...) return "hookmetamethod was not found in exploit environment" end,
            ["islclosure"] = islclosure or is_lclosure or isluaclosure or function(...) return "islclosure was not found in exploit environment" end,
            ["iscclosure"] = iscclosure or is_cclosure or function(...) return "iscclosure was not found in exploit environment" end,
            ["newcclosure"] = newcclosure or new_cclosure or function(...) return "newcclosure was not found in exploit environment" end,
            ["cloneref"] = clonereference or cloneref or function(...) return "cloneref was not found in exploit environment" end,
            ["getconnections"] = getconnections or get_connections or get_signal_cons or function(...) return "getconnections was not found in exploit environment" end,
            ["getnamecallmethod"] = getnamecallmethod or get_namecall_method or function(...) return "getconnections was not found in exploit environment" end,
            ["setnamecallmethod"] = setnamecallmethod or set_namecall_method or function(...) return "getconnections was not found in exploit environment" end,

            --// Instance Functions \\--
            ["getnilinstances"] = getnilinstances or get_nil_instances or function(...) return "getnilinstances was not found in exploit environment" end,
            ["getproperties"] = getproperties or get_properties or function(...) return "getproperties was not found in exploit environment" end,
            ["fireclickdetector"] = fireclickdetector or fire_click_detector or function(...) return "fireclickdetector was not found in exploit environment" end,
            ["gethiddenproperties"] = gethiddenproperties or get_hidden_properties or gethiddenprop or get_hidden_prop or function(...) return "gethiddenproperties was not found in exploit environment" end,
            ["sethiddenproperties"] = sethiddenproperties or set_hidden_properties or sethiddenprop or set_hidden_prop or function(...) return "sethiddenproperties was not found in exploit environment" end,
            ["getscripts"] = getrunningscripts or getscripts or get_running_scripts or get_scripts or function(...) return "getscripts was not found in exploit environment" end,

            --// Network Functions \\--
            ["setsimulationradius"] = setsimradius or set_simulation_radius or setsimulationradius or function(...) return "setsimulationradius was not found in exploit environment" end,
            ["getsimulationradius"] = getsimradius or get_simulation_radius or getsimulationradius or function(...) return "getsimulationradius was not found in exploit environment" end,
            ["isnetworkowner"] = isnetowner or isnetworkowner or is_network_owner or isnetworkowner or function(...) return "isnetworkowner was not found in exploit environment" end, 

            --// Script Methods \\--
            ["getthreadcontext"] = getthreadcontext or get_thread_context or getthreadidentity or get_thread_identity or function(...) return "getthreadcontext was not found in exploit environment" end,
            ["setthreadcontext"] = setthreadcontext or set_thread_context or setthreadidentity or set_thread_identity  or function(...) return "setthreadcontext was not found in exploit environment" end,
            ["getcallingscript"] = getcallingscript or get_calling_script or function(...) return "getcallingscript was not found in exploit environment" end,
            ["getscriptclosure"] = getscriptclosure or function(...) return "getscriptclosure was not found in exploit environment" end,
            ["securecall"] = KRNL_SAFE_CALL or securecall or secure_call or function(...) return "securecall was not found in exploit environment" end,

            --// Misc Functions \\--
            ["http_request"] = http_request or request or httprequest or function(...) return "http_request was not found in exploit environment" end,
            ["isluau"] = function() return true end,
            ["isrbxactive"] = iswindowactive or isrbxactive or function(...) return "isrbxactive was not found in exploit environment" end, 
            ["writeclipboard"] = write_clipboard or writeclipboard or setclipboard or set_clipboard or function(...) return "writeclipboard was not found in exploit environment" end,
            ["queue_on_teleport"] = queue_on_teleport or queueonteleport or function(...) return "queue_on_teleport was not found in exploit environment" end,
            ["is_exploit_function"] = is_synapse_function or iskrnlclosure or isourclosure or isexecutorclosure or is_sirhurt_closure or issentinelclosure or is_protosmasher_closure or function(...) return "is_exploit_function was not found in exploit environment" end,
            ["firesignal"] = fire_signal or firesignal or function(...) return "firesignal was not found in exploit environment" end,
            ["getcustomasset"] = getcustomasset or getsynasset or function(...) return  "customasset was not found in exploit environment" end
        }

        for FuncName, Function in next, Functions do
            getgenv()[FuncName] = Function;
        end

        if not (type(Functions["setreadonly"]) == "string" and type(Functions["setrawmetatable"]) == "string") then 
            Functions["setreadonly"](getgenv().syn, false)

            Functions["setrawmetatable"](getgenv().syn, {
                __index = function(OriginalEnv, Element)
                    return getgenv()[Element];
                end,
            })
            Functions["setreadonly"](getgenv().syn, true)
        end

        local SynIsGoingToMakeMeCry = {
            ["syn_checkcaller"] = checkcaller,
            ["syn_clipboard_set"] = clipboard_set or setclipboard,
            ["syn_context_get"] = context_get or getthreadcontext,
            ["syn_context_set"] = context_set or setthreadcontext,
            ["syn_decompile"] = decompile,
            ["syn_getcallingscript"] = getcallingscript,
            ["syn_getgc"] = getgc,
            ["syn_getgenv"] = getgenv,
            ["syn_getinstances"] = getinstances,
            ["syn_getloadedmodules"] = getloadedmodules,
            ["syn_getmenv"] = getmenv,
            ["syn_getreg"] = getreg,
            ["syn_getrenv"] = getrenv,
            ["syn_getsenv"] = getsenv,
            ["syn_io_append"] = appendfile,
            ["syn_io_delfile"] = delfile,
            ["syn_io_delfolder"] = delfolder,
            ["syn_io_isfile"] = isfile,
            ["syn_io_isfolder"] = isfolder,
            ["syn_io_listdir"] = listdir,
            ["syn_io_makefolder"] = makefolder,
            ["syn_io_read"] = read or readfile,
            ["syn_io_write"] = write or writefile,
            ["syn_isactive"] = isactive,
            ["syn_islclosure"] = islclosure,
            ["syn_keypress"] = keypress,
            ["syn_keyrelease"] = keyrelease,
            ["syn_mouse1click"] = mouse1click,
            ["syn_mouse1press"] = mouse1press,
            ["syn_mouse1release"] = mouse1release,
            ["syn_mouse2click"] = mouse2click,
            ["syn_mouse2press"] = mouse2press,
            ["syn_mouse2release"] = mouse2release,
            ["syn_mousemoveabs"] = mousemoveabs,
            ["syn_mousemoverel"] = mousemoverel,
            ["syn_mousescroll"] = mousescroll,
            ["syn_newcclosure"] = newcclosure,
            ["syn_setfflag"] = setfflag,
        }

        for FunctionName, Function in next, SynIsGoingToMakeMeCry do
            getgenv()[FunctionName] = Function;
        end
    end
end

-- [6] FINAL FORCE FIXES
do
    if not getgenv()["rconsoleinfo"] then
        getgenv()["rconsoleinfo"] = function(msg)
            local print_func = getgenv().rconsoleprint or print
            pcall(function() print_func("@@BLUE@@") end) 
            pcall(function() print_func("blue") end)
            print_func("[INFO] " .. tostring(msg) .. "\n")
            pcall(function() print_func("@@WHITE@@") end)
            pcall(function() print_func("white") end)
        end
    end

    if not getgenv()["deletefile"] then
        getgenv()["deletefile"] = getgenv().delfile or getgenv().removefile or function(file)
            warn("deletefile: Função não suportada pelo seu executor (" .. tostring(file) .. ")")
        end
    end
end

-- [7] HTTP & HYDROXIDE FIXES (Novo - Anti-Crash Hook)
do
    -- Identifica a função de request
    local RequestFunc = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    
    if RequestFunc then
        -- Define game:HttpPost e game:HttpPostAsync globalmente
        local function DefineHttpPost()
            getgenv().HttpPost = function(self, url, body, contentType)
                 local response = RequestFunc({
                    Url = url,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = contentType or "application/json"
                    },
                    Body = body
                })
                return response.Body or ""
            end
        end
        DefineHttpPost()

        -- Hook no Namecall para compatibilidade com scripts que usam game:HttpPost() e para Bypass do Hydroxide
        local mt = getrawmetatable(game)
        local old_namecall = mt.__namecall
        if setreadonly then setreadonly(mt, false) end

        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}

            -- Só executa a modificação se o script for do Executor (Evita crashes do jogo)
            if checkcaller() then
                
                -- [Fix 1] HttpPost Implementation
                if method == "HttpPost" or method == "HttpPostAsync" then
                    local response = RequestFunc({
                        Url = args[1],
                        Method = "POST",
                        Headers = {["Content-Type"] = "application/json"},
                        Body = args[2]
                    })
                    return response.Body or ""
                end

                -- [Fix 2] Hydroxide Version Check Bypass (JSON Fix)
                if method == "HttpGet" or method == "HttpGetAsync" then
                    local url = tostring(args[1])
                    if url:find("Upbolt/Hydroxide/commits") then
                        return '[{"commit": {"message": "Bypassed by Iris Compat"}}]'
                    end
                end
            end

            return old_namecall(self, ...)
        end)

        if setreadonly then setreadonly(mt, true) end
    end
end

print("Iris Compatibility Suite Loaded Successfully!")
