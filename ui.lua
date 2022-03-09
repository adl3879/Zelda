local class = require "lib.middleclass"
local Weapon = require "weapon"
local Magic = require "magic"
require "utils.settings"

local UI = class("UI")

-- clone table
function table.clone(t)
	local t2 = {}
	for key, value in pairs(t) do
		t2[key] = value
	end
	return t2
end

function UI:initialize()
	self.font = love.graphics.newFont(ui_data.font, ui_data.font_size)
	
	-- bar setup
	self.health_bar_rect = { x = 10, y = 10, w = ui_data.health_bar_width, h = ui_data.bar_height }
	self.energy_bar_rect = { x = 10, y = 34, w = ui_data.energy_bar_width, h = ui_data.bar_height }
end

function UI:show_bar(current, max_amount, bg_rect, color)
	love.graphics.setColor(ui_data.bg_color)
	love.graphics.rectangle("fill", bg_rect.x, bg_rect.y, bg_rect.w, bg_rect.h)
	
	-- drawing the bar
	local ratio = current / max_amount
	local current_width = bg_rect.w * ratio
	local current_rect = table.clone(bg_rect)
	current_rect.w = current_width
	
	love.graphics.setColor(color)
	love.graphics.rectangle("fill", current_rect.x, current_rect.y, current_rect.w, current_rect.h)
	-- border
	love.graphics.setColor(ui_data.border_color)
	love.graphics.rectangle("line", bg_rect.x, bg_rect.y, bg_rect.w, bg_rect.h, 3)
	
	-- reset color
	love.graphics.setColor(1, 1, 1)
end

function UI:show_exp(exp)
	local exp_str = tostring(math.floor(exp))
	local text_width, text_height = self.font:getWidth(exp_str), self.font:getHeight(exp_str)  
	local px = window_width - text_width - 20
	local py = window_height - text_height - 20
	
	-- draw bg
	love.graphics.setColor(ui_data.bg_color)
	love.graphics.rectangle("fill", px - 20 / 2, py - 20 / 2, text_width + 20, text_height + 20)
	-- border
	love.graphics.setColor(ui_data.border_color)
	love.graphics.rectangle("line", px - 20 / 2, py - 20 / 2, text_width + 20, text_height + 20, 3)
	
	love.graphics.setColor(1, 1, 1)
	love.graphics.setFont(self.font)
	love.graphics.print(exp_str, px, py)
	
	-- reset
	love.graphics.setColor(1, 1, 1)
end

function UI:selection_box(left, top, has_switched)
	love.graphics.setColor(ui_data.bg_color)
	love.graphics.rectangle("fill", left, top, ui_data.item_box_size, ui_data.item_box_size)
	
	if has_switched then
		love.graphics.setColor(ui_data.border_color_active)
	else
		love.graphics.setColor(ui_data.border_color)
	end
	love.graphics.rectangle("line", left, top, ui_data.item_box_size, ui_data.item_box_size, 3)
	
	-- reset color
	love.graphics.setColor(1, 1, 1)
	return { x = left, y = top, w = ui_data.item_box_size, h = ui_data.item_box_size }
end

-- weapon overlay
function UI:weapon_overlay(weapon, has_switched)
	local sprite = Weapon.SPRITES[weapon]["full"]
	local rect = self:selection_box(10, 610, has_switched)
	
	-- draw weapon on overlay
	love.graphics.draw(sprite, love.graphics.center(sprite, rect))
end

function UI:magic_overlay(magic, has_switched)
	local sprite = Magic.SPRITES[magic]
	local rect = self:selection_box(80, 615, has_switched) -- magic
	love.graphics.draw(sprite, love.graphics.center(sprite, rect))
end

function UI:render()
	local player = GameObjectInstance:get_player()
	-- bar
	self:show_bar(player.health, player.stats.health, self.health_bar_rect, { 1, 0, 0 })
	self:show_bar(player.energy, player.stats.energy, self.energy_bar_rect, { 0, 0, 1 })
	-- experience
	self:show_exp(player.exp)
	-- selection box
	self:weapon_overlay(player.weapons[player.current_weapon_idx], player.can_switch_weapon)
	self:magic_overlay(player.magic_list[player.magic_index], player.can_switch_magic)
end

return UI
