local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local function StripDressUpBackground()
    if type(_G.SetDressUpBackground) == "function" then _G.SetDressUpBackground() end
    local names = {
        "DressUpBackgroundTopLeft","DressUpBackgroundTopRight",
        "DressUpBackgroundBotLeft","DressUpBackgroundBotRight",
        "DressUpModelBackgroundTopLeft","DressUpModelBackgroundTopRight",
        "DressUpModelBackgroundBotLeft","DressUpModelBackgroundBotRight",
        "SideDressUpBackgroundTopLeft","SideDressUpBackgroundTopRight",
        "SideDressUpBackgroundBotLeft","SideDressUpBackgroundBotRight",
    }
    for i=1,#names do
        local t = _G[names[i]]
        if t then t:Hide() t:SetAlpha(0) t:SetTexture(nil) end
    end
    local f = _G.DressUpFrame or _G.SideDressUpFrame
    if f and f.GetRegions then
        local regs = { f:GetRegions() }
        for i=1,#regs do
            local r = regs[i]
            if r and r.GetObjectType and r:GetObjectType()=="Texture" then
                local n = r:GetName()
                if not n or n:find("Background") or n:find("BG") then
                    r:Hide() r:SetAlpha(0) r:SetTexture(nil)
                end
            end
        end
    end
end

local function SkinDressingRoom()
    StripDressUpBackground()
    local f = _G.DressUpFrame
    if f and f.StripTextures then f:StripTextures(true) end
    if f and f.CloseButton and S.HandleCloseButton then S:HandleCloseButton(f.CloseButton) end
    local sf = _G.SideDressUpFrame
    if sf and sf.StripTextures then sf:StripTextures(true) end
    if sf and sf.CloseButton and S.HandleCloseButton then S:HandleCloseButton(sf.CloseButton) end
end

function S:Blizzard_DressingRoom()
    if not (E.private and E.private.skins and E.private.skins.blizzard and E.private.skins.blizzard.enable and E.private.skins.blizzard.dressingroom) then return end
    SkinDressingRoom()
    if _G.DressUpFrame and _G.DressUpFrame.HookScript then _G.DressUpFrame:HookScript("OnShow", SkinDressingRoom) end
    if _G.SideDressUpFrame and _G.SideDressUpFrame.HookScript then _G.SideDressUpFrame:HookScript("OnShow", SkinDressingRoom) end
end

local function Register()
    if E and E.db then
        S:AddCallback("Blizzard_DressingRoom")
    else
        local f = CreateFrame("Frame")
        f:RegisterEvent("PLAYER_LOGIN")
        f:SetScript("OnEvent", function()
            if not E or not E.db then return end
            S:AddCallback("Blizzard_DressingRoom")
            f:UnregisterEvent("PLAYER_LOGIN")
        end)
    end
end

Register()
