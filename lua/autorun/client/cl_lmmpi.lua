--LMMPI
surface.CreateFont( "LMMPITitleFont", {
	font = "Arial",
	size = 20,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})

surface.CreateFont( "LMMPIDescFont", {
	font = "Arial",
	size = 15,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})

surface.CreateFont( "LMMPILabelSmall", {
	font = "Arial",
	size = 25,
	weight = 2000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})

surface.CreateFont( "LMMPINoFont", {
	font = "Lato Light",
	size = 30,
	weight = 250,
	antialias = true,
	strikeout = false,
	additive = true,
} )

surface.CreateFont( "LMMPISellLabel", {
	font = "Lato Light",
	size = 20,
	weight = 250,
	antialias = true,
	strikeout = false,
	additive = true,
} )

surface.CreateFont( "LMMPIfontclose", {
	font = "Arial",
	size = 18,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
})


net.Receive("LMMPIOpenTheOGMenu", function()
	local DFrame = vgui.Create( "DFrame" )
	DFrame:SetSize( 500, 210 )
	DFrame:Center()
	DFrame:SetDraggable( true )
	DFrame:MakePopup()
	DFrame:SetTitle( "" )
	DFrame:ShowCloseButton( false )
	DFrame.Paint = function( self, w, h )
		draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(35, 35, 35, 250))
		draw.RoundedBox(2, 0, 0, DFrame:GetWide(), 30, Color(40, 40, 40, 255))
		draw.SimpleText( "Interrogate a player!", "LMMPITitleFont", DFrame:GetWide() / 2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local frameclose = vgui.Create("DButton", DFrame)
	frameclose:SetSize(20, 20)
	frameclose:SetPos(DFrame:GetWide() - frameclose:GetWide() - 3, 3)
	frameclose:SetText("X");
	frameclose:SetTextColor(Color(0,0,0,255))
	frameclose:SetFont("LMMPIfontclose")
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

	local DComboBoxPlayer = vgui.Create( "DComboBox", DFrame )
	DComboBoxPlayer:SetPos( 10, 35 )
	DComboBoxPlayer:SetSize( DFrame:GetWide() - 20, 20 )
	DComboBoxPlayer:SetValue( "Select a player" )
	for k, v in pairs(player.GetAll()) do
		DComboBoxPlayer:AddChoice( v:Nick() )
	end
	DComboBoxPlayer.OnSelect = function( panel, index, value )
	end

	local DComboBoxReason = vgui.Create( "DComboBox", DFrame )
	DComboBoxReason:SetPos( 10, 60 )
	DComboBoxReason:SetSize( DFrame:GetWide() - 20, 20 )
	DComboBoxReason:SetValue( "Select a reason" )
	for k, v in pairs(LMMPIConfig.Reasons) do
		DComboBoxReason:AddChoice( v )
	end
	DComboBoxReason.OnSelect = function( panel, index, value )
	end

	local wlabel = vgui.Create("DLabel", DFrame)
	wlabel:SetPos(10, 85)
	wlabel:SetSize(DFrame:GetWide() - 20, 90)
	wlabel:SetText("WARNING: Clicking the icons below chat\nwill use that action immediately so please make sure\nNot to click it unless you are sure!")
	wlabel:SetFont("LMMPILabelSmall")
	wlabel:SetTextColor(Color(255,0,0))

	local Interrogate = vgui.Create( "DButton", DFrame )
	Interrogate:SetPos( 10, 175 )
	Interrogate:SetSize( DFrame:GetWide() - 20,20 )
	Interrogate:SetText( "Interrogate Player" )
	Interrogate.OnCursorEntered = function(self)
		self.hover = true
	end
	Interrogate.OnCursorExited = function(self)
		self.hover = false
	end
	Interrogate.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, (self.hover and Color(0,160,255,250)) or Color(255,255,255,255)) -- Paints on hover
		Interrogate:SetTextColor(self.hover and Color(255,255,255,250) or Color(0,0,0,255))
	end
	Interrogate.DoClick = function()
		net.Start("LMMPIInterrogatePlayer")
			net.WriteString(DComboBoxPlayer:GetValue())
			net.WriteString(DComboBoxReason:GetValue())
		net.SendToServer()
		DFrame:Close()
	end
end)

net.Receive("LMMPIInterrorBeginCalling",function()
	local reason = net.ReadString()
	local target = net.ReadEntity()
	local calling = net.ReadEntity()

	local DFrame = vgui.Create( "DFrame" )
	DFrame:SetSize( 500, 370 )
	DFrame:Center()
	DFrame:SetDraggable( true )
	DFrame:MakePopup()
	DFrame:SetTitle( "" )
	DFrame:ShowCloseButton( false )
	DFrame.Paint = function( self, w, h )
		draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(35, 35, 35, 250))
		draw.RoundedBox(2, 0, 0, DFrame:GetWide(), 30, Color(40, 40, 40, 255))
		draw.SimpleText( "Interrogate "..target:Nick(), "LMMPITitleFont", DFrame:GetWide() / 2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local frameclose = vgui.Create("DButton", DFrame)
	frameclose:SetSize(20, 20)
	frameclose:SetPos(DFrame:GetWide() - frameclose:GetWide() - 3, 3)
	frameclose:SetText("X");
	frameclose:SetTextColor(Color(0,0,0,255))
	frameclose:SetFont("LMMPIfontclose")
	frameclose.hover = false
	frameclose.DoClick = function()
		DFrame:Close()
		net.Start("LMMPIEndTheInterror")
			net.WriteEntity(target)
		net.SendToServer()
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

	local reasonL = vgui.Create("DLabel", DFrame)
	reasonL:SetPos(10, 35)
	reasonL:SetSize(DFrame:GetWide() - 20, 20)
	reasonL:SetText("Reason: "..reason)
	reasonL:SetTextColor(Color(255,0,0,255))
	reasonL:SetFont("LMMPILabelSmall")

	local richtext = vgui.Create( "RichText", DFrame )
	richtext:SetPos(10, 60)
	richtext:SetSize(DFrame:GetWide() - 20, 250)

	richtext:InsertColorChange( 192, 192, 192, 255 )
	richtext:AppendText( "You are interrogating "..target:Nick().." for the reason of "..reason..". Make sure to prove your point!\n\n" )

	net.Receive("LMMPIGetMessage", function(len, ply)
		local message = net.ReadString()
		local ply = net.ReadEntity()

		if IsValid(richtext) then
			richtext:InsertColorChange(192,192,192,255)
			richtext:AppendText( os.date("%I:%M:%S %p") )
			richtext:InsertColorChange(255,255,255,255)
			richtext:AppendText(" - ")
			local plycolor = team.GetColor(ply:Team())
			richtext:InsertColorChange(plycolor.r, plycolor.g, plycolor.b, plycolor.a)
			richtext:AppendText(ply:Nick())
			richtext:InsertColorChange(255,255,255,255)
			richtext:AppendText(": "..message.."\n")
		end
	end)

	net.Receive("LMMPIGetMessageCaller", function(len, ply)
		local message = net.ReadString()
		local ply = net.ReadEntity()

		if IsValid(richtext) then
			richtext:InsertColorChange(192,192,192,255)
			richtext:AppendText( os.date("%I:%M:%S %p") )
			richtext:InsertColorChange(255,255,255,255)
			richtext:AppendText(" - ")
			local plycolor = team.GetColor(ply:Team())
			richtext:InsertColorChange(plycolor.r, plycolor.g, plycolor.b, plycolor.a)
			richtext:AppendText(ply:Nick())
			richtext:InsertColorChange(255,255,255,255)
			richtext:AppendText(": "..message.."\n")
		end
	end)

	local EnterText = vgui.Create("DTextEntry", DFrame)
	EnterText:SetPos(10, 320)
	EnterText:SetSize(DFrame:GetWide() - 20,20)
	EnterText:SetText("Enter a message...")
	EnterText.OnEnter = function( self )
		net.Start("LMMPIEnterText")
			net.WriteEntity(target)
			net.WriteString(self:GetValue())
		net.SendToServer()
		self:SetText("Enter a message...")
	end

	ForceMOTD = vgui.Create( "DImageButton", DFrame )
	ForceMOTD:SetPos( 10, 345 )
	ForceMOTD:SetImage( "icon16/information.png" )
	ForceMOTD:SizeToContents()
	ForceMOTD.DoClick = function()
		net.Start("LMMPIForceMOTD")
			net.WriteEntity(target)
		net.SendToServer()
	end

	BanPlayer = vgui.Create( "DImageButton", DFrame )
	BanPlayer:SetPos( 35, 345 )
	BanPlayer:SetImage( "icon16/bomb.png" )
	BanPlayer:SizeToContents()
	BanPlayer.DoClick = function()
		net.Start("LMMPIEnterText")
			net.WriteEntity(target)
			net.WriteString("Im gonna ban you now... Follow the rules next time!")
		net.SendToServer()
		DFrame:Close()
				local DFrame2 = vgui.Create( "DFrame" )
				DFrame2:SetSize( 500, 110 )
				DFrame2:Center()
				DFrame2:SetDraggable( true )
				DFrame2:MakePopup()
				DFrame2:SetTitle( "" )
				DFrame2:ShowCloseButton( false )
				DFrame2.Paint = function( self, w, h )
					draw.RoundedBox(2, 0, 0, DFrame2:GetWide(), DFrame2:GetTall(), Color(35, 35, 35, 250))
					draw.RoundedBox(2, 0, 0, DFrame2:GetWide(), 30, Color(40, 40, 40, 255))
					draw.SimpleText( "Interrogate "..target:Nick(), "LMMPITitleFont", DFrame2:GetWide() / 2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				local frameclose = vgui.Create("DButton", DFrame2)
				frameclose:SetSize(20, 20)
				frameclose:SetPos(DFrame2:GetWide() - frameclose:GetWide() - 3, 3)
				frameclose:SetText("X");
				frameclose:SetTextColor(Color(0,0,0,255))
				frameclose:SetFont("LMMPIfontclose")
				frameclose.hover = false
				frameclose.DoClick = function()
					DFrame2:Close()
					net.Start("LMMPIEndTheInterror")
						net.WriteEntity(target)
					net.SendToServer()
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

				local TextEntry = vgui.Create( "DTextEntry", DFrame2 )	-- create the form as a child of frame
				TextEntry:SetPos( 10, 50 )
				TextEntry:SetSize(DFrame2:GetWide() - 20,20)
				TextEntry:SetText( "Enter the time in min to ban "..target:Nick().." for..." )
				TextEntry.OnEnter = function( self )

				end

				local BanPlayerB = vgui.Create( "DButton", DFrame2 )
				BanPlayerB:SetPos( 10, 75 )
				BanPlayerB:SetSize( DFrame2:GetWide() - 20,20 )
				BanPlayerB:SetText( "Ban "..target:Nick() )
				BanPlayerB.OnCursorEntered = function(self)
					self.hover = true
				end
				BanPlayerB.OnCursorExited = function(self)
					self.hover = false
				end
				BanPlayerB.Paint = function( self, w, h )
					draw.RoundedBox(0, 0, 0, w, h, (self.hover and Color(0,160,255,250)) or Color(255,255,255,255)) -- Paints on hover
					BanPlayerB:SetTextColor(self.hover and Color(255,255,255,250) or Color(0,0,0,255))
				end
				BanPlayerB.DoClick = function()
					DFrame2:Close()
					net.Start("LMMPIBanPlayer")
						net.WriteEntity(target)
						net.WriteFloat(tonumber(TextEntry:GetValue()))
						net.WriteString(reason)
					net.SendToServer()
						local DFrame3 = vgui.Create( "DFrame" )
						DFrame3:SetSize( 500, 370 )
						DFrame3:Center()
						DFrame3:SetDraggable( true )
						DFrame3:MakePopup()
						DFrame3:SetTitle( "" )
						DFrame3:ShowCloseButton( false )
						DFrame3.Paint = function( self, w, h )
							draw.RoundedBox(2, 0, 0, DFrame3:GetWide(), DFrame3:GetTall(), Color(35, 35, 35, 250))
							draw.RoundedBox(2, 0, 0, DFrame3:GetWide(), 30, Color(40, 40, 40, 255))
							draw.SimpleText( "Interrogate "..target:Nick(), "LMMPITitleFont", DFrame3:GetWide() / 2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						end

						local frameclose = vgui.Create("DButton", DFrame3)
						frameclose:SetSize(20, 20)
						frameclose:SetPos(DFrame3:GetWide() - frameclose:GetWide() - 3, 3)
						frameclose:SetText("X");
						frameclose:SetTextColor(Color(0,0,0,255))
						frameclose:SetFont("LMMPIfontclose")
						frameclose.hover = false
						frameclose.DoClick = function()
							DFrame3:Close()
							net.Start("LMMPIEndTheInterror")
								net.WriteEntity(target)
							net.SendToServer()
							print(LMMPIConfig.FreezeCommand.." "..target:Nick().."")
							LocalPlayer():ConCommand(LMMPIConfig.FreezeCommand.." "..target:Nick())
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

						local reasonL = vgui.Create("DLabel", DFrame3)
						reasonL:SetPos(10, 35)
						reasonL:SetSize(DFrame3:GetWide() - 20, 20)
						reasonL:SetText("Reason: "..reason)
						reasonL:SetTextColor(Color(255,0,0,255))
						reasonL:SetFont("LMMPILabelSmall")

						local richtext = vgui.Create( "RichText", DFrame3 )
						richtext:SetPos(10, 60)
						richtext:SetSize(DFrame3:GetWide() - 20, 250)

						richtext:InsertColorChange( 192, 192, 192, 255 )
						richtext:AppendText( "You are interrogating "..target:Nick().." for the reason of "..reason..". Make sure to prove your point!\n\n" )

						net.Receive("LMMPIGetMessageCaller", function(len, ply)
							local message = net.ReadString()
							local ply = net.ReadEntity()

							if IsValid(richtext) then
								richtext:InsertColorChange(192,192,192,255)
								richtext:AppendText( os.date("%I:%M:%S %p") )
								richtext:InsertColorChange(255,255,255,255)
								richtext:AppendText(" - ")
								local plycolor = team.GetColor(ply:Team())
								richtext:InsertColorChange(plycolor.r, plycolor.g, plycolor.b, plycolor.a)
								richtext:AppendText(ply:Nick())
								richtext:InsertColorChange(255,255,255,255)
								richtext:AppendText(": "..message.."\n")
							end
						end)

						local UnBanPlayerB = vgui.Create( "DButton", DFrame3 )
						UnBanPlayerB:SetPos( 10, 320 )
						UnBanPlayerB:SetSize( DFrame3:GetWide() - 20,20 )
						UnBanPlayerB:SetText( "Abort ban for "..target:Nick() )
						UnBanPlayerB.OnCursorEntered = function(self)
							self.hover = true
						end
						UnBanPlayerB.OnCursorExited = function(self)
							self.hover = false
						end
						UnBanPlayerB.Paint = function( self, w, h )
							draw.RoundedBox(0, 0, 0, w, h, (self.hover and Color(0,160,255,250)) or Color(255,255,255,255)) -- Paints on hover
							UnBanPlayerB:SetTextColor(self.hover and Color(255,255,255,250) or Color(0,0,0,255))
						end
						UnBanPlayerB.DoClick = function()
							DFrame3:Close()
							net.Start("LMMPIUnbanPlayer")
								net.WriteEntity(target)
								net.WriteString(reason)
							net.SendToServer()
						end
			end

	end

	KickPlayer = vgui.Create( "DImageButton", DFrame )
	KickPlayer:SetPos( 60, 345 )
	KickPlayer:SetImage( "icon16/door_out.png" )
	KickPlayer:SizeToContents()
	KickPlayer.DoClick = function()
		DFrame:Close()
		net.Start("LMMPIEndTheInterror")
			net.WriteEntity(target)
		net.SendToServer()
		net.Start("LMMPIKickPlayer")
			net.WriteEntity(target)
			net.WriteString(reason)
		net.SendToServer()
	end

	FreezePlayer = vgui.Create( "DImageButton", DFrame )
	FreezePlayer:SetPos( 85, 345 )
	FreezePlayer:SetImage( "icon16/control_pause_blue.png" )
	FreezePlayer:SizeToContents()
	FreezePlayer.DoClick = function()
		DFrame:Close()
		net.Start("LMMPIEndTheInterror")
			net.WriteEntity(target)
		net.SendToServer()
		LocalPlayer():ConCommand(LMMPIConfig.FreezeCommand.." "..target:Nick())
	end

	Up = vgui.Create( "DImageButton", DFrame )
	Up:SetPos( 110, 345 )
	Up:SetImage( "icon16/arrow_up.png" )
	Up:SizeToContents()
	Up.DoClick = function()
		richtext:GotoTextStart()
	end

	Down = vgui.Create( "DImageButton", DFrame )
	Down:SetPos( 135, 345 )
	Down:SetImage( "icon16/arrow_down.png" )
	Down:SizeToContents()
	Down.DoClick = function()
			richtext:GotoTextEnd()
	end

	chat.AddText(Color(255,0,0), "WARNING: There is no second option to abort ban/kick so be careful!")
	chat.AddText(Color(255,0,0), "Here is the icon key...")
	chat.AddText(Color(255,255,255), "Blue I: Opens MOTD on both people")
	chat.AddText(Color(255,255,255), "Bomb: Opens ban menu")
	chat.AddText(Color(255,255,255), "Door with out arrow: Kicks player")
	chat.AddText(Color(255,255,255), "Pause button: Closes menu and freezes player")
	chat.AddText(Color(255,255,255), "Up arrow: Moves convo to the top")
	chat.AddText(Color(255,255,255), "Down arrow: Moves convo to the bottom")
end)

net.Receive("LMMPIInterrorBegin",function()
	local reason = net.ReadString()
	local target = net.ReadEntity()
	local calling = net.ReadEntity()

	local DFrame = vgui.Create( "DFrame" )
	DFrame:SetSize( 500, 370 )
	DFrame:Center()
	DFrame:SetDraggable( true )
	DFrame:MakePopup()
	DFrame:SetTitle( "" )
	DFrame:ShowCloseButton( false )
	DFrame.Paint = function( self, w, h )
		draw.RoundedBox(2, 0, 0, DFrame:GetWide(), DFrame:GetTall(), Color(35, 35, 35, 250))
		draw.RoundedBox(2, 0, 0, DFrame:GetWide(), 30, Color(40, 40, 40, 255))
		draw.SimpleText( "Interrogation by "..calling:Nick(), "LMMPITitleFont", DFrame:GetWide() / 2, 15, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local frameclose = vgui.Create("DButton", DFrame)
	frameclose:SetSize(20, 20)
	frameclose:SetPos(DFrame:GetWide() - frameclose:GetWide() - 3, 3)
	frameclose:SetText("X");
	frameclose:SetTextColor(Color(0,0,0,255))
	frameclose:SetFont("LMMPIfontclose")
	frameclose.hover = false
	frameclose.DoClick = function()
		chat.AddText(Color(255,0,0), "You can not exit the Interrogation yet!")
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

	net.Receive("LMMPIForceClose", function()
		DFrame:Close()
		chat.AddText(Color(255,0,0), "The Interrogation has closed!")
	end)

	local reasonL = vgui.Create("DLabel", DFrame)
	reasonL:SetPos(10, 35)
	reasonL:SetSize(DFrame:GetWide() - 20, 20)
	reasonL:SetText("Reason: "..reason)
	reasonL:SetTextColor(Color(255,0,0,255))
	reasonL:SetFont("LMMPILabelSmall")

	local richtext = vgui.Create( "RichText", DFrame )
	richtext:SetPos(10, 60)
	richtext:SetSize(DFrame:GetWide() - 20, 250)

	richtext:InsertColorChange( 192, 192, 192, 255 )
	richtext:AppendText( "You are being interrogated by "..calling:Nick().." for the reason of "..reason..". Make sure to prove your point and defend yourself!\n\n" )

	net.Receive("LMMPIGetMessage", function(len, ply)
		local message = net.ReadString()
		local ply = net.ReadEntity()

		if IsValid(richtext) then
			richtext:InsertColorChange(192,192,192,255)
			richtext:AppendText( os.date("%I:%M:%S %p") )
			richtext:InsertColorChange(255,255,255,255)
			richtext:AppendText(" - ")
			local plycolor = team.GetColor(ply:Team())
			richtext:InsertColorChange(plycolor.r, plycolor.g, plycolor.b, plycolor.a)
			richtext:AppendText(ply:Nick())
			richtext:InsertColorChange(255,255,255,255)
			richtext:AppendText(": "..message.."\n")
		end
	end)

	net.Receive("LMMPIGetMessageCaller", function(len, ply)
		local message = net.ReadString()
		local ply = net.ReadEntity()

		if IsValid(richtext) then
			richtext:InsertColorChange(192,192,192,255)
			richtext:AppendText( os.date("%I:%M:%S %p") )
			richtext:InsertColorChange(255,255,255,255)
			richtext:AppendText(" - ")
			local plycolor = team.GetColor(ply:Team())
			richtext:InsertColorChange(plycolor.r, plycolor.g, plycolor.b, plycolor.a)
			richtext:AppendText(ply:Nick())
			richtext:InsertColorChange(255,255,255,255)
			richtext:AppendText(": "..message.."\n")
		end
	end)

	local EnterText = vgui.Create("DTextEntry", DFrame)
	EnterText:SetPos(10, 320)
	EnterText:SetSize(DFrame:GetWide() - 20,20)
	EnterText:SetText("Enter a message...")
	EnterText.OnEnter = function( self )
		net.Start("LMMPIEnterText")
			net.WriteEntity(calling)
			net.WriteString(self:GetValue())
		net.SendToServer()
		self:SetText("Enter a message...")
	end

	ForceMOTD = vgui.Create( "DImageButton", DFrame )
	ForceMOTD:SetPos( 10, 345 )
	ForceMOTD:SetImage( "icon16/information.png" )
	ForceMOTD:SizeToContents()
	ForceMOTD.DoClick = function()
		LocalPlayer():ConCommand(LMMPIConfig.MOTDCommand)
	end

	Up = vgui.Create( "DImageButton", DFrame )
	Up:SetPos( 35, 345 )
	Up:SetImage( "icon16/arrow_up.png" )
	Up:SizeToContents()
	Up.DoClick = function()
		richtext:GotoTextStart()
	end

	Down = vgui.Create( "DImageButton", DFrame )
	Down:SetPos( 60, 345 )
	Down:SetImage( "icon16/arrow_down.png" )
	Down:SizeToContents()
	Down.DoClick = function()
			richtext:GotoTextEnd()
	end

end)

net.Receive("LMMPINotifyN",function()
	local message = net.ReadString()
	chat.AddText(Color(0,0,0), "[Player Interrogation]", Color(255,255,255), ": "..message)
end)
