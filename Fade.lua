AK.Fade = {
    __call = function(I)
        I:Update()
    end
} 
    
do 
    local Fade = AK.Fade
    Fade.__index = Fade
    
    local fade_asset = {
        ["white"] = CS.FindAsset("Frameworks/Fade/White" , "Model" ),
        ["black"] = CS.FindAsset("Frameworks/Fade/Black" , "Model" ),
        ["grey"] = CS.FindAsset("Frameworks/Fade/Grey" , "Model" )
    }
    
    local style = {}
    
        -- > Classique style
        style["classique"] = {
            init = function(self)
                local fade = CS.New("Fade",self.gameObject)
                local find = false
                for k,v in pairs(fade_asset) do 
                    if k == self.model_type and not find then
                        fade:CreateComponent("ModelRenderer"):SetModel( v )
                        find = true
                        break
                    end
                end
                if not find then
                    return false
                end
                do
                    local Pos = self.gameObject.LocalPos
                    fade.transform:SetLocalPosition( Vector3:New( Pos.x , Pos.y , self.area ) ) 
                end
                self.fade = fade
                self.wait_tick = 0
                return true
            end,
            update = function(self)
                
                if self.wait_tick >= self.wait_time then 
                    self.tick = self.tick + 1
                    local factor = self.tick / self.duration
                    local progression = (1 - (1 - factor) * (1 - factor))
                        
                    
                    if self.state then
                        self.fade.modelRenderer:SetOpacity( progression ) 
                        if self.tick >= self.duration then 
                            self.state = false
                            self.start = false
                            self.fade.modelRenderer:SetOpacity( 1.0 ) 
                            self.tick = 0
                            return true
                        else    
                            return false
                        end
                    else
                        self.fade.modelRenderer:SetOpacity( 1 - progression ) 
                        if self.tick >= self.duration then 
                            self.state = true
                            self.start = false
                            self.fade.modelRenderer:SetOpacity( 0 ) 
                            self.tick = 0
                            return true
                        else    
                            return false
                        end
                    end
                else
                    self.wait_tick = self.wait_tick + 1 
                end
            end
        }
        -- Style classique close
        
        -- Style Slide Y
        style["slide_y"] = {
            init = style["classique"].init,
            update = function(self)
                self.wait_tick = self.wait_tick + 1
                
                if self.wait_tick >= self.wait_time then 
                    self.tick = self.tick + 1
                    local factor = self.tick / self.duration
                    local progression = (1 - (1 - factor) * (1 - factor))
                        
                    
                    if self.state then
                        self.fade.transform:SetLocalScale( Vector3:New( 1 , progression , 1 ) )
                        if self.param.change_opa then 
                            self.fade.modelRenderer:SetOpacity( progression ) 
                        end
                        if self.tick >= self.duration then 
                            self.state = false
                            self.start = false
                            self.fade.transform:SetLocalScale( Vector3:New( 1 , 1 , 1 ) )
                            if self.param.change_opa then 
                                self.fade.modelRenderer:SetOpacity( 0 ) 
                            end
                            return true
                        else    
                            return false
                        end
                    else
                        self.fade.transform:SetLocalScale( Vector3:New( 1 , 1 - progression , 1 ) )
                        if self.param.change_opa then 
                            self.fade.modelRenderer:SetOpacity( 1 - progression ) 
                        end
                        if self.tick >= self.duration then 
                            self.state = true
                            self.start = false
                            self.fade.transform:SetLocalScale( Vector3:New( 1 , 0 , 1 ) )
                            if self.param.change_opa then 
                                self.fade.modelRenderer:SetOpacity( 0 ) 
                            end
                            return true
                        else    
                            return false
                        end
                    end
                end
            end
        }
        -- Slide X close
        
        style["slide_x"] = {
            init = style["classique"].init,
            update = function(self)
                self.wait_tick = self.wait_tick + 1
                
                if self.wait_tick >= self.wait_time then 
                    self.tick = self.tick + 1
                    local factor = self.tick / self.duration
                    local progression = (1 - (1 - factor) * (1 - factor))
                        
                    
                    if self.state then
                        self.fade.transform:SetLocalScale( Vector3:New( progression , 1 , 1 ) )
                        if self.param.change_opa then 
                            self.fade.modelRenderer:SetOpacity( progression ) 
                        end
                        if self.tick >= self.duration then 
                            self.state = false
                            self.start = false
                            self.fade.transform:SetLocalScale( Vector3:New( 1 , 1 , 1 ) )
                            if self.param.change_opa then 
                                self.fade.modelRenderer:SetOpacity( 0 ) 
                            end
                            return true
                        else    
                            return false
                        end
                    else
                        self.fade.transform:SetLocalScale( Vector3:New( 1 - progression , 1 , 1 ) )
                        if self.param.change_opa then 
                            self.fade.modelRenderer:SetOpacity( 1 - progression ) 
                        end
                        if self.tick >= self.duration then 
                            self.state = true
                            self.start = false
                            self.fade.transform:SetLocalScale( Vector3:New( 1 , 0 , 1 ) )
                            if self.param.change_opa then 
                                self.fade.modelRenderer:SetOpacity( 0 ) 
                            end
                            return true
                        else    
                            return false
                        end
                    end
                end
            end
        }
        -- Slide X close
        
        style["centered"] = {
            init = style["classique"].init,
            update = function(self)
                self.wait_tick = self.wait_tick + 1
                
                if self.wait_tick >= self.wait_time then 
                    self.tick = self.tick + 1
                    local factor = self.tick / self.duration
                    local progression = (1 - (1 - factor) * (1 - factor))
                        
                    
                    if self.state then
                        self.fade.transform:SetLocalScale( Vector3:New( progression , progression , 1 ) )
                        if self.param.change_opa then 
                            self.fade.modelRenderer:SetOpacity( progression ) 
                        end
                        if self.tick >= self.duration then 
                            self.state = false
                            self.start = false
                            self.fade.transform:SetLocalScale( Vector3:New( 1 , 1 , 1 ) )
                            if self.param.change_opa then 
                                self.fade.modelRenderer:SetOpacity( 0 ) 
                            end
                            return true
                        else    
                            return false
                        end
                    else
                        self.fade.transform:SetLocalScale( Vector3:New( 1 - progression , 1 - progression , 1 ) )
                        if self.param.change_opa then 
                            self.fade.modelRenderer:SetOpacity( 1 - progression ) 
                        end
                        if self.tick >= self.duration then 
                            self.state = true
                            self.start = false
                            self.fade.transform:SetLocalScale( Vector3:New( 1 , 0 , 1 ) )
                            if self.param.change_opa then 
                                self.fade.modelRenderer:SetOpacity( 0 ) 
                            end
                            return true
                        else    
                            return false
                        end
                    end
                end
            end
        }
        -- Slide centered close
        
 
    
    
    function Fade:New(gameObject,area,style,vitesse,wait_time,model_type,change_opa,callback)
        return setmetatable( { 
            gameObject = gameObject,
            init = false,
            state = false,
            start = false,
            area = area or 10,
            style = style or "classique",
            vitesse = vitesse or 1,
            wait_time = wait_time or 0,
            model_type = model_type or "black",
            callback = callback or Nil,
            param = {
                change_opa = change_opa or true
            },
            fade = nil,
            wait_tick = 0,
            tick = 0,
            duration = 120
        } , self ) 
    end
    
    function Fade:Init()
        if not self.init then
            do 
                local doinit = false
                for k,v in pairs(style) do
                    if k == self.style and not doinit then
                        if v.init(self) then
                            doinit = true
                            break
                        end
                    end
                end
                if not doinit then return false end
            end     
            self.init = true
            return true
        else
            return false
        end
    end
    
    function Fade:Start(callback)
        if self.init then
            self.start = true
            self.wait_tick = 0
            self.tick = 0
            if callback ~= nil then
                self.callback = callback
            end
        end
    end
    
    function Fade:Update()
        if self.init and self.start then
            if style[self.style].update(self) then
                self.callback(self.state)
            end
        end  
    end
    
end
