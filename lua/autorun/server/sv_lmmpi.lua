--LMMPI

util.AddNetworkString("LMMPIOpenTheOGMenu")
util.AddNetworkString("LMMPIInterrogatePlayer")
util.AddNetworkString("LMMPIInterrorBeginCalling")
util.AddNetworkString("LMMPIInterrorBegin")
util.AddNetworkString("LMMPIEndTheInterror")
util.AddNetworkString("LMMPIForceClose")
util.AddNetworkString("LMMPIEnterText")
util.AddNetworkString("LMMPIGetMessage")
util.AddNetworkString("LMMPIGetMessageCaller")
util.AddNetworkString("LMMPIForceMOTD")
util.AddNetworkString("LMMPINotifyN")

function LMMPIOpenIMenu(ply)
	net.Start("LMMPIOpenTheOGMenu")
	net.Send(ply)
end

function LMMPINotify(ply, message)
		net.Start("LMMPINotifyN")
			net.WriteString(message)
		net.Send(ply)
end

local function GetPlayerByName( ply )
	local Players = player.GetAll()
	for i=1, table.Count( Players ) do
		if string.find( string.lower( Players[i]:Nick() ), string.lower( ply ) ) then
			return Players[i]
		end
	end
	return nil
end

function LMMPIInterrogatePlayerFinal(calling_ply, target_ply, reason)
	print(calling_ply)
	print(target_ply)
	if target_ply != nil then
		net.Start("LMMPIInterrorBeginCalling")
			net.WriteString(reason)
			net.WriteEntity(target_ply)
			net.WriteEntity(calling_ply)
		net.Send(calling_ply)
		net.Start("LMMPIInterrorBegin")
			net.WriteString(reason)
			net.WriteEntity(target_ply)
			net.WriteEntity(calling_ply)
		net.Send(target_ply)
	end
end

local function LMMPIChatCommand(ply, text)
	local text = string.lower(text)
	if text == "!pi" or text == "/pi" then
		if table.HasValue(LMMPIConfig.AdminGroups, ply:GetUserGroup()) then
			LMMPIOpenIMenu(ply)
		else
			LMMPINotify(ply, "You are not the correct rank!")
		end
		return ''
	end
end
hook.Add("PlayerSay", "LMMPIChatCommand", LMMPIChatCommand)

net.Receive("LMMPIInterrogatePlayer",function(len, ply)
		local player = net.ReadString()
		local reason = net.ReadString()
		if table.HasValue(LMMPIConfig.AdminGroups, ply:GetUserGroup()) then
				LMMPIInterrogatePlayerFinal(ply, GetPlayerByName(player), reason)
		end
end)

net.Receive("LMMPIEndTheInterror", function(len, ply)
	if table.HasValue(LMMPIConfig.AdminGroups,ply:GetUserGroup()) then
		local target = net.ReadEntity()
		net.Start("LMMPIForceClose")
		net.Send(target)
	end
end)

net.Receive("LMMPIEnterText", function(len, ply)
	if table.HasValue(LMMPIConfig.AdminGroups,ply:GetUserGroup()) then
		local sendto = net.ReadEntity()
		local message = net.ReadString()
		net.Start("LMMPIGetMessage")
			net.WriteString(message)
			net.WriteEntity(ply)
		net.Send(sendto)
		net.Start("LMMPIGetMessageCaller")
			net.WriteString(message)
			net.WriteEntity(ply)
		net.Send(sendto)
	end
end)

net.Receive("LMMPIForceMOTD",function(len, ply)
	local target = net.ReadEntity()
	if table.HasValue(LMMPIConfig.AdminGroups,ply:GetUserGroup()) then
		target:ConCommand(LMMPIConfig.MOTDCommand)
		ply:ConCommand(LMMPIConfig.MOTDCommand)
	end
end)
