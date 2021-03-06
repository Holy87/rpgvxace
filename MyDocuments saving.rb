$imported = {} if $imported == nil
$imported["H87_Homesave"] = true
#===============================================================================
# MYDOCUMENTS SAVING
#===============================================================================
# Author: Holy87
# Version: 1.0
# User difficulty: ★
#-------------------------------------------------------------------------------
# This script changes the savegames path: not in the game root anymore, but
# in C:\Users\Username\MyDocuments\GameTitle\Saves.
# Not only this script will make your game more professional, but will allow
# you to install the game in different paths having the saves in the same
# folder. You could also share the project in a CD disk and can play to your
# frients without installing anithyng on the PC.
#-------------------------------------------------------------------------------
# Instructions:
# Install this script under Materials and above the Main. 
# IMPORTANT: REQUIRES HOLY87 UNIVERSAL MODULE.
#-------------------------------------------------------------------------------
# Compatibility:
# DataManager: alias methos
#   settings_path
#   save_file_exists?
#   make_filename
#-------------------------------------------------------------------------------

#==============================================================================
# ** Homesave
#------------------------------------------------------------------------------
#  This is the core of the script.
#==============================================================================
module Homesave
  SAVES_FOLDER = "Saves" #change this string for saves folder
  #--------------------------------------------------------------------------
  # * Returns the game folder name
  #--------------------------------------------------------------------------
  def self.folder_name; load_data("Data/System.rvdata2").game_title; end
  #--------------------------------------------------------------------------
  # * Returns the MyDocuments path
  #--------------------------------------------------------------------------
  def self.mydocuments; Win.getFolderPath(:docs); end
  #--------------------------------------------------------------------------
  # * Returns the Saves folder name
  #--------------------------------------------------------------------------
  def self.saves; SAVES_FOLDER; end
  #--------------------------------------------------------------------------
  # * Returns the complete folder path
  #--------------------------------------------------------------------------
  def self.folder_path
    fpath = mydocuments
    Dir.mkdir(fpath) if !File.directory?(fpath)
    fpath << "/"+folder_name
    Dir.mkdir(fpath) if !File.directory?(fpath)
    fpath << "/"+saves
    Dir.mkdir(fpath) if !File.directory?(fpath)
    return fpath
  end
end #homesave

#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
#  Path editing
#==============================================================================
module DataManager
  class << self
    alias sett_filename settings_path       #alias method settings_path (supp)
    alias exst_filename save_file_exists?   #alias method save_file_exists?
    alias save_filename make_filename       #alias method make_filename
  end
  #--------------------------------------------------------------------------
  # * Changes the game_settings path (universal module)
  #--------------------------------------------------------------------------
  def self.settings_path
    Homesave.folder_path+"/"+sett_filename
  end
  #--------------------------------------------------------------------------
  # * Changes the path where saves are checked
  #--------------------------------------------------------------------------
  def self.save_file_exists?
    temp = Dir.pwd
    Dir.chdir(Homesave.folder_path)
    exist = exst_filename
    Dir.chdir(temp)
    return exist
  end
  #--------------------------------------------------------------------------
  # * changes the saves path
  #--------------------------------------------------------------------------
  def self.make_filename(index)
    Homesave.folder_path+"/"+save_filename(index)
  end
end #DataManager
