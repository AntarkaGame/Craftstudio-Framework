do

    local camera2D = AK.Cam2D
    camera2D.__index = camera2D
    
    local CheckScript = function(gameObject)
        local ScriptedBehavior = gameObject:GetComponent("ScriptedBehavior")
        local Asset
        do local Craft = CS
            Asset = Craft.FindAsset( "Data/AKInScript/Button" , "Script" )
        end
        
        if ScriptedBehavior == nil then
            gameObject:CreateScriptedBehavior( Asset , nil ) 
        end
        
        return true
    end
    
    local CSSCallAction 
    local CSSubAction
    local CSSCut = {
        ["text"] = function(object,value,primary) 
            primary = primary or false
            local compx = object.behavior
            if type(value) == "string" then 
                primary = primary or false
                if object.textRenderer ~= nil then
                    if primary and compx ~= nil then
                        compx.actu_text = value
                    end
                    object.textRenderer:SetText( value ) 
                else
                    local child = object:GetChildren()
                    if #child == 1 then
                        local child_object = child[1] 
                        if child_object.textRenderer ~= nil then
                            if primary and compx ~= nil  then
                                compx.actu_text = value
                            end
                            child_object.textRenderer:SetText( value ) 
                        end
                    end
                end
            elseif type(value) == "table" then
                if not primary then
                    local tablevalue 
                    local comp 
                    
                    if object.textRenderer ~= nil then
                        comp = true
                    end
                    
                    if tablevalue == nil then
                        if comp then 
                            if object.textRenderer:GetText() == value[2] then tablevalue = value[1] elseif object.textRenderer:GetText() == value[1] then tablevalue = value[2] else tablevalue = value[1] end 
                        else
                            local child = object:GetChildren()[1]
                            if child.textRenderer:GetText() == value[2] then tablevalue = value[1] elseif child.textRenderer:GetText() == value[1] then tablevalue = value[2] else tablevalue = value[1] end 
                        end
                    end
                    
                    if comp then
                        if primary and compx ~= nil then
                            object.behavior.actu_text = tablevalue
                        end
                        object.textRenderer:SetText( tablevalue ) 
                    else
                        local child = object:GetChildren()
                        if #child == 1 then
                            local child_object = child[1] 
                            if child_object.textRenderer ~= nil then
                                if primary and comp ~= nil then
                                    object.behavior.actu_text = tablevalue
                                end
                                child_object.textRenderer:SetText( tablevalue ) 
                            end
                        end
                    end
                end
            end
        end,
        ["text_scale"] = function(object,value,primary) 
            primary = primary or false
            local comp = object:GetComponent("ScriptedBehavior")
            if type(value) == "string" then 
                local str = string
                local _,_,a,b,c = str.find(value, '([%d%p]*)[%s]([%d%p]*)[%s]([%d%p]*)')
                
                if object.textRenderer ~= nil then
                    local scale = object.Scale
                    a = tonumber(a) or scale.x
                    b = tonumber(b) or scale.y
                    c = tonumber(c) or scale.z 
                    if a > 1 then a = a / 100 elseif a < 0 then a = 0 end
                    if b > 1 then b = b / 100 elseif b < 0 then b = 0 end
                    if c > 1 then c = c / 100 elseif c < 0 then c = 0 end
                    
                    local V3 = Vector3
                    if primary and comp ~= nil then
                        comp.scale = V3:New( a , b , c )
                    end
                    object.transform:SetLocalScale( V3:New( a , b , c ) )
                else
                    local child = object:GetChildren()
                    if #child == 1 then
                        local child_object = child[1] 
                        local scale = child_object.Scale
                        a = tonumber(a) or scale.x
                        b = tonumber(b) or scale.y
                        c = tonumber(c) or scale.z 
                        if a > 1 then a = a / 100 elseif a < 0 then a = 0 end
                        if b > 1 then b = b / 100 elseif b < 0 then b = 0 end
                        if c > 1 then c = c / 100 elseif c < 0 then c = 0 end
                        if child_object.textRenderer ~= nil then
                            local V3 = Vector3
                            if primary and comp ~= nil then
                                comp.scale = V3:New( a , b , c )
                            end
                            child_object.transform:SetLocalScale( V3:New( a , b , c ) )
                        end
                    end
                end
            elseif type(value) == "number" then
                if value > 1 then value = value / 100 elseif value < 0 then value = 0 end
                if object.textRenderer ~= nil then
                    local V3 = Vector3
                    if primary and comp ~= nil then
                        comp.scale = V3:New( value )
                    end
                    object.transform:SetLocalScale( V3:New( value ) )
                else
                    local child = object:GetChildren()
                    if #child == 1 then
                        local child_object = child[1] 
                        if child_object.textRenderer ~= nil then
                            local V3 = Vector3
                            if primary and comp ~= nil then
                                comp.scale = V3:New( value )
                            end
                            child_object.transform:SetLocalScale( V3:New( value ) )
                        end
                    end
                end
            end
        end,
        ["text_opacity"] = function(object,value,primary) 
            primary = primary or false
            local comp = object:GetComponent("ScriptedBehavior")
            if type(value) == "number" then 
                if object.textRenderer ~= nil then
                    if primary and comp ~= nil then
                        comp.text_opacity = value
                    end
                    object.textRenderer:SetOpacity( value ) 
                else
                    local child = object:GetChildren()
                    if #child == 1 then
                        local child_object = child[1] 
                        if child_object.textRenderer ~= nil then
                            if primary and comp ~= nil then
                                comp.text_opacity = value
                            end
                            child_object.textRenderer:SetOpacity( value ) 
                        end
                    end
                end
            end
        end,
        ["font"] = function(object,value,primary) 
            primary = primary or false
            local comp = object.behavior
            local Craft =  CS
            if object.textRenderer ~= nil then
                if primary and comp ~= nil then
                    object.behavior.font = Craft.FindAsset( value )
                end
                object.textRenderer:SetFont( Craft.FindAsset( value ) ) 
            else
                local child = object:GetChildren()
                if #child == 1 then
                    local child_object = child[1] 
                    if child_object.textRenderer ~= nil then
                        if primary and comp ~= nil then
                            comp.font = Craft.FindAsset( value )
                        end
                        child_object.textRenderer:SetFont( Craft.FindAsset( value ) ) 
                    end
                end
            end
        end,
        ["align"] = function(object,value,primary) 
            primary = primary or false
            local comp = object:GetComponent("ScriptedBehavior")
            local var
            if value == "left" then
                var = TextRenderer.Alignment.Left
            elseif value == "right" then
                var = TextRenderer.Alignment.Right
            else
                var = TextRenderer.Alignment.Center
            end
            if object.textRenderer ~= nil then
                if primary and comp ~= nil then
                    comp.align = var
                end
                object.textRenderer:SetAlignment( var ) 
            else
                local child = object:GetChildren()
                if #child == 1 then
                    local child_object = child[1] 
                    if child_object.textRenderer ~= nil then
                        if primary and comp ~= nil then
                            comp.align = var
                        end
                        child_object.textRenderer:SetAlignment( var ) 
                    end
                end
            end
        end,
        ["scale"] = function(object,value,primary) 
            primary = primary or false
            local comp = object:GetComponent("ScriptedBehavior")
            if type(value) == "string" then
                local _,_,a,b,c = string.find(value, '([%d%p]*)[%s]([%d%p]*)[%s]([%d%p]*)')
                local scale = object.Scale
                a = tonumber(a) or scale.x
                b = tonumber(b) or scale.y
                c = tonumber(c) or scale.z 
                if a > 1 then a = a / 100 elseif a < 0 then a = 0 end
                if b > 1 then b = b / 100 elseif b < 0 then b = 0 end
                if c > 1 then c = c / 100 elseif c < 0 then c = 0 end
                local V3 = Vector3
                if primary and comp ~= nil then
                    comp.scale = V3:New( a , b , c )
                end
                object.transform:SetLocalScale( V3:New( a , b , c ) )
            elseif type(value) == "number" then
                if value > 1 then value = value / 100 elseif value < 0 then value = 0 end
                local V3 = Vector3
                if primary and comp ~= nil then
                    comp.scale = V3:New( value )
                end
                object.transform:SetLocalScale( V3:New( value ) ) 
            elseif type(value) == "table" then
                value = value or {}
                value[1] = value[1] or 1
                value[2] = value[2] or 1
                value[3] = value[3] or 1 
                
                -- On vérifie les valeurs
                if value[1] > 1 then value[1] = value[1] / 100 elseif value[1] < 0 then value[1] = 0 end
                if value[2] > 1 then value[2] = value[1] / 100 elseif value[2] < 0 then value[2] = 0 end
                if value[3] > 1 then value[3] = value[1] / 100 elseif value[3] < 0 then value[3] = 0 end
                
                local V3 = Vector3
                if primary and comp ~= nil then
                    comp.scale = V3:New( unpack(value) )
                end
                object.transform:SetLocalScale( V3:New( unpack(value) ) ) 
            end
        end,
        ["model"] = function(object,value,primary) 
            primary = primary or false
            local comp = object:GetComponent("ScriptedBehavior")
            local Craft = CS
            if object.modelRenderer ~= nil then 
                if primary and comp ~= nil then
                    comp.model = Craft.FindAsset( value , "Model" )
                end
                object.modelRenderer:SetModel( Craft.FindAsset( value , "Model" ) ) 
            end
        end,
        ["opacity"] = function(object,value,primary) 
            primary = primary or false
            local comp = object:GetComponent("ScriptedBehavior")
            value = tonumber(value)
            if type(value) == "number" then
                local component 
                if object.modelRenderer ~= nil then
                    component = object.modelRenderer
                elseif object.mapRenderer ~= nil then
                    component = object.mapRenderer
                elseif object.textRenderer ~= nil then
                    component = object.textRenderer
                end
                
                if primary and comp ~= nil then
                    comp.opacity = value
                end
                component:SetOpacity( value ) 
            end
        end,
        ["zindex"] = function(object,value,primary)
            primary = primary or false
            if type(value) == "number" then
                if value >= 0 and value <= 150 then
                    AK.UI:Zindex(object.Name,value,true)
                end
            elseif type(value) == "string" then
                if value == "inherit" then
                    local parent = object:GetParent()
                    if parent ~= nil then
                        AK.UI:Zindex(object.Name,parent.Pos.z,true)
                    end
                end
            end
        end,
        ["show"] = function(object,value)
            if type(value) == "number" then
                AK.UI:Show(object.Name,value)
            elseif type(value) == "table" then
                value[1] = value[1] or 1
                AK.UI:Show(object.Name,value[1],value[2])
            elseif type(value) == "string" then
                local str = string
                local _,_,a,b = str.find(value, '([%a%d%p]*)[%s]?([%a%d%p]*)')
                a = a or 1
                AK.UI:Show(object.Name,a,b)
            end
        end,
        ["hide"] = function(object,value)
            if type(value) == "number" then
                AK.UI:Hide(object.Name,value)
            elseif type(value) == "table" then
                value[1] = value[1] or 0
                AK.UI:Hide(object.Name,value[1],value[2])
            elseif type(value) == "string" then
                local str = string
                local _,_,a,b = str.find(value, '([%a%d%p]*)[%s]?([%a%d%p]*)')
                a = a or 0
                AK.UI:Hide(object.Name,a,b)
            end
        end,
        ["atob"] = function(object,value)
            if type(value) == "string" then
                local str = string
                local _,_,a,b = str.find(value, '([%a%d%p]*)[%s]?([%a%d%p]*)')
                
                if a ~= nil then
                    if b == nil or b == "" then 
                        AK.UI:AtoB(object.Name,a,false)
                    else
                        AK.UI:AtoB(a,b,false)
                    end
                end
            elseif type(value) == "table" then
                
            end
        end,
        ["button_reset"] = function(object,value)
            if type(value) == "boolean" then
                local comp = object.behavior
                if value then
                    comp.default_value = true
                elseif not value then
                    comp.default_value = false
                end
            end
        end,
        ["only_reset"] = function(object,value)
            if type(value) == "table" then
                local comp = object.behavior
                if comp ~= nil then 
                    comp.only_reset = {unpack(value)}
                end
            end
        end,
        ["dont_reset"] = function(object,value)
            if type(value) == "table" then
                local comp = object.behavior
                if comp ~= nil then 
                    comp.dont_reset = {unpack(value)}
                end
            end
        end,
        
        -- > Timer
        ["timer"] = function(object,value)
            if type(value) == "table" then
                if value[1] ~= nil then
                    value[1] = tonumber(value[1])
                    if type(value[2]) == "function" then
                        value[3] = value[3] or false
                        local ma = math
                        local random = ma.random(1,1000)
                        local name = "timer"..random
                        Declare(name,Timer:New(value[1]*60,value[3],true,value[2]) )
                        AK.TaskList:Add(name,{value[1]*60},function(Table)
                            _G[Table.item]()
                        end)
                    end
                end
            end
        end,
        ["escape"] = function(object,value)
            if type(value) == "string" then
                local comp = object:GetScriptedBehavior( CS.FindAsset( "Data/AKInScript/Cam2D_Container" ) ) 
                if comp ~= nil then
                    local sub = string.sub
                    local key = sub(object.Name,11)
                    AK.UI.Module[key]["Escape"] = value
                    comp.Escape = value
                end
            elseif type(value) == "function" then
                local comp = object:GetScriptedBehavior( CS.FindAsset( "Data/AKInScript/Cam2D_Container" ) ) 
                if comp ~= nil then
                    local sub = string.sub
                    local key = sub(object.Name,11)
                    AK.UI.Module[key]["Escape_function"] = value
                end
            elseif type(value) == "table" then 
                --[[local search = pairs
                for k,v in search(CSSubAction) do    
                    for a,b in search(value) do
                        if a == k then
                        
                                v(object,b)
                                
                        end
                    end
                end ]]
            end
        end,
        ["SwitchIn"] = function(object,value)
            if type(value) == "function" then
                local comp = object:GetScriptedBehavior( CS.FindAsset( "Data/AKInScript/Cam2D_Container" ) ) 
                if comp ~= nil then
                    local sub = string.sub
                    local key = sub(object.Name,11)
                    AK.UI.Module[key]["Switch_IN"] = value
                end
            end
        end,
        ["SwitchOut"] = function(object,value)
            if type(value) == "function" then
                local comp = object:GetScriptedBehavior( CS.FindAsset( "Data/AKInScript/Cam2D_Container" ) ) 
                if comp ~= nil then
                    local sub = string.sub
                    local key = sub(object.Name,11)
                    print("Apply out")
                    AK.UI.Module[key]["Switch_OUT"] = value
                end
            end
        end
    }
    
    -- > Sub Action stylesheets
    CSSubAction = {
        ["echo"] = function(object,value) 
            local echo = tostring(value) 
            if echo == "pos" then
                echo = object.Pos
            elseif echo == "scale" then
                echo = object.Scale
            end
            printx = print
            printx(echo)
        end,
        ["escape"] = CSSCut["escape"],
        ["SwitchIn"] = CSSCut["SwitchIn"],
        ["SwitchOut"] = CSSCut["SwitchOut"],
        ["play"] = function(object,value)
            if type(value) == "string" then 
                if value == "this" then
                    if AK.UI:StateAnim(object.Name) then 
                        AK.UI:Anim(object.Name)
                    end
                else
                    if AK.UI:StateAnim(value) then 
                        AK.UI:Anim(value)
                    end
                end
            elseif type(value) == "table" then
                for i=1,#value do 
                    if value[i] == "this" then
                        if AK.UI:StateAnim(object.Name) then 
                            AK.UI:Anim(object.Name)
                        end
                    else
                        if AK.UI:StateAnim(value[i]) then 
                            AK.UI:Anim(value[i])
                        end
                    end
                end
            end
        end,
        ["url"] = function(object,value)
            if type(value) == "string" then 
                local Craft = CS
                Craft.Web.Open( value ) 
            end
        end,
        ["redirect"] = function(object,value)
            if type(value) == "string" then 
                local Craft = CS
                Craft.Web.Redirect( value ) 
            end
        end,
        ["get"] = function(object,value)
            if type(value) == "table" then 
                if value[1] ~= nil then
                    local Craft = CS
                    local comp 
                    value[3] = value[3] or "json"
                    value[4] = value[4] or Nil
                    if value[3] == "text" then
                        comp = Craft.Web.ResponseType.Text
                    elseif value[3] == "json" then
                        comp =  Craft.Web.ResponseType.Json
                    end
                    Craft.Web.Get( value[1] , value[2] , comp , value[4] ) 
                end
            end
        end,
        ["post"] = function(object,value)
            if type(value) == "table" then 
                if value[1] ~= nil then
                    local Craft = CS
                    local comp 
                    value[3] = value[3] or "json"
                    value[4] = value[4] or Nil
                    if value[3] == "text" then
                        comp = Craft.Web.ResponseType.Text
                    elseif value[3] == "json" then
                        comp =  Craft.Web.ResponseType.Json
                    end
                    Craft.Web.Post( value[1] , value[2] , comp , value[4] ) 
                end
            end
        end,
        ["stop"] = function(object,value,primary,index)
            primary = primary or false
            if type(value) == "string" then 
                local Craft = CS
                local T = table
                if value == "this" then 
                    if AK.UI:StateAnim(object.Name) and AK.UI.LerpTab[object.Name].state then
                        AK.UI:Anim(object.Name)
                        T.remove( object.behavior.OnNextCallback , index ) 
                    end
                else
                    if AK.UI:StateAnim(value) and AK.UI.LerpTab[value].state then
                        AK.UI:Anim(value)
                        local item = Craft.Get(value)
                        T.remove( item.behavior.OnNextCallback , index ) 
                    end
                end
            elseif type(value) == "table" then
                local Craft = CS
                local T = table
                for i=1,#value do 
                    if value[i] == "this" then
                        if AK.UI:StateAnim(object.Name) and not AK.UI.LerpTab[object.Name].state then 
                            AK.UI:Anim(object.Name)
                            T.remove( object.behavior.OnNextCallback , index ) 
                        end
                    else
                        if AK.UI:StateAnim(value[i]) and not AK.UI.LerpTab[value].state then 
                            AK.UI:Anim(value[i])
                            local item = Craft.Get(value[i])
                            T.remove( item.behavior.OnNextCallback , index ) 
                        end
                    end
                end
            end
        end,
        ["switch"] = function(object,value)
            if type(value) == "string" then
                local str = string.find
                local _,_,a,b = str(value, '([%a%d%p]*)[%s]?([%a%d%p]*)')
                local result = {a,b}
                if #result == 1 then
                    AK.UI:Switch(value) 
                elseif #result == 2 then
                    if AK.UI.ModuleActive == a then
                        AK.UI:Switch(b)
                    elseif AK.UI.ModuleActive == b then
                        AK.UI:Switch(a)
                    else
                        AK.UI:Switch(a)
                        -- do nothing 
                        
                    end
                end
            end
        end,
        ["append"] = function(object,value)
            if type(value) == "string" then
                local Craft = CS
                local asset = Craft.FindAsset( value , "Scene" ) 
                if asset ~= nil then 
                    Craft.LoadScene( asset ) 
                end
            end
        end,
        ["load"] = function(object,value)
            if type(value) == "string" then
                local Craft = CS
                local asset = Craft.AppendScene( value , "Scene" ) 
                if asset ~= nil then 
                    Craft.AppendScene( asset ) 
                end
            end
        end,
        ["instantiate"] = function(object,value)
            if type(value) == "table" then
                local Craft = CS
                value = value or {}
                local asset = Craft.FindAsset( value[2] , "Scene" ) 
                if asset ~= nil then
                    AK.UI[value[1]] = Craft.Instantiate( value[1].."_key" , asset ) 
                end
            end
        end,
        ["destroy"] = function(object,value)
            if type(value) == "string" then
                if AK.UI[value] ~= nil then
                    local Craft = CS
                    Craft.Destroy( AK.UI[value] ) 
                    AK.UI[value] = nil
                end
            end
        end,
        ["exit"] = function(object,value)
            local Craft = CS
            if type(value) == "boolean" then
                if value then
                    Craft.Exit()
                end
            elseif type(value) == "table" then
                value = value or {}
                value[1] = value[1] or true
                value[2] = value[2] or Nil 
                if value[1] then
                    value[2]()
                    Craft.Exit()
                end
            end
        end,
        ["next"] = function(object,value) 
            if type(value) == "table" then
                local search = pairs
                for k,v in search(CSSubAction) do    
                    for a,b in search(value) do
                        if a == k then
                            object:OnNext( function( gameObject , this, index )
                                v(object,b,false,index)
                            end ) 
                        end
                    end
                end
            elseif type(value) == "function" then
                object:OnNext( value ) 
            end
        end,
        ["atob"]        = CSSCut["atob"],
        ["timer"]       = CSSCut["timer"],
        ["show"]        = CSSCut["show"],
        ["hide"]        = CSSCut["hide"],
        ["zindex"]      = CSSCut["zindex"],
        ["scale"]       = CSSCut["scale"],
        ["model"]       = CSSCut["model"],
        ["opacity"]     = CSSCut["opacity"],
        ["text"]        = CSSCut["text"],
        ["font"]        = CSSCut["font"],
        ["align"]       = CSSCut["align"],
        ["text_scale"]      = CSSCut["text_scale"],
        ["text_opacity"]    = CSSCut["text_opacity"],
        ["button_resetset"]       = CSSCut["button_reset"]
    }
    
    -- > CSS Callable Action
    CSSCallAction = {
        ["onclick"] = function(object,value) 
            CheckScript(object)
            if type(value) == "table" then
                local search = pairs
                for k,v in search(CSSubAction) do    
                    for a,b in search(value) do
                        if a == k then
                            object:OnClick( function()
                                v(object,b)
                                
                            end ) 
                        end
                    end
                end
            elseif type(value) == "function" then
                object:OnClick( value ) 
            end
        end,
        ["onchoice"] = function(object,value) 
            if type(value) == "function" then
                object:OnChoice( value )
            end
        end,
        ["outclick"] = function(object,value) 
            CheckScript(object)
            if type(value) == "table" then
                local search = pairs
                for k,v in search(CSSubAction) do    
                    for a,b in search(value) do
                        if a == k then
                            object:OutClick( function()
                                v(object,b)
                                
                            end ) 
                        end
                    end
                end
            elseif type(value) == "function" then
                object:OutClick( value ) 
            end
        end,
        ["onfocus"] = function(object,value) 
        end,
        ["outfocus"] = function(object,value) 
        end,
        ["onhover"] = function(object,value) 
            CheckScript(object)
            if type(value) == "table" then
                local search = pairs
                for k,v in search(CSSubAction) do    
                    for a,b in search(value) do
                        if a == k then
                            object:OnHover( function()
                                v(object,b)
                            end ) 
                        end
                    end
                end
            elseif type(value) == "function" then
                object:OnHover( value ) 
            end
        end,
        ["outhover"] = function(object,value) 
            CheckScript(object)
            if type(value) == "table" then
                local search = pairs
                for k,v in search(CSSubAction) do    
                    for a,b in search(value) do
                        if a == k then
                            object:OutHover( function()
                                v(object,b)
                            end ) 
                        end
                    end
                end
            elseif type(value) == "function" then
                object:OutHover( value ) 
            end
        end,
        ["oncall"] = function(object,value) 
            CheckScript(object)
            if type(value) == "table" then
                local search = pairs
                for k,v in search(CSSubAction) do    
                    for a,b in search(value) do
                        if a == k then
                            object:OnCall( function()
                                v(object,b)
                            end ) 
                        end
                    end
                end
            elseif type(value) == "function" then
                object:OnCall( value ) 
            end
        end
    }
    
    -- > Head action stylesheets
    local CSSAction = {
        ["switch_call"] = function(object,value) 
            if type(value) == "function" then
                local sub = string.sub
                local key = sub(object.Name, 11)
                AK.UI.Module[key]["Escape_function"] = value
            end
        end,
        -- model
        ["model"]       = CSSCut["model"],
        ["animation"] = function(object,value) 
            if type(value) == "string" and object.modelRenderer ~= nil then
                local Craft = CS
                object.modelRenderer:SetAnimation( Craft.FindAsset( value, "Animation" ) ) 
            end
        end,
        
        -- Map
        ["map"] = function(object,value) 
            if value ~= nil and object.mapRenderer ~= nil then
                local Craft = CS
                object.mapRenderer:SetMap( Craft.FindAsset( value , "Map" ) ) 
            end
        end,
        ["tile"] = function(object,value) 
            if value ~= nil and object.mapRenderer ~= nil then
                local Craft = CS
                object.mapRenderer:SetTileSet( Craft.FindAsset( value , "TileSet" ) ) 
            end
        end,
        
        -- Input action
        ["onclick"]     = CSSCallAction["onclick"],
        ["onchoice"]    = CSSCallAction["onchoice"],
        ["outclick"]    = CSSCallAction["outclick"],
        ["onfocus"]     = CSSCallAction["onfocus"],
        ["outfocus"]    = CSSCallAction["outfocus"],
        ["onhover"]     = CSSCallAction["onhover"],
        ["outhover"]    = CSSCallAction["outhover"],
        ["oncall"]      = CSSCallAction["oncall"],
        ["next"]        = CSSCallAction["next"],
        ["SwitchIn"] = CSSCut["SwitchIn"],
        ["SwitchOut"] = CSSCut["SwitchOut"],
        
        -- Camera action
        ["projection"] = function(object,value) 
            if type(value) == "string" then 
                if object.camera ~= nil then 
                    local cam = Camera
                    if value == "perspective" then
                        object.camera:SetProjectionMode( cam.ProjectionMode.Perspective ) 
                    else
                        object.camera:SetProjectionMode( cam.ProjectionMode.Orthographic )
                    end
                end
            end
        end,
        ["fov"] = function(object,value) 
            value = tonumber(value)
            if type(value) == "number" then 
                if object.camera ~= nil then 
                    object.camera:SetFOV( value ) 
                end
            end
        end,
        ["orthoscale"] = function(object,value) 
            if type(value) == "number" then 
                if object.camera ~= nil then 
                    object.camera:SetOrthographicScale( value ) 
                end
            end
        end,
        ["radarsize"] = function(object,value) 
            if type(value) == "table" then 
                if object.camera ~= nil then 
                    value = value or {}
                    value[1] = value[1] or 1
                    value[2] = value[2] or 1
                    object.camera:SetRenderViewportSize( unpack(value) ) 
                end
            end
        end,
        ["radarposition"] = function(object,value) 
            if type(value) == "table" then 
                if object.camera ~= nil then 
                    value = value or {}
                    value[1] = value[1] or 1
                    value[2] = value[2] or 1
                    object.camera:SetRenderViewportPosition( unpack(value) ) 
                end
            end
        end,
        
        -- Transform action
        ["scale"]       = CSSCut["scale"],
        ["margin"] = function(object,value)
            if type(value) == "string" then       
                local str = string.find          
                local _,_,a,b = str(value, '([%d%p]*)[%s]?([%d%p]*)')
                local result = {a,b}
                result[1] = result[1] or 0
                result[2] = result[2] or 0
                local pos = object.Pos
                local V3 = Vector3
                if #result == 1 then
                    object.transform:SetPosition( V3:New( pos.x + result[1], pos.y + result[1], pos.z ) )
                
                elseif #result == 2 then
                    object.transform:SetPosition( V3:New( pos.x + result[1], pos.y + result[2], pos.z ) )

                else
                    -- do nothing
                    
                end
            elseif type(value) == "table" then
                value[1] = value[1] or 0
                value[2] = value[2] or 0
                value[3] = value[3] or true
                local V3 = Vector3
                if value[3] then 
                    local pos = object.Pos
                    object.transform:SetPosition( V3:New( pos.x + value[1], pos.y + value[2], pos.z ) )
                else
                    local pos = object.LocalPos
                    object.transform:SetLocalPosition( V3:New( pos.x + value[1], pos.y + value[2], pos.z ) )
                end
            end
        end,
        ["position"] = function(object,value)
            if type(value) == "string" then
                if value == "inherit" then
                    local parent = object:GetParent()
                    if parent ~= nil then
                        object.transform:SetPosition( parent.Pos ) 
                    end
                elseif value == "center" then
                    local V3 = Vector3
                    object.transform:SetPosition( V3:New( 0 , 0 , object.Pos.z ) ) 
                else
                    -- do nothing 
                    
                end
            end
        end,
        
        -- GameObject
        ["parent"] = function(object,value)
            if value ~= nil and type(value) == "string" then
                local Craft = CS
                local parent = Craft.Get(value)
                if parent ~= nil then 
                    object:SetParent( parent ) 
                end
            end
        end,
        ["behavior"] = function(object,value)
            if type(value) == "table" then
                local comp = object.behavior
                if comp ~= nil then
                    local search = pairs
                    for k,v in search(value) do
                        if comp[k] ~= nil then
                            comp[k] = v 
                        end
                    end
                end
            end
        end,
        ["escape"] = CSSCut["escape"],
        
        -- > Input
        
        -- > Position
        ["atob"]        = CSSCut["atob"],
        ["timer"]       = CSSCut["timer"],
        
        -- Animation
        ["show"]        = CSSCut["show"],
        ["hide"]        = CSSCut["hide"],
        
        -- Triple contexte
        ["opacity"]     = CSSCut["opacity"],
        ["zindex"]      = CSSCut["zindex"],
        
        -- TextRenderer CSS
        ["text"]        = CSSCut["text"],
        ["font"]        = CSSCut["font"],
        ["align"]       = CSSCut["align"];
        ["only_reset"]  = CSSCut["only_reset"];
        ["button_reset"]    = CSSCut["button_reset"],
        ["text_scale"]      = CSSCut["text_scale"],
        ["text_opacity"]    = CSSCut["text_opacity"]
    }
    
    local CSSUnique = {
        ["keypattern"] = function(object,value,primary) 
            local search = pairs
            for k,v in search(CSSAction) do
                for a,b in search(value) do 
                    if a == k then
                        v(object,b,false)
                    end
                end
            end
        end
    }
    
    
    -- > UI build CSS function
    function camera2D:BuildCSS(autoapply,name,size)
        autoapply = autoapply or false
        if size ~= nil then
            self.DynamicSheets[name] = {
                size = size;
                exec_min = AK[name.."_min"];
                exec_max = AK[name.."_max"];
            }
            
            if self.Screen.Size.x >= size then
                self:ApplyCSS(self.DynamicSheets[name].exec_max)
            else
                self:ApplyCSS(self.DynamicSheets[name].exec_min)
            end
            return
        else
            if autoapply then
                self:ApplyCSS(AK[name])
            end
        end
    end

    function camera2D:ApplyCSS(x)
        
        local search = pairs
        for k,v in search(x) do
            
            local str = string.find
            local _,_,a,b,c,d,e = str(k, '([%a%d%p]*)[%s]?([%a%d%p]*)[%s]?([%a%d%p]*)[%s]?([%a%d%p]*)[%s]?([%a%d%p]*)')
            local result = {a,b,c,d,e}
            
            local Craft = CS 
            
            for keys,values in search(result) do
                if values ~= nil and values ~= "" then 
                    local object = Craft.Get(values) 
                    if object ~= nil then 
                    
                        local pos = {{},{},nil}
                        local posinit = false
                        local margin = {false,{0,0}}
                        local fixedcontaint = {false,nil}
                        local anim = {false,1,false,{0,0},{0,0}}
                        local anim_name = nil
                        for a,b in search(v) do
                            if a == "script" then
                                b = b or "OnClick"
                                local comp = object:GetComponent("ScriptedBehavior")
                                if comp == nil then
                                    self:AddScript(values,b)
                                end
                            elseif a == "left" or a == "right" then
                                posinit = true
                                pos[1][1] = a
                                pos[1][2] = b
                            elseif a == "top" or a == "bottom" then
                                posinit = true
                                pos[2][1] = a
                                pos[2][2] = b
                            elseif a == "margin" then
                                margin[1] = true
                                local _,_,m,w = str(b, '([%d%p]*)[%s]?([%d%p]*)')
                                m = m or 0
                                w = w or 0
                                margin[2][1] = m
                                margin[2][2] = w 
                            elseif a == "resize" then 
                                pos[3] = b or false
                            elseif a == "position" then
                                posinit = true
                            elseif a == "call_func" then
                                b()
                            elseif a == "container" then
                                if type(b) == "string" then 
                                    local new_parent = Craft.FindGameObject(b) 
                                    object:SetParent(new_parent)
                                    fixedcontaint[1] = true
                                    fixedcontaint[2] = b
                                end
                            elseif a == "anim" then
                                if type(b) == "table" then 
                                    if #b >= 3 then
                                        if not anim[1] then
                                            anim[1] = true
                                        end
                                        
                                        anim[2] = b[1] or 1
                                        anim[3] = b[2] or false
                                        anim[4] = b[3] or {0,0}
                                        anim[5] = b[4] or {0,0}
                                    end
                                end
                            elseif a == "anim_name" then
                                anim_name = b
                            elseif a == "anim_pos" then
                                if not anim[1] then
                                    anim[1] = true
                                end
                                if type(b) == "table" then
                                    anim[4][1] = b[1] or 0
                                    anim[4][2] = b[2] or 0
                                elseif type(b) == "number" then
                                    anim[4][1] = b
                                    anim[4][2] = 0
                                elseif type(b) == "string" then 
                                    local _,_,a,b = str(b,"([%d%p]*)[%s]?([%d%p]*)")
                                    anim[4][1] = a or 0
                                    anim[4][2] = b or 0
                                end
                            elseif a == "anim_scale" then  
                                if not anim[1] then
                                    anim[1] = true
                                end
                                if type(b) == "table" then
                                    anim[5][1] = b[1] or 0
                                    anim[5][2] = b[2] or 0
                                elseif type(b) == "number" then
                                    anim[5][1] = b
                                    anim[5][2] = 0
                                elseif type(b) == "string" then 
                                    local _,_,a,b = str(b,"([%d%p]*)[%s]?([%d%p]*)")
                                    anim[5][1] = a or 0
                                    anim[5][2] = b or 0
                                end
                            elseif a == "anim_speed" then
                                anim[2] = b
                            elseif a == "anim_resize" then
                                anim[3] = b
                            end 
                            self:TrimCSS(values,a,b,keys) 
                        end  
                        if posinit then
                            if not fixedcontaint[1] then 
                                pos[3] = pos[3] or false
                                if margin[1] then
                                    pos[1][2] = pos[1][2] or 0
                                    pos[2][2] = pos[2][2] or 0
                                    pos[1][2] = pos[1][2] + margin[2][1]
                                    pos[2][2] = pos[2][2] + margin[2][2]
                                    self:Pos(values,pos[1],pos[2],pos[3])
                                else
                                    self:Pos(values,pos[1],pos[2],pos[3])
                                end
                            end
                        end
                        if anim[1] then
                            if anim_name ~= nil then
                                self:NewAnim(anim_name,anim[2],anim[3],anim[4],anim[5])
                            else
                                self:NewAnim(values,anim[2],anim[3],anim[4],anim[5])
                            end
                        end
                    end
                end
            end
        end
    end
    
    function camera2D:TrimCSS(object,K,V,indexCall)    
        local Craft = CS
        local object = Craft.FindGameObject(object)

        local keyfind = false
        local index = nil
        indexCall = indexCall or nil
        local search = pairs
        for a,b in search(CSSAction) do
            
            local str = string.find
            local lower = string.lower
            if str(K,"key",1) == 1 and not keyfind then
                keyfind = true
                local sub = string.sub
                index = sub(K, 4)
            elseif a == lower(K) then
                b(object,V,true)
            end
        end
        
        index = tonumber(index)
        indexCall = tonumber(indexCall) 
        
        if index ~= nil and indexCall ~= nil then
            if index == indexCall then
                CSSUnique["keypattern"](object,V,true)
            end
        end
    end

end
