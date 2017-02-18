function AK.Ascii:NewTable(ValidChar)
    local Tbl = {}
    for i=1,#ValidChar do
        Tbl[i] = true
    end
    function Tbl:AddChar(Chr)
        self[Chr] = true
    end
    function Tbl:RemoveChar(Chr)
        self[Chr] = false
    end
    return setmetatable(Tbl,{__index = function() return false end})
end

function AK.Ascii:RestrictedTable(AddChar,RemoveChar)
    local Tbl = {     [9] = true , [17] = true , [32] = true , [48] = true,  [49] = true,  [50] = true,  [51] = true,  [52] = true,  [53] = true,
      [54] = true,    [55] = true,  [56] = true,  [57] = true,  [65] = true,  [66] = true,  [67] = true,
      [68] = true,    [69] = true,  [70] = true,  [71] = true,  [72] = true,  [73] = true,  [74] = true,  
      [75] = true,    [76] = true,  [77] = true,  [78] = true,  [79] = true,  [80] = true,  [81] = true,  
      [82] = true,    [83] = true,  [84] = true,  [85] = true,  [86] = true,  [87] = true,  [88] = true,    
      [89] = true,    [90] = true,  [97] = true,  [98] = true,  [99] = true,  [100] = true, [101] = true, 
      [102] = true,   [103] = true, [104] = true, [105] = true, [106] = true, [107] = true, [108] = true, 
      [109] = true,   [110] = true, [111] = true, [112] = true, [113] = true, [114] = true, [115] = true, 
      [116] = true,   [117] = true, [118] = true, [119] = true, [120] = true, [121] = true, [122] = true, 
      [95] = true
    }
    if AddChar ~= nil then
        for i=1,#AddChar do
            Tbl[i] = true
        end
    end
    if RemoveChar ~= nil then
        for i=1,#RemoveChar do
            Tbl[i] = false
        end
    end
    function Tbl:AddChar(Chr)
        self[Chr] = true
    end
    function Tbl:RemoveChar(Chr)
        self[Chr] = false
    end
    return setmetatable(Tbl,{__index = function() return false end})
end

function AK.Ascii:DefaultTable(AddChar,RemoveChar)
    local Tbl = {     
      [9] = true , [13] = true , [17] = true , [32] = true,  [33] = true,  [34] = true,  [35] = true,  [36] = true,  [37] = true,  [38] = true,
      [39] = true,  [40] = true,  [41] = true,  [42] = true,  [43] = true,  [44] = true,  [45] = true, 
      [46] = true,  [47] = true,  [48] = true,  [49] = true,  [50] = true,  [51] = true,  [52] = true,
      [53] = true,  [54] = true,  [55] = true,  [56] = true,  [57] = true,  [58] = true,  [59] = true,
      [60] = true,  [61] = true,  [62] = true,  [63] = true,  [64] = true,  [65] = true,  [66] = true,
      [67] = true,  [68] = true,  [69] = true,  [70] = true,  [71] = true,  [72] = true,  [73] = true,
      [74] = true,  [75] = true,  [76] = true,  [77] = true,  [78] = true,  [79] = true,  [80] = true,
      [81] = true,  [82] = true,  [83] = true,  [84] = true,  [85] = true,  [86] = true,  [87] = true,
      [88] = true,  [89] = true,  [91] = true,  [92] = true,  [93] = true,  [94] = true,  [95] = true,
      [90] = true,  [97] = true,  [98] = true,  [99] = true,  [100] = true, [101] = true, [102] = true,
      [103] = true, [104] = true, [105] = true, [106] = true, [107] = true, [108] = true, [109] = true,
      [110] = true, [111] = true, [112] = true, [113] = true, [114] = true, [115] = true, [116] = true,
      [117] = true, [118] = true, [119] = true, [120] = true, [121] = true, [122] = true, [123] = true,
      [124] = true, [125] = true, [126] = true
    }
    if AddChar ~= nil then
        for i=1,#AddChar do
            Tbl[i] = true
        end
    end
    if RemoveChar ~= nil then
        for i=1,#RemoveChar do
            Tbl[i] = false
        end
    end
    function Tbl:AddChar(Chr)
        self[Chr] = true
    end
    function Tbl:RemoveChar(Chr)
        self[Chr] = false
    end
    return setmetatable(Tbl,{__index = function() return false end})
end

function AK.Ascii:Bypass(Char)
    return self.BypassTable[Char].v, self.BypassTable[Char].t
end

function AK.Ascii:AddBypass(Char,ReplaceV,ReplaceT)
    self.BypassTable[Char].v = ReplaceV
    self.BypassTable[Char].t = ReplaceT
end


AK.TXT = {} 
do 

    local Language = AK.TXT
    
    Language.Data = {}
    Language.ObjectList = {}
    Language.Librairie = {}
    
    Language.Error = {__index = function() 
        return "LANG ERR" 
    end }
    
    function Language:Construct()
        for i = 1 ,#Language.Librairie do
            Language.Librairie[i]()
        end
    end
    
    function Language:Return(lang)
        self.Data[lang] = {}
        setmetatable(self.Data[lang],Language.Error)
        return self.Data[lang] 
    end
    
    function Language:New(lang)
        if self.Data[lang] ~= nil then 
            self.ActiveLang = lang
            local R = self.ObjectList
            for i = 1, #R do
                R[i]:SendMessage("Refresh")
            end
        end
    end 
    
    setmetatable(Language,Language)
        
    -- > Language metamethode
    Language.__index = Language
    Language.__call = function(mt,lang)
        mt:New(lang)
    end
    
end
