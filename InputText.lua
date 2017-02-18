function Behavior:Awake()

    -- > Callback action
    self.gameObject.OnClick = function( gameObject, callback ) 
        if self.onClickCallback ~= nil then self.onClickCallback[#self.onClickCallback + 1] = callback else self.onClickCallback = {callback} end
    end
    
    self.gameObject.OutClick = function( gameObject, callback )
        if self.OutClickCallback ~= nil then self.OutClickCallback[#self.OutClickCallback + 1] = callback else self.OutClickCallback = {callback} end
    end
    
    self.gameObject.OnHover = function( gameObject, callback ) 
        if self.onHoverCallback ~= nil then self.onHoverCallback[#self.onHoverCallback + 1] = callback else self.onHoverCallback = {callback} end
    end
    
    self.gameObject.OutHover = function( gameObject, callback ) 
        if self.outHoverCallback ~= nil then self.outHoverCallback[#self.outHoverCallback + 1] = callback else self.outHoverCallback = {callback} end
    end
    
    self.gameObject.OnFocus = function( gameObject, callback ) 
        if self.onFocusCallback ~= nil then self.onFocusCallback[#self.onFocusCallback + 1] = callback else self.onFocusCallback = {callback} end
    end
    
    self.gameObject.OutFocus = function( gameObject, callback ) 
        if self.outFocusCallback ~= nil then self.outFocusCallback[#self.outFocusCallback + 1] = callback else self.outFocusCallback = {callback} end
    end
    
    self.gameObject.OnNext = function( gameObject, callback ) 
        if self.OnNextCallback ~= nil then self.OnNextCallback[#self.OnNextCallback + 1] = callback else self.OnNextCallback = {callback} end
    end
    
    self.gameObject.OnCall = function( gameObject, callback ) 
        if self.OnCallCallback ~= nil then self.OnCallCallback[#self.OnCallCallback + 1] = callback else self.OnCallCallback = {callback} end
    end

    self.active = false
    local dochild = false
    
    local child = self.gameObject:GetChildren()
    if #child == 0 then
        local enfant = CS.CreateGameObject("Focus",self.gameObject)
        enfant:CreateComponent("TextRenderer"):SetFont( AK.Fonts.DefaultFont ) 
        enfant.transform:SetLocalPosition( Vector3:New( 0 , 0 , 0.1 ) ) 
        self.active = true
        self.input_child = enfant
    elseif #child == 1 then
        if string.find(child[1].Name,"Cursor",1) == 1 then
            self.cursor_active = true
            self.cursor = child[1]
            dochild = true
            local enfant = CS.CreateGameObject("texte",self.gameObject)
            enfant:CreateComponent("TextRenderer"):SetFont( AK.Fonts.DefaultFont ) 
            enfant.transform:SetLocalPosition( Vector3:New( 0 , 0 , 0.1 ) ) 
            self.active = true
            self.input_child = enfant
        else
            if child[1].textRenderer ~= nil then
                self.input_child = child[1]
                self.active = true
            else
                local enfant = child[1]
                enfant:CreateComponent("TextRenderer"):SetFont( AK.Fonts.DefaultFont ) 
                enfant.transform:SetLocalPosition( Vector3:New( 0 , 0 , 0.1 ) ) 
                self.active = true
                self.input_child = enfant
            end
        end
    elseif #child > 1 then
        for k,v in pairs(child) do 
            if string.find(v.Name,"Cursor",1) == 1 then
                self.cursor_active = true
                self.cursor = v
                dochild = true
            elseif string.find(string.lower(v.Name),"texte",1) == 1 then
                local enfant = v
                if enfant.textRenderer == nil then
                    enfant:CreateComponent("TextRenderer"):SetFont( AK.Fonts.DefaultFont ) 
                end
                enfant.transform:SetLocalPosition( Vector3:New( 0 , 0 , 0.1 ) ) 
                self.active = true
                self.input_child = enfant
            end
        end
    end
    
    if not dochild then
        for k,v in pairs(child) do
            if string.find(v.Name,"Cursor",1) == 1 then
                self.cursor_active = true
                self.cursor = v
            end
        end
    end
    
    if self.cursor_active then
        self.cursor.transform:SetLocalPosition( Vector3:New( 0 , 0 , 0.2 ) )
        if self.cursor.modelRenderer == nil then
            
            self.cursor:CreateComponent("ModelRenderer"):SetModel( CS.FindAsset( "Frameworks/Input/Cursor_y25", "Model" ) ) 
        end
    end
    
    -- > Si le modelRenderer est nil alors
    if self.gameObject.modelRenderer == nil then
        self.gameObject:CreateComponent("ModelRenderer"):SetModel( CS.FindAsset( "Frameworks/Input/Input_black" , "Model" ) ) 
    end
    
    -- > Si le bouton est actif (a bien un enfant texte)
    if self.active then

        -- > Input value
        self.input_min_length = 2
        self.input_max_length = 14
        self.input_type = "text"
        self.input_content = ""
        self.input_focus_value = self.input_child.Name
        self.input_child.textRenderer:SetText( self.input_focus_value ) 
        self.input_entered = false
    
        -- > Button value
        self.button_hover = false
        self.button_focus = false
        self.button_ascii = AK.Ascii:DefaultTable()
        
        -- > Cursor value
        if self.cursor_active then 
            self.cursor_blinktimer = 0.5
            self.cursor_blinkinterval = 0.2
            self.cursor_scale = 0
        end
        
        -- > Input function
        self.input = function( caractere )
            local numChar = string.byte(caractere)
            if self.button_ascii[numChar] then
                if #self.input_content <= (self.input_max_length -1) then    
                    self.input_content = self.input_content ..caractere
                    self.input_child.textRenderer:SetText(self.input_content)
                end
            elseif numChar == 13 then
                if #self.input_content >= (self.input_min_length +1) and #self.input_content <= (self.input_max_length - 1) then
                    CS.Input.OnTextEntered( nil )
                end
            elseif numChar == 8 then
                if #self.input_content ~= 0 then
                    self.input_content = self.input_content:sub( 1, #self.input_content - 1 )
                    self.input_child.textRenderer:SetText(self.input_content)
                end
            end
            self:CursorUpdate()
        end 
        
        -- > CSS SKILL
        if self.gameObject.modelRenderer ~= nil then 
            self.component = "model"
            local child = self.gameObject:GetChildren()
            if #child == 1 then
                local child_object = child[1] 
                if child_object.textRenderer ~= nil then
                    self.child_text = child_object
                    self.font = child_object.textRenderer:GetFont()
                    self.align = child_object.textRenderer:GetAlignment()
                    self.actu_text = child_object.textRenderer:GetText()
                    self.text_opacity = child_object.textRenderer:GetOpacity()
                    self.text_scale = child_object.transform:GetLocalScale()
                end
            end
        elseif self.gameObject.textRenderer ~= nil then
            self.component = "text"
            self.font = self.gameObject.textRenderer:GetFont()
            self.align = self.gameObject.textRenderer:GetAlignment()
            self.text_opacity = self.gameObject.textRenderer:GetOpacity()
            self.actu_text = self.gameObject.textRenderer:GetText()
            self.text_scale = self.gameObject.transform:GetLocalScale()
        end
        
        -- > Valeur par défault 
        self.default_value = true
        self.opacity = self.gameObject.modelRenderer:GetOpacity()
        self.scale = self.gameObject.transform:GetLocalScale()
        self.model = self.gameObject.modelRenderer:GetModel()
        self.name = self.gameObject.Name
        self.only_reset = nil
        self.dont_reset = nil
        
        self.ButtonAction = {
            ["opacity"] = function()
                if self.component == "model" then
                    self.gameObject.modelRenderer:SetOpacity( self.opacity )
                elseif self.component == "text" then
                    self.gameObject.textRenderer:SetOpacity( self.opacity )
                end
            end,
            ["text"] = function()
                if self.component == "model" then
                    if self.actu_text ~= nil then 
                        self.child_text.textRenderer:SetText(self.actu_text)
                    end
                elseif self.component == "text" then
                    self.gameObject.textRenderer:SetText(self.actu_text)
                end
            end,
            ["align"] = function()
                if self.component == "model" then
                    if self.actu_text ~= nil then 
                        self.child_text.textRenderer:SetAlignment(self.align)
                    end
                elseif self.component == "text" then
                    self.gameObject.textRenderer:SetAlignment(self.align)
                end
            end,
            ["font"] = function()
                if self.component == "model" then
                    if self.actu_text ~= nil then 
                        self.child_text.textRenderer:SetFont(self.font)
                    end
                elseif self.component == "text" then
                    self.gameObject.textRenderer:SetFont(self.font)
                end
            end,
            ["model"] = function()
                if self.component == "model" then
                    if self.gameObject.modelRenderer:GetModel() ~= self.model and not self.focus then
                        self.gameObject.modelRenderer:SetModel( self.model )
                    end
                end
            end,
            ["text_opacity"] = function()
                if self.component == "model" then
                    if self.actu_text ~= nil then 
                        self.child_text.textRenderer:SetOpacity( self.text_opacity )
                    end
                elseif self.component == "text" then
                    self.gameObject.textRenderer:SetOpacity( self.text_opacity )
                end
            end,
            ["scale"] = function()
                self.gameObject.transform:SetLocalScale( self.scale )
            end
        }
    
    end
    
end

function Behavior:Reset()
    if self.default_value and self.only_reset == nil then
    
        if self.component == "model" then 
            self.gameObject.modelRenderer:SetOpacity( self.opacity )
            if self.gameObject.modelRenderer:GetModel() ~= self.model and not self.focus then
                self.gameObject.modelRenderer:SetModel( self.model )
            end
            if self.actu_text ~= nil then
                self.child_text.textRenderer:SetAlignment(self.align)
                self.child_text.textRenderer:SetFont(self.font)
                self.child_text.textRenderer:SetOpacity( self.text_opacity )
            end
        elseif self.component == "text" then
            self.gameObject.textRenderer:SetOpacity( self.text_opacity )
            self.gameObject.textRenderer:SetAlignment(self.align)
            self.gameObject.textRenderer:SetFont(self.font)
        end
        self.gameObject.transform:SetLocalScale( self.scale )
        
    end
    
    if self.only_reset ~= nil then
        if type(self.only_reset) == "table" then 
            for k,v in pairs(self.only_reset) do
                for a,b in pairs(self.ButtonAction) do
                    if a == string.lower(v) then
                        b()
                    end
                end
            end
        end
    end
end

function Behavior:Reset_Button()
    self.input_entered = false
    self.input_child.textRenderer:SetText( self.input_focus_value ) 
    self.button_hover = false
    self.button_focus = false
    self.input_content = ""
    self:CursorUpdate()
end

function Behavior:Hover(v)
    if v then
        if self.onHoverCallback ~= nil then
            for _,v in pairs(self.onHoverCallback) do 
                v( self.gameObject, self.opacity, self.scale, self.model ) 
            end
        end
        if not self.button_focus then
            self.gameObject.modelRenderer:SetModel( CS.FindAsset( "Frameworks/Input/Input_black_hover", "Model" ) )
        end
    else
        if self.outHoverCallback ~= nil then
            for _,v in pairs(self.outHoverCallback) do 
                v( self.gameObject, self.opacity, self.scale, self.model ) 
            end
        end
        self:Reset()
    end
end

function Behavior:Focus(v)
    if v then
        if self.input_child.textRenderer:GetText() == self.input_focus_value then
            self.input_child.textRenderer:SetText("")
        end 
        if self.onFocusCallback ~= nil then
            for _,v in pairs(self.onFocusCallback) do
                v( self.gameObject , self )
            end
        end
        CS.Input.OnTextEntered( self.input )
        self.gameObject.modelRenderer:SetModel( CS.FindAsset( "Frameworks/Input/Input_black_focus", "Model" ) )
        self.input_entered = true
    else
        self.gameObject.modelRenderer:SetModel( CS.FindAsset( "Frameworks/Input/Input_black", "Model" ) )
        CS.Input.OnTextEntered( nil )
        self.input_entered = false
        if self.outFocusCallback ~= nil then
            for _,v in pairs(self.outFocusCallback) do
                v( self.gameObject , self )
            end
        end
        if self.outClickCallback ~= nil then
            for _,v in pairs(self.outClickCallback) do 
                v( self.gameObject , self ) 
            end
        end
    end
end

function Behavior:Call()
    if self.OnCallCallback ~= nil then
        for _,v in pairs(self.OnCallCallback) do 
            v( self ) 
        end
    end
end

function Behavior:CursorUpdate(V)
    if self.cursor_active then 
        V = V or false
        if V then
            self.cursor_blinktimer = ( self.cursor_blinktimer + 1 / 60 ) % ( self.cursor_blinkinterval * 2 )
            if self.cursor_blinktimer < self.cursor_blinkinterval then
                self.cursor_scale = 1
            else
                self.cursor_scale = 0
            end
        else
            local width = self.input_child.textRenderer:GetTextWidth()
            local offset = -width / 2.1
            self.cursor.transform:SetLocalPosition( Vector3:New( width + offset, 0, 0 ) )
        end
        
        if #self.input_content == self.input_max_length then
            self.cursor.transform:SetLocalScale( Vector3:New( 0 ) )
            return
        end
        
        if self.button_focus then
            self.cursor.transform:SetLocalScale( Vector3:New( self.cursor_scale ) ) 
        else
            self.cursor.transform:SetLocalScale( Vector3:New( 0 ) ) 
        end    
    end
end

function Behavior:Update()

    if self.active then 
    
        if self.OnNextCallback ~= nil then
            for k,v in pairs(self.OnNextCallback) do
                v( self , self.gameObject , k ) 
            end
        end
        
        if AK.UI.ray:IntersectsModelRenderer( self.gameObject.modelRenderer ) ~= nil  then
            if not self.button_hover then
                self.button_hover = true
                self:Hover(true)
            end
            if CS.KeyReleased("SG") and not self.button_focus then
                if self.onClickCallback ~= nil then
                    for _,v in pairs(self.onClickCallback) do 
                        v( self.gameObject , self ) 
                    end
                end
                self.button_focus = true
                self:Focus(true)
                self:CursorUpdate()
            end
        else
            if self.button_hover then
                self.button_hover = false
                self:Hover(false)
                if self.button_focus then
                    self.button_focus = false
                    self:Focus(false)
                end
            end
        end
        
        self:CursorUpdate(true)
    end
    
end
