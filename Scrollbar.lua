AK.Scroll = {
    __call = function(I)
        I:Call()
    end
} 
    
do 
    local Scroll = AK.Scroll
    Scroll.__index = Scroll
    
    function Scroll:New(gameObject,axe,container,coef,focus_model,fond_molette,molette_active)
        return setmetatable( { 
            gameObject = gameObject,
            active = false,
            max = nil,
            min = nil,
            axe = axe,
            scrollbar = nil,
            scrollbar_model = false,
            scrollbar_focus = focus_model or "Frameworks/Scroll/Bar_focus",
            molette_active = molette_active,
            container = container,
            clicked = false,
            flecheH = nil,
            flecheB = nil,
            fond_molette = fond_molette,
            coef = coef or 100,
            factor = 0
        } , self ) 
    end
    
    function Scroll:Init()
        local child = self.gameObject:GetChildren()
        
        for k,v in pairs(child) do
            local name = string.lower(v.Name)
            
            if string.find(name,"max",1) == 1 then
                self.max = self.axe and v.LocalPos.y or v.LocalPos.x
            elseif string.find(name,"min",1) == 1 then
                self.min = self.axe and v.LocalPos.y or v.LocalPos.x
            elseif string.find(name,"scrollbar",1) == 1 then
                self.scrollbar = v
                self.scrollbar_model = CS.CheckModel( v , "Frameworks/Scroll/Bar" ) 
            elseif string.find(name,"flecheh",1) == 1 then
                self.flecheH = v
            elseif string.find(name,"flecheb",1) == 1 then
                self.flecheB = v
            end
        end
        
        if self.scrollbar ~= nil and self.max ~= nil and self.min ~= nil then self.active = true else return false end
    end
    
    function Scroll:GoFactor()
        local bar = self.scrollbar.LocalPos
        self.factor = math.round( ( self.axe and bar.y - self.min or bar.x - self.min )  / ( self.max - (self.min) ) * self.coef)
        if self.container ~= nil then 
            self.container:SendMessage("Move", { factor = self.factor , coef = self.coef, axe = self.axe } )  
        end
    end
    
    function Scroll:Move()
        local warp = AK.UI.ray.position + AK.UI.ray.direction
        local bar = self.scrollbar.LocalPos
        warp = self.axe and warp.y - self.gameObject.Pos.y or warp.x - self.gameObject.Pos.x
        
        if self.axe then 
            warp = (warp < self.min) and self.min or ( ( warp > self.max ) and self.max or warp ) 
        else
            warp = (warp > self.min) and self.min or ( ( warp < self.max ) and self.max or warp ) 
        end

        if self.axe then 
            self.scrollbar.transform:SetLocalPosition( Vector3:New( bar.x , warp , bar.z ) )  
        else
            self.scrollbar.transform:SetLocalPosition( Vector3:New( warp , bar.y , bar.z ) ) 
        end
        
        self:GoFactor()
    end
    
    function Scroll:Molette(V)
        if self.molette_active then 
            local bar = self.scrollbar.LocalPos
            local axe = self.axe and bar.y or bar.x
            axe = V and ( ( axe + 2 > self.max ) and self.max or axe + 2 ) or ( ( axe - 2 < self.min ) and self.min or axe - 2 )
            
            if self.axe then
                self.scrollbar.transform:SetLocalPosition( Vector3:New( bar.x , axe , bar.z ) ) 
            else
                self.scrollbar.transform:SetLocalPosition( Vector3:New( axe , bar.y , bar.z ) ) 
            end
            
            self:GoFactor()
        end
    end
 
    function Scroll:Call()
        
        local ray = AK.UI.ray
        if self.active then
        
            local molette = false
            
            if self.clicked then
                self:Move()
                if CS.KeyReleased("SG") then 
                    self.clicked = false
                    AK.OnDrag = true
                    self.scrollbar.modelRenderer:SetModel( self.scrollbar_model ) 
                end 
            else
                if ray:IntersectsModelRenderer( self.scrollbar.modelRenderer ) ~= nil then 
                    if CS.KeyDown("SG") and AK.OnDrag then 
                        self.clicked = true 
                        AK.OnDrag = false
                        self.scrollbar.modelRenderer:SetModel( CS.FindAsset( self.scrollbar_focus , "Model" ) ) 
                    end
                    molette = true
                elseif ray:IntersectsModelRenderer( self.gameObject.modelRenderer ) ~= nil then
                    if CS.KeyReleased("SG") then
                        self:Move()
                    end
                    molette = true
                end
            end 
            
            if self.fond_molette ~= nil then
                if ray:IntersectsModelRenderer( self.fond_molette.modelRenderer ) ~= nil then
                    molette = true
                end
            end
            
            if molette then 
                if CS.KeyPressed("SMH") then
                    self:Molette(false)
                elseif CS.KeyPressed("SMB") then 
                    self:Molette(true)
                end 
            end
            
            if CS.KeyReleased("SG") then
                if self.flecheH ~= nil then
                    if ray:IntersectsModelRenderer( self.flecheH.modelRenderer ) ~= nil then
                        self:Molette(true)
                    end
                end
                
                if self.flecheB ~= nil then
                    if ray:IntersectsModelRenderer( self.flecheB.modelRenderer ) ~= nil then
                        self:Molette(false)
                    end
                end
            end
            
        end
    end 
    
    function Scroll:Set(V)
        local coef_warp = 100 - (self.coef - V.coef)
        local bar = self.scrollbar.LocalPos 
        
        if coef_warp >= 50 then
            bar.x = (self.min / 50) * (coef_warp - 50) 
        else 
            bar.x = (self.max / 50) * (50 - coef_warp)
        end
        
        self.scrollbar.transform:SetLocalPosition( bar ) 
    end
    
    function Scroll:Get()
        return self.factor
    end
    
end
