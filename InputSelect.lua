function Behavior:Awake()
    if self.wakning == nil then
        self.wakning = true
        self.intersects = 0
        self.active = true
        
        self.gameObject.OnChoice = function( gameObject, callback ) 
            if self.onChoiceCallback ~= nil then 
                self.onChoiceCallback[#self.onChoiceCallback + 1] = callback 
            else 
                self.onChoiceCallback = {callback} 
            end
        end
        
        if self.active then
            
            self.input_default = nil 
            self.input_choix = {}
            self.input_texte = nil
            self.input_action = function(key) end
            
            local child = self.gameObject:GetChildren()
            local back_key 
            for k,v in pairs(child) do 
                local name = v.Name
                
                -- > Check if the key is default value
                if string.find(name,"[default]",1) and self.input_default == nil then
                    local key = string.sub(name,10)
                    --v:SetName(key)
                    back_key = k
                    self.input_default = v
                end
                
                -- > Add new key
                self.input_choix[k] = v
            end
            
            if self.input_default == nil then
                for k,v in pairs(child) do
                    if v:GetName() == Storage["Option"].general["Language"] then
                        self.input_default = child[k]
                    end
                end
            end
            
            local text_child 
            text_child = CS.New("Texte",self.gameObject)
            text_child:CreateComponent("TextRenderer"):SetFont( CS.FindAsset("Sample Fonts/Russo One" , "Font" ) ) 
            text_child.transform:SetLocalPosition( Vector3:New( -5 , 0 , 0.1 ) )
            text_child.transform:SetLocalScale( Vector3:New( 0.8 ) ) 
            text_child.textRenderer:SetAlignment( TextRenderer.Alignment.Left ) 
            text_child.textRenderer:SetText( self.input_default.Name ) 
            self.input_texte = text_child
            self.input_default = back_key
            
            if self.gameObject.modelRenderer == nil then
                self.gameObject:CreateComponent("ModelRenderer"):SetModel( CS.FindAsset( "Frameworks/Input/Input_select" , "Model" ) ) 
            end
            
            -- > While createGameObject with input_choix
            for k,v in pairs(self.input_choix) do
                local new_choix 
                new_choix = CS.New(v.Name,self.gameObject)
                new_choix:CreateComponent("ModelRenderer"):SetModel( CS.FindAsset( "Frameworks/Input/Input_select_choix" , "Model" ) ) 
                new_choix.transform:SetLocalPosition( Vector3:New( 0 , 0 , -0.5 ) ) 
                new_choix:CreateScriptedBehavior( CS.FindAsset( "Data/AKInput/Input_select_child" , "Script" ) , {key=k} ) 
                
                local new_choix_texte
                new_choix_texte = CS.New("texte",new_choix)
                new_choix_texte:CreateComponent("TextRenderer"):SetFont( CS.FindAsset("Sample Fonts/Russo One" , "Font" ) ) 
                new_choix_texte.transform:SetLocalPosition( Vector3:New( 0 , 0 , 0.1 ) ) 
                new_choix_texte.transform:SetLocalPosition( Vector3:New( -5 , 0 , 0.1 ) )
                new_choix_texte.transform:SetLocalScale( Vector3:New( 0.7 ) ) 
                new_choix_texte.textRenderer:SetAlignment( TextRenderer.Alignment.Left ) 
                new_choix_texte.textRenderer:SetText( v.Name ) 
                
                self.input_choix[k] = new_choix
                CS.Destroy( v ) 
            end
           
            
            self.button_focus = true
            self.button_volet = false
            self.button_volet_incre = 2.8
            self.button_hover = false
            self.button_state = true
            self.button_inactive_byclick = true
            
        end
    end
end

function Behavior:CreateNewItem(T)

end

function Behavior:New_default(V)
    if V ~= nil then
        self.input_texte.textRenderer:SetText( self.input_choix[V.key].Name ) 
        self.input_action(self.input_choix[V.key].Name)
        if self.onChoiceCallback ~= nil then
            for k,v in pairs(self.onChoiceCallback) do
                v( self , self.input_choix[V.key].Name ) 
            end
        end
        self:Focus(false)
    end
end

function Behavior:Get()
    return self.input_texte.textRenderer:GetText()
end

function Behavior:Volet(V)  
    V = V or false
    if V then
        local incre = self.button_volet_incre
        for _,v in pairs(self.input_choix) do
            v.transform:SetLocalPosition( Vector3:New( 0 , -incre , 0 ) ) 
            incre = incre + 2.5
            v:SendMessage("Call",{true})
        end
    else
        for _,v in pairs(self.input_choix) do
            v.transform:SetLocalPosition( Vector3:New( 0 , 0 , -0.5 ) ) 
            v:SendMessage("Call",{false})
        end
    end
end

function Behavior:Reset_Button() 
    self.button_focus = true
    self.button_volet = false
    self.gameObject.modelRenderer:SetModel( CS.FindAsset( "Frameworks/Input/Input_select" , "Model" ) ) 
    self:New_default({key=self.input_default})
end

function Behavior:Put(V)
    V = V or false
    if V then
        self.active = true
        if not self.button_state then
            self.button_state = true
            self.gameObject.modelRenderer:SetModel( CS.FindAsset( "Frameworks/Input/Input_select" , "Model" ) ) 
        end
    else
        self.active = false
        if self.button_state then
            self.button_state = false
            self.gameObject.modelRenderer:SetModel( CS.FindAsset( "Frameworks/Input/Input_select_inactive" , "Model" ) ) 
        end
    end
end

function Behavior:Focus(V)
    V = V or false
    if V then
        if self.button_focus then
            self.gameObject.modelRenderer:SetModel( CS.FindAsset( "Frameworks/Input/Input_select_focus" , "Model" ) ) 
            self:Volet(true)
            self.button_focus = false
            self.button_volet = true
        end
    else
        if not self.button_focus then 
            self.gameObject.modelRenderer:SetModel( CS.FindAsset( "Frameworks/Input/Input_select" , "Model" ) ) 
            self:Volet(false)
            self.button_focus = true
            self.button_volet = false
        end
    end
end

function Behavior:Update()
    
    if self.active and self.button_state then 
        
        self.intersects = false
        
        if not self.button_focus then 
            for _,v in pairs(self.input_choix) do
                if AK.UI.ray:IntersectsModelRenderer( v.modelRenderer ) ~= nil then
                    self.intersects = true
                end
            end
        end
        
        if AK.UI.ray:IntersectsModelRenderer( self.gameObject.modelRenderer ) ~= nil then
            self.intersects = true
            if not self.button_hover then
                self.button_hover = true
            end
            if CS.KeyReleased("SG") then
                self:Focus( self.button_focus ) 
            end
        else
            if self.button_hover then
                self.button_hover = false
            end
        end
        
        if not self.intersects and not self.button_focus then
            if self.button_inactive_byclick then
                if CS.KeyReleased("SG") then
                    self.intersects = false
                    self:Focus(false)
                end
            else
                self.intersects = false
                self:Focus( false ) 
            end
        end
    
    end
    
end
