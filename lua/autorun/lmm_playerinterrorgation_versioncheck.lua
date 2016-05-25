--[[You really should not edit this!]]--
local version = "1.1" -- DO NOT EDIT THIS!
local version_url = "https://raw.githubusercontent.com/XxLMM13xXgaming/lmm_player_Interrogation/master/version.txt" -- DO NOT EDIT THIS!
local update_url = "https://github.com/XxLMM13xXgaming/lmm_player_Interrogation" -- DO NOT EDIT THIS!
local update_ur = "https://raw.githubusercontent.com/XxLMM13xXgaming/lmm_player_Interrogation/master/versionur.txt" -- DO NOT EDIT THIS!
local msg_outdated = "You are using a outdated/un-supported version. You are on version "..version.."! Please download the new version here: " .. update_url -- DO NOT EDIT THIS!
local ranksthatgetnotify = { "superadmin", "owner", "admin" } -- DO NOT EDIT THIS!
local addon_id = "LMMPI" -- DO NOT EDIT THIS
local addon_name = "Player Interrorgation" -- DO NOT EDIT THIS

if (SERVER) then

	AddCSLuaFile("lmm_pi_config.lua")
	include("lmm_pi_config.lua")

	util.AddNetworkString(addon_id.."VersionCheck")

	concommand.Add( addon_id.."_version", function(ply)
		http.Fetch(version_url, function(body, len, headers, code, ply)
			newversion = body
		end )
		http.Fetch(update_ur, function(body, len, headers, code, ply)
			thenewversiontext = body
		end )
		net.Start(addon_id.."VersionCheck")
			net.WriteString(newversion)
			net.WriteString(thenewversiontext)
		net.Send(ply)
	end )

	http.Fetch(version_url, function(body, len, headers, code, ply)
		if (string.Trim(body) ~= version) then
			MsgC( Color(255,0,0), "["..addon_name.." ("..version..")] You are NOT using the latest version! (version: "..string.Trim(body)..")\n" )
		else
			MsgC( Color(255,0,0), "["..addon_name.." ("..version..")] You are using the latest version!\n" )
		end
	end )
	timer.Create(addon_id.."VersionCheckServerTimer", 600, 0, function()
		http.Fetch(version_url, function(body, len, headers, code, ply)
			if (string.Trim(body) ~= version) then
				MsgC( Color(255,0,0), "["..addon_name.." ("..version..")] You are NOT using the latest version! ("..string.Trim(body)..")\n" )
			end
		end )
	end )

	hook.Add("PlayerInitialSpawn", addon_id.."VersionCheck", function(theply)
		if (table.HasValue( ranksthatgetnotify, theply:GetUserGroup() ) ~= true) then return end

		http.Fetch(version_url, function(body, len, headers, code, ply)
			if (string.Trim(body) ~= version) then
				http.Fetch(version_url, function(body, len, headers, code, ply)
					newversion = body
				end )
				http.Fetch(update_ur, function(body, len, headers, code, ply)
					thenewversiontext = body
				end )
				net.Start(addon_id.."VersionCheck")
					net.WriteString(newversion)
					net.WriteString(thenewversiontext)
				net.Send(theply)
			else
			end
		end, function(error)

			-- Silently fail

		end)
	end)


end

if (CLIENT) then
	include("lmm_pi_config.lua")

	surface.CreateFont( addon_id.."TitleFont", {
		font = "Arial",
		size = 20,
		weight = 5000,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont( addon_id.."DescFont", {
		font = "Arial",
		size = 15,
		weight = 5000,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont( addon_id.."LabelSmall", {
		font = "Arial",
		size = 25,
		weight = 2000,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	surface.CreateFont( addon_id.."fontclose", {
		font = "Arial",
		size = 18,
		weight = 5000,
		blursize = 0,
		scanlines = 0,
		antialias = true,
	})

	net.Receive(addon_id.."VersionCheck", function()
		local newversion = net.ReadString()
		local thenewversiontext = net.ReadString()

		local DFrame = vgui.Create( "DFrame" )
		DFrame:SetSize( 500, 260 )
		DFrame:Center()
		DFrame:SetDraggable( true )
		DFrame:MakePopup()
		DFrame:SetTitle( "" )
		DFrame:ShowCloseButton( false )
		DFrame.Paint = function( self, w, h )
			draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(35, 35, 35, 250))
			draw.RoundedBox(2, 0, 0, DFrame:GetWide(), 30, Color(40, 40, 40, 255))
			draw.SimpleText( "Ugh-oh!", addon_id.."TitleFont", DFrame:GetWide() / 2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local frameclose = vgui.Create("DButton", DFrame)
		frameclose:SetSize(20, 20)
		frameclose:SetPos(DFrame:GetWide() - frameclose:GetWide() - 3, 3)
		frameclose:SetText("X");
		frameclose:SetTextColor(Color(0,0,0,255))
		frameclose:SetFont(addon_id.."fontclose")
		frameclose.hover = false
		frameclose.DoClick = function()
			DFrame:Close()
		end
		frameclose.OnCursorEntered = function(self)
			self.hover = true
		end
		frameclose.OnCursorExited = function(self)
			self.hover = false
		end
		function frameclose:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, (self.hover and Color(255,15,15,250)) or Color(255,255,255,255)) -- Paints on hover
			frameclose:SetTextColor(self.hover and Color(255,255,255,250) or Color(0,0,0,255))
		end

		local addontext = vgui.Create("DLabel", DFrame)
		addontext:SetText("Addon Name: "..addon_name)
		addontext:SetPos(10, 35)
		addontext:SetSize(500, 20)
		addontext:SetFont(addon_id.."LabelSmall")

		local versiontext = vgui.Create("DLabel", DFrame)
		versiontext:SetText("Your version: "..version)
		versiontext:SetPos(10, 65)
		versiontext:SetSize(500, 15)
		versiontext:SetFont(addon_id.."LabelSmall")

		local newversiontext = vgui.Create("DLabel", DFrame)
		newversiontext:SetText("New version: "..newversion)
		newversiontext:SetPos(10, 90)
		newversiontext:SetSize(500, 50)
		newversiontext:SetFont(addon_id.."LabelSmall")


		local richtext = vgui.Create( "RichText", DFrame )
		richtext:SetPos(10, 120)
		richtext:SetSize(480, 100)

		richtext:InsertColorChange( 255, 0, 0, 255 )
		richtext:AppendText( "Why is there a version change?\n\n\n" )

		richtext:InsertColorChange( 192, 192, 192, 255 )
		richtext:AppendText( thenewversiontext )

		local lbl = vgui.Create( "DLabelURL", DFrame )
		lbl:SetPos( 10, 220 )
		lbl:SetSize( 500, 20 )
		lbl:SetColor( Color( 255, 0, 0, 255 ) )
		lbl:SetText( "Click here to update "..string.lower(addon_name) )
		lbl:SetURL( update_url )
	end)
end
