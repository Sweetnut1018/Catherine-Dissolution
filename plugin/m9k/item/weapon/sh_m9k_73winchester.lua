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

local ITEM = catherine.item.New( "weapon_m9k_73winchester", "WEAPON" )
ITEM.name = "^Item_Name_73Winchester"
ITEM.desc = "^Item_Desc_73Winchester"
ITEM.cost = 5000
ITEM.model = "models/weapons/w_winchester_1873.mdl"
ITEM.weaponClass = "m9k_winchester73"
ITEM.weaponType = "primary"

catherine.item.Register( ITEM )