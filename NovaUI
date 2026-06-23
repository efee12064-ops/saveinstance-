-- NovaUI.lua
-- Modern, minimalist GUI kütüphanesi
-- Tamamen özgün yapı, Rayfield'dan farklı tasarım felsefesi

local NovaUI = {
    Version = "1.0.0",
    Theme = {
        Dark = {
            Background = Color3.fromRGB(18, 18, 24),
            Surface = Color3.fromRGB(28, 28, 38),
            SurfaceHover = Color3.fromRGB(38, 38, 52),
            Primary = Color3.fromRGB(99, 102, 241), -- İndigo
            PrimaryHover = Color3.fromRGB(129, 140, 248),
            Text = Color3.fromRGB(226, 232, 240),
            TextSecondary = Color3.fromRGB(148, 163, 184),
            Border = Color3.fromRGB(51, 65, 85),
            Success = Color3.fromRGB(52, 211, 153),
            Danger = Color3.fromRGB(248, 113, 113),
            Warning = Color3.fromRGB(251, 191, 36),
        },
        Light = {
            Background = Color3.fromRGB(248, 250, 252),
            Surface = Color3.fromRGB(255, 255, 255),
            SurfaceHover = Color3.fromRGB(241, 245, 249),
            Primary = Color3.fromRGB(99, 102, 241),
            PrimaryHover = Color3.fromRGB(79, 70, 229),
            Text = Color3.fromRGB(15, 23, 42),
            TextSecondary = Color3.fromRGB(71, 85, 105),
            Border = Color3.fromRGB(203, 213, 225),
            Success = Color3.fromRGB(16, 185, 129),
            Danger = Color3.fromRGB(239, 68, 68),
            Warning = Color3.fromRGB(234, 179, 8),
        }
    },
    Windows = {},
    Notifications = {},
    CurrentTheme = nil,
}

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Yardımcı fonksiyonlar
local function getService(name)
    local service = game:GetService(name)
    return if cloneref then cloneref(service) else service
end

local function createUI()
    -- Ana UI container
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NovaUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if gethui then
        screenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(screenGui)
        screenGui.Parent = CoreGui
    else
        screenGui.Parent = CoreGui
    end
    
    return screenGui
end

-- ============================================
-- Ana Pencere (Window) Sınıfı
-- ============================================
local WindowClass = {}
WindowClass.__index = WindowClass

function NovaUI:CreateWindow(config)
    config = config or {}
    local theme = config.Theme and NovaUI.Theme[config.Theme] or NovaUI.Theme.Dark
    
    -- Ana container
    local screenGui = createUI()
    local window = Instance.new("Frame")
    window.Name = config.Title or "NovaUI"
    window.Size = UDim2.new(0, 600, 0, 450)
    window.Position = UDim2.new(0.5, -300, 0.5, -225)
    window.BackgroundColor3 = theme.Background
    window.BackgroundTransparency = 0
    window.BorderSizePixel = 0
    window.Parent = screenGui
    window.ClipsDescendants = true
    
    -- Gölge efekti
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0.5, -10, 0.5, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316041501" -- Soft shadow
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 10, 10)
    shadow.Parent = window
    
    -- Yuvarlak köşeler
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = window
    
    -- Başlık çubuğu (drag için)
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 48)
    titleBar.BackgroundColor3 = theme.Surface
    titleBar.BackgroundTransparency = 0
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    -- Başlık metni
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.Title or "NovaUI"
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Parent = titleBar
    
    -- Kapatma butonu
    local closeBtn = Instance.new("ImageButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -42, 0.5, -16)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Image = "rbxassetid://7072718814" -- X icon
    closeBtn.ImageColor3 = theme.TextSecondary
    closeBtn.Parent = titleBar
    
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {ImageColor3 = theme.Danger}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {ImageColor3 = theme.TextSecondary}):Play()
    end)
    
    -- İçerik alanı
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, 0, 1, -48)
    content.Position = UDim2.new(0, 0, 0, 48)
    content.BackgroundTransparency = 1
    content.Parent = window
    
    -- Sol sidebar (tab'ler için)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 160, 1, 0)
    sidebar.BackgroundColor3 = theme.Surface
    sidebar.BackgroundTransparency = 0
    sidebar.BorderSizePixel = 0
    sidebar.Parent = content
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 0)
    sidebarCorner.Parent = sidebar
    
    -- Sidebar'daki tab listesi
    local tabList = Instance.new("ScrollingFrame")
    tabList.Name = "TabList"
    tabList.Size = UDim2.new(1, 0, 1, 0)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 3
    tabList.Parent = sidebar
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Padding = UDim.new(0, 4)
    tabListLayout.Parent = tabList
    
    -- Sağ içerik alanı
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -160, 1, 0)
    contentArea.Position = UDim2.new(0, 160, 0, 0)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = content
    
    -- Window objesi
    local self = setmetatable({
        _screenGui = screenGui,
        _window = window,
        _contentArea = contentArea,
        _tabList = tabList,
        _tabs = {},
        _currentTab = nil,
        _theme = theme,
        _config = config,
    }, WindowClass)
    
    -- Sürükleme fonksiyonu
    local function makeDraggable()
        local dragging = false
        local dragOffset = Vector2.new()
        
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragOffset = input.Position - window.AbsolutePosition
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        RunService.RenderStepped:Connect(function()
            if dragging then
                local mousePos = UserInputService:GetMouseLocation()
                window.Position = UDim2.fromOffset(mousePos.X - dragOffset.X, mousePos.Y - dragOffset.Y)
            end
        end)
    end
    makeDraggable()
    
    -- Kapatma
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Tab oluşturma
    function self:CreateTab(name, icon)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = name
        tabBtn.Size = UDim2.new(1, -12, 0, 36)
        tabBtn.Position = UDim2.new(0, 6, 0, 0)
        tabBtn.BackgroundColor3 = theme.Background
        tabBtn.BackgroundTransparency = 0.8
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = "  " .. name
        tabBtn.TextColor3 = theme.TextSecondary
        tabBtn.TextSize = 14
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.Parent = tabList
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = tabBtn
        
        -- Tab içeriği
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, -24, 1, 0)
        tabContent.Position = UDim2.new(0, 12, 0, 8)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 4
        tabContent.Visible = false
        tabContent.Parent = contentArea
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 8)
        contentLayout.Parent = tabContent
        
        -- Tab objesi
        local tabObj = {
            _button = tabBtn,
            _content = tabContent,
            _elements = {},
            _name = name,
        }
        
        -- Tab seçme
        tabBtn.MouseButton1Click:Connect(function()
            self:SelectTab(name)
        end)
        
        -- Hover efektleri
        tabBtn.MouseEnter:Connect(function()
            if self._currentTab ~= name then
                TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.6}):Play()
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if self._currentTab ~= name then
                TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
            end
        end)
        
        self._tabs[name] = tabObj
        
        -- İlk tab'ı seç
        if not self._currentTab then
            self:SelectTab(name)
        end
        
        -- Element ekleme fonksiyonları
        function tabObj:CreateButton(config)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.BackgroundColor3 = theme.Surface
            btn.BackgroundTransparency = 0
            btn.BorderSizePixel = 0
            btn.Text = config.Text or "Button"
            btn.TextColor3 = theme.Text
            btn.TextSize = 14
            btn.Font = Enum.Font.Gotham
            btn.Parent = tabContent
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn
            
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = theme.SurfaceHover}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Surface}):Play()
            end)
            
            btn.MouseButton1Click:Connect(function()
                if config.Callback then
                    pcall(config.Callback)
                end
                -- Click animasyonu
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = theme.Primary}):Play()
                task.wait(0.1)
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = theme.Surface}):Play()
            end)
            
            return btn
        end
        
        function tabObj:CreateToggle(config)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 40)
            container.BackgroundColor3 = theme.Surface
            container.BackgroundTransparency = 0
            container.BorderSizePixel = 0
            container.Parent = tabContent
            
            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 8)
            containerCorner.Parent = container
            
            -- Label
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -70, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = config.Text or "Toggle"
            label.TextColor3 = theme.Text
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = container
            
            -- Toggle switch
            local switch = Instance.new("Frame")
            switch.Size = UDim2.new(0, 44, 0, 24)
            switch.Position = UDim2.new(1, -56, 0.5, -12)
            switch.BackgroundColor3 = theme.Border
            switch.BackgroundTransparency = 0
            switch.BorderSizePixel = 0
            switch.Parent = container
            
            local switchCorner = Instance.new("UICorner")
            switchCorner.CornerRadius = UDim.new(1, 0)
            switchCorner.Parent = switch
            
            -- Toggle thumb
            local thumb = Instance.new("Frame")
            thumb.Size = UDim2.new(0, 18, 0, 18)
            thumb.Position = UDim2.new(0, 3, 0.5, -9)
            thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            thumb.BackgroundTransparency = 0
            thumb.BorderSizePixel = 0
            thumb.Parent = switch
            
            local thumbCorner = Instance.new("UICorner")
            thumbCorner.CornerRadius = UDim.new(1, 0)
            thumbCorner.Parent = thumb
            
            local state = config.Default or false
            if state then
                switch.BackgroundColor3 = theme.Primary
                thumb.Position = UDim2.new(0, 23, 0.5, -9)
            end
            
            -- Click handler
            local function toggle()
                state = not state
                if state then
                    TweenService:Create(switch, TweenInfo.new(0.3), {BackgroundColor3 = theme.Primary}):Play()
                    TweenService:Create(thumb, TweenInfo.new(0.3), {Position = UDim2.new(0, 23, 0.5, -9)}):Play()
                else
                    TweenService:Create(switch, TweenInfo.new(0.3), {BackgroundColor3 = theme.Border}):Play()
                    TweenService:Create(thumb, TweenInfo.new(0.3), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
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
                Set = function(self, newState)
                    state = newState
                    if state then
                        switch.BackgroundColor3 = theme.Primary
                        thumb.Position = UDim2.new(0, 23, 0.5, -9)
                    else
                        switch.BackgroundColor3 = theme.Border
                        thumb.Position = UDim2.new(0, 3, 0.5, -9)
                    end
                end,
                Get = function() return state end
            }
        end
        
        function tabObj:CreateSlider(config)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 56)
            container.BackgroundColor3 = theme.Surface
            container.BackgroundTransparency = 0
            container.BorderSizePixel = 0
            container.Parent = tabContent
            
            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 8)
            containerCorner.Parent = container
            
            -- Label ve değer
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, -12, 0, 20)
            label.Position = UDim2.new(0, 12, 0, 8)
            label.BackgroundTransparency = 1
            label.Text = config.Text or "Slider"
            label.TextColor3 = theme.Text
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = container
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0.3, -12, 0, 20)
            valueLabel.Position = UDim2.new(0.7, 0, 0, 8)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(config.Default or 50)
            valueLabel.TextColor3 = theme.Primary
            valueLabel.TextSize = 14
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.Parent = container
            
            -- Slider track
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -24, 0, 4)
            track.Position = UDim2.new(0, 12, 0, 38)
            track.BackgroundColor3 = theme.Border
            track.BackgroundTransparency = 0
            track.BorderSizePixel = 0
            track.Parent = container
            
            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(1, 0)
            trackCorner.Parent = track
            
            -- Slider fill
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0.5, 0, 1, 0)
            fill.BackgroundColor3 = theme.Primary
            fill.BackgroundTransparency = 0
            fill.BorderSizePixel = 0
            fill.Parent = track
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = fill
            
            -- Slider thumb
            local thumb = Instance.new("Frame")
            thumb.Size = UDim2.new(0, 16, 0, 16)
            thumb.Position = UDim2.new(0.5, -8, 0.5, -8)
            thumb.BackgroundColor3 = theme.Primary
            thumb.BackgroundTransparency = 0
            thumb.BorderSizePixel = 0
            thumb.Parent = track
            
            local thumbCorner = Instance.new("UICorner")
            thumbCorner.CornerRadius = UDim.new(1, 0)
            thumbCorner.Parent = thumb
            
            local min = config.Min or 0
            local max = config.Max or 100
            local value = config.Default or 50
            local dragging = false
            
            local function updateSlider(newValue)
                value = math.clamp(newValue, min, max)
                local percent = (value - min) / (max - min)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                thumb.Position = UDim2.new(percent, -8, 0.5, -8)
                valueLabel.Text = tostring(value)
                if config.Callback then
                    pcall(config.Callback, value)
                end
            end
            
            updateSlider(value)
            
            -- Mouse events
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local localX = math.clamp(input.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
                    local percent = localX / track.AbsoluteSize.X
                    updateSlider(min + percent * (max - min))
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local localX = math.clamp(input.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
                    local percent = localX / track.AbsoluteSize.X
                    updateSlider(min + percent * (max - min))
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            return {
                Set = updateSlider,
                Get = function() return value end
            }
        end
        
        function tabObj:CreateDropdown(config)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 40)
            container.BackgroundColor3 = theme.Surface
            container.BackgroundTransparency = 0
            container.BorderSizePixel = 0
            container.Parent = tabContent
            
            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 8)
            containerCorner.Parent = container
            
            -- Label
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.5, -12, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = config.Text or "Dropdown"
            label.TextColor3 = theme.Text
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = container
            
            -- Seçili değer
            local selectedLabel = Instance.new("TextLabel")
            selectedLabel.Size = UDim2.new(0.4, -12, 1, 0)
            selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
            selectedLabel.BackgroundTransparency = 1
            selectedLabel.Text = config.Default or "Select..."
            selectedLabel.TextColor3 = theme.TextSecondary
            selectedLabel.TextSize = 14
            selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
            selectedLabel.Font = Enum.Font.Gotham
            selectedLabel.Parent = container
            
            -- Dropdown arrow
            local arrow = Instance.new("ImageLabel")
            arrow.Size = UDim2.new(0, 16, 0, 16)
            arrow.Position = UDim2.new(1, -28, 0.5, -8)
            arrow.BackgroundTransparency = 1
            arrow.Image = "rbxassetid://6031090475" -- Chevron down
            arrow.ImageColor3 = theme.TextSecondary
            arrow.Parent = container
            
            -- Dropdown list (gizli)
            local listFrame = Instance.new("Frame")
            listFrame.Size = UDim2.new(1, 0, 0, 120)
            listFrame.Position = UDim2.new(0, 0, 0, 40)
            listFrame.BackgroundColor3 = theme.Surface
            listFrame.BackgroundTransparency = 0
            listFrame.BorderSizePixel = 0
            listFrame.Visible = false
            listFrame.ClipsDescendants = true
            listFrame.Parent = container
            
            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 8)
            listCorner.Parent = listFrame
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 2)
            listLayout.Parent = listFrame
            
            local isOpen = false
            
            local function toggleDropdown()
                isOpen = not isOpen
                listFrame.Visible = isOpen
                if isOpen then
                    TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
                    container.Size = UDim2.new(1, 0, 0, 160)
                else
                    TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    container.Size = UDim2.new(1, 0, 0, 40)
                end
            end
            
            -- Dropdown butonu
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = container
            btn.MouseButton1Click:Connect(toggleDropdown)
            
            -- Seçenekleri ekle
            local options = config.Options or {}
            local selected = config.Default
            
            for _, option in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 32)
                optBtn.BackgroundColor3 = theme.Surface
                optBtn.BackgroundTransparency = 0.5
                optBtn.BorderSizePixel = 0
                optBtn.Text = option
                optBtn.TextColor3 = theme.TextSecondary
                optBtn.TextSize = 13
                optBtn.Font = Enum.Font.Gotham
                optBtn.Parent = listFrame
                
                if option == selected then
                    optBtn.TextColor3 = theme.Primary
                end
                
                optBtn.MouseButton1Click:Connect(function()
                    selected = option
                    selectedLabel.Text = option
                    selectedLabel.TextColor3 = theme.Primary
                    
                    for _, child in ipairs(listFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child.TextColor3 = theme.TextSecondary
                        end
                    end
                    optBtn.TextColor3 = theme.Primary
                    
                    if config.Callback then
                        pcall(config.Callback, option)
                    end
                    
                    toggleDropdown()
                end)
            end
            
            return {
                Set = function(self, newOption)
                    selected = newOption
                    selectedLabel.Text = newOption
                    for _, child in ipairs(listFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child.TextColor3 = child.Text == newOption and theme.Primary or theme.TextSecondary
                        end
                    end
                end,
                Get = function() return selected end
            }
        end
        
        function tabObj:CreateTextbox(config)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 56)
            container.BackgroundColor3 = theme.Surface
            container.BackgroundTransparency = 0
            container.BorderSizePixel = 0
            container.Parent = tabContent
            
            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 8)
            containerCorner.Parent = container
            
            -- Label
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -12, 0, 20)
            label.Position = UDim2.new(0, 12, 0, 6)
            label.BackgroundTransparency = 1
            label.Text = config.Text or "Text Input"
            label.TextColor3 = theme.Text
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = container
            
            -- Input box
            local input = Instance.new("TextBox")
            input.Size = UDim2.new(1, -24, 0, 28)
            input.Position = UDim2.new(0, 12, 0, 24)
            input.BackgroundColor3 = theme.Background
            input.BackgroundTransparency = 0
            input.BorderSizePixel = 0
            input.Text = config.Default or ""
            input.TextColor3 = theme.Text
            input.TextSize = 14
            input.Font = Enum.Font.Gotham
            input.PlaceholderText = config.Placeholder or "Type here..."
            input.PlaceholderColor3 = theme.TextSecondary
            input.Parent = container
            
            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 6)
            inputCorner.Parent = input
            
            local value = config.Default or ""
            
            input.FocusLost:Connect(function(enterPressed)
                value = input.Text
                if config.Callback then
                    pcall(config.Callback, value)
                end
            end)
            
            return {
                Set = function(self, newText)
                    value = newText
                    input.Text = newText
                end,
                Get = function() return value end
            }
        end
        
        return tabObj
    end
    
    -- Tab seçme
    function self:SelectTab(name)
        if self._currentTab == name then return end
        
        -- Eski tab'ı gizle
        if self._currentTab then
            local oldTab = self._tabs[self._currentTab]
            if oldTab then
                oldTab._content.Visible = false
                TweenService:Create(oldTab._button, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.8,
                    TextColor3 = self._theme.TextSecondary
                }):Play()
            end
        end
        
        self._currentTab = name
        local newTab = self._tabs[name]
        if newTab then
            newTab._content.Visible = true
            TweenService:Create(newTab._button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.2,
                TextColor3 = self._theme.Text
            }):Play()
        end
    end
    
    -- Tema değiştirme
    function self:SetTheme(themeName)
        local newTheme = NovaUI.Theme[themeName]
        if not newTheme then return end
        
        self._theme = newTheme
        -- UI'ı güncelle (basitlik için sadece birkaç örnek)
        self._window.BackgroundColor3 = newTheme.Background
        self._window.TitleBar.BackgroundColor3 = newTheme.Surface
        -- ... diğer theme güncellemeleri
    end
    
    -- Pencereyi kapat
    function self:Destroy()
        self._screenGui:Destroy()
    end
    
    -- Bildirim gösterme
    function self:Notify(config)
        NovaUI:Notify(config)
    end
    
    table.insert(NovaUI.Windows, self)
    return self
end

-- ============================================
-- Bildirim Sistemi
-- ============================================
function NovaUI:Notify(config)
    local theme = self.CurrentTheme or NovaUI.Theme.Dark
    local container = self._notificationContainer
    
    if not container then
        container = Instance.new("Frame")
        container.Name = "Notifications"
        container.Size = UDim2.new(0, 320, 0, 0)
        container.Position = UDim2.new(1, -340, 0, 12)
        container.BackgroundTransparency = 1
        container.Parent = (gethui and gethui()) or CoreGui
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = container
        
        self._notificationContainer = container
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
    
    -- İçerik
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -24, 0, 0)
    content.Position = UDim2.new(0, 12, 0, 12)
    content.BackgroundTransparency = 1
    content.Parent = notif
    
    -- Başlık
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = config.Title or "Notification"
    title.TextColor3 = theme.Text
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamSemibold
    title.Parent = content
    
    -- Mesaj
    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, 0, 0, 0)
    message.Position = UDim2.new(0, 0, 0, 24)
    message.BackgroundTransparency = 1
    message.Text = config.Message or ""
    message.TextColor3 = theme.TextSecondary
    message.TextSize = 13
    message.TextXAlignment = Enum.TextXAlignment.Left
    message.TextWrapped = true
    message.Font = Enum.Font.Gotham
    message.Parent = content
    
    -- Boyutları hesapla
    local textBounds = message.TextBounds
    local height = 24 + textBounds.Y + 12 + 12
    content.Size = UDim2.new(1, 0, 0, height)
    message.Size = UDim2.new(1, 0, 0, textBounds.Y)
    notif.Size = UDim2.new(1, 0, 0, height + 24)
    
    -- Giriş animasyonu
    notif.BackgroundTransparency = 0
    notif.Position = UDim2.new(0, 0, 0, -height - 24)
    TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Cubic), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    -- Otomatik kapatma
    task.delay(config.Duration or 4, function()
        TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Cubic), {
            Position = UDim2.new(0, 0, 0, -height - 24),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.5)
        notif:Destroy()
    end)
end

-- ============================================
-- Başlangıç
-- ============================================
NovaUI.CurrentTheme = NovaUI.Theme.Dark

return NovaUI
