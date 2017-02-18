do

    local camera2D = AK.Cam2D
    camera2D.__index = camera2D
    
    -- > SHOW FUNCTION
    function camera2D:Show(object,value,speed)
        value = value or 1
        speed = speed or 0.05
        if type(object) == "string" then
            local item = CS.Get(object)
            if type(value) == "number" then
                local opacity = item.modelRenderer:GetOpacity()
                if opacity < value then
                    local count = (value-opacity) / speed
                    AK.TaskList:Add(object,{count,speed,value},function(Table)
                        local this = CS.Get(Table.item)
                        local opacity = this.modelRenderer:GetOpacity()
                        this.modelRenderer:SetOpacity( opacity + Table.add )
                        
                        if Table.boucle >= Table.boucle_max then
                            this.modelRenderer:SetOpacity( Table.valeur )
                        end
                    end)
                else
                    --Error("L'opacité du modèle est supérieur à value")
                end
            end
        elseif type(object) == "table" then
            if type(value) == "number" then
                for i = 1, #object do 
                    local item = CS.Get(object[i])
                    local opacity = item.modelRenderer:GetOpacity()
                    if opacity < value then
                        local count = (value-opacity) / speed
                        
                        AK.TaskList:Add(object[i],{count,speed,value},function(Table)
                            local this = CS.Get(Table.item)
                            local opacity = this.modelRenderer:GetOpacity()
                            this.modelRenderer:SetOpacity( opacity + Table.add )
                            
                            if Table.boucle >= Table.boucle_max then
                                this.modelRenderer:SetOpacity( Table.valeur )
                            end
                        end)
                    else
                        --Error("L'opacité du modèle est supérieur à value")
                    end
                end
                
            end
        end
    end
    
    function camera2D:Hide(object,value,speed)
        value = value or 0
        speed = speed or 0.05
        if type(object) == "string" then 
            local item = CS.Get(object)
            if type(value) == "number" then
                local opacity = item.modelRenderer:GetOpacity()
                if opacity > value then
                    local count = (opacity-value) / speed
                    AK.TaskList:Add(object,{count,speed,value},function(Table)
                        local this = CS.Get(Table.item)
                        local opacity = this.modelRenderer:GetOpacity()
                        this.modelRenderer:SetOpacity( opacity - Table.add )
                        
                        if Table.boucle >= Table.boucle_max then
                            this.modelRenderer:SetOpacity( Table.valeur )
                        end
                    end)
                else
                    --Error("L'opacité du modèle est inférieur à value")
                end
            end
        elseif type(object) == "table" then
            if type(value) == "number" then
                for i = 1, #object do 
                    local item = CS.Get(object[i])
                    local opacity = item.modelRenderer:GetOpacity()
                    if opacity > value then
                        local count = (opacity-value) / speed
                        
                        AK.TaskList:Add(object[i],{count,speed,value},function(Table)
                            local this = CS.Get(Table.item)
                            local opacity = this.modelRenderer:GetOpacity()
                            this.modelRenderer:SetOpacity( opacity - Table.add )
                            
                            if Table.boucle >= Table.boucle_max then
                                this.modelRenderer:SetOpacity( Table.valeur )
                            end
                        end)
                    else
                        --Error("L'opacité du modèle est supérieur à value")
                    end
                end
                
            end
        end
    end
    
    -- > NewAnimation function
    function camera2D:NewAnim(item,speed,resize,decalpos,decalscale,parent)
        local lerpresize = resize or false
        parent = parent or false
        local comptype = nil
            
        decalpos = decalpos or {}
        decalscale = decalscale or {}
        
        decalpos[1] = decalpos[1] or 0
        decalpos[2] = decalpos[2] or 0
        decalscale[1] = decalscale[1] or 0
        decalscale[2] = decalscale[2] or 0
        
        if type(item) == "string" then 
            local object = CS.Get(item)
            if object ~= nil then

                if self.LerpTab[item] == nil then 
                    local pos = object.transform:GetLocalPosition()
                    local scale = object.transform:GetLocalScale()
                    
                    self.LerpTab[item] = {
                        play = false,
                        state = false,
                        speed = speed,
                        auto = lerpresize,
                        defaut = pos,
                        decalinfo = {decalpos[1],decalpos[2]},
                        defautscale = scale,
                        scaleinfo = {decalscale[1],decalscale[2]},
                        lerp = Vector3:New( pos.x + decalpos[1] , pos.y + decalpos[2] , pos.z ),
                        lerpscale =  Vector3:New( scale.x + decalscale[1] , scale.y + decalscale[2] , scale.z ) 
                    }
                    
                else
                    print(item.." possède déjà une animation.")
                    return false
                end

            else
                print("L'object est inexistant, impossible d'ajouter une animation.")
                return false
            end
        elseif type(item) == "table" then
            for i = 1, #item do
                local object = CraftStudio.FindGameObject(item[i])
                
                if object ~= nil then
                
                    if self.LerpTab[item[i]] == nil then 
                        local pos = object.transform:GetLocalPosition()
                        local scale = object.transform:GetLocalScale()
                        
                        self.LerpTab[item[i]] = {
                            play = false,
                            state = false,
                            speed = speed,
                            auto = lerpresize,
                            defaut = pos,
                            decalinfo = {decalpos[1],decalpos[2]},
                            defautscale = scale,
                            scaleinfo = {decalscale[1],decalscale[2]},
                            lerp = Vector3:New( pos.x + decalpos[1] , pos.y + decalpos[2] , pos.z ),
                            lerpscale =  Vector3:New( scale.x + decalscale[1] , scale.y + decalscale[2] , scale.z ) 
                        }
                        
                    else
                        print(item[i].." possède déjà une animation.")
                    end
                else
                    print("L'object ".. item[i] .." est inexistant, impossible d'ajouter une animation.")
                end
            end
        end
    end
    
    -- > State anim or table group anim
    function camera2D:StateAnim(item)   
        if type(item) == "string" then 
            if self.LerpTab[item] ~= nil then
                if self.LerpTab[item].play then
                    return false
                elseif not self.LerpTab[item].play then
                    return true
                end
            end
        elseif type(item) == "table" then
            local count = 0
            local need = #item
            for i = 1 ,#item do
                if self.LerpTab[item[i]] ~= nil then
                    if self.LerpTab[item[i]].play then
                        -- do nothing 
                    elseif not self.LerpTab[item[i]].play then
                        count = count + 1 
                    end
                end
                if count == need then 
                    return true 
                end
            end
            return false
        end
    end
    
    function camera2D:Anim(item,easing)
        easing = easing or "InOutCubic"
        if type(item) == "string" then 
            if self.LerpTab[item] ~= nil then
                if not self.LerpTab[item].play then
                    if self.LerpTab[item].state then
                        AK.TaskList:Add(item,{(self.LerpTab[item].speed*60),nil,easing},function(Table)
                            local Lerp_item = self.LerpTab[Table.item] 
                            local object = CraftStudio.FindGameObject(Table.item)
                            local factor = Table.boucle / Table.boucle_max
                            local progression = (1 - (1 - factor) * (1 - factor))
            
                            object.transform:SetLocalPosition( Vector3.Lerp(
                                Lerp_item.lerp,
                                Lerp_item.defaut, 
                                progression
                            ) )
                            object.transform:SetLocalScale( Vector3.Lerp(
                                Lerp_item.lerpscale,
                                Lerp_item.defautscale,
                                progression
                            ) )  
                            
                            if Table.boucle >= Table.boucle_max then
                                Lerp_item.play = false
                            end
                        end)
                    else
                        AK.TaskList:Add(item,{(self.LerpTab[item].speed*60),nil,easing},function(Table)
                            local Lerp_item = self.LerpTab[Table.item] 
                            local object = CraftStudio.FindGameObject(Table.item)
                            local factor = Table.boucle / Table.boucle_max
                            local progression = (1 - (1 - factor) * (1 - factor))
                            
                            do
                                local state = self.LerpTab[item].state
                                local POSdefaut = state and Lerp_item.defaut  or Lerp_item.lerp
                                local POSlerp   = state and Lerp_item.lerp or Lerp_item.defaut
                
                                object.transform:SetLocalPosition( Vector3.Lerp(
                                    POSdefaut,
                                    POSlerp, 
                                    progression
                                ) )
                            end
                            
                            object.transform:SetLocalScale( Vector3.Lerp(
                                Lerp_item.defautscale,
                                Lerp_item.lerpscale,
                                progression
                            ) ) 
                            
                            if Table.boucle >= Table.boucle_max then
                                Lerp_item.play = false
                            end
                        end)
                    end
                    self.LerpTab[item].play = true
                    self.LerpTab[item].state = not self.LerpTab[item].state
                else
                    self.LerpTab[item].state = not self.LerpTab[item].state
                    AK.TaskList:Reverse(item)
                end
            else
                print("Le lerp "..item.." n'existe pas")
                return false
            end
        elseif type(item) == "table" then
        
            for i = 1 , #item do 
                if self.LerpTab[item[i]] ~= nil then
                    if not self.LerpTab[item[i]].play then
                        if self.LerpTab[item[i]].state then
                            AK.TaskList:Add(item[i],{(self.LerpTab[item[i]].speed*60),nil},function(Table)
                                local Lerp_item = self.LerpTab[Table.item] 
                                local object = CraftStudio.FindGameObject(Table.item)
                                local factor = Table.boucle / Table.boucle_max
                                local progression = (1 - (1 - factor) * (1 - factor))
                
                                object.transform:SetLocalPosition( Vector3.Lerp(
                                    Lerp_item.lerp,
                                    Lerp_item.defaut, 
                                    progression
                                ) )
                                object.transform:SetLocalScale( Vector3.Lerp(
                                    Lerp_item.lerpscale,
                                    Lerp_item.defautscale,
                                    progression
                                ) )  
                                
                                if Table.boucle >= Table.boucle_max then
                                    Lerp_item.play = false
                                end
                            end)
                        else
                            AK.TaskList:Add(item[i],{(self.LerpTab[item[i]].speed*60),nil},function(Table)
                                local Lerp_item = self.LerpTab[Table.item] 
                                local object = CraftStudio.FindGameObject(Table.item)
                                local factor = Table.boucle / Table.boucle_max
                                local progression = (1 - (1 - factor) * (1 - factor))
                
                                object.transform:SetLocalPosition( Vector3.Lerp(
                                    Lerp_item.defaut,
                                    Lerp_item.lerp, 
                                    progression
                                ) )
                                object.transform:SetLocalScale( Vector3.Lerp(
                                    Lerp_item.defautscale,
                                    Lerp_item.lerpscale,
                                    progression
                                ) ) 
                                
                                if Table.boucle >= Table.boucle_max then
                                    Lerp_item.play = false
                                end
                            end)
                        end
                        self.LerpTab[item[i]].play = true
                        self.LerpTab[item[i]].state = not self.LerpTab[item[i]].state
                    end
                else
                    print("Le lerp "..item.." n'existe pas")
                    return false
                end
            end
        
        end
        
    end
    
    function camera2D:OnAnim(item,parent,callback)
        if type(item) ~= "table" then
            item = {item}
        end
        parent = parent or false
        callback = callback or Nil

        for i=1,#item do 
        
            local object
            
            -- > Si l'animation est parente ou non
            if not parent then 
                object = CS.Get(item[i])
            else
                object = CS.Get(item[i]):GetParent()
            end
            
            -- > Si l'objet ne possède pas de script
            if object:GetComponent("ScriptedBehavior") == nil then
                self:AddScript(item,"OnClick")
            end
            
            -- > OnHover Action
            object:OnHover(function(gameObject)
                return callback(gameObject,object)
            end)
            
            --> Out Hover Action
            object:OutHover(function(this,gameObject)
                if AK.UI.LerpTab[item[i]].state then
                    this.toaction = true
                end
                local func = function(this,gameObject,index)
                    if this.toaction and AK.UI:StateAnim(item) then 
                        print(index)
                        table.remove(this.OnNextCallback,index)
                        callback(gameObject)
                    end
                end
                
                if this.OnNextCallback == nil then 
                    this.OnNextCallback = {func} 
                else
                    this.OnNextCallback[#this.OnNextCallback + 1] = func
                end
            end)

        end
    end

end
