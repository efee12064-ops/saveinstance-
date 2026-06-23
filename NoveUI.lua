-- NovaUI.lua
-- Modern, minimalist GUI kütüphanesi
-- Team S*x tarzı koyu tema, yeşil accent

local NovaUI = {
    Version = "1.0.0",
    Theme = {
        Dark = {
            Background = Color3.fromRGB(14, 14, 18),        -- Ana arka plan (neredeyse siyah)
            Surface = Color3.fromRGB(22, 22, 28),           -- Kart/Container arka planı
            SurfaceHover = Color3.fromRGB(30, 30, 38),      -- Hover durumu
            SurfaceActive = Color3.fromRGB(28, 28, 36),      -- Aktif/Seçili durum
            Primary = Color3.fromRGB(74, 222, 128),          -- Yeşil accent (#4ade80)
            PrimaryHover = Color3.fromRGB(96, 230, 144),    -- Yeşil hover
            PrimaryDark = Color3.fromRGB(34, 197, 94),      -- Koyu yeşil
            Text = Color3.fromRGB(226, 232, 240),          -- Ana metin (beyazmsı)
            TextSecondary = Color3.fromRGB(148, 163, 184), -- İkincil metin (gri)
            TextMuted = Color3.fromRGB(100, 116, 139),     -- Soluk metin
            Border = Color3.fromRGB(35, 35, 45),            -- Border/ayırıcı
            BorderLight = Color3.fromRGB(50, 50, 62),       -- Açık border
            Success = Color3.fromRGB(74, 222, 128),
            Danger = Color3.fromRGB(248, 113, 113),
            Warning = Color3.fromRGB(251, 191, 36),
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
local TextService = game:GetService("TextService")

-- Yardımcı fonksiyonlar
local function getService(name)
    local service = game:GetService(name)
    return if cloneref then cloneref(service) else service
end

local function createUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NovaUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999

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
    local theme = NovaUI.Theme.Dark

    -- Ana container
    local screenGui = createUI()

    -- Ana pencere frame
    local window = Instance.new("Frame")
    window.Name = config.Title or "NovaUI"
    window.Size = UDim2.new(0, 520, 0, 380)
    window.Position = UDim2.new(0.5, -260, 0.5, -190)
    window.BackgroundColor3 = theme.Background
    window.BackgroundTransparency = 0
    window.BorderSizePixel = 0
    window.Parent = screenGui
    window.ClipsDescendants = true

    -- Gölge efekti (soft shadow)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0.5, -20, 0.5, -20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316041501"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 10, 10)
    shadow.Parent = window

    -- Yuvarlak köşeler (8px radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = window

    -- Stroke/Border (ince çizgi)
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.Border
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = window

    -- Başlık çubuğu
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 36)
    titleBar.BackgroundColor3 = theme.Surface
    titleBar.BackgroundTransparency = 0
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window

    -- Title bar stroke (alt çizgi)
    local titleStroke = Instance.new("UIStroke")
    titleStroke.Color = theme.Border
    titleStroke.Thickness = 1
    titleStroke.Transparency = 0.3
    titleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    titleStroke.Parent = titleBar

    -- Başlık metni (sol üst, küçük)
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 12, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.Title or "NovaUI"
    titleLabel.TextColor3 = theme.Text
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.Parent = titleBar

    -- Kapatma butonu (X)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -36, 0.5, -14)
    closeBtn.BackgroundColor3 = theme.SurfaceHover
    closeBtn.BackgroundTransparency = 1
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = theme.TextSecondary
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeBtn

    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0, TextColor3 = theme.Danger}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextColor3 = theme.TextSecondary}):Play()
    end)

    -- İçerik alanı (title bar altı)
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, 0, 1, -36)
    content.Position = UDim2.new(0, 0, 0, 36)
    content.BackgroundTransparency = 1
    content.Parent = window

    -- Sol sidebar (tab'ler için) - 130px genişlik
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 130, 1, 0)
    sidebar.BackgroundColor3 = theme.Background
    sidebar.BackgroundTransparency = 0
    sidebar.BorderSizePixel = 0
    sidebar.Parent = content

    -- Sidebar stroke (sağ çizgi)
    local sidebarStroke = Instance.new("UIStroke")
    sidebarStroke.Color = theme.Border
    sidebarStroke.Thickness = 1
    sidebarStroke.Transparency = 0.3
    sidebarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    sidebarStroke.Parent = sidebar

    -- Tab listesi (scrollable)
    local tabList = Instance.new("ScrollingFrame")
    tabList.Name = "TabList"
    tabList.Size = UDim2.new(1, 0, 1, -12)
    tabList.Position = UDim2.new(0, 0, 0, 6)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 2
    tabList.ScrollBarImageColor3 = theme.BorderLight
    tabList.Parent = sidebar

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Padding = UDim.new(0, 2)
    tabListLayout.Parent = tabList

    local tabListPadding = Instance.new("UIPadding")
    tabListPadding.PaddingLeft = UDim.new(0, 8)
    tabListPadding.PaddingRight = UDim.new(0, 8)
    tabListPadding.PaddingTop = UDim.new(0, 4)
    tabListPadding.Parent = tabList

    -- Sağ içerik alanı
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -130, 1, 0)
    contentArea.Position = UDim2.new(0, 130, 0, 0)
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
        TweenService:Create(window, TweenInfo.new(0.3), {Size = UDim2.new(0, 520, 0, 0)}):Play()
        task.wait(0.3)
        screenGui:Destroy()
    end)

    -- Tab oluşturma
    function self:CreateTab(name, icon)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = name
        tabBtn.Size = UDim2.new(1, 0, 0, 30)
        tabBtn.BackgroundColor3 = theme.Surface
        tabBtn.BackgroundTransparency = 1
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = "  " .. name
        tabBtn.TextColor3 = theme.TextSecondary
        tabBtn.TextSize = 12
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.Parent = tabList

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = tabBtn

        -- Tab içeriği (scrollable)
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, -16, 1, -12)
        tabContent.Position = UDim2.new(0, 8, 0, 6)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 2
        tabContent.ScrollBarImageColor3 = theme.BorderLight
        tabContent.Visible = false
        tabContent.Parent = contentArea

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 6)
        contentLayout.Parent = tabContent

        local contentPadding = Instance.new("UIPadding")
        contentPadding.PaddingRight = UDim.new(0, 4)
        contentPadding.Parent = tabContent

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
                TweenService:Create(tabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.6, TextColor3 = theme.Text}):Play()
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if self._currentTab ~= name then
                TweenService:Create(tabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextColor3 = theme.TextSecondary}):Play()
            end
        end)

        self._tabs[name] = tabObj

        -- İlk tab'ı seç
        if not self._currentTab then
            self:SelectTab(name)
        end

        -- ============================================
        -- ELEMENTLER
        -- ============================================

        -- 1. BUTTON (Fotoğraftaki gibi: label sol, "Button" yazı sağda)
        function tabObj:CreateButton(config)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 32)
            container.BackgroundColor3 = theme.Surface
            container.BackgroundTransparency = 0
            container.BorderSizePixel = 0
            container.Parent = tabContent

            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 6)
            containerCorner.Parent = container

            -- Sol label
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.5, -12, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = config.Text or "Button"
            label.TextColor3 = theme.Text
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = container

            -- Sağda değer/buton metni
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0.5, -12, 1, 0)
            valueLabel.Position = UDim2.new(0.5, 0, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = config.Value or "Button"
            valueLabel.TextColor3 = theme.TextSecondary
            valueLabel.TextSize = 12
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Font = Enum.Font.Gotham
            valueLabel.Parent = container

            -- Invisible click area
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = container

            btn.MouseEnter:Connect(function()
                TweenService:Create(container, TweenInfo.new(0.15), {BackgroundColor3 = theme.SurfaceHover}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(container, TweenInfo.new(0.15), {BackgroundColor3 = theme.Surface}):Play()
            end)

            btn.MouseButton1Click:Connect(function()
                -- Click flash
                TweenService:Create(container, TweenInfo.new(0.1), {BackgroundColor3 = theme.Primary}):Play()
                task.wait(0.1)
                TweenService:Create(container, TweenInfo.new(0.2), {BackgroundColor3 = theme.SurfaceHover}):Play()

                if config.Callback then
                    pcall(config.Callback)
                end
            end)

            return {
                SetText = function(self, newText) label.Text = newText end,
                SetValue = function(self, newVal) valueLabel.Text = newVal end,
            }
        end

        -- 2. TOGGLE (Switch sağda, yeşil/kapalı)
        function tabObj:CreateToggle(config)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 32)
            container.BackgroundColor3 = theme.Surface
            container.BackgroundTransparency = 0
            container.BorderSizePixel = 0
            container.Parent = tabContent

            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 6)
            containerCorner.Parent = container

            -- Sol label
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -70, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = config.Text or "Toggle"
            label.TextColor3 = theme.Text
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = container

            -- Toggle switch (sağda)
            local switch = Instance.new("Frame")
            switch.Size = UDim2.new(0, 36, 0, 20)
            switch.Position = UDim2.new(1, -48, 0.5, -10)
            switch.BackgroundColor3 = theme.Border
            switch.BackgroundTransparency = 0
            switch.BorderSizePixel = 0
            switch.Parent = container

            local switchCorner = Instance.new("UICorner")
            switchCorner.CornerRadius = UDim.new(1, 0)
            switchCorner.Parent = switch

            -- Toggle thumb (yuvarlak)
            local thumb = Instance.new("Frame")
            thumb.Size = UDim2.new(0, 14, 0, 14)
            thumb.Position = UDim2.new(0, 3, 0.5, -7)
            thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            thumb.BackgroundTransparency = 0
            thumb.BorderSizePixel = 0
            thumb.Parent = switch

            local thumbCorner = Instance.new("UICorner")
            thumbCorner.CornerRadius = UDim.new(1, 0)
            thumbCorner.Parent = thumb

            local state = config.Default or false

            local function updateToggle()
                if state then
                    TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = theme.Primary}):Play()
                    TweenService:Create(thumb, TweenInfo.new(0.2), {Position = UDim2.new(0, 19, 0.5, -7)}):Play()
                else
                    TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = theme.Border}):Play()
                    TweenService:Create(thumb, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -7)}):Play()
                end
            end

            updateToggle()

            -- Click handler
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = container

            btn.MouseEnter:Connect(function()
                TweenService:Create(container, TweenInfo.new(0.15), {BackgroundColor3 = theme.SurfaceHover}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(container, TweenInfo.new(0.15), {BackgroundColor3 = theme.Surface}):Play()
            end)

            btn.MouseButton1Click:Connect(function()
                state = not state
                updateToggle()
                if config.Callback then
                    pcall(config.Callback, state)
                end
            end)

            return {
                Set = function(self, newState)
                    state = newState
                    updateToggle()
                end,
                Get = function() return state end
            }
        end

        -- 3. SLIDER (Yeşil fill, değer sağda)
        function tabObj:CreateSlider(config)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 42)
            container.BackgroundColor3 = theme.Surface
            container.BackgroundTransparency = 0
            container.BorderSizePixel = 0
            container.Parent = tabContent

            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 6)
            containerCorner.Parent = container

            -- Label (sol üst)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, -12, 0, 16)
            label.Position = UDim2.new(0, 12, 0, 6)
            label.BackgroundTransparency = 1
            label.Text = config.Text or "Slider"
            label.TextColor3 = theme.Text
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = container

            -- Değer (sağ üst)
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0.3, -12, 0, 16)
            valueLabel.Position = UDim2.new(0.7, 0, 0, 6)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(config.Default or 50)
            valueLabel.TextColor3 = theme.Primary
            valueLabel.TextSize = 12
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.Parent = container

            -- Slider track
            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, -24, 0, 3)
            track.Position = UDim2.new(0, 12, 0, 28)
            track.BackgroundColor3 = theme.Border
            track.BackgroundTransparency = 0
            track.BorderSizePixel = 0
            track.Parent = container

            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(1, 0)
            trackCorner.Parent = track

            -- Slider fill (yeşil)
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(0.5, 0, 1, 0)
            fill.BackgroundColor3 = theme.Primary
            fill.BackgroundTransparency = 0
            fill.BorderSizePixel = 0
            fill.Parent = track

            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = fill

            -- Slider thumb (küçük nokta)
            local thumb = Instance.new("Frame")
            thumb.Size = UDim2.new(0, 12, 0, 12)
            thumb.Position = UDim2.new(0.5, -6, 0.5, -6)
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

            local function updateSlider(newValue, fireCallback)
                value = math.clamp(newValue, min, max)
                local percent = (value - min) / (max - min)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                thumb.Position = UDim2.new(percent, -6, 0.5, -6)
                valueLabel.Text = tostring(math.floor(value))
                if fireCallback and config.Callback then
                    pcall(config.Callback, value)
                end
            end

            updateSlider(value, false)

            -- Mouse events
            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local localX = math.clamp(input.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
                    local percent = localX / track.AbsoluteSize.X
                    updateSlider(min + percent * (max - min), true)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local localX = math.clamp(input.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
                    local percent = localX / track.AbsoluteSize.X
                    updateSlider(min + percent * (max - min), true)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            -- Hover efekti container
            local hoverBtn = Instance.new("TextButton")
            hoverBtn.Size = UDim2.new(1, 0, 1, 0)
            hoverBtn.BackgroundTransparency = 1
            hoverBtn.Text = ""
            hoverBtn.Parent = container

            hoverBtn.MouseEnter:Connect(function()
                TweenService:Create(container, TweenInfo.new(0.15), {BackgroundColor3 = theme.SurfaceHover}):Play()
            end)
            hoverBtn.MouseLeave:Connect(function()
                TweenService:Create(container, TweenInfo.new(0.15), {BackgroundColor3 = theme.Surface}):Play()
            end)

            return {
                Set = function(self, newValue) updateSlider(newValue, true) end,
                Get = function() return value end
            }
        end

        -- 4. DROPDOWN (Seçili değer sağda, ok ile)
        function tabObj:CreateDropdown(config)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 32)
            container.BackgroundColor3 = theme.Surface
            container.BackgroundTransparency = 0
            container.BorderSizePixel = 0
            container.ClipsDescendants = true
            container.Parent = tabContent

            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 6)
            containerCorner.Parent = container

            -- Label (sol)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.5, -12, 0, 32)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = config.Text or "Dropdown"
            label.TextColor3 = theme.Text
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = container

            -- Seçili değer (sağ)
            local selectedLabel = Instance.new("TextLabel")
            selectedLabel.Size = UDim2.new(0.3, -12, 0, 32)
            selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
            selectedLabel.BackgroundTransparency = 1
            selectedLabel.Text = config.Default or "Select..."
            selectedLabel.TextColor3 = theme.TextSecondary
            selectedLabel.TextSize = 12
            selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
            selectedLabel.Font = Enum.Font.Gotham
            selectedLabel.Parent = container

            -- Dropdown arrow (sağda)
            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.new(0, 20, 0, 32)
            arrow.Position = UDim2.new(1, -28, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "▼"
            arrow.TextColor3 = theme.TextMuted
            arrow.TextSize = 10
            arrow.Font = Enum.Font.Gotham
            arrow.Parent = container

            -- Dropdown list (açılır)
            local listFrame = Instance.new("Frame")
            listFrame.Size = UDim2.new(1, 0, 0, 0)
            listFrame.Position = UDim2.new(0, 0, 0, 32)
            listFrame.BackgroundColor3 = theme.Surface
            listFrame.BackgroundTransparency = 0
            listFrame.BorderSizePixel = 0
            listFrame.Visible = false
            listFrame.Parent = container

            local listCorner = Instance.new("UICorner")
            listCorner.CornerRadius = UDim.new(0, 0)
            listCorner.Parent = listFrame

            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 1)
            listLayout.Parent = listFrame

            local isOpen = false
            local selected = config.Default
            local optionHeight = 28

            local function toggleDropdown()
                isOpen = not isOpen
                if isOpen then
                    local count = #config.Options
                    listFrame.Visible = true
                    container.Size = UDim2.new(1, 0, 0, 32 + (count * optionHeight) + 4)
                    TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                    TweenService:Create(container, TweenInfo.new(0.2), {BackgroundColor3 = theme.SurfaceHover}):Play()
                else
                    container.Size = UDim2.new(1, 0, 0, 32)
                    TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    TweenService:Create(container, TweenInfo.new(0.2), {BackgroundColor3 = theme.Surface}):Play()
                    task.delay(0.2, function()
                        if not isOpen then listFrame.Visible = false end
                    end)
                end
            end

            -- Dropdown butonu
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = container
            btn.MouseButton1Click:Connect(toggleDropdown)

            btn.MouseEnter:Connect(function()
                if not isOpen then
                    TweenService:Create(container, TweenInfo.new(0.15), {BackgroundColor3 = theme.SurfaceHover}):Play()
                end
            end)
            btn.MouseLeave:Connect(function()
                if not isOpen then
                    TweenService:Create(container, TweenInfo.new(0.15), {BackgroundColor3 = theme.Surface}):Play()
                end
            end)

            -- Seçenekleri ekle
            local options = config.Options or {}

            for _, option in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, optionHeight)
                optBtn.BackgroundColor3 = theme.Surface
                optBtn.BackgroundTransparency = 0.5
                optBtn.BorderSizePixel = 0
                optBtn.Text = "  " .. option
                optBtn.TextColor3 = option == selected and theme.Primary or theme.TextSecondary
                optBtn.TextSize = 12
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                optBtn.Font = Enum.Font.Gotham
                optBtn.Parent = listFrame

                optBtn.MouseEnter:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0, TextColor3 = theme.Text}):Play()
                end)
                optBtn.MouseLeave:Connect(function()
                    local color = option == selected and theme.Primary or theme.TextSecondary
                    TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.5, TextColor3 = color}):Play()
                end)

                optBtn.MouseButton1Click:Connect(function()
                    selected = option
                    selectedLabel.Text = option
                    selectedLabel.TextColor3 = theme.Primary

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

            return {
                Set = function(self, newOption)
                    selected = newOption
                    selectedLabel.Text = newOption
                    for _, child in ipairs(listFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child.TextColor3 = child.Text == "  " .. newOption and theme.Primary or theme.TextSecondary
                        end
                    end
                end,
                Get = function() return selected end
            }
        end

        -- 5. KEYBIND ("Bind" - tuş atama)
        function tabObj:CreateBind(config)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 32)
            container.BackgroundColor3 = theme.Surface
            container.BackgroundTransparency = 0
            container.BorderSizePixel = 0
            container.Parent = tabContent

            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 6)
            containerCorner.Parent = container

            -- Label (sol)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.5, -12, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = config.Text or "Bind"
            label.TextColor3 = theme.Text
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = container

            -- Key display (sağda, küçük kutu)
            local keyBox = Instance.new("Frame")
            keyBox.Size = UDim2.new(0, 40, 0, 22)
            keyBox.Position = UDim2.new(1, -52, 0.5, -11)
            keyBox.BackgroundColor3 = theme.Background
            keyBox.BackgroundTransparency = 0
            keyBox.BorderSizePixel = 0
            keyBox.Parent = container

            local keyBoxCorner = Instance.new("UICorner")
            keyBoxCorner.CornerRadius = UDim.new(0, 4)
            keyBoxCorner.Parent = keyBox

            local keyLabel = Instance.new("TextLabel")
            keyLabel.Size = UDim2.new(1, 0, 1, 0)
            keyLabel.BackgroundTransparency = 1
            keyLabel.Text = config.Default and config.Default.Name or "..."
            keyLabel.TextColor3 = theme.TextSecondary
            keyLabel.TextSize = 11
            keyLabel.Font = Enum.Font.GothamBold
            keyLabel.Parent = keyBox

            local currentKey = config.Default
            local listening = false

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = container

            btn.MouseEnter:Connect(function()
                TweenService:Create(container, TweenInfo.new(0.15), {BackgroundColor3 = theme.SurfaceHover}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(container, TweenInfo.new(0.15), {BackgroundColor3 = theme.Surface}):Play()
            end)

            btn.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true
                keyLabel.Text = "..."
                keyLabel.TextColor3 = theme.Primary

                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        keyLabel.Text = input.KeyCode.Name
                        keyLabel.TextColor3 = theme.TextSecondary
                        listening = false
                        connection:Disconnect()

                        if config.Callback then
                            pcall(config.Callback, input.KeyCode)
                        end
                    end
                end)
            end)

            return {
                Set = function(self, keyCode)
                    currentKey = keyCode
                    keyLabel.Text = keyCode.Name
                end,
                Get = function() return currentKey end
            }
        end

        -- 6. TEXTBOX (Input)
        function tabObj:CreateTextbox(config)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 0, 56)
            container.BackgroundColor3 = theme.Surface
            container.BackgroundTransparency = 0
            container.BorderSizePixel = 0
            container.Parent = tabContent

            local containerCorner = Instance.new("UICorner")
            containerCorner.CornerRadius = UDim.new(0, 6)
            containerCorner.Parent = container

            -- Label
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -12, 0, 18)
            label.Position = UDim2.new(0, 12, 0, 6)
            label.BackgroundTransparency = 1
            label.Text = config.Text or "Input"
            label.TextColor3 = theme.Text
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = container

            -- Input box
            local input = Instance.new("TextBox")
            input.Size = UDim2.new(1, -24, 0, 26)
            input.Position = UDim2.new(0, 12, 0, 26)
            input.BackgroundColor3 = theme.Background
            input.BackgroundTransparency = 0
            input.BorderSizePixel = 0
            input.Text = config.Default or ""
            input.TextColor3 = theme.Text
            input.TextSize = 12
            input.Font = Enum.Font.Gotham
            input.PlaceholderText = config.Placeholder or "Type here..."
            input.PlaceholderColor3 = theme.TextMuted
            input.ClearTextOnFocus = false
            input.Parent = container

            local inputCorner = Instance.new("UICorner")
            inputCorner.CornerRadius = UDim.new(0, 4)
            inputCorner.Parent = input

            -- Input stroke
            local inputStroke = Instance.new("UIStroke")
            inputStroke.Color = theme.Border
            inputStroke.Thickness = 1
            inputStroke.Parent = input

            input.Focused:Connect(function()
                TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = theme.Primary}):Play()
            end)

            input.FocusLost:Connect(function(enterPressed)
                TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = theme.Border}):Play()
                if config.Callback then
                    pcall(config.Callback, input.Text)
                end
            end)

            return {
                Set = function(self, newText) input.Text = newText end,
                Get = function() return input.Text end
            }
        end

        -- 7. LABEL (Sadece metin)
        function tabObj:CreateLabel(config)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Text = config.Text or "Label"
            label.TextColor3 = config.Color or theme.TextSecondary
            label.TextSize = 11
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = tabContent

            return {
                Set = function(self, newText) label.Text = newText end,
            }
        end

        -- 8. SEPARATOR (Ayırıcı çizgi)
        function tabObj:CreateSeparator()
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.BackgroundColor3 = theme.Border
            line.BackgroundTransparency = 0.5
            line.BorderSizePixel = 0
            line.Parent = tabContent

            return line
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
                    BackgroundTransparency = 1,
                    TextColor3 = self._theme.TextSecondary
                }):Play()
            end
        end

        self._currentTab = name
        local newTab = self._tabs[name]
        if newTab then
            newTab._content.Visible = true
            TweenService:Create(newTab._button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0,
                BackgroundColor3 = self._theme.SurfaceActive,
                TextColor3 = self._theme.Primary
            }):Play()
        end
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
    local theme = NovaUI.Theme.Dark
    local container = self._notificationContainer

    if not container then
        container = Instance.new("Frame")
        container.Name = "Notifications"
        container.Size = UDim2.new(0, 280, 0, 0)
        container.Position = UDim2.new(1, -300, 0, 12)
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

    local notifStroke = Instance.new("UIStroke")
    notifStroke.Color = theme.Border
    notifStroke.Thickness = 1
    notifStroke.Parent = notif

    -- İçerik
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -24, 0, 0)
    content.Position = UDim2.new(0, 12, 0, 10)
    content.BackgroundTransparency = 1
    content.Parent = notif

    -- Başlık
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 18)
    title.BackgroundTransparency = 1
    title.Text = config.Title or "Notification"
    title.TextColor3 = theme.Text
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamSemibold
    title.Parent = content

    -- Mesaj
    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, 0, 0, 0)
    message.Position = UDim2.new(0, 0, 0, 22)
    message.BackgroundTransparency = 1
    message.Text = config.Message or ""
    message.TextColor3 = theme.TextSecondary
    message.TextSize = 12
    message.TextXAlignment = Enum.TextXAlignment.Left
    message.TextWrapped = true
    message.Font = Enum.Font.Gotham
    message.Parent = content

    -- Boyutları hesapla
    local textBounds = message.TextBounds
    local height = 22 + textBounds.Y + 10 + 10
    content.Size = UDim2.new(1, 0, 0, height)
    message.Size = UDim2.new(1, 0, 0, textBounds.Y)
    notif.Size = UDim2.new(1, 0, 0, height + 20)

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
