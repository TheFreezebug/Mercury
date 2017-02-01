  local MenuTab = {}
  MenuTab.index = 6 //Internal identifier for table
  MenuTab.Name = "User Data" // Display name 
  MenuTab.Desc = "User Data" // Description 
  MenuTab.Icon = "icon16/cd_burn.png" // Icon
local bandata = {}
local totalchunks = 0
local gotchunks = 0

function MenuTab:ShouldGenerateTab()

	return true


end


local function DoLayout(gframe,bantable)
			



end



local function GenerateMenu(frame)

 	local prosh = vgui.Create("DPropertySheet", frame) // Property sheet in which everything attaches to.

	 prosh:Dock(FILL)
	
	 function prosh:GetWindow()
	    return frame
	 end 

	 function frame:GetPropertySheet()
	 	return prosh
	 end
 	
 	 


end

Mercury.ModHook.Add("AddMenuRealtime","Testing",function()
    Mercury.Menu.AddMenuTab(MenuTab.index,MenuTab.Icon,MenuTab.Name,MenuTab.Desc,GenerateMenu,MenuTab.ShouldGenerateTab) 
end)


 
