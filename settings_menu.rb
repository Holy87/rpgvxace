=begin
 ==============================================================================
  ■ Holy87 GAME OPTIONS
      version 1.1
      User difficulty: ★★
      License: CC-BY. Everyone can distribute this script and use in their free
      and commercial games. Credit required.
 ==============================================================================
    This script add a settings menu to configure maker's and other script's
    custom options (if they can support). Give to the player the options due
    to him!
 ==============================================================================
  ■ Compatibility
    Scene_Title -> alias create_command_window
    Scene_Menu -> alias create_command_window
    DataManager -> alias load_normal_database
 ==============================================================================
  ■ Installation and instructions
    Install this script under Materials and above the Main
    REQUIRES THE UNVIERSAL SUPPORT MODULE OF HOLY87.
    
  ■ Instruction for making game options
  
      You can easly add options adding them at the ELEMENTS array (below).
      It's possible to add options that change switches, variables, bars
      and other elements. Let's see how.
      
    ● To add separators
      {:type => :separator, :text => "This is a separator"}
      The separator is used to make more organized the settings menu separating
      many categories. It's important to set type as :separator, while the :text
      attribute shows the section title.
      
    ● To add switches
      {:type => :switch, :text => "Option name", :sw => 10, :on => "ON",
       :off => "OGFF", :help => "Activates the option"}
      With this command you can setup a switch option. The :sw parameter indicates
      the game switch ID to set true or false. The parameters :on and :off are the
      text showed in the options.
      You can also add the value :default => true if you want that the switch will
      be active as new game starts.
      
    ● To add Variables
      {:type => :variable, :text => "Option name", :var => 2, :max => 5,
       :help => "Change the option value"}
      This command set up an options with a game variable. With :var we can set
      the variable ID and :max the maximum value. In this case, we set up that
      option of the variable 2 can have the values 0, 1, 2, 3, 4 and 5.
      You can also customize value names, for example
      
      {:type => :variable, :text => "Difficulty", :var => 5,
       :help => "Set up the game difficulty.",
       :values => ["Easy", "Normal", "Hard", "Extreme"] }
      Are there so many values to show in a single line? No problem!
      Add the parameter :open_popup => true to show the option selection in a
      popup window with unlimited values.
      In this case, you can omit the :max parameter because the values are already
      defined.
      
    ● To add bars
      Another way to control variables is using bars. This will show a bar
      that fills up or empties as the user preferences. The configuration is similiar
      to the variables, but you mai define also the bar color. Example:
      {:type => :bar, :text => "Volume", :var => 5, :max => 100, :color => 5,
       :help => "Set up the game volume."}
      The color refers to the color number in the windowskin (for example, 0 is
      the text color).
      The bars have also the benefit of being coupled with a switch, if the user
      press Enter the option can be disabled (for example, to make audio mute).
      Just add the :sw attribute like a switch option! 
      
  ■ Advanced options for geeks
    
      SET UP GLOBAL OPTIONS (THAT NON DEPEND FROM THE SAVEGAME)
      If you set a switch ID or variable not like an integer number, but like
      a string or a symbol, the option is seen like global and will be saved
      in $game_settings.
      
      ENABLING OR DISABLING SOME OPTIONS
      You can enable or disable the options in 2 ways:
      ● $game_system.option_enable(tag, true/false) enables or disables the
        game option, using this code in a call script or other scripts.
        The <tag> parameter is the option tag defined in the option configuration
        (:tag => :option_name)
      ● using :condition => "condition" in the option configuration.
        For example, :condition => "$game_switches[55] == true" will allow the option
        only if the switch 55 is true
      
      ADVANCED ENTRIES FOR CUSTOM RUBY CODE EXECUTION
      Setting the type as :advanced, it will be executed a code when the player press
      enter on him. Example:
      {:type => :advanced, method => :change_scene}
      Then you may define the change_scene method in the Option class:

      class Option
        def change_scene
          SceneManager.call(Mia_Scena)
        end
      end
      
      Also, if you want to customize the walue showed in the options, you may alias
      the method draw_advanced in Window_GameOptions.
      
      If you set the value :method => :method_name in a bar, switch or variable, it
      will be executed the method method_name before the value is setted. You can set
      :var or :sw to 0 if you don't want to use definitely a variable or a switch.
      The method in this case must receive a INNER PARAMETER that refers to the setted
      value.

      If you set the value :val_mt => :method_name, the value that will be showed in
      the options will be taken from the method method_name, defined in the Option class.
      
  ■ Instruction for other scripters
  
      It is useful to scripters to add game options to proper scripts directly in this
      settings menu, instead of creating apart.
      For the scripters, the options ae divided by 8 categories:
      - Generic, same defined by the user
      - Appearance, like themes and wallpapers
      - Audio, for music and sounds
      - Game, for game options like battle speed and difficulty level
      - Graphic, like screen resolution and special effects
      - Commands, for game controls
      - System, for techincal configurations
      - Internet, for the online functionalities
      The categories will have a dedicated separator automatically inserted (all but the
      generic category).
      To add an option in those categories, for every option you may pass the hash (defined
      like the previous options) in the respective methods:
      if $imported["H87_Options"]
      H87Options.push_system_option(hash)
      H87Options.push_generic_option(hash)
      H87Options.push_game_option(hash)
      H87Options.push_graphic_option(hash)
      H87Options.push_sound_option(hash)
      H87Options.push_appearance_option(hash)
      H87Options.push_keys_option(hash)
      H87Options.push_internet_option(hash)
      
    ● Custom popup windows
      You can create custom popup windows with an option creating a subclass of
      Window_OptionPopup (see below) or Generic_PopupWindow, and setting this
      attribute to the option: :popup => ClassName
 ==============================================================================
=end
$imported = {} if $imported == nil
$imported["H87_Options"] = true
#==============================================================================
# ** CONFIGURATION
#------------------------------------------------------------------------------
#  Configure texts and options
#==============================================================================
module H87Options
  #--------------------------------------------------------------------------
  # * Vocab
  #--------------------------------------------------------------------------
  #Settings command
  OPTION_COMMAND = "Settings"
  #Disabled bar value:
  OFF_BAR = "OFF"  
  #Options ordered for category:
  SYSTEM_OPTIONS =      "System"
  GAME_OPTIONS =        "Game"
  SOUND_OPTIONS =       "Audio"
  APPEARANCE_OPTIONS =  "appearance"
  GRAPHIC_OPTIONS =     "Graphic"
  INTERNET_OPTIONS =    "Internet"
  KEYS_OPTIONS =        "Commands"
  USER_OPTIONS =        "General"
  #--------------------------------------------------------------------------
  # * Sound used when switch is toggled
  #--------------------------------------------------------------------------
  TOGGLE_SOUND = "Switch2"
  #--------------------------------------------------------------------------
  # * Do you want to show the settings menu in the title? There will be
  #   showed only the GLOBAL options (stored in Game_Settings)
  #--------------------------------------------------------------------------
  SHOW_ON_TITLE = false
  #--------------------------------------------------------------------------
  # * Show settings menu in main menu?
  #--------------------------------------------------------------------------
  SHOW_ON_MENU = true
  #--------------------------------------------------------------------------
  # * Set here the options. See the examples to understand how create the
  #   options
  #--------------------------------------------------------------------------
  ELEMENTS = [
  #normal switch
    { :type => :switch, #switch type
      :text => "Switcher", #option name
      :help => "This is a switch try",#showed in help
      :sw   => 3, #switch ID
      :on   => "ON",  #ON text
      :off  => "OFF", #OFF text
      :default => true, #default value (optional)
    },
  #separator
    { :type => :separator,  #separator type
      :text => "Separator",#showed text
    },
  #variable
    { :type => :variable,   #variable type
      :text => "Alarm",   #showed text
      :help => "Set the alarm value", #description
      :var  => 10,          #variable ID
      :max  => 11,          #max value
      :default => 6,        #default value
    },
  #another variable
    { :type => :variable,   #variable type
      :text => "Difficolty",#showed text
      :help => "Set the game difficulty", #description
      :var  => 11,          #variable
      :values => ["Easy","Normal","Hard"],#values 0, 1 and 2
    },
  #another variable, there are so many values, so it will show a popup
    { :type => :variable,   #variable type
      :text => "Month",#showed text
      :help => "Set the month", #description
      :var  => 12,          #variable
      :open_popup => true,  #use a popup instead of the line
      :values => ["January", "February", "March", "April", "May",
      "June", "July", "August", "September", "October", "November",
      "December"],# months of the year
    },
  #Variable showed as a bar
    { :type   => :bar, #bar type
      :text   => "Filler", #showed text
      :sw     => 5, #switch ON/OFF
      :var    => 13,#variable ID
      :color  => 10, #bar color (10 is red in the default windowskin)
      :max    => 50, #max value
    },
  #Another bar
    { :type   => :bar, #bar type
      :text   => "Prowess", #showed text
      :var    => 14,#variable ID
      :color  => 4, #bar color (4 is blue)
      :max    => 100, #max value
      :default => 44,
      :condition => "$game_switches[5] == false", #this option is avaiable only
      # if the switch 5 is false (so if you deactivate the previous bar)
    },
  #Advanced option
    { :type => :advanced, #special option
      :method => :call_debug, #activation method, see below
      :text => "Go to debug", #showed text
      :condition => "$TEST", #Active only if it's a game test
      :help => "Shows the debug window if it is a play test.",
    },       
  ] #DO NOT DELETE THIS PARENTHESIS!
  
  #--------------------------------------------------------------------------
  # * Custom menu title configuration
  # => ONLY IF YOU USE MY CUSTOM MENU TITLE!
  #--------------------------------------------------------------------------
  TITLE_ICON = "Icon"  #command icon
  TITLE_BALOON = "Baloon" # baloon picture
end

class Option
  #there will be defined all the custom methods
  
  #for the previous example
  def call_debug
    SceneManager.call(Scene_Debug)
  end
end

#==============================================================================
# ** END OF CONFIGURATION
#------------------------------------------------------------------------------
#                 - WARNING: DO NOT EDIT BELOW! -
#==============================================================================






#==============================================================================
# ** Modulo H87Options
#------------------------------------------------------------------------------
#  Modulo di gestione delle opzioni
#==============================================================================
module H87Options
  #--------------------------------------------------------------------------
  # * Restituisce le opzioni di gioco
  #--------------------------------------------------------------------------
  def self.game_options
    return @game.nil? ? [] : @game
  end
  #--------------------------------------------------------------------------
  # * Restituisce le opzioni definite dall'utente
  #--------------------------------------------------------------------------
  def self.user_options
    return ELEMENTS + generic_options
  end
  #--------------------------------------------------------------------------
  # * Restituisce le opzioni generali
  #--------------------------------------------------------------------------
  def self.generic_options
    return @generic.nil? ? [] : @generic
  end
  #--------------------------------------------------------------------------
  # * Restituisce le opzioni grafiche
  #--------------------------------------------------------------------------
  def self.graphic_options
    return @graphic.nil? ? [] : @graphic
  end
  #--------------------------------------------------------------------------
  # * Restituisce le opzioni di sistema
  #--------------------------------------------------------------------------
  def self.system_options
    return @system.nil? ? [] : @system
  end
  #--------------------------------------------------------------------------
  # * Restituisce le opzioni audio
  #--------------------------------------------------------------------------
  def self.sound_options
    return @sound.nil? ? [] : @sound
  end
  #--------------------------------------------------------------------------
  # * Restituisce le opzioni dei comandi
  #--------------------------------------------------------------------------
  def self.keys_options
    return @keys.nil? ? [] : @keys
  end
  #--------------------------------------------------------------------------
  # * Restituisce le opzioni internet
  #--------------------------------------------------------------------------
  def self.internet_options
    return @internet.nil? ? [] : @internet
  end
  #--------------------------------------------------------------------------
  # * Restituisce le opzioni d'aspetto
  #--------------------------------------------------------------------------
  def self.appearance_options
    return @appearance.nil? ? [] : @appearance
  end
  #--------------------------------------------------------------------------
  # * Restituisce tutte le opzioni
  #--------------------------------------------------------------------------
  def self.all_options
    return user_options + game_options + appearance_options + graphic_options +
    sound_options + keys_options + system_options + internet_options
  end
  #--------------------------------------------------------------------------
  # * Aggiunge le opzioni di sistema
  #--------------------------------------------------------------------------
  def self.push_system_option(hash)
    if @system.nil?
      @system = [{:type=> :separator, :text=> SYSTEM_OPTIONS}]
    end
    @system.push(hash)
  end
  #--------------------------------------------------------------------------
  # * Aggiunge le opzioni dei comandi
  #--------------------------------------------------------------------------
  def self.push_keys_option(hash)
    if @keys.nil?
      @keys = [{:type=> :separator, :text=> KEYS_OPTIONS}]
    end
    @keys.push(hash)
  end
  #--------------------------------------------------------------------------
  # * Aggiunge le opzioni generiche
  #--------------------------------------------------------------------------
  def self.push_generic_option(hash)
    @generic = [] if @generic.nil?
    @generic.push(hash)
  end
  #--------------------------------------------------------------------------
  # * Aggiunge le opzioni d'aspetto
  #--------------------------------------------------------------------------
  def self.push_appearance_option(hash)
    if @appearance.nil?
      @appearance = [{ :type=> :separator,:text=> APPEARANCE_OPTIONS}]
    end
    @appearance.push(hash)
  end
  #--------------------------------------------------------------------------
  # * Aggiunge le opzioni di gioco
  #--------------------------------------------------------------------------
  def self.push_game_option(hash)
    if @game.nil?
      @game = [{:type=> :separator, :text=> GAME_OPTIONS}]
    end
    @game.push(hash)
  end
  #--------------------------------------------------------------------------
  # * Aggiunge le opzioni audio
  #--------------------------------------------------------------------------
  def self.push_sound_option(hash)
    if @sound.nil?
      @sound = [{ :type=> :separator, :text=> SOUND_OPTIONS}]
    end
    @sound.push(hash)
  end
  #--------------------------------------------------------------------------
  # * Aggiunge le opzioni grafiche
  #--------------------------------------------------------------------------
  def self.push_graphic_option(hash)
    if @graphic.nil?
      @graphic = [{ :type=> :separator, :text=> GRAPHIC_OPTIONS}]
    end
    @graphic.push(hash)
  end
  #--------------------------------------------------------------------------
  # * Aggiunge le opzioni internet
  #--------------------------------------------------------------------------
  def self.push_internet_option(hash)
    if @internet.nil?
      @internet = [{ :type=> :separator, :text=> INTERNET_OPTIONS}]
    end
    @internet.push(hash)
  end
  #--------------------------------------------------------------------------
  # * Restituisce la lista delle opzioni
  #--------------------------------------------------------------------------
  def self.option_list
    options = []
    for option in all_options
      opt = Option.new(option)
      next if opt.for_game? and $game_temp.nil? || $game_temp.in_game == false
      options.push(opt)
    end
    return options
  end
end

#==============================================================================
# ** classe Scene_Menu
#------------------------------------------------------------------------------
#  Aggiunta del comando Opzioni
#==============================================================================
class Scene_Menu < Scene_MenuBase
  alias h87options_create_command_window create_command_window unless $@
  #--------------------------------------------------------------------------
  # * Finestra comandi
  #--------------------------------------------------------------------------
  def create_command_window
    h87options_create_command_window
    @command_window.set_handler(:options, method(:command_options))
  end
  #--------------------------------------------------------------------------
  # * Vai alle opzioni
  #--------------------------------------------------------------------------
  def command_options
    $game_temp.in_game = true
    SceneManager.call(Scene_Options)
  end
end

#==============================================================================
# ** Classe Window_MenuCommand
#------------------------------------------------------------------------------
#  Aggiunta del comando Opzioni
#==============================================================================
class Window_MenuCommand < Window_Command
  alias h87options_aoc add_original_commands unless $@
  #--------------------------------------------------------------------------
  # * Aggiunta del comando
  #--------------------------------------------------------------------------
  def add_original_commands
    h87options_aoc
    if H87Options::SHOW_ON_MENU
      add_command(H87Options::OPTION_COMMAND, :options, true)
    end
  end
end

#==============================================================================
# ** classe Scene_Title
#------------------------------------------------------------------------------
#  Aggiunta del comando per andare alle opzioni
#==============================================================================
class Scene_Title < Scene_Base
  alias h87options_create_command_window create_command_window unless $@
  #--------------------------------------------------------------------------
  # * Aggiunta dell'evento
  #--------------------------------------------------------------------------
  def create_command_window
    h87options_create_command_window
    @command_window.set_handler(:options, method(:command_options))
  end
  #--------------------------------------------------------------------------
  # * Comando per le opzioni
  #--------------------------------------------------------------------------
  def command_options
    $game_temp.in_game = false
    SceneManager.call(Scene_Options)
  end
  #--------------------------------------------------------------------------
  # * Aggiunta del comando del menu titolo personalizzato
  #--------------------------------------------------------------------------
  if $imported["H87_TitleMenu"]
  alias h87options_ccp crea_contenuti_personalizzati
  def crea_contenuti_personalizzati
    h87options_ccp 
    if H87Options::SHOW_ON_TITLE
      add_cursor(:options,:command_options,H87Options::TITLE_ICON,H87Options::TITLE_BALOON)
    end
  end;end
end

#==============================================================================
# ** Classe Window_TitleCommand
#------------------------------------------------------------------------------
#  Aggiunta del comando Opzioni
#==============================================================================
class Window_TitleCommand < Window_Command
  alias h87options_aoc make_command_list unless $@
  #--------------------------------------------------------------------------
  # * Aggiunta del comando
  #--------------------------------------------------------------------------
  def make_command_list
    h87options_aoc
    if H87Options::SHOW_ON_TITLE
      add_command(H87Options::OPTION_COMMAND, :options, true)
    end
  end
end

#==============================================================================
# ** DataManager
#------------------------------------------------------------------------------
#  Modifica del caricamento iniziale
#==============================================================================
module DataManager
  class << self
    alias h87options_lnd load_normal_database
  end
  #--------------------------------------------------------------------------
  # * Alias caricamento DB
  #--------------------------------------------------------------------------
  def self.load_normal_database
    h87options_lnd
    initialize_options
  end
  #--------------------------------------------------------------------------
  # * Inizializza le variabili globali
  #--------------------------------------------------------------------------
  def self.initialize_options
    for option in H87Options.option_list
      next if $game_settings[option.id] != nil
      next if option.value != nil
      option.value = option.default if option.default != nil
      option.toggle if option.type == :bar
    end
  end
end

#==============================================================================
# ** Classe Option
#------------------------------------------------------------------------------
#  Contiene le impostazioni della singola opzione di gioco
#==============================================================================
class Option
  #--------------------------------------------------------------------------
  # * Variabili d'istanza pubblici
  #--------------------------------------------------------------------------
  attr_reader :type         #tipo
  attr_reader :description  #descrizione
  attr_reader :name         #nome
  attr_reader :values       #elenco valori
  attr_reader :max          #massimo della variabile
  attr_reader :default      #valore predefinito
  attr_reader :value_method #metodo che restituisce il valore
  attr_reader :bar_color    #colore della barra
  attr_reader :tag          #etichetta (per salvataggio in game_settings)
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(hash)
    @type = hash[:type]
    @description = hash[:help]
    @name = hash[:text]
    @for_game = hash[:in_game]
    @tag = hash[:tag]
    @default = hash[:default]
    case @type
    when :switch; init_switch(hash)
    when :variable; init_variable(hash)
    when :separator; init_separator(hash)
    when :advanced; init_advanced(hash)
    when :bar; init_bar(hash)
    end
    @method = hash[:method]
    @value_method = hash[:val_mt] unless hash[:val_mt].nil?
    @special_draw = hash[:special] unless hash[:special].nil?
    @enabled_condition = hash[:condition] unless hash[:condition].nil?
  end
  #--------------------------------------------------------------------------
  # * Inizializza gli attributi dello switch
  #--------------------------------------------------------------------------
  def init_switch(hash)
    @default = false if @default.nil?
    @switch = hash[:sw]
    @values = [hash[:off], hash[:on]]
  end
  #--------------------------------------------------------------------------
  # * Inizializza gli attributi della variabile
  #--------------------------------------------------------------------------
  def init_variable(hash)
    @distance = hash[:distance].nil? ? 1 : hash[:distance]
    @variable = hash[:var]
    @need_popup = hash[:open_popup]
    @popup = eval(hash[:popup]) if hash[:popup]
    @default = 0 if @default.nil?
    if hash[:values].nil?
      @values = []
      @max = hash[:max]
      for i in 0..@max
        @values.push(i)
      end
    else
      @values = hash[:values]
      @max = @values.size
    end
  end
  #--------------------------------------------------------------------------
  # * Inizializza gli attributi del separatore
  #--------------------------------------------------------------------------
  def init_separator(hash)
  end
  #--------------------------------------------------------------------------
  # * Inizializza gli attributi dell'oggetto avanzato
  #--------------------------------------------------------------------------
  def init_advanced(hash)
    @popup = eval(hash[:popup]) if hash[:popup]
  end
  #--------------------------------------------------------------------------
  # * Inizializza gli attributi della barra
  #--------------------------------------------------------------------------
  def init_bar(hash)
    @max = hash[:max]
    @variable = hash[:var]
    @default = 0 if @default.nil?
    @switch = hash[:sw] if hash[:sw] != nil
    @distance = hash[:distance].nil? ? 1 : hash[:distance]
    @bar_color = hash[:color]
  end
  #--------------------------------------------------------------------------
  # * Restituisce il valore dell'opzione
  #--------------------------------------------------------------------------
  def value
    return method(@value_method).call if @value_method != nil
    case @type
    when :switch
      return switch
    when :variable, :bar
      return variable
    end
  end
  #--------------------------------------------------------------------------
  # * Imposta il valore dell'opzione
  #--------------------------------------------------------------------------
  def value=(new_value)
    method(@method).call(new_value) if @method
    case @type
    when :switch
      set_switch(new_value)
    when :variable, :bar
      set_variable(new_value)
    end
  end
  #--------------------------------------------------------------------------
  # * Cambia lo stato della switch
  #--------------------------------------------------------------------------
  def toggle
    set_switch(!self.switch) if @switch
  end
  #--------------------------------------------------------------------------
  # * Incrementa il valore dell'opzione
  #--------------------------------------------------------------------------
  def increment
    if @type == :switch
      toggle
    else
      set_switch(true)
      self.value += @distance
      if :variable
        self.value = 0 if self.value > @max
      else
        self.value = @max if self.value > @max
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Decrementa il valore dell'opzione
  #--------------------------------------------------------------------------
  def decrement
    if @type == :switch
      toggle
    else
      set_switch(true)
      self.value -= @distance
      if :variable
        self.value = @max if self.value < 0
      else
        self.value = 0 if self.value < 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce la classe della finestra di popup
  #--------------------------------------------------------------------------
  def popup
    return @popup if @popup
    return Generic_PopupWindow if @need_popup
    return nil
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'ID dello switch o variabile assegnato
  #--------------------------------------------------------------------------
  def id
    return @variable if @variable != nil
    return @switch if @switch != nil
    return @tag
  end
  #--------------------------------------------------------------------------
  # * Restituisce lo stato della switch
  #--------------------------------------------------------------------------
  def switch
    return true if @switch.nil?
    return true if @switch == 0
    if @switch.is_a?(Integer)
      return $game_switches[@switch]
    else
      return $game_settings[@switch]
    end
  end
  #--------------------------------------------------------------------------
  # * Imposta lo stato della switch
  #--------------------------------------------------------------------------
  def set_switch(value)
    return if @switch.nil?
    return if @switch == 0
    if @switch.is_a?(Integer)
      $game_switches[@switch] = value
    else
      $game_settings[@switch] = value
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce lo stato della variabile
  #--------------------------------------------------------------------------
  def variable
    return 0 if @variable == 0
    if @variable.is_a?(Integer)
      return $game_variables[@variable]
    else
      return $game_settings[@variable]
    end
  end
  #--------------------------------------------------------------------------
  # * Imposta lo stato della variabile
  #--------------------------------------------------------------------------
  def set_variable(value)
    return if @variable == 0
    if @variable.is_a?(Integer)
      $game_variables[@variable] = value
    else
      $game_settings[@variable] = value
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'opzione ha una switch
  #--------------------------------------------------------------------------
  def toggable?
    return @switch != nil
  end
  #--------------------------------------------------------------------------
  # * Restituisce le condizioni di abilitazione dell'opzione
  #--------------------------------------------------------------------------
  def enabled?
    if $game_system != nil && self.tag != nil &&
      $game_system.enabling_options[self.tag] == false
      return false
    end
    return true if @enabled_condition.nil?
    return eval(@enabled_condition)
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se è un separatore
  #--------------------------------------------------------------------------
  def separator?
    return @type == :separator
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se è un'opzione disponibile solo nella partita
  #   (ossia, non visibile nella schermata del titolo)
  #--------------------------------------------------------------------------
  def for_game?
    return true if @variable.is_a?(Integer)
    return true if @switch.is_a?(Integer)
    return true if @for_game
    return false
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'opzione apre un popup
  #--------------------------------------------------------------------------
  def open_popup?
    return self.popup != nil
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'opzione è disponibile e configurabile
  #--------------------------------------------------------------------------
  def value_active?(value_index)
    if @type == :switch
      return value_index == 1 && value ? true : false
    elsif @type == :variable
      return value == value_index * @distance
    else
      return true
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'opzione è attiva
  #--------------------------------------------------------------------------
  def is_on?
    return self.switch
  end
  #--------------------------------------------------------------------------
  # * Restituisc true se l'opzione può essere decrementata
  #--------------------------------------------------------------------------
  def can_decrement?
    return false if @type == :bar && self.value <= 0
    return false if @need_popup
    return true
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se l'opzione può essere incrementata
  #--------------------------------------------------------------------------
  def can_increment?
    return false if @type == :bar && self.value >= self.max
    return false if @need_popup
    return true
  end
  #--------------------------------------------------------------------------
  # * Esegue il metodo personalizzato dell'opzione
  #--------------------------------------------------------------------------
  def execute_method
    return unless @method
    method(@method).call
  end
end

#==============================================================================
# ** Scene_Options
#------------------------------------------------------------------------------
#  Schermata delle opzioni
#==============================================================================
class Scene_Options < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Inizio
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_option_window
    create_popup_windows
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    super
    update_popups
  end
  #--------------------------------------------------------------------------
  # * Fine
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_popups
  end
  #--------------------------------------------------------------------------
  # * Aggiorna le finestre di popup
  #--------------------------------------------------------------------------
  def update_popups
    @popups.each_value{|p| p.update}
  end
  #--------------------------------------------------------------------------
  # * Elimina le finestre di popup
  #--------------------------------------------------------------------------
  def dispose_popups
    @popups.each_value{|p| p.dispose}
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra d'aiuto
  #--------------------------------------------------------------------------
  def create_help_window
    @help_window = Window_Help.new
  end
  #--------------------------------------------------------------------------
  # * Creazione della finestra delle opzioni
  #--------------------------------------------------------------------------
  def create_option_window
    @option_window = Window_GameOptions.new(@help_window.y + @help_window.height)
    @option_window.help_window = @help_window
    @option_window.set_handler(:cancel, method(:return_scene))
    @option_window.activate
  end
  #--------------------------------------------------------------------------
  # * Crea le finestre di popup
  #--------------------------------------------------------------------------
  def create_popup_windows
    @popups = {}
    opt = H87Options.option_list
    y = @help_window.height
    for i in 0..opt.size-1
      if opt[i].popup
        popup = opt[i].popup.new(y, opt[i])
        popup.visible = false
        popup.set_handler(:cancel, method(:close_popup))
        popup.set_handler(:ok, method(:item_selected))
        @popups[i] = popup
      end
    end
  end  
  #--------------------------------------------------------------------------
  # * Restituisce la finestra di popup attualmente aperta
  #--------------------------------------------------------------------------
  def popup
    return @popups[@popup_index]
  end
  #--------------------------------------------------------------------------
  # * Mostra la finestra di popup
  #   index: indice dell'opzione
  #--------------------------------------------------------------------------
  def show_popup(index)
    @last_frame = Graphics.frame_count
    @popup_index = index
    x = Graphics.width - popup.width
    y = @help_window.height
    popup.x = Graphics.width
    popup.visible = true
    if $imported["H87_SmoothMovements"]
      @option_window.smooth_move(0 - popup.width, y)
      popup.smooth_move(x, y)
    else
      @option_window.x = 0 - popup.width
      popup.x = x
    end
    popup.activate
  end
  #--------------------------------------------------------------------------
  # * Viene eseguito quando l'utente seleziona un'opzione dal popup
  #--------------------------------------------------------------------------
  def item_selected
    if @last_frame < Graphics.frame_count
      @option_window.item.value = popup.selected_value
      @option_window.refresh
      close_popup
    else
      popup.activate
    end
  end
  #--------------------------------------------------------------------------
  # * Chiude la finestra di popup
  #--------------------------------------------------------------------------
  def close_popup
    popup.deactivate
    x = Graphics.width
    y = @help_window.height
    if $imported["H87_SmoothMovements"]
      @option_window.smooth_move(0, y)
      popup.smooth_move(x, y)
    else
      @option_window.x = 0
      popup.x = x
    end
    @option_window.activate
    @popup_index = nil
  end
end

#==============================================================================
# ** Window_GameOptions
#------------------------------------------------------------------------------
#  Finestra che contiene l'elenco delle opzioni
#==============================================================================
class Window_GameOptions < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #   y: coordinata Y iniziale
  #--------------------------------------------------------------------------
  def initialize(y)
    super(0, y, Graphics.width, Graphics.height - y)
    @data = []
    make_option_list
    create_contents
    refresh
    self.index = 0
    cursor_down if item && item.separator?
  end
  #--------------------------------------------------------------------------
  # * draw_item
  #   index: indice dell
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(item, rect.x, rect.y, enable?(item))
      draw_item_state(rect, item)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Item Name
  #     enabled : Enabled flag. When false, draw semi-transparently.
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    change_color(normal_color, enabled)
    draw_text(x, y, width, line_height, item.name) unless item.separator?
  end
  #--------------------------------------------------------------------------
  # * Mostra lo stato dell'opzione a seconda del tipo
  #--------------------------------------------------------------------------
  def draw_item_state(rect, item)
    case item.type
    when :separator
      draw_separator(rect, item)
    when :switch
      draw_switch(rect, item)
    when :variable
      draw_variable(rect, item)
    when :bar
      draw_bar(rect, item)
    when :advanced
      draw_advanced(rect, item)
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna il separatore
  #--------------------------------------------------------------------------
  def draw_separator(rect, item)
    color = gauge_back_color
    color.alpha = 128
    contents.fill_rect(rect.x, rect.y+2, rect.width, rect.height-4, color)
    draw_text(rect.x, rect.y, rect.width, line_height, item.name, 1)
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Down
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    super
    super if item.separator?
  end
  #--------------------------------------------------------------------------
  # * Move Cursor Up
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    super
    super if item.separator?
  end
  #--------------------------------------------------------------------------
  # * Disegna lo switch
  #--------------------------------------------------------------------------
  def draw_switch(rect, item)
    x = get_state_x(rect)
    width = get_state_width(x, rect, item)
    change_color(normal_color, enable?(item) && !item.value)
    contents.draw_text(x, rect.y, width, line_height, item.values[0], 1)
    x += width
    change_color(normal_color, enable?(item) && item.value)
    contents.draw_text(x, rect.y, width, line_height, item.values[1], 1)
  end
  #--------------------------------------------------------------------------
  # * Disegna la variabile
  #--------------------------------------------------------------------------
  def draw_variable(rect, item)
    unless item.open_popup?
      draw_values_variable(rect, item)
    else
      draw_popup_variable(rect, item)
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna la variabile se apre un popup
  #--------------------------------------------------------------------------
  def draw_popup_variable(rect, item)
    x = get_state_x(rect)
    width = rect.width - x
    change_color(normal_color, enable?(item))
    draw_text(x, rect.y, width, line_height, item.values[item.value], 1)
  end
  #--------------------------------------------------------------------------
  # * Disegna i valori della variabile
  #--------------------------------------------------------------------------
  def draw_values_variable(rect, item)
    x = get_state_x(rect)
    width = get_state_width(x, rect, item)
    for i in 0..item.max
      next if item.values[i].nil?
      change_color(normal_color, enable?(item) && item.value_active?(i))
      draw_text(x+(width*i), rect.y, width, line_height, item.values[i], 1)
    end
  end
  #--------------------------------------------------------------------------
  # * Disegna la barra
  #--------------------------------------------------------------------------
  def draw_bar(rect, item)
    x = get_state_x(rect)
    width = rect.width - x
    color = text_color(item.bar_color)
    color.alpha = enable?(item) ? 255 : 128
    contents.fill_rect(x, rect.y+5, width, line_height-10, color)
    contents.clear_rect(x+1, rect.y+6, width-2, line_height-12)
    rate = item.value/item.max.to_f
    contents.fill_rect(x, rect.y+5, width*rate, line_height-10, color)
    if item.is_on?
      change_color(normal_color, enable?(item))
      text = sprintf("%2d%%",rate*100)
    else
      change_color(power_down_color, enable?(item))
      text = H87Options::OFF_BAR
    end
    draw_text(x, rect.y, width, line_height, text, 1)
  end
  #--------------------------------------------------------------------------
  # * Disegna il valore del metodo avanzato
  #--------------------------------------------------------------------------
  def draw_advanced(rect, item)
  end
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(item)
  end
  #--------------------------------------------------------------------------
  # * Creazione della lista delle opzioni
  #--------------------------------------------------------------------------
  def make_option_list
    @data = H87Options.option_list
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    @data ? @data.size : 0
  end
  #--------------------------------------------------------------------------
  # * Display in Enabled State?
  #--------------------------------------------------------------------------
  def enable?(item)
    item.enabled?
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'opzione selezionata
  #--------------------------------------------------------------------------
  def item
    return @data[index]
  end
  #--------------------------------------------------------------------------
  # * Restituisce la coordinata X dove disegnare lo stato
  #--------------------------------------------------------------------------
  def get_state_x(rect)
    return rect.x + rect.width / 2
  end
  #--------------------------------------------------------------------------
  # * Restituisce la larghezza del valore in caso di più valori
  #--------------------------------------------------------------------------
  def get_state_width(x, rect, item)
    return (rect.width - x) / item.values.size
  end
  #--------------------------------------------------------------------------
  # * Esecuzione dell'azione di selezione (INVIO)
  #--------------------------------------------------------------------------
  def action
    case item.type
    when :switch, :bar
      toggle_item
    when :advanced
      process_method
    when :variable
      open_popup
    end
  end
  #--------------------------------------------------------------------------
  # * Cambia lo stato della switch dell'opzione
  #--------------------------------------------------------------------------
  def toggle_item
    return unless item.toggable?
    item.toggle
    RPG::SE.new(H87Options::TOGGLE_SOUND).play
    refresh
    activate
  end
  #--------------------------------------------------------------------------
  # * Chiama il metodo
  #--------------------------------------------------------------------------
  def process_method
    item.execute_method
    open_popup
  end
  #--------------------------------------------------------------------------
  # * Apre il popup
  #--------------------------------------------------------------------------
  def open_popup
    return unless item.popup
    Sound.play_ok
    SceneManager.scene.show_popup(self.index)
    deactivate
  end
  #--------------------------------------------------------------------------
  # * Aggiornamento
  #--------------------------------------------------------------------------
  def update
    return if disposed?
    super
    update_other_commands
  end
  #--------------------------------------------------------------------------
  # * Aggiorna gli altri comandi
  #--------------------------------------------------------------------------
  def update_other_commands
    return unless active && cursor_movable?
    shift_left if Input.repeat?(:LEFT) && item.can_decrement? && enable?(item)
    shift_right if Input.repeat?(:RIGHT) && item.can_increment? && enable?(item)
    action if Input.trigger?(:C) && enable?(item)
  end
  #--------------------------------------------------------------------------
  # * Scorri a sinistra se è una variabile o una barra
  #--------------------------------------------------------------------------
  def shift_left
    item.decrement
    Sound.play_cursor
    refresh
  end
  #--------------------------------------------------------------------------
  # * Scorri a destra se è una variabile o una barra
  #--------------------------------------------------------------------------
  def shift_right
    item.increment
    Sound.play_cursor
    refresh
  end
end

#==============================================================================
# ** Window_OptionPopup
#------------------------------------------------------------------------------
#  Classe d'appoggio per le finestre di popup
#==============================================================================
class Window_OptionPopup < Window_Selectable
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #--------------------------------------------------------------------------
  def initialize(y, option, width = 200)
    super(Graphics.width, y, width, Graphics.height - y)
    @option = option
    @data = []
    refresh
    select_last
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    make_option_list
    create_contents
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Ottiene la lista delle opzioni dei valori
  #--------------------------------------------------------------------------
  def make_option_list
  end  
  #--------------------------------------------------------------------------
  # * Restituisce il numero di oggetti
  #--------------------------------------------------------------------------
  def item_max
    return @data.nil? ? 0 : @data.size
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'opzione selezionata
  #--------------------------------------------------------------------------
  def select_last
  end
  #--------------------------------------------------------------------------
  # * Restituisce la nuova opzione selezionata dall'utente
  #--------------------------------------------------------------------------
  def selected_value
    return @keys ? @keys[self.index] : self.index
  end
end

#==============================================================================
# ** Generic_PopupWindow
#------------------------------------------------------------------------------
#  Finestra dei popup generici delle opzioni
#==============================================================================
class Generic_PopupWindow < Window_OptionPopup
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #   y: coordinata Y
  #   option: opzione del popup
  #--------------------------------------------------------------------------
  def initialize(y, option)
    super(y, option, 200)
  end
  #--------------------------------------------------------------------------
  # * disegna l'oggetto
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    draw_text(rect, item(index))
  end
  #--------------------------------------------------------------------------
  # * Ottiene l'elenco dei valori dell'opzione
  #--------------------------------------------------------------------------
  def make_option_list
    @data = @option.values
    if @data.is_a?(Hash)
      @keys = @data.keys
      @data = @data.values
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce il valore selezionato
  #--------------------------------------------------------------------------
  def item(index = self.index)
    return @data[index]
  end
  
  def key(index = self.index)
    return @keys[index]
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'opzione selezionata
  #--------------------------------------------------------------------------
  def select_last
    if @option.values.is_a?(Array)
      self.index = [[@option.value, 0].max, @option.values.size-1].min
    else
      self.index = keys_from_hash
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'opzione selezionata dall'hash dei valori
  #--------------------------------------------------------------------------
  def keys_from_hash
    if @keys.find_index(@option.value)
      return @keys.find_index(@option.value)
    else
      return @keys.first
    end
  end
end

#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  Aggiunta dei parametri
#==============================================================================
class Game_Temp
  attr_accessor :in_game
end

#==============================================================================
# ** Game_System
#------------------------------------------------------------------------------
#  Aggiunta dei parametri
#==============================================================================
class Game_System
  attr_accessor :options_initialized
  attr_accessor :enabling_options
  def option_enable(tag, state)
    @enabling_options = {} if @enabling_options.nil?
    @enabling_options[tag] = state
  end
end

#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  Inizializzazione delle opzioni
#==============================================================================
class Scene_Map < Scene_Base
  alias h87options_start start unless $@
  def start
    h87options_start
    initialize_options
  end
  #--------------------------------------------------------------------------
  # * Inizializza le opzioni, se non ancora inizializzate
  #--------------------------------------------------------------------------
  def initialize_options
    return if $game_system.options_initialized
    $game_system.options_initialized = true
    for option in H87Options.option_list
      next unless option.for_game?
      option.value = option.default if option.default != nil
      option.toggle if option.type == :bar
    end
  end
end
