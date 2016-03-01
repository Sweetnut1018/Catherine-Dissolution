--[[
< CATHERINE > - A free role-playing framework for Garry's Mod.
Development and design by L7D.

Catherine is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Catherine.  If not, see <http://www.gnu.org/licenses/>.
]]--

local PLUGIN = PLUGIN
local PANEL = { }

function PANEL:Init( )
	catherine.vgui.note = self

	self.ent = nil
	self.entCheck = CurTime( ) + 1
	self.player = catherine.pl
	self.w, self.h = ScrW( ) * 0.3, ScrH( ) * 0.5
	self.x, self.y = ScrW( ) / 2 - self.w / 2, ScrH( ) / 2 - self.h / 2
	self.title = LANG( "Item_Name_Note" )
	self.textLen = 0
	
	self:SetSize( self.w, self.h )
	self:SetPos( ScrW( ), self.y )
	self:SetTitle( "" )
	self:MakePopup( )
	self:ShowCloseButton( false )
	self:MoveTo( ScrW( ) / 2 - self.w / 2, self.y, 0.2, 0 )
	
	self.textEnt = vgui.Create( "DTextEntry", self )
	self.textEnt:SetPos( 10, 35 )
	self.textEnt:SetSize( self.w - 20, self.h - 80 )
	self.textEnt:SetFont( "catherine_normal15" )
	self.textEnt:SetText( "" )
	self.textEnt:SetMultiline( true )
	self.textEnt:SetAllowNonAsciiCharacters( true )
	self.textEnt.Paint = function( pnl, w, h )
		catherine.theme.Draw( CAT_THEME_TEXTENT, w, h )
		pnl:DrawTextEntryText( Color( 50, 50, 50 ), Color( 45, 45, 45 ), Color( 50, 50, 50 ) )
	end
	self.textEnt.OnTextChanged = function( pnl )
		self.textLen = pnl:GetText( ):utf8len( )
	end
	
	self.writeText = vgui.Create( "catherine.vgui.button", self )
	self.writeText:SetPos( 10, self.h - 35 )
	self.writeText:SetSize( self.w - 20, 25 )
	self.writeText.Cant = false
	self.writeText:SetStr( LANG( "Note_WriteStr" ) )
	self.writeText:SetStrFont( "catherine_normal20" )
	self.writeText:SetStrColor( Color( 50, 50, 50, 255 ) )
	self.writeText:SetGradientColor( Color( 255, 255, 255, 150 ) )
	self.writeText.Click = function( pnl )
		if ( !IsValid( self.ent ) ) then return end
		local text = self.textEnt:GetText( )
		
		if ( !pnl.Cant ) then
			if ( text != "" ) then
				if ( self.textLen < PLUGIN.textmaxLen ) then
					netstream.Start( "catherine.dissolution.plugin.note.Write", {
						self.ent,
						text
					} )
					
					self:Close( )
				else
					catherine.notify.Add( LANG( "Note_Notify_Error02" ), 5 )
				end
			else
				catherine.notify.Add( LANG( "Note_Notify_Error01" ), 5 )
			end
		else
			catherine.notify.Add( LANG( "Note_Notify_Error03" ), 5 )
		end
	end
	self.writeText.PaintBackground = function( pnl, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 235, 235, 235, 255 ) )
	end
	
	self.close = vgui.Create( "catherine.vgui.button", self )
	self.close:SetPos( self.w - 30, 0 )
	self.close:SetSize( 30, 25 )
	self.close:SetStr( "X" )
	self.close:SetStrFont( "catherine_normal35" )
	self.close:SetStrColor( Color( 255, 255, 255, 255 ) )
	self.close:SetGradientColor( Color( 255, 255, 255, 255 ) )
	self.close.Click = function( )
		if ( self.closing ) then return end
		
		self:Close( )
	end
end

function PANEL:InitializeNote( ent, text )
	if ( !IsValid( ent ) ) then
		self:Close( )
		return
	end
	
	self.ent = ent

	self.textEnt:RequestFocus( )

	if ( !ent:CanEdit( self.player ) ) then
		self.writeText.Cant = true
		self.writeText:AlphaTo( 50, 0.3, 0 )
	end
	
	if ( text ) then
		self.textEnt:SetText( text )
		self.textLen = text:utf8len( )
		self.textEnt:SetCaretPos( self.textLen )
		
		self.writeText:SetStr( LANG( "Note_ChangeStr" ) )
	else
		self.writeText:SetStr( LANG( "Note_WriteStr" ) )
	end
end

function PANEL:Paint( w, h )
	catherine.theme.Draw( CAT_THEME_MENU_BACKGROUND, w, h )
	
	draw.SimpleText( self.title, "catherine_normal20", 0, 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT )
end

function PANEL:Think( )
	if ( ( self.entCheck or 0 ) <= CurTime( ) ) then
		if ( !IsValid( self.ent ) and !self.closing ) then
			self:Close( )
			return
		end
		
		self.entCheck = CurTime( ) + 0.5
	end
end

function PANEL:Close( )
	self.closing = true
	
	self:MoveTo( ScrW( ), self.y, 0.2, 0, nil, function( )
		self:Remove( )
		self = nil
	end )
end

vgui.Register( "catherine.vgui.note", PANEL, "DFrame" )