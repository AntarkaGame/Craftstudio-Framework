AK.Cam2D = {
    __call = function(I)
        I:Update()
    end
} 
    
do 
    local camera2D = AK.Cam2D
    camera2D.__index = camera2D

    function camera2D:New(cs,state,name)
        return setmetatable( { 
            cs = cs,
            state = state or false, 
            generate = false,
            this = nil,
            name = name,
            Screen = { 
                Size = {} , 
                Center = {} , 
                PTU = nil , 
                SSS = nil 
            },
            Mouse = { 
                Pos = {}, 
                Delta = {}, 
                ToPixel = {}, 
                ToMouse = {}, 
                Move = false, 
                In = true
            },
            ActiveTab = {},
            ShowTab = {},
            Module = {},
            LerpTab = {},
            css = {},
            ModuleEntry = nil,
            ModuleActive = nil,
            Comportement = nil,
            Component_list = {
                ["Button"]  = CS.FindAsset( "Data/AKInScript/Button" , "Script" ),
                ["Window"]  = CS.FindAsset( "Data/AKInScript/Window" , "Script" ),
                ["DragBox"] = CS.FindAsset( "Data/AKInScript/DragBox" , "Script" )
            },
            DynamicSheets = {},
            ray = nil
        }, self )
    end
    
    function camera2D:Get()
        return self
    end
    
    function camera2D:Generate(resize)
        resize = resize or false
        if not AK.Start then
            AK.Start = true
        end
        self.cs.gameObject.transform:SetPosition( Vector3:New( 0 , 0 , 9990 ) ) 
        self.this = CraftStudio.CreateGameObject( self.name , self.cs.gameObject ) 
        self.this:CreateComponent( "Camera" ) 
        self.this.camera:SetProjectionMode( Camera.ProjectionMode.Orthographic ) 
        self.this.transform:SetLocalPosition( Vector3:New( 0 , 0 , 50 ) ) 
        
        if resize then
            self:ScreenResize() 
        end
    end
    
    function camera2D:UpdateCamScale(resize)
        resize = resize or false
        
        self.this.camera:SetOrthographicScale( CS.Screen.GetSize().y / 16 ) 
        self.Screen.SSS = math.MinMax(CS.Screen.GetSize().x,CS.Screen.GetSize().y)
        self.Screen.PTU = self.this.camera:GetOrthographicScale() / self.Screen.SSS 
        if resize then 
            self:ScreenResize() 
        end
    end
    
    function camera2D:ScreenResize(CamScale)
        CamScale = CamScale or false 
        
        self.Screen.Size.x, self.Screen.Size.y =  CS.Screen.GetSize().x, CS.Screen.GetSize().y
        self:UpdateCamScale(CamScale) 
        self.Screen.Center.x, self.Screen.Center.y = self.Screen.Size.x * self.Screen.PTU / 2 , self.Screen.Size.y * self.Screen.PTU / 2
        
        -- > Resizing active tab
        if #self.ActiveTab ~= 0 then 
            for i = 0, #self.ActiveTab do
                if self.ActiveTab[i] ~= nil then
                    if self.LerpTab[self.ActiveTab[i][1]] ~= nil then
                        if not self.LerpTab[self.ActiveTab[i][1]].play and AK.TempResize then
                            -- On va calculer la position par rapport au lerp
                            local back_pos = self.LerpTab[self.ActiveTab[i][1]].defaut
                            local decal = {}
                            decal.x = self.ActiveTab[i][2][2] or 0
                            decal.y = self.ActiveTab[i][3][2] or 0
                            local lerp = {}
                            lerp.x = self.LerpTab[self.ActiveTab[i][1]].decalinfo[1] or 0
                            lerp.y = self.LerpTab[self.ActiveTab[i][1]].decalinfo[2] or 0
                            self:Pos(self.ActiveTab[i][1],{self.ActiveTab[i][2][1],lerp.x + (decal.x)},{self.ActiveTab[i][3][1],lerp.y + (decal.y)},false)
                        else
                            self:Pos(self.ActiveTab[i][1],self.ActiveTab[i][2],self.ActiveTab[i][3],false)
                        end
                    else
                        self:Pos(self.ActiveTab[i][1],self.ActiveTab[i][2],self.ActiveTab[i][3],false)
                    end
                end
            end 
        end

        -- > Resize lerp element
        for k,v in pairs(self.LerpTab) do 
            if self.LerpTab[k] ~= nil then 
                if self.LerpTab[k].auto then 
                    local object = CS.Get(k).transform
                    local pos = object:GetLocalPosition()
                    local scale = object:GetLocalScale() 
                    
                    self.LerpTab[k].defaut = pos
                    self.LerpTab[k].lerp = Vector3:New( pos.x + self.LerpTab[k].decalinfo[1]  , pos.y + self.LerpTab[k].decalinfo[2] , pos.z )  
                    
                    self.LerpTab[k].defautscale = scale
                    self.LerpTab[k].lerpscale = Vector3:New( scale.x + self.LerpTab[k].scaleinfo[1] , scale.y + self.LerpTab[k].scaleinfo[2] , scale.z  ) 
                end
            end
        end
        
        for k,v in pairs(self.DynamicSheets) do
            if self.Screen.Size.x >= v.size then
                self:ApplyCSS(v.exec_max)
            else
                self:ApplyCSS(v.exec_min)
            end
        end
        
        if AK.Console ~= nil then
            AK.UI:Pos("Console_Container",{"left",0},{"top",0},false)
        end

    end
    
    -- > Function ScanRoom
    function camera2D:ScanRoom(ModuleEntry,backswitch,callback)
        backswitch = backswitch or false
        callback = callback or Nil
        for i, rootGameObject in ipairs( CraftStudio.GetRootGameObjects() ) do
            self:ScanWhile(rootGameObject:GetChildren(),ModuleEntry,0)  
        end
        self.ModuleActive = self.ModuleEntry
        self:Switch(self.ModuleActive,backswitch)
        return callback()
    end
    
    function camera2D:ScanWhile(this,ModuleEntry,boucle)
        local item = this
        local boucle = boucle + 1 
        for k,_ in pairs(this) do
            local name = item[k]:GetName()
            AK.Scanning(self,item[k],ModuleEntry)
            
            if item[k].Children ~= 0 then
                self:ScanWhile(item[k]:GetChildren(),ModuleEntry,boucle) 
            end
        end
    end
    
    -- > Function pour changer la profondeur d'un objet ou d'une liste d'objet.
    function camera2D:Zindex(list,zpos,global)
        local chunk = global or false
        local origin = CS.Get("Camera2D").Pos
        
        if type(list) == "string" then
            local object = CS.Get(list) 
                
            if object ~= nil then 
                if not chunk then
                    object.transform:SetPosition( Vector3:New( object.Pos.x , object.Pos.y , origin - zpos ) )
                else
                    local object_pos = object.LocalPos
                    object.transform:SetLocalPosition( Vector3:New( object.LocalPos.x , object.LocalPos.y , object_pos.z + zpos ) ) 
                end
            end
        elseif type(list) == "table" then 
            for i = 1, #list do    
                local object = CS.Get(list[i]) 
                
                if object ~= nil then 
                    if not chunk then
                        object.transform:SetPosition( Vector3:New( object.Pos.x, object.Pos.y , origin - zpos ) )
                    else
                        local object_pos = object.LocalPos
                        object.transform:SetLocalPosition( Vector3:New( object.LocalPos.x , object.LocalPos.y , object_pos.z + zpos ) ) 
                    end
                end
            end
        end
    end
    
    -- > Function pour ajouter un Script de la librairie.
    function camera2D:AddScript(item,action,behavior,callback)
        local behavior = behavior or nil
        
        if type(item) == "string" then 
            local object = CS.Get(item)
            if object ~= nil then
                if self.Component_list[action] ~= nil then 
                    object:CreateScriptedBehavior( self.Component_list[action] , behavior ) 
                    if callback ~= nil then
                        return callback(object)
                    end
                else
                    print("Le composant "..action.." n'existe pas dans la liste des composants disponible")
                    return false
                end
            else
                print("Objet inexistant, impossible d'ajouter un composant")
                return false
            end
        elseif type(item) == "table" then
            for i = 1 , #item do 
                local object = CS.Get(item[i])
                if object ~= nil then
                    if self.Component_list[action] ~= nil then 
                        object:CreateScriptedBehavior( self.Component_list[action] , behavior ) 
                    else
                        print("Le composant "..action.." n'existe pas dans la liste des composants disponible")
                    end
                else
                    print("Objet inexistant, impossible d'ajouter un composant")
                end
            end
        end
    end
    
    -- > Function pour positionner
    function camera2D:Pos(item,x,y,key,callback)  
        key = key or false
        x = x or {}
        y = y or {}
        x[1] = x[1] or "center"
        y[1] = y[1] or "center"
        x[2] = x[2] or 0
        y[2] = y[2] or 0
        callback = callback or Nil
        
        local object = CS.Get(item)
        if object ~= nil then
            if key then
                table.insert(self.ActiveTab,{item,{x[1],x[2]},{y[1],y[2]}})
            end 
            local comptype  
            
            if object.modelRenderer ~= nil then
                comptype = "model"
            elseif object.textRenderer ~= nil then
                comptype = "text"
            end 
            
            local exec = {}
            local Back = {x=x[1],y=y[1]}
            local BackPos = {x=x[2],y=y[2]}
            local SCX,SCY = self.Screen.Size.x * self.Screen.PTU / 2 , self.Screen.Size.y * self.Screen.PTU / 2
            
            if x[1] == "left" then 
                x[1] = -1
                exec.x = x[1] * SCX + x[2] 
            elseif x[1] == "right" then 
                x[1] = 1; x[2] = -x[2]
                exec.x = x[1] * SCX + x[2] 
            elseif x[1] == "center" then
                exec.x = 0 + x[2]
            else 
                exec.x = 0 
            end  
            
            if comptype == "text" then
                if y[1] == "top" then 
                    y[1] = 1; 
                    y[2] = -y[2]; 
                    exec.y = y[1] * SCY + (y[2] - 0.8)
                elseif y[1] == "bottom" then 
                    y[1] = -1; 
                    exec.y = y[1] * SCY + (y[2] + 0.8)
                elseif y[1] == "center" then
                    exec.y = 0 + y[2]
                else 
                    exec.y = 0 
                end
            else
                if y[1] == "top" then 
                    y[1] = 1
                    y[2] = -y[2]
                    exec.y = y[1] * SCY + y[2] 
                elseif y[1] == "bottom" then 
                    y[1] = -1
                    exec.y = y[1] * SCY + y[2] 
                elseif y[1] == "center" then
                    exec.y = 0 + y[2]
                else 
                    exec.y = 0 
                end
            end
            
            object.transform:SetLocalPosition( Vector3:New( exec.x, exec.y, object.transform:GetLocalPosition().z ) ) 
            
            x[1] = Back.x
            y[1] = Back.y
            x[2] = BackPos.x
            y[2] = BackPos.y
        
            -- > Callback si existant
            return callback(item)
        else
            Error("Impossible de positionner un objet inexistant")
        end
        
    end
    
    -- > Follow the mouse and create decal Pos (DRAG and DROP)
    function camera2D:FollowGetDecaPos(item)
        return CS.Get(item).transform:GetLocalPosition() - Vector3:New(self.Mouse.ToMouse.x,self.Mouse.ToMouse.y,0)
    end
    
    function camera2D:FollowMouse(item,DecaPos,pattern)
        local object = CS.Get(item)
        
        if object ~= nil then
            local pos = object.transform:GetLocalPosition()
            local DecaPosX,DecaPosY = DecaPos[1] or DecaPos.x, DecaPos[2] or DecaPos.y
            if pattern ~= nil then
                local x = pattern[1] and self.Mouse.ToMouse.x + DecaPosX or pos.x
                local y = pattern[2] and self.Mouse.ToMouse.y + DecaPosY or pos.y
                object.transform:SetLocalPosition( Vector3:New( 
                    x, 
                    y, 
                    pos.z 
                ) )
            else
                object.transform:SetLocalPosition( Vector3:New( 
                    self.Mouse.ToMouse.x + DecaPosX, 
                    self.Mouse.ToMouse.y + DecaPosY, 
                    pos.z 
                ) )
            end
        else
            Error("l'object est inexistant, impossible d'appliquer la function followmouse")
        end
    end
    
    -- > Switch
    function camera2D:Switch(ContainerName,resize,callback) 
        resize = resize or false
        local Module = ContainerName
        if Module ~= nil then 
            if Module == "Exit" then
                CS.CloseGame() 
            end
            
            if self.Module[Module] ~= nil then 
                local active = self.ModuleActive 
                self.Module[active]["Object"].transform:SetLocalPosition( Vector3:New( 200, 0 , self.Module[active]["Object"].transform:GetLocalPosition().z ) ) 
                self.Module[active]["Chunk"] = false
                if self.Module[active]["Switch_OUT"] ~= nil then
                    self.Module[active]["Switch_OUT"]()
                end
                self.Module[Module]["Object"].transform:SetLocalPosition( Vector3:New( 0, 0 , self.Module[Module]["Object"].transform:GetLocalPosition().z ) ) 
                self.Module[Module]["Chunk"] = true
                self.ModuleActive = Module
                self:ScreenResize(resize)
                if self.Module[Module]["Switch_IN"] ~= nil then
                    self.Module[Module]["Switch_IN"]()
                end
                self.RecallEchap = self.Module[self.ModuleActive]["Escape"]
                if callback ~= nil then
                    return callback()
                end
            else
                return
            end
        else
            return false
        end
    end
    
    function camera2D:NewContainer(container,switch,param,callback)
        local entry = switch or false
        local object = CraftStudio.FindGameObject(container)
        local escape = param[1] 
        
        if object ~= nil then
            if self.Module[container] == nil then
                self.Module[container] = {
                    ["Chunk"] = false,
                    ["Object"] = object,
                    ["Escape"] = escape,
                    ["Escape_function"] = nil,
                    ["Switch_IN"] = nil,
                    ["Switch_OUT"] = nil,
                    ["Style"] = {}
                }
                
                if callback ~= nil then
                    return callback()
                end
                
                if entry then
                    self.ModuleActive = container
                    self:Switch(self.ModuleActive)
                else
                    return
                end
            else
                print("le module "..container.." existe déjà")
            end
        else
            Error("container inexistant")
        end
    end
    
    function camera2D:DeleteContainer(container)
        local object = CS.Get(container)
        
        if object ~= nil and self.Module[container] ~= nil then
            self.Module[container] = nil
            CS.Destroy( object ) 
            return
        else
            Error("impossible de détruire un container inexistant")
        end
    end
    
    function camera2D:AtoB(a,b,global,callback)
        local origin = CS.Get(a)
        local position = CS.Get(b)  
        global = global or true
        callback = callback or Nil
        
        if origin ~= nil and position ~= nil then 
            if global then 
                AK.TaskList:Add("ResizeContaint",{}, function() 
                    origin.transform:SetPosition( position.Pos ) 
                end )
            else
                AK.TaskList:Add("ResizeContaint",{}, function() 
                    origin.transform:SetLocalPosition( position.LocalPos ) 
                end )
            end
            return callback()
        else
            print("object do not exist")
        end
    end

    function camera2D:Update(key,callback)
        self.ray = self.this.camera:CreateRay( CS.Input.GetMousePosition() ) 
        self.Mouse.Pos = CS.Input.GetMousePosition()
        self.Mouse.Delta = CS.Input.GetMouseDelta()
        
        if self.Mouse.Delta.x ~= 0 or self.Mouse.Delta.x ~= 0 and self.Mouse.In then
            self.Mouse.Move = true
        else
            self.Mouse.Move = false
        end
        
        if self.Mouse.Pos.x >= 0 and self.Mouse.Pos.x <= self.Screen.Size.x and self.Mouse.Pos.y >= 0 and self.Mouse.Pos.y <= self.Screen.Size.y then
            if not self.Mouse.In then
                self.Mouse.In = true
            end
            self.Mouse.ToPixel.x = self.Mouse.Pos.x * self.Screen.PTU
            self.Mouse.ToPixel.y = self.Mouse.Pos.y * self.Screen.PTU
            self.Mouse.ToMouse.x = self.Mouse.ToPixel.x - self.Screen.Center.x
            self.Mouse.ToMouse.y = -self.Mouse.ToPixel.y + self.Screen.Center.y
        else
            if self.Mouse.In then 
                self.Mouse.In = false
            end
        end
        
        if self.Screen.Size.x ~= CS.Screen.GetSize().x or self.Screen.Size.y ~= CS.Screen.GetSize().y then
            if callback ~= nil then
                return callback()
            end
            self:ScreenResize(false)
        end
        
        if AK.TaskList ~= nil then 
            AK.TaskList:Update()
        end
        
        if CS.KeyPressed("ECHAP") and AK.UI.ToAction and not AK.EndReach then
            if self.Module[self.ModuleActive]["Escape_function"] ~= nil then
                self.Module[self.ModuleActive]["Escape_function"]()
            end
            self:Switch( self.Module[self.ModuleActive]["Escape"] ) 
        end
    
    end
    
end

function CS.Cam( cs , containerIndex, callback )
    callback = callback or Nor
    containerIndex = containerIndex or "Accueil" 
    AK.UI = AK.Cam2D:New(cs,false,"Camera2D")
    AK.UI:Generate()
    AK.UI:ScanRoom(containerIndex,false,callback)
    AK.UI:ScreenResize(true)
    AK.UI.ToAction = true
end
