-- ============================================
-- AI-STYLE NOVAUI - Modern Developer Interface
-- ============================================

local NovaAI = {
    Version = "3.0.0",
    Theme = {
        Dark = {
            Background = Color3.fromRGB(13, 17, 23),    -- VS Code dark
            Surface = Color3.fromRGB(22, 27, 34),       -- GitHub dark
            SurfaceHover = Color3.fromRGB(33, 38, 45),
            Primary = Color3.fromRGB(88, 166, 255),     -- VS Code blue
            PrimaryHover = Color3.fromRGB(120, 190, 255),
            Secondary = Color3.fromRGB(48, 54, 61),
            Text = Color3.fromRGB(230, 237, 243),
            TextSecondary = Color3.fromRGB(139, 148, 158),
            Border = Color3.fromRGB(48, 54, 61),
            Success = Color3.fromRGB(46, 160, 67),
            Danger = Color3.fromRGB(248, 81, 73),
            Warning = Color3.fromRGB(218, 165, 32),
            Terminal = Color3.fromRGB(0, 0, 0),
            Code = Color3.fromRGB(30, 30, 40),
        }
    },
    Windows = {},
    Panels = {},
}

-- Services
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RS = game:GetService("RunService")

-- UI Oluşturucu
local function createUI()
    local sg = Instance.new("ScreenGui")
    sg.Name = "NovaAI"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local plr = Players.LocalPlayer
    if plr and plr:FindFirstChild("PlayerGui") then
        sg.Parent = plr.PlayerGui
    else
        sg.Parent = CoreGui
    end
    return sg
end

-- ============================================
-- ANA PENCERE (VS Code Tarzı)
-- ============================================
local WindowClass = {}
WindowClass.__index = WindowClass

function NovaAI:CreateWindow(config)
    config = config or {}
    local theme = NovaAI.Theme.Dark
    local sg = createUI()
    
    -- Ana Pencere
    local window = Instance.new("Frame")
    window.Name = config.Title or "NovaAI"
    window.Size = UDim2.new(0, 900, 0, 600)
    window.Position = UDim2.new(0.5, -450, 0.5, -300)
    window.BackgroundColor3 = theme.Background
    window.BorderSizePixel = 0
    window.Parent = sg
    window.ClipsDescendants = true
    
    -- Yuvarlak Köşeler
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = window
    
    -- ==========================================
    -- TITLE BAR (VS Code Tarzı)
    -- ==========================================
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 36)
    titleBar.BackgroundColor3 = theme.Surface
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    -- Başlık
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = config.Title or "NovaAI Terminal"
    title.TextColor3 = theme.Text
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamSemibold
    title.Parent = titleBar
    
    -- VS Code Tarzı Butonlar (Sola)
    local buttons = {"Close", "Minimize", "Maximize"}
    local btnColors = {
        Close = Color3.fromRGB(237, 66, 69),
        Minimize = Color3.fromRGB(251, 189, 8),
        Maximize = Color3.fromRGB(46, 160, 67)
    }
    
    local btnX = 12
    for _, name in ipairs(buttons) do
        local btn = Instance.new("Frame")
        btn.Size = UDim2.new(0, 14, 0, 14)
        btn.Position = UDim2.new(0, btnX, 0.5, -7)
        btn.BackgroundColor3 = btnColors[name]
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 0
        btn.Parent = titleBar
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(1, 0)
        btnCorner.Parent = btn
        
        btn.MouseEnter:Connect(function()
            TS:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TS:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        end)
        
        if name == "Close" then
            btn.MouseButton1Click:Connect(function()
                sg:Destroy()
            end)
        end
        
        btnX = btnX + 20
    end
    
    -- ==========================================
    -- SIDEBAR (VS Code Tarzı)
    -- ==========================================
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 220, 1, -36)
    sidebar.Position = UDim2.new(0, 0, 0, 36)
    sidebar.BackgroundColor3 = theme.Surface
    sidebar.BorderSizePixel = 0
    sidebar.Parent = window
    
    -- Sidebar başlığı
    local sidebarTitle = Instance.new("TextLabel")
    sidebarTitle.Size = UDim2.new(1, -24, 0, 28)
    sidebarTitle.Position = UDim2.new(0, 12, 0, 8)
    sidebarTitle.BackgroundTransparency = 1
    sidebarTitle.Text = "EXPLORER"
    sidebarTitle.TextColor3 = theme.TextSecondary
    sidebarTitle.TextSize = 11
    sidebarTitle.TextXAlignment = Enum.TextXAlignment.Left
    sidebarTitle.Font = Enum.Font.GothamBold
    sidebarTitle.Parent = sidebar
    
    -- Tab Listesi (Explorer)
    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, 0, 1, -40)
    tabList.Position = UDim2.new(0, 0, 0, 36)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 2
    tabList.Parent = sidebar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 2)
    tabLayout.Parent = tabList
    
    -- ==========================================
    -- CONTENT AREA (Ana Çalışma Alanı)
    -- ==========================================
    local contentArea = Instance.new("ScrollingFrame")
    contentArea.Size = UDim2.new(1, -236, 1, -48)
    contentArea.Position = UDim2.new(0, 228, 0, 40)
    contentArea.BackgroundTransparency = 1
    contentArea.BorderSizePixel = 0
    contentArea.ScrollBarThickness = 4
    contentArea.Parent = window
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 6)
    contentLayout.Parent = contentArea
    
    -- ==========================================
    -- STATUS BAR (Bottom)
    -- ==========================================
    local statusBar = Instance.new("Frame")
    statusBar.Size = UDim2.new(1, 0, 0, 24)
    statusBar.Position = UDim2.new(0, 0, 1, -24)
    statusBar.BackgroundColor3 = theme.Surface
    statusBar.BorderSizePixel = 0
    statusBar.Parent = window
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 10)
    statusCorner.Parent = statusBar
    
    -- Status metni
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -24, 1, 0)
    statusText.Position = UDim2.new(0, 12, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "● Ready | NovaAI v3.0 | " .. game.PlaceId
    statusText.TextColor3 = theme.TextSecondary
    statusText.TextSize = 11
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.Font = Enum.Font.Gotham
    statusText.Parent = statusBar
    
    -- ==========================================
    -- WINDOW OBJECT
    -- ==========================================
    local self = setmetatable({
        _sg = sg,
        _window = window,
        _contentArea = contentArea,
        _tabList = tabList,
        _tabs = {},
        _currentTab = nil,
        _theme = theme,
        _statusBar = statusText,
        _config = config,
    }, WindowClass)
    
    -- Drag fonksiyonu
    local function makeDraggable()
        local dragging = false
        local dragOffset = Vector2.new()
        
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragOffset = input.Position - window.AbsolutePosition
            end
        end)
        
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        RS.RenderStepped:Connect(function()
            if dragging then
                local mousePos = UIS:GetMouseLocation()
                window.Position = UDim2.fromOffset(mousePos.X - dragOffset.X, mousePos.Y - dragOffset.Y)
            end
        end)
    end
    makeDraggable()
    
    -- ==========================================
    -- TAB OLUŞTURMA (VS Code Explorer Tarzı)
    -- ==========================================
    function self:CreateTab(name, icon)
        -- Explorer'da görünen buton
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = name
        tabBtn.Size = UDim2.new(1, -12, 0, 32)
        tabBtn.Position = UDim2.new(0, 6, 0, 0)
        tabBtn.BackgroundColor3 = theme.Background
        tabBtn.BackgroundTransparency = 0.7
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = "  " .. (icon or "📁") .. "  " .. name
        tabBtn.TextColor3 = theme.TextSecondary
        tabBtn.TextSize = 13
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.Parent = tabList
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = tabBtn
        
        -- Tab içeriği (ScrollingFrame)
        local tabContent = Instance.new("Frame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = contentArea
        
        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.Padding = UDim.new(0, 6)
        tabContentLayout.Parent = tabContent
        
        -- Section ekleme fonksiyonu
        function tabContent:CreateSection(title)
            local section = Instance.new("Frame")
            section.Size = UDim2.new(1, -12, 0, 28)
            section.Position = UDim2.new(0, 6, 0, 0)
            section.BackgroundTransparency = 1
            section.Parent = tabContent
            
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 1, -1)
            line.BackgroundColor3 = theme.Border
            line.BackgroundTransparency = 0.5
            line.Parent = section
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = "// " .. title
            label.TextColor3 = theme.TextSecondary
            label.TextSize = 11
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.GothamBold
            label.Parent = section
            
            return {
                AddElement = function(self, element)
                    element.Parent = tabContent
                end
            }
        end
        
        -- Element ekleme fonksiyonları
        function tabContent:CreateButton(config)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -12, 0, 36)
            btn.Position = UDim2.new(0, 6, 0, 0)
            btn.BackgroundColor3 = theme.Surface
            btn.BackgroundTransparency = 0
            btn.BorderSizePixel = 0
            btn.Text = "  " .. (config.Icon or "▶") .. "  " .. (config.Text or "Button")
            btn.TextColor3 = theme.Text
            btn.TextSize = 13
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Font = Enum.Font.Gotham
            btn.Parent = tabContent
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn
            
            btn.MouseEnter:Connect(function()
                TS:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = theme.SurfaceHover}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TS:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = theme.Surface}):Play()
            end)
            
            btn.MouseButton1Click:Connect(function()
                if config.Callback then
                    pcall(config.Callback)
                end
                -- Click efekti
                TS:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = theme.Primary}):Play()
                task.wait(0.08)
                TS:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = theme.Surface}):Play()
            end)
            
            return btn
        end
        
        function tabContent:CreateToggle(config)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -12, 0, 36)
            container.Position = UDim2.new(0, 6, 0, 0)
            container.BackgroundColor3 = theme.Surface
            container.BorderSizePixel = 0
            container.Parent = tabContent
            
            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 6)
            containerCorner.Parent = container
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -60, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = "  " .. (config.Icon or "⬡") .. "  " .. (config.Text or "Toggle")
            label.TextColor3 = theme.Text
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = container
            
            -- Switch
            local switch = Instance.new("Frame")
            switch.Size = UDim2.new(0, 36, 0, 20)
            switch.Position = UDim2.new(1, -48, 0.5, -10)
            switch.BackgroundColor3 = theme.Border
            switch.BorderSizePixel = 0
            switch.Parent = container
            
            local switchCorner = Instance.new("UICorner")
            switchCorner.CornerRadius = UDim.new(1, 0)
            switchCorner.Parent = switch
            
            local thumb = Instance.new("Frame")
            thumb.Size = UDim2.new(0, 14, 0, 14)
            thumb.Position = UDim2.new(0, 3, 0.5, -7)
            thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            thumb.BorderSizePixel = 0
            thumb.Parent = switch
            
            local thumbCorner = Instance.new("UICorner")
            thumbCorner.CornerRadius = UDim.new(1, 0)
            thumbCorner.Parent = thumb
            
            local state = config.Default or false
            if state then
                switch.BackgroundColor3 = theme.Primary
                thumb.Position = UDim2.new(0, 19, 0.5, -7)
            end
            
            local function toggle()
                state = not state
                if state then
                    TS:Create(switch, TweenInfo.new(0.25), {BackgroundColor3 = theme.Primary}):Play()
                    TS:Create(thumb, TweenInfo.new(0.25), {Position = UDim2.new(0, 19, 0.5, -7)}):Play()
                else
                    TS:Create(switch, TweenInfo.new(0.25), {BackgroundColor3 = theme.Border}):Play()
                    TS:Create(thumb, TweenInfo.new(0.25), {Position = UDim2.new(0, 3, 0.5, -7)}):Play()
                end
                if config.Callback then
                    pcall(config.Callback, state)
                end
            end
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = container
            btn.MouseButton1Click:Connect(toggle)
            
            return {
                Set = function(_, s) state = s; if s then switch.BackgroundColor3 = theme.Primary thumb.Position = UDim2.new(0, 19, 0.5, -7) else switch.BackgroundColor3 = theme.Border thumb.Position = UDim2.new(0, 3, 0.5, -7) end end,
                Get = function() return state end
            }
        end
        
        function tabContent:CreateSlider(config)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -12, 0, 48)
            container.Position = UDim2.new(0, 6, 0, 0)
            container.BackgroundColor3 = theme.Surface
            container.BorderSizePixel = 0
            container.Parent = tabContent
            
            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 6)
            containerCorner.Parent = container
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.6, -12, 0, 20)
            label.Position = UDim2.new(0, 12, 0, 6)
            label.BackgroundTransparency = 1
            label.Text = "  " .. (config.Icon or "▬") .. "  " .. (config.Text or "Slider")
            label.TextColor3 = theme.Text
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = container
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0.4, -12, 0, 20)
            valueLabel.Position = UDim2.new(0.6, 0, 0, 6)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(config.Default or 50)
            valueLabel.TextColor3 = theme.Primary
            valueLabel.TextSize = 13
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.Parent = container
            
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -24, 0, 4)
            track.Position = UDim2.new(0, 12, 0, 34)
            track.BackgroundColor3 = theme.Border
            track.BorderSizePixel = 0
            track.Parent = container
            
            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(1, 0)
            trackCorner.Parent = track
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0.5, 0, 1, 0)
            fill.BackgroundColor3 = theme.Primary
            fill.BorderSizePixel = 0
            fill.Parent = track
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = fill
            
            local thumb = Instance.new("Frame")
            thumb.Size = UDim2.new(0, 14, 0, 14)
            thumb.Position = UDim2.new(0.5, -7, 0.5, -7)
            thumb.BackgroundColor3 = theme.Primary
            thumb.BorderSizePixel = 0
            thumb.Parent = track
            
            local thumbCorner = Instance.new("UICorner")
            thumbCorner.CornerRadius = UDim.new(1, 0)
            thumbCorner.Parent = thumb
            
            local min, max = config.Min or 0, config.Max or 100
            local value = config.Default or 50
            local dragging = false
            
            local function updateSlider(newValue)
                value = math.clamp(newValue, min, max)
                local percent = (value - min) / (max - min)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                thumb.Position = UDim2.new(percent, -7, 0.5, -7)
                valueLabel.Text = tostring(value)
                if config.Callback then
                    pcall(config.Callback, value)
                end
            end
            updateSlider(value)
            
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local localX = math.clamp(input.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
                    updateSlider(min + (localX / track.AbsoluteSize.X) * (max - min))
                end
            end)
            
            UIS.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local localX = math.clamp(input.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
                    updateSlider(min + (localX / track.AbsoluteSize.X) * (max - min))
                end
            end)
            
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            return {
                Set = updateSlider,
                Get = function() return value end
            }
        end
        
        function tabContent:CreateDropdown(config)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -12, 0, 36)
            container.Position = UDim2.new(0, 6, 0, 0)
            container.BackgroundColor3 = theme.Surface
            container.BorderSizePixel = 0
            container.Parent = tabContent
            
            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 6)
            containerCorner.Parent = container
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.5, -12, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = "  " .. (config.Icon or "▼") .. "  " .. (config.Text or "Dropdown")
            label.TextColor3 = theme.Text
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = container
            
            local selectedLabel = Instance.new("TextLabel")
            selectedLabel.Size = UDim2.new(0.4, -12, 1, 0)
            selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
            selectedLabel.BackgroundTransparency = 1
            selectedLabel.Text = config.Default or "Select..."
            selectedLabel.TextColor3 = theme.Primary
            selectedLabel.TextSize = 13
            selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
            selectedLabel.Font = Enum.Font.Gotham
            selectedLabel.Parent = container
            
            local listFrame = Instance.new("Frame")
            listFrame.Size = UDim2.new(1, 0, 0, 0)
            listFrame.Position = UDim2.new(0, 0, 0, 36)
            listFrame.BackgroundColor3 = theme.Surface
            listFrame.BorderSizePixel = 0
            listFrame.Visible = false
            listFrame.ClipsDescendants = true
            listFrame.Parent = container
            
            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 6)
            listCorner.Parent = listFrame
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 2)
            listLayout.Parent = listFrame
            
            local isOpen = false
            local options = config.Options or {}
            local selected = config.Default
            
            for _, option in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 28)
                optBtn.BackgroundColor3 = theme.Surface
                optBtn.BackgroundTransparency = 0.5
                optBtn.BorderSizePixel = 0
                optBtn.Text = "  " .. option
                optBtn.TextColor3 = option == selected and theme.Primary or theme.TextSecondary
                optBtn.TextSize = 12
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                optBtn.Font = Enum.Font.Gotham
                optBtn.Parent = listFrame
                
                optBtn.MouseButton1Click:Connect(function()
                    selected = option
                    selectedLabel.Text = option
                    for _, child in ipairs(listFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child.TextColor3 = child.Text == "  " .. option and theme.Primary or theme.TextSecondary
                        end
                    end
                    if config.Callback then
                        pcall(config.Callback, option)
                    end
                    toggleDropdown()
                end)
            end
            
            local function toggleDropdown()
                isOpen = not isOpen
                listFrame.Visible = isOpen
                if isOpen then
                    container.Size = UDim2.new(1, -12, 0, 36 + #options * 30)
                    listFrame.Size = UDim2.new(1, 0, 0, #options * 30)
                else
                    container.Size = UDim2.new(1, -12, 0, 36)
                    listFrame.Size = UDim2.new(1, 0, 0, 0)
                end
            end
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = container
            btn.MouseButton1Click:Connect(toggleDropdown)
            
            return {
                Set = function(_, opt) selected = opt; selectedLabel.Text = opt end,
                Get = function() return selected end
            }
        end
        
        function tabContent:CreateInput(config)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -12, 0, 48)
            container.Position = UDim2.new(0, 6, 0, 0)
            container.BackgroundColor3 = theme.Surface
            container.BorderSizePixel = 0
            container.Parent = tabContent
            
            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 6)
            containerCorner.Parent = container
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -12, 0, 20)
            label.Position = UDim2.new(0, 12, 0, 4)
            label.BackgroundTransparency = 1
            label.Text = "  " .. (config.Icon or "⌨") .. "  " .. (config.Text or "Input")
            label.TextColor3 = theme.Text
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = container
            
            local input = Instance.new("TextBox")
            input.Size = UDim2.new(1, -24, 0, 26)
            input.Position = UDim2.new(0, 12, 0, 22)
            input.BackgroundColor3 = theme.Code
            input.BackgroundTransparency = 0
            input.BorderSizePixel = 0
            input.Text = config.Default or ""
            input.TextColor3 = theme.Text
            input.TextSize = 13
            input.Font = Enum.Font.Gotham
            input.PlaceholderText = config.Placeholder or "Type here..."
            input.PlaceholderColor3 = theme.TextSecondary
            input.Parent = container
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 4)
            inputCorner.Parent = input
            
            local value = config.Default or ""
            
            input.FocusLost:Connect(function()
                value = input.Text
                if config.Callback then
                    pcall(config.Callback, value)
                end
            end)
            
            return {
                Set = function(_, text) value = text; input.Text = text end,
                Get = function() return value end
            }
        end
        
        function tabContent:CreateParagraph(config)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -12, 0, 0)
            container.Position = UDim2.new(0, 6, 0, 0)
            container.BackgroundColor3 = theme.Code
            container.BackgroundTransparency = 0.5
            container.BorderSizePixel = 0
            container.Parent = tabContent
            
            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 6)
            containerCorner.Parent = container
            
            local text = Instance.new("TextLabel")
            text.Size = UDim2.new(1, -24, 0, 0)
            text.Position = UDim2.new(0, 12, 0, 8)
            text.BackgroundTransparency = 1
            text.Text = config.Text or "// Insert your text here"
            text.TextColor3 = theme.TextSecondary
            text.TextSize = 12
            text.TextXAlignment = Enum.TextXAlignment.Left
            text.TextWrapped = true
            text.Font = Enum.Font.Gotham
            text.Parent = container
            
            local textBounds = text.TextBounds
            local height = textBounds.Y + 16
            container.Size = UDim2.new(1, -12, 0, height)
            text.Size = UDim2.new(1, -24, 0, textBounds.Y)
            
            return container
        end
        
        -- Tab seçme ve düzenleme
        local tabObj = {
            _btn = tabBtn,
            _content = tabContent,
            _name = name,
            CreateSection = tabContent.CreateSection,
            CreateButton = tabContent.CreateButton,
            CreateToggle = tabContent.CreateToggle,
            CreateSlider = tabContent.CreateSlider,
            CreateDropdown = tabContent.CreateDropdown,
            CreateInput = tabContent.CreateInput,
            CreateParagraph = tabContent.CreateParagraph,
        }
        
        tabBtn.MouseButton1Click:Connect(function()
            self:SelectTab(name)
        end)
        
        tabBtn.MouseEnter:Connect(function()
            if self._currentTab ~= name then
                TS:Create(tabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if self._currentTab ~= name then
                TS:Create(tabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.7}):Play()
            end
        end)
        
        self._tabs[name] = tabObj
        
        if not self._currentTab then
            self:SelectTab(name)
        end
        
        return tabObj
    end
    
    -- Tab seçme fonksiyonu
    function self:SelectTab(name)
        if self._currentTab == name then return end
        
        if self._currentTab then
            local oldTab = self._tabs[self._currentTab]
            if oldTab then
                oldTab._content.Visible = false
                TS:Create(oldTab._btn, TweenInfo.new(0.15), {
                    BackgroundTransparency = 0.7,
                    TextColor3 = self._theme.TextSecondary
                }):Play()
            end
        end
        
        self._currentTab = name
        local newTab = self._tabs[name]
        if newTab then
            newTab._content.Visible = true
            TS:Create(newTab._btn, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.2,
                TextColor3 = self._theme.Text
            }):Play()
        end
    end
    
    -- Status güncelleme
    function self:SetStatus(text)
        statusText.Text = "● " .. text
    end
    
    -- Bildirim
    function self:Notify(config)
        NovaAI:Notify(config)
    end
    
    -- Kapatma
    function self:Destroy()
        sg:Destroy()
    end
    
    table.insert(NovaAI.Windows, self)
    return self
end

-- ============================================
-- BİLDİRİM SİSTEMİ
-- ============================================
function NovaAI:Notify(config)
    local theme = NovaAI.Theme.Dark
    local container = NovaAI._notifContainer
    
    if not container then
        container = Instance.new("Frame")
        container.Name = "Notifications"
        container.Size = UDim2.new(0, 340, 0, 0)
        container.Position = UDim2.new(1, -360, 0, 12)
        container.BackgroundTransparency = 1
        container.Parent = (gethui and gethui()) or CoreGui
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = container
        
        NovaAI._notifContainer = container
    end
    
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1, 0, 0, 0)
    notif.BackgroundColor3 = theme.Surface
    notif.BackgroundTransparency = 1
    notif.BorderSizePixel = 0
    notif.ClipsDescendants = true
    notif.Parent = container
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notif
    
    -- Sol kenar çizgisi
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 4, 1, 0)
    line.BackgroundColor3 = theme.Primary
    line.BorderSizePixel = 0
    line.Parent = notif
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -24, 0, 0)
    content.Position = UDim2.new(0, 16, 0, 10)
    content.BackgroundTransparency = 1
    content.Parent = notif
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = config.Title or "Notification"
    title.TextColor3 = theme.Text
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamSemibold
    title.Parent = content
    
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, 0, 0, 0)
    msg.Position = UDim2.new(0, 0, 0, 22)
    msg.BackgroundTransparency = 1
    msg.Text = config.Message or ""
    msg.TextColor3 = theme.TextSecondary
    msg.TextSize = 12
    msg.TextXAlignment = Enum.TextXAlignment.Left
    msg.TextWrapped = true
    msg.Font = Enum.Font.Gotham
    msg.Parent = content
    
    local tb = msg.TextBounds
    local h = 22 + tb.Y + 10
    content.Size = UDim2.new(1, 0, 0, h)
    msg.Size = UDim2.new(1, 0, 0, tb.Y)
    notif.Size = UDim2.new(1, 0, 0, h + 20)
    
    notif.BackgroundTransparency = 0
    notif.Position = UDim2.new(0, 0, 0, -h - 20)
    TS:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Cubic), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    task.delay(config.Duration or 4, function()
        TS:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Cubic), {
            Position = UDim2.new(0, 0, 0, -h - 20),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.5)
        notif:Destroy()
    end)
end

-- ============================================
-- BAŞLATMA
-- ============================================
NovaAI.CurrentTheme = NovaAI.Theme.Dark

return NovaAI
