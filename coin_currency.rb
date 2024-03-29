$imported = {} if $imported == nil
$imported["H87_Golds"] = 1.3
#===============================================================================
# COIN CURRENCY
#===============================================================================
# Author: Holy87
# Version: 1.3
# User difficulty: ★
# License: CC-BY. Everyone can distribute this script and use in their free
# and commercial games. Credit required.
#-------------------------------------------------------------------------------
# In many role-playing games like World of Warcraft and Dragon Age, the owned gold
# is showed in bronze coins, silver coins and gold coins.
# This script will convert the gold from a simply number to a coin currency with
# the relative icon.
# * Compatible with YEA Save Engine.
#-------------------------------------------------------------------------------
# Instructions:
# Copy the script under Materials and before the Main.
# In a message, you can also convert a number in coins writing the \M[value]
# escape key.
#-------------------------------------------------------------------------------
# Compatibility:
# Window_Base
#   draw_currency_value       -> override
#   process_escape_character  -> alias
# Window_ShopBuy
#   draw_item                 -> override
#-------------------------------------------------------------------------------
module H87_GoldSetup

  #===============================================================================
  # ** CONFIGURATION **
  #===============================================================================
  #Insert the proper icons'ID:
  ICONBRONZE = 140 #bronze coin icon
  ICONSILVER = 141 #silver coin icon
  ICONGOLD = 361 #gold coin icon

  #If you want, you can set different values for every value:
  VALUEBRONZE = 1 #1 bronze coin, don't change
  VALUESILVER = 100 #100 bronze coins
  VALUEGOLD = 100 #100 silver coins

  #Set this constant to true if you want that the digits will overlay a part of
  #the icon, saving space.
  IconOverlay = true
end

module Vocab
  #Text showed at the end of battle.
  ObtainGold = "You have gained \\M[%s]!"
end

#===============================================================================
# ** END OF CONFIGURATION **
# Don't edit above if you don't know what you're doing.
#===============================================================================

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  Most of the necessary methods are in this class
#==============================================================================
class Window_Base < Window
  include H87_GoldSetup #module inclusion
  #--------------------------------------------------------------------------
  # * draw_currency_value override
  #--------------------------------------------------------------------------
  def draw_currency_value(value, unit, x, y, width)
    @negative = false
    if value < 0
      @negative = true
      value *= -1
    end
    icon_width = IconOverlay ? 12 : 24
    bronzes = get_bronzes(value)
    silvers = get_silvers(value)
    golds = get_golds(value)
    w2 = width
    if bronzes > 0
      draw_icon(ICONBRONZE, x + w2 - 24, y)
      w2 -= icon_width
      w1 = text_size(bronzes).width
      draw_text(x, y, w2, line_height, bronzes, 2)
      w2 -= w1
    end
    if silvers > 0
      draw_icon(ICONSILVER, x + w2 - 24, y)
      w2 -= icon_width
      w1 = text_size(silvers).width
      draw_text(x, y, w2, line_height, silvers, 2)
      w2 -= w1
    end
    if golds > 0
      draw_icon(ICONGOLD, x + w2 - 24, y)
      w2 -= icon_width
      w1 = text_size(golds).width
      draw_text(x, y, w2, line_height, golds, 2)
      w2 -= w1
    end
    if @negative #draws a minus with negative numbers
      draw_text(x, y, w2, line_height, "-", 2)
    end
  end

  #--------------------------------------------------------------------------
  # * Returns the bronze coins from value
  #--------------------------------------------------------------------------
  def get_bronzes(value)
    value % VALUESILVER
  end

  #--------------------------------------------------------------------------
  # * Returns the silver coins from value
  #--------------------------------------------------------------------------
  def get_silvers(value)
    value / VALUESILVER % VALUEGOLD
  end

  # Returns the gold coins from value
  # @param [Integer] value
  # @return [Fixnum]
  def get_golds(value)
    value / VALUESILVER / VALUEGOLD
  end

  # * alias process_escape_character
  alias goldp_e_c process_escape_character unless $@

  # @param [String] code
  # @param [String] text
  # @param [Integer] pos
  def process_escape_character(code, text, pos)
    return process_draw_coins(obtain_escape_param(text), pos) if code.upcase == 'M'
    goldp_e_c(code, text, pos)
  end

  # draw the coins in the window
  # @param [Integer] value
  # @param [Integer] pos
  def process_draw_coins(value, pos)
    width = calc_currency_width(value)
    draw_currency_value(value, "", pos[:x], pos[:y], width)
    pos[:x] += width
  end

  # returns the text width
  # @param [Integer] value
  # @return [Integer]
  def calc_currency_width(value)
    icon_width = IconOverlay ? 12 : 24
    bronzes = get_bronzes(value)
    silvers = get_silvers(value)
    golds = get_golds(value)
    text = ""
    width = 0
    if bronzes > 0
      text += bronzes.to_s
      width += icon_width
    end
    if silvers > 0
      text += silvers.to_s
      width += icon_width
    end
    if golds > 0
      text += golds.to_s
      width += icon_width
    end
    width + text_size(text).width
  end
end

#window_base

#==============================================================================
# ** Window_ShopBuy
#------------------------------------------------------------------------------
#  Edit to show coins
#==============================================================================
class Window_ShopBuy < Window_Selectable
  # draw item
  def draw_item(index)
    item = @data[index]
    rect = item_rect(index)
    draw_item_name(item, rect.x, rect.y, enable?(item))
    rect.width -= 4
    draw_currency_value(price(item), "", rect.x, rect.y, rect.width)
  end
end

#window_shopbuy

if $imported["YEA-SaveEngine"]
  #==============================================================================
  # ** Window_FileStatus
  #------------------------------------------------------------------------------
  #  Override for Yanfy engine compatibility
  #==============================================================================
  class Window_FileStatus < Window_Base
    # draw_save_gold
    # @param [Integer] dx
    # @param [Integer] dy
    # @param [Integer] dw
    def draw_save_gold(dx, dy, dw)
      return if @header[:party].nil?
      reset_font_settings
      change_color(system_color)
      draw_text(dx, dy, dw, line_height, YEA::SAVE::TOTAL_GOLD)
      change_color(normal_color)
      draw_currency_value(@header[:party].gold.group.to_i, "", dx, dy, dw)
    end
  end
end
