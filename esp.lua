while wait() do
    local players = game.Players:GetPlayers()
    local LocalPlayer = game.Players.LocalPlayer 
    for i=1, #players do
		if players[i].TeamColor == LocalPlayer.TeamColor and workspace:FindFirstChild(players[i].Name) and players[i].Name ~= LocalPlayer.Name then
            local BillboardGui = Instance.new("BillboardGui")
			local Frame = Instance.new("Frame")
			--Properties:
			BillboardGui.Parent = game.Workspace[players[i].Name].Head
			BillboardGui.Active = true
			BillboardGui.AlwaysOnTop = true
			BillboardGui.LightInfluence = 1
			BillboardGui.Size = UDim2.new(0, 20, 0, 20)
			
			Frame.Parent = BillboardGui
			Frame.BackgroundColor3 = Color3.new(players[i].TeamColor.r, players[i].TeamColor.g, players[i].TeamColor.b)
			Frame.Size = UDim2.new(0, 10, 0, 10)
			end
		if players[i].TeamColor ~= LocalPlayer.TeamColor and workspace:FindFirstChild(players[i].Name) and players[i].Name ~= LocalPlayer.Name then
			local BillboardGui = Instance.new("BillboardGui")
			local Frame = Instance.new("Frame")
			--Properties:
			BillboardGui.Parent = game.Workspace[players[i].Name].Head
			BillboardGui.Active = true
			BillboardGui.AlwaysOnTop = true
			BillboardGui.LightInfluence = 1
			BillboardGui.Size = UDim2.new(0, 20, 0, 20)
			
			Frame.Parent = BillboardGui
			Frame.BackgroundColor3 = Color3.new(players[i].TeamColor.r, players[i].TeamColor.g, players[i].TeamColor.b)
			Frame.Size = UDim2.new(0, 10, 0, 10)
        end
    end
end