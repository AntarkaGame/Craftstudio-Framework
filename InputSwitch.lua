function Behavior:Reset_Button()
    self.input_child.transform:SetLocalPosition( Vector3:New( -1.5625 , 0 , 0.1 ) ) 
    self.button_state = true
    self:Set(true)
end

function Behavior:Set(V)
end

function Behavior:Get()
end

function Behavior:Awake()
    if self.wakning == nil then
        self.wakning = true
        self.active = true
        self.input_child = nil
        self.input_trigger = {}
        
        local child = self.gameObject:GetChildren()
        
        -- > On positionne et configure nos enfants
        if #child == 0 then
            local enfant = CS.New( "Locket" , self.gameObject ) 
            enfant:CreateComponent("ModelRenderer"):SetModel( CS.FindAsset( "Frameworks/Input/Input_switch_locket" , "Model" ) ) 
            enfant.transform:SetLocalPosition( Vector3:New( -1.5625 , 0 , 0.1 ) ) 
            self.input_child = enfant
        elseif #child == 1 then
            if child[1].modelRenderer == nil then
                child[1]:CreateComponent("ModelRenderer"):SetModel( CS.FindAsset( "Frameworks/Input/Input_switch_locket" , "Model" ) ) 
            end
            child[1].transform:SetLocalPosition( Vector3:New( -1.5625 , 0 , 0.1 ) ) 
            self.input_child = child[1]
        else
            self.active = false
        end
        
        -- > On crée un gameObject si inexistant
        if self.gameObject.modelRenderer == nil then
            self.gameObject:CreateComponent("ModelRenderer"):SetModel( CS.FindAsset( "Frameworks/Input/Input_switch" , "Model" ) )
        end
        
        -- > On crée deux modèles non-opa pour la collider.
        do
            local on = CS.New( "on" , self.gameObject ) 
            on:CreateComponent("ModelRenderer"):SetModel( CS.FindAsset( "Frameworks/Input/Input_switch_locket" , "Model" ) ) 
            on.transform:SetLocalPosition( Vector3:New( -1.5625 , 0 , 0.1 ) ) 
            on.modelRenderer:SetOpacity(0)
            
            local off = CS.New( "off" , self.gameObject ) 
            off:CreateComponent("ModelRenderer"):SetModel( CS.FindAsset( "Frameworks/Input/Input_switch_locket" , "Model" ) ) 
            off.transform:SetLocalPosition( Vector3:New( 1.5625 , 0 , 0.1 ) ) 
            off.modelRenderer:SetOpacity(0)
            
            self.input_trigger = {on,off}
        end
        
        self.button_hover = false
        self.button_state = true
    end
end

function Behavior:Switch(V)
    local PosX = self.input_child.LocalPos.x
    if V == "on" and not self.button_state then
        self.button_state = true
        self:Set(true)
        PosX = -1.5625
    elseif V == "off" and self.button_state then
        self.button_state = false
        self:Set(false)
        PosX = 1.5625
    end
    self.input_child.transform:SetLocalPosition( Vector3:New( PosX , 0 , 0.1 ) )
end

function Behavior:Update()
    
    if self.active then
    
        local ray = AK.UI.ray
        if ray:IntersectsModelRenderer( self.gameObject.modelRenderer ) ~= nil then
            if not self.button_hover then
                self.button_hover = true
            end
        else
            if self.button_hover then
                self.button_hover = false
            end
        end
        
        if self.button_hover then
            for k,v in pairs(self.input_trigger) do 
                if ray:IntersectsModelRenderer( v.modelRenderer ) ~= nil then
                    if CS.KeyReleased("SG") then
                        self:Switch(v.Name)
                    end
                end
            end
        end
        
    end
    
end
