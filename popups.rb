$imported = {} if $imported == nil
$imported["H87_Popup"] = true
#===============================================================================
# Holy87 Generic Popup System
# Version 1.1
#===============================================================================
# This script allow to show dinamically multiple popups for acquiring or losing
# gold and items and when an actor leveled up.
# It is also possible creating customized popups for the most various
# situations. Just insert a script call like this:
# Popup.show("Message")
# Or
# Popup.show("Message",x) where x is the Icon ID
# or, also
# Popup.show("Message",x,[R,G,B,S]) where RGB is the color, S the saturation.
#-------------------------------------------------------------------------------
# INSTALLATION
# Install the script under Materials and before the Main, Import an image for
# the popup bar. It's not important the size, the script will automatically adapt.
# INFO compatibility:
# *Class Scene_Map
#  Alias: update, start, terminate
# *Class Game_Party
#  Alias: gain_gold, gain_item
# *Class Game_Actor
#  Overrides: show_level_up
#===============================================================================
module H87_Popup
#-------------------------------------------------------------------------------
# GENERAL CONFIGURATION
# Configure the script for generic options.
#-------------------------------------------------------------------------------
  #Popup appear speed. Small numbers make the popup faster.
  Speed = 3
  #-----------------------------------------------------------------------------
  #Time in seconds where the popup starts to fade.
  PTime = 4
  #-----------------------------------------------------------------------------
  #Fading speed when the popup must disappear
  Fade = 4
  #-----------------------------------------------------------------------------
  #Y coordinate where the popup will appear.
  #If it is under the screen, consecutive popups will create an ascending stack,
  #otherwise a discending stack.
  AppearingHeight = 355
  #-----------------------------------------------------------------------------
  #Picture of the popup background
  PopupBitmap = "Popup"
  #-----------------------------------------------------------------------------
  #Distance in pixel from the left border of the screen when the popup appears
  XDistance = 5
  #Distance in pixel between 2 popups when they are showed in stack
  YDistance = 3
  #-----------------------------------------------------------------------------
  #Set the switch that will be used to activate and disactivate auto popups,
  #in the case that you want change gold and items without the player notices.
  Switch = 2
#-------------------------------------------------------------------------------
# POPUP CONFIGURATION
# Specific configuration for every popup type (color and sound)
#-------------------------------------------------------------------------------
  # *Items
  #Select the sound that will be played when an item is obtained
  ItemSound = "Item1"
  #Set the background tone of the popup (Red, Green, Yellow and Saturation)
  ItemGainedColor = [-50,0,70,0]
  #-----------------------------------------------------------------------------
  # *Gaining and losing gold
  #Icon showed when gaining and losing gold
  GoldIcon = 361
  #Sound when the player gain gold
  GoldSound = "Shop"
  #Show popup when the player acquires gold?
  ShowGainGold = true
  #Show popup when the player loses gold?
  ShowLossGold = true
  #Select the popup tone when the player acquires gold
  GoldTone = [-50,70,0,10]
  #Select the popup tone when the player loses gold
  LoseTone = [70,0,-50,50]
  #-----------------------------------------------------------------------------
  # *Level Up configuration (Only if level up message is showed)
  # Do you want to show a popup when actors level up from the map instead of the
  # classic message?
  ShowLVUP = true
  # Do you want to show the acquired new skills?
  ShowSkills = true
  #Upper level icon
  LVUPIcon = 125
  #Popup tone
  LVUPTone      = [ 50, 50,100,0]
  #Tone for new skills
  SKillTone     = [ 50, 50,50,0]
  #FX that will be played at level up
  LVUPSound = "Up1"
  #Earned skill text
  Learn = "acquired!"
  #-----------------------------------------------------------------------------
  # *Switches
  # Set the popup for switches (It works only in test mode)
  SwitchIcon = 80
  #Set the tone for swithces
  SwitchTone = [0,0,0,255]
#-------------------------------------------------------------------------------
# FONT
# Font configuration
#-------------------------------------------------------------------------------
  #Font name:
  FontName = Font.default_name #substitute with the font name string
  FontSize = Font.default_size #substitute with a value (i.e. 20)
  FontOutline = true #false if you don't want the font outline
  #-----------------------------------------------------------------------------
#===============================================================================
# END OF CONFIGURATION
# Don't edit under this line if you don't know how to script.
#===============================================================================
end
#===============================================================================
# Popup module
#===============================================================================
module Popup
  #-----------------------------------------------------------------------------
  # * show the popup
  #-----------------------------------------------------------------------------
  def self.show(text, icon=0, tone=nil)
    SceneManager.scene.show_generic_popup(text, icon, tone) if SceneManager.scene_is?(Scene_Map)
  end
  #-----------------------------------------------------------------------------
  # * play a sound
  #-----------------------------------------------------------------------------
  def self.play_sound(sound)
    RPG::SE.new(sound,80,100).play if SceneManager.scene_is?(Scene_Map)
  end
  #-----------------------------------------------------------------------------
  # * show gold in coins (if you have coin currency)
  #-----------------------------------------------------------------------------
  def self.gold_show(money,tone)
    show(money,-1,tone)
  end
end

#===============================================================================
# Scene_Map
#===============================================================================
class Scene_Map < Scene_Base
  include H87_Popup
  #-----------------------------------------------------------------------------
  # * Start
  #-----------------------------------------------------------------------------
  alias h87_pstart start
  def start
    h87_pstart
    if $popups.nil?
      $popups = []
      $oblo = Viewport.new(0,0,Graphics.width,Graphics.height)
    else
      $oblo.visible = true
      $oblo.z = 10
    end
    print $popups
  end
  #-----------------------------------------------------------------------------
  # * Update
  #-----------------------------------------------------------------------------
  alias h87_pupdate update
  def update
    h87_pupdate
    aggiorna_popups
  end
  #-----------------------------------------------------------------------------
  # * Aggiunge un nuovo popup
  #-----------------------------------------------------------------------------
  def show_generic_popup(testo, icona=0, tone=nil)
    immagine = Sprite.new($oblo)
    immagine.bitmap = Cache.picture(PopupBitmap)
    immagine.tone = Tone.new(tone[0],tone[1],tone[2],tone[3]) if tone != nil
    finestra = Window_Map_Popup.new(immagine.width,testo, icona)
    finestra.viewport = $oblo
    finestra.opacity = 0
    finestra.x = 0-finestra.width
    finestra.y = AppearingHeight
    immagine.x = riposizionax(finestra,immagine)
    immagine.y = riposizionay(finestra,immagine)
    popup = [finestra,immagine,0,0]
    sposta_popup_su #sposta sopra tutti i popup già presenti
    $popups.push(popup)
  end
  #-----------------------------------------------------------------------------
  # * Calcola la posizione dell'immagine
  #-----------------------------------------------------------------------------
  def riposizionax(finestra,immagine)
    larg=(finestra.width-immagine.width)/2
    return finestra.x+larg
  end
  #-----------------------------------------------------------------------------
  # * Calcola la posizione dell'immagine
  #-----------------------------------------------------------------------------
  def riposizionay(finestra,immagine)
    alt=(finestra.height-immagine.height)/2
    return finestra.y+alt
  end
  #-----------------------------------------------------------------------------
  # * Aggiornamento
  #-----------------------------------------------------------------------------
  def aggiorna_popups
    muovi_popup
    fade_popup
  end
  #-----------------------------------------------------------------------------
  # * Muove i popup
  #-----------------------------------------------------------------------------
  def muovi_popup
    for i in 0..$popups.size-1
      break if $popups[i] == nil
      barra = $popups[i]
      finestra = barra[0]
      next if finestra.disposed?
      immagine = barra[1]
      tempo    = barra[2]
      prossimay= barra[3]
      x = finestra.x
      y = finestra.y
      metax = XDistance
      if AppearingHeight > Graphics.height/2
        metay = AppearingHeight - YDistance - prossimay
      else
        metay = AppearingHeight + YDistance + prossimay
      end
      finestra.x += (metax-x)/Speed
      finestra.y += (metay-y)/Speed
      tempo += 1
      immagine.x = riposizionax(finestra,immagine)
      immagine.y = riposizionay(finestra,immagine)
      if tempo > PTime*Graphics.frame_rate
        finestra.contents_opacity -= Fade
        immagine.opacity -= Fade
      end
      $popups[i] = [finestra,immagine,tempo, prossimay] #riassemblamento
    end
  end
  #-----------------------------------------------------------------------------
  # * Assegna la prossima coordinata Y
  #-----------------------------------------------------------------------------
  def sposta_popup_su
    for i in 0..$popups.size-1
      next if $popups[i][1].disposed?
      $popups[i][3]+=$popups[i][1].height+YDistance
    end
  end
  #-----------------------------------------------------------------------------
  # * Terminate
  #-----------------------------------------------------------------------------
  alias h87_pterminate terminate
  def terminate
    h87_pterminate
    $oblo.visible = false
  end
  #-----------------------------------------------------------------------------
  # *Elimina i popup non più presenti
  #-----------------------------------------------------------------------------
  def fade_popup
    $popups.each do |popup|
      next if popup.nil?
      if popup[1].opacity == 0
        elimina_elemento(popup)
      end
    end
  end
end #scene_map

#===============================================================================
# Classe Window_Map_Popup
#===============================================================================
class Window_Map_Popup < Window_Base
  def initialize(larghezza,testo, icona=0)
    super(0,0,larghezza,48)
    @testo = testo
    @icona = icona
    refresh
  end
  #-----------------------------------------------------------------------------
  # * refresh della finestra
  #-----------------------------------------------------------------------------
  def refresh
    self.contents.clear
    if @icona < 0 and $imported["H87_Golds"]
      show_gold_popup
    else
      show_text_popup
    end
  end
  #-----------------------------------------------------------------------------
  # * mostra il testo del popup
  #-----------------------------------------------------------------------------
  def show_text_popup
    draw_icon(@icona,0,0)
    @icona == 0 ? d = 0 : d = 24
    self.contents.font.name = H87_Popup::FontName
    self.contents.font.size = H87_Popup::FontSize
    self.contents.font.outline = H87_Popup::FontOutline
    text = convert_escape_characters(@testo)
    text.gsub!(/\eC\[(\d+)\]/i,"")
    self.contents.draw_text(d,0,self.width-(self.padding*2)-d,line_height,text)
  end
  #-----------------------------------------------------------------------------
  # * mostra l'oro in monete
  #-----------------------------------------------------------------------------
  def show_gold_popup
    draw_currency_value(@testo.to_i, "", 0, 0, self.width-(self.padding*2))
  end
end #Scene_Map

#===============================================================================
# Classe Game_Party
#===============================================================================
class Game_Party < Game_Unit
  alias ottieni_oro gain_gold unless $@
  #-----------------------------------------------------------------------------
  # * Ottieni Oro
  #-----------------------------------------------------------------------------
  def gain_gold(amount)
    if $game_switches[H87_Popup::Switch] == false
      if amount> 0 and H87_Popup::ShowGainGold
        if $imported["H87_Golds"]
          Popup.gold_show(amount,H87_Popup::GoldTone)
        else
          Popup.show("+"+amount.to_s+Vocab.currency_unit,H87_Popup::GoldIcon,H87_Popup::GoldTone)
        end
        Popup.esegui(H87_Popup::GoldSound)
      end
      if amount < 0 and H87_Popup::ShowLossGold
        if $imported["H87_Golds"]
          Popup.gold_show(amount,H87_Popup::LoseTone)
        else
          Popup.show(amount.to_s+Vocab.currency_unit,H87_Popup::GoldIcon,H87_Popup::LoseTone)
        end
        Popup.esegui(H87_Popup::GoldSound)
      end
    end
    ottieni_oro(amount)
  end
  #-----------------------------------------------------------------------------
  # * Ottieni Oggetto
  #-----------------------------------------------------------------------------
  alias prendi_oggetto gain_item
  def gain_item(item, amount, include_equip = false)
    case item
    when RPG::Item
      oggetto = $data_items[item.id]
    when RPG::Armor
      oggetto = $data_armors[item.id]
    when RPG::Weapon
      oggetto = $data_weapons[item.id]
    end
    if amount > 0 and $game_switches[H87_Popup::Switch] == false and item != nil
      nome = oggetto.name
      icona = oggetto.icon_index
      testo = sprintf("%s x%d",nome,amount)
      Popup.show(testo,icona,H87_Popup::ItemGainedColor)
      Popup.play_sound(H87_Popup::ItemSound)
    end
    prendi_oggetto(item, amount, include_equip)
  end
end # Game_Party

#===============================================================================
# Classe Game_Actor
#===============================================================================
class Game_Actor < Game_Battler
  #-----------------------------------------------------------------------------
  # * Mostra Lv. Up
  #-----------------------------------------------------------------------------
  def display_level_up(new_skills)
    if SceneManager.scene_is?(Scene_Map) and H87_Popup::ShowLVUP
      testo = sprintf("%s %s%2d!",@name,Vocab::level,@level)
      Popup.show(testo,H87_Popup::LVUPIcon,H87_Popup::LVUPTone)
      Popup.esegui(H87_Popup::LVUPSound)
      if H87_Popup::ShowSkills
        for skill in new_skills
          testo = sprintf("%s %s",skill.name,H87_Popup::Learn)
          Popup.show(testo,skill.icon_index,H87_Popup::SKillTone)
        end
      end
    else
      $game_message.new_page
      $game_message.add(sprintf(Vocab::LevelUp, @name, Vocab::level, @level))
      new_skills.each do |skill|
        $game_message.add(sprintf(Vocab::ObtainSkill, skill.name))
      end
    end
  end
  
end # Game_Actor

#===============================================================================
# Classe Scene_Title
#===============================================================================
class Scene_Title < Scene_Base
  #-----------------------------------------------------------------------------
  # * eliminazione dei popup
  #-----------------------------------------------------------------------------
  alias h87_pop_start start unless $@
  def start
    unless $popups.nil?
      $popups.each do |i|
        elimina_elemento(i)
      end
      $oblo.dispose
      $popups = nil
      $oblo = nil
    end
    h87_pop_start
  end
end

#===============================================================================
# Classe Scene_Base
#===============================================================================
class Scene_Base
  #-----------------------------------------------------------------------------
  # *Dispone finestre e picture
  #-----------------------------------------------------------------------------
  def elimina_elemento(i)
    i[0].dispose unless i[0].disposed?
    i[1].dispose unless i[1].disposed?
    $popups.delete(i)
  end
end
