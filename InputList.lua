function Behavior:Reset_Button()
    self.input_focus:SendMessage("Focus",{false})
    self.input_focus = self.input_choix[self.input_child_save]
    self.input_choix[self.input_child_save]:SendMessage("Focus",{true})
end

function Behavior:Get()
end

function Behavior:Awake()
    if self.wakning == nil then 
        self.wakning = true
        self.active = true
        if self.input_name == "nil" then
            self.active = false
        end
        self.input_child = nil
        self.input_list = nil
        self.input_default = nil
        self.input_choix = {}
        self.input_direction = true
        self.input_decal = 13
        self.input_incre = 7
        self.input_focus = nil
        
        self.input_child_save = nil
        
        local child = self.gameObject:GetChildren()
        
        if self.active then 
        
            --[[if self.gameObject.modelRenderer == nil then
                self.gameObject:CreateComponent("ModelRenderer"):SetModel( CS.FindAsset( "Frameworks/Input/Input_black" , "Model" ) )
            end ]]
            
            if #child == 0 then
                self.active = false
            elseif #child == 1 then
                local enfant = child[1]
                
                if string.find(child[1].Name,"liste",1) == 1 and self.input_list == nil then
                    self.input_list = child[1]
                    --enfant = CS.New( "texte" , self.gameObject ) 
                end
                
    
                --[[if enfant.textRenderer == nil then
                    enfant:CreateComponent("TextRenderer"):SetFont( AK.Fonts() ) 
                else
                    if enfant.textRenderer:GetFont() == nil then
                        enfant.textRenderer:SetFont( AK.Fonts() ) 
                    end
                end 
                enfant.textRenderer:SetText( self.input_name ) 
                enfant.transform:SetLocalPosition( Vector3:New( 0 , 0 , 0.1 ) )  ]]
                self.input_child = enfant
            elseif #child == 2 then
                local dochild = true
                for k,v in pairs(child) do 
                    local name = v.Name
                    if string.find(name,"liste",1) == 1 and self.input_list == nil then
                        self.input_list = v
                    elseif dochild then
                        if v.textRenderer ~= nil then
                            if v.textRenderer:GetFont() == nil then
                                v.textRenderer:SetFont( AK.Fonts() ) 
                            end
                            v.textRenderer:SetText( self.input_name ) 
                            v.transform:SetLocalPosition( Vector3:New( 0 , 0 , 0.1 ) ) 
                        else
                            v:CreateComponent( "TextRenderer" ):SetFont( AK.Fonts() ) 
                            v.textRenderer:SetText( self.input_name ) 
                            v.transform:SetLocalPosition( Vector3:New( 0 , 0 , 0.1 ) ) 
                        end
                        dochild = false
                    end
                end
            else
                self.active = false
            end
            
            if self.input_list ~= nil then
                local child_list = self.input_list:GetChildren()
                
                if #child_list > 1 then
                    local incre = self.input_incre
                    do
                        local Pos = self.input_list.LocalPos
                        self.input_list.transform:SetLocalPosition( Vector3:New( self.input_decal , Pos.y , Pos.z ) ) 
                    end
                    
                    for k,v in pairs(child_list) do
                                
                        self.input_choix[k] = v 
                        
                        if v.modelRenderer == nil then
                            v:CreateComponent("ModelRenderer"):SetModel( CS.FindAsset( "Frameworks/Input/Input_list" , "Model" ) ) 
                        end
                        
                        if self.input_focus == nil then
                            v:CreateScriptedBehavior( CS.FindAsset( "Data/AKInput/Input_list_child" , "Script" ) , {key=k,focus=true,parent=self.gameObject.Name} )                         
                            self.input_child_save = k
                            self.input_focus = v
                        else
                            v:CreateScriptedBehavior( CS.FindAsset( "Data/AKInput/Input_list_child" , "Script" ) , {key=k,focus=false,parent=self.gameObject.Name} ) 
                        end
                        
                        local Pos = self.input_list.LocalPos
                        if k == 1 then
                            v.transform:SetLocalPosition( Vector3:New( 0 , Pos.y , Pos.z ) ) 
                        else
                            if k ~= 2 then
                                incre = incre + incre
                            end
                            v.transform:SetLocalPosition( Vector3:New( 0 + incre , Pos.y , Pos.z ) ) 
                        end
                        
                    end
                else
                    self.active = false
                end 
                
            else
                self.active = false
            end
            
        end
    end
end

function Behavior:New_focus(V)
    if type(V) == "table" then
        print(V.key)
        self.input_focus:SendMessage("Focus",{false})
        self.input_focus = self.input_choix[V.key]
        self.input_choix[V.key]:SendMessage("Focus",{true})
    end
end
