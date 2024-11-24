---@diagnostic disable: undefined-field, inject-field
-- Smooth scrollbar (code from Spanky)
---@class GF_ScrollPanel: DScrollPanel
local GFScrollPanel = {}
AccessorFunc(GFScrollPanel, "scrolldistance", "ScrollDistance", FORCE_NUMBER)
function GFScrollPanel:Init()
    self:SetScrollDistance(32)
    local scrollPanel = self

    local vbar = self:GetVBar()
    function vbar:OnMouseWheeled( dlta )
        if not self:IsVisible() then return false end
        -- We return true if the scrollbar changed.
        -- If it didn't, we feed the mousehweeling to the parent panel
        if self.CurrentScroll == nil then self.CurrentScroll = self:GetScroll() end
        self.CurrentScroll = math.Clamp(self.CurrentScroll + (dlta * -scrollPanel:GetScrollDistance()), 0, self.CanvasSize)
        self:AnimateTo(self.CurrentScroll, 0.05, 0, 0.1)
        return self:AddScroll( dlta * -2 )
    end
    function vbar:OnMouseReleased()
        self.CurrentScroll = self:GetScroll()

        self.Dragging = false
        self.DraggingCanvas = nil
        self:MouseCapture( false )
    
        self.btnGrip.Depressed = false
    end
end
vgui.Register("GF_ScrollPanel", GFScrollPanel, "DScrollPanel")

return GFScrollPanel