AK.SoundController = {
    __call = function(mt)
        mt:Update()
    end
} 

do 
    
    local SoundController = AK.SoundController 
    
    --> Methodes magiques
    SoundController.__index = SoundController
    
    function SoundController:New()
        if AK.Background == nil then
            AK.Background = {}
        end
        
        return setmetatable( { 
            playlist = {} , 
            field = "Musique/",
            category = nil,
            track = nil,
            track_name = nil,
            init = false,
            started = false
        } , self ) 
    end
    
    function SoundController:AddCategory(name)
        if type(name) == "string" then 
            local _env = self.playlist[name]
            if _env == nil then
                _env = {}
            end
        elseif type(name) == "table" then
            local search = pairs
            for _,v in search(name) do
                if self.playlist[v]  == nil then
                    self.playlist[v] = {}
                end
            end
        end
    end
    
    function SoundController:AddSound(category,name,defaultVolume)
        defaultVolume = defaultVolume or 1 
        if category ~= nil then
            local _env = self.playlist[category]
            if _env ~= nil then
                local TypeName = type(name) 
                if TypeName == "table" then
                    local search = pairs
                    for _,v in search(name) do 
                        self.playlist[category][v] = {
                            v,
                            defaultVolume
                        }
                    end
                    
                elseif TypeName == "string" then
                    self.playlist[category][name] = {
                        name,
                        defaultVolume
                    }
                    
                end
            end
        end
    end 
    
    function tablelength(T)
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    
    function SoundController:Init(category,trackID)
        trackID = trackID or 1
        local _env = self.playlist[category]
        if _env ~= nil then
            
            self.category = category 
            
            if type(trackID) == "number" then
                
                local lh = tablelength(self.playlist[category])
                for k,_ in pairs(self.playlist[category]) do
                    self.track = self.playlist[category][k] 
                    self.track_name = k
                    break
                end
            else
                self.track = self.playlist[category][trackID] 
                self.track_name = trackID
            end
            
            self.init = true
        end
    end
    
    function SoundController:Switch(category,trackID)
        if self.category ~= category then 
            if self.playlist[category] ~= nil then
            
                self.category = category
                self.started = false
                
                local state = AK.Background:GetState() 
                if state == SoundInstance.State.Playing then
                    AK.Background:Stop()
                end
                
                if trackID ~= nil then
                    self.track = self.playlist[category][trackID] 
                    self.track_name = trackID
                    self.init = true
                else
                
                    local search = pairs
                    for k,_ in search(self.playlist[category]) do
                        self.track = self.playlist[category][k] 
                        self.track_name = k
                        self.init = true
                        break
                    end
                end 
                
            end
        end
    end
    
    function SoundController:Next(trackID)
        
        local RS = function() 
            local next = false
            local next_check = false
            local search = pairs 
            
            for k,_ in search(self.playlist[self.category]) do
                if next then 
                    self.track = self.playlist[self.category][k] 
                    self.track_name = k
                    self.init = true
                    next_check = false
                    break
                else
                    if k == self.track_name then
                        next = true
                        next_check = true
                    end
                end
            end
            
            if next_check then
                for k,_ in search(self.playlist[self.category]) do
                    self.track = self.playlist[self.category][k] 
                    self.track_name = k
                    self.init = true
                    break
                end
            end
        end
        
        if AK.Background:GetState() == SoundInstance.State.Stopped then
            RS()
        elseif AK.Background:GetState() == SoundInstance.State.Playing then 
            self.started = false
            AK.Background:Stop()
            
            if trackID ~= nil then
                if self.playlist[self.category][trackID] ~= nil then 
                    self.track = self.playlist[self.category][trackID] 
                    self.track_name = trackID
                    self.init = true
                end
            else
                RS()
            end
        end 
    end
    
    function SoundController:Pause()
        local state = AK.Background:GetState() 
        
        if state == SoundInstance.State.Playing then 
            AK.Background:Pause()
        elseif state == SoundInstance.State.Paused then 
            AK.Background:Resume()
        end
    end
    
    function SoundController:Update()
        
        if self.init then
            if not self.started then
                self.started = true
            end
            
            local _env = self.track
            AK.Background = CS.FindAsset( self.field.._env[1] ):CreateInstance()
            AK.Background:SetVolume( _env[2] * Storage["Option"].sound["general"] * Storage["Option"].sound["musique"] )
            AK.Background:SetLoop( false )
            AK.Background:Play() 
            self.init = false
        end
        
        if self.started then
            if AK.Background:GetState()  == SoundInstance.State.Stopped then
                self:Next()
            end
        end
    end
    
end
