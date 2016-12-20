$imported = {} if $imported == nil
$imported["H87-XInput"] = 1.0
#===============================================================================
# Interfaccia XInput di Holy87
# Difficoltà utente: ★
# Versione 1.0
#===============================================================================
# Questo script vi permette di utilizzare i controller per PC più moderni, come
# il controller dell'XBox 360/One, PS4 e Logitech. Lo script è subito utilizzabile
# per miglirare i controlli del gioco automaticamente (ad esempio, muovervi con
# le frecce direzionali anziché gli analogici e selezionare con il tasto A),
# inoltre offre le seguenti funzionalità:
# ● Supporto agli analogici: potete ottenere il valore preciso degli stick
#   analogici destro e sinistro e dei grilletti dorsali
# ● Supporto fino a 4 controller, per giochi multigiocatore
# ● Vibrazione: possibiltà di gestire la vibrazione sui 2 diversi motori
# ● Livello batteria: potrete riconoscere se il controller è wireless e lo stato
#   della batteria
# ● Rimappamento tasti: è possibile personalizzare i controlli e sovrascrivere
#   quelli di default di RPG Maker
# ● Utilizzo dello script a 3 strati: alto (semplice), medio e basso (raw)
# Questo script scavalca le impostazioni del game pad del gioco (quella
# finestra che compare quando si preme F1)
#===============================================================================
# Istruzioni: inserire lo script sotto Materials, prima del Main.
# Lo script è plug & play, ma ci sono 3 livelli di interazione (opzionali)
#
# ■ LIVELLO ALTO
# Questo livello è adatto a tutti: comprende semplici metodi per gestire solo la
# vibrazione del controller via eventi in modo semplificato. Dalla finestra
# degli eventi, selezionate il comando chiama script scrivendo queste righe:
# ● start_vibration(forza) per far vibrare il controller (forza è un valore
#   da 0 a 100). Esempio: start_vibration(50) farà vibrare a metà potenza.
# ● start_vibration(forza_sinistra, forza_destra) per far vibrare il controller
#   con forze diverse destra e sinistra
# ● stop_vibration per fermare la vibrazione
# ● controller_vibration(forza_sinistra, forza_destra, tempo) per far vibrare
#   il controller per x frame determinati dal valore tempo.
#
# ■ LIVELLO MEDIO
# Questo livello è adatto a chi se ne intende un po' di script (ma non troppo).
# Si basa sul controllo del modulo Input e richiamabile da qualsiasi posizione
# È possibile utilizzare nuovi simboli per i tasti specifici del controller,
# come DPAD_UP, PAD_Y, :PAD_START, PAD_A ecc... (trovi la lista più in basso)
# nei metodi press? trigger? repeat?
# inoltre questi metodi sono stati arricchiti da un nuovo parametro che consente
# di scegliere quale controller verificare. Ad esempio:
# Input.trigger?(:C, 1) verificherà se il tasto C è premuto sul secondo
# controller.
#                                * ATTENZIONE *
# È possibile usare TUTTI i metodi sottostanti aggiungendo un ulteriore parametro
# che specifica quale dei 4 controller scegliere (con valori da 0 a 3, dove 0
# è il giocaore 1 e 3 il giocatore 4). Se non viene specificato, viene
# automaticamente scelto il controller 1.
# Esempio:
# Input.press?(:LEFT) < controllerà se il tasto sinistra è premuto dal gioc. 1
# Input.press?(:LEFT, 1) < controllerà se sinistra è premuto dal giocatore 2
# Input.press?(:DPAD_LEFT) < controllerà se è stato premuto specificamente il
#		pulsante sinistro del pad direzionale del controller del giocatore 1.
#
# ● Input.battery_level: restituisce il livello di batteria del controller.
#   -1: senza batteria; 0: scarico, 1: basso, 2: medio, 3: carico
#
# ● Input.left_analog / Input.right_analog: restituiscono rispettivamente le
#   coordinate X e Y degli analogici sinistro e destro come hash {:x => 0, :y => 0}
#   Esempio:
#   print Input.left_analog[:x] => se l'analogico è inclinato all'estrema destra,
#   restituirà 32767
#   I valori degli analogici variano da -32767 a 32767 sia per coordinata X che
#   Y, questo significa che se l'analogico è dritto segnerà 0.
#
# ● Input.left_trigger / Input.right_trigger: restituiscono i valori dei
#   grilletti sinistro e destro con un valore che varia da 0 (riposo) a 255
#
# ● Input.vibrate(sinistro, destro, frames)
#   Fa vibrare il controller. Bisogna impostare la potenza dei motori sinistro
#   e destro (valore da 0 a 100) e la durata in frames.
# ● Input.start_vibration(forza): fa vibrare il controller in tempo indefinito
# ● Input.stop_vibration: Interrompe la vibrazione del controller
#
# ● Input.user_control: restituisce l'ultimo tipo di controllo usato come:
#   :controller, significa che è stato usato un controller
#   :legacy, significa che il giocatore sta usando la tastira o un vecchio pad
#   compatibile Direct 2D (i vecchi controller senza analogico).
#
# ■ LIVELLO BASSO
# Si tratta della comunicazione al livello più basso del controller, dove ricevi
# i dati RAW del gamepad. Se sai gestire questo livello, probabilmente non hai
# neanche bisogno di questa documentazione in quanto ti basterà guardare le
# descrizioni dei metodi contenute negli script.
# ● XInput.get_state restituisce una classe rappresentante l'istanziazione della
#   struttura dello stato del controller, ossia XInput_State con i seguenti
#   attributi (o nil se non è collegato alcun controller):
#   packet_number restituisce il numero del pacchetto. Il numero differisce
#   dallo stato del controller, se non è cambiato allora lo stato  del
#   controller non è cambiato.
#   game_pad restituisce lo stato dei pulsanti come classe Game_Pad ed ha i
#   seguenti metodi e attributi:
#   buttons restituisce un intero indicante i pulsanti premuti. Si tratta di un
#   intero a 16 bit dove ogni bit rappresenta lo stato di un pulsante. Ad
#   esempio, 2 in binario corrisponde a 0000000000000010, il secondo bit a
#   1 indica che è premuto il tasto giù del D-PAD.
#   Altro esempio: 6 in binario corrisponde a 0000000000000110, il secondo bit
#   è sempre il tasto giù mentre il terzo è il tasto sinistra: il giocatore sta
#   premendo giù e sinistra contemporaneamente. Per evitare di impazzire, puoi
#   utilizzare il metodo 'keymap_state' per ottenere un hash con tutti i pulsanti
#   premuti (le chiavi dell'hash sono i pulsanti, il valore è true se sono
#   normali pulsanti e intero se sono analogici o grilletti rappresentanti il
#		loro valore)
#   Puoi anche usare il metodo button_pressed?(costante) per controllare se
#   un determinato pulsante, rappresentato da una costante definita in basso,
#   è premuto. Alcune costanti: GAMEPAD_LEFT_SHOULDER, GAMEPAD_A, GAMEPAD_BACK
#   Esempio d'uso:
#		XInput.get_state.game_pad.button_pressed?(XInput::PAD_X)
#			restituisce true se il tasto X del controller è premuto
#		XInput.get_state.keymap_state.keys
#			restituisce l'array dei pulsanti premuti, es. [:DPAD_UP, :LEFT_SHOULDER]
#
# ● XInput.get_battery_info: restituisce le informazioni sulla batteria come
#			oggetto XInput_BatteryInformation che ha 2 attributi:
#			battery_type restituisce il tipo di batteria, che può essere
#			BATTERY_TYPE_WIRED se il controller è a cavo (no wireless)
#		  BATTERY_TYPE_ALKALINE se alimentato con pile alcaline (le classiche stilo)
#		  BATTERY_TYPE_NIMH se alimentato con batteria ricaricabile al litio
#		  BATTERY_TYPE_UNKNOWN se la batteria è sconosciuta.
#			Queste costanti rappresentano rispettivamente i valori 1, 2, 3 e 4.
#			battery_level restituisce il livello di carica, che può essere
#			BATTERY_LEVEL_EMPTY se il controller è scarico
#  		BATTERY_LEVEL_LOW se la batteria è quasi scarica
#  		BATTERY_LEVEL_MEDIUM se la batteria è sul livello medio
#  		BATTERY_LEVEL_FULL se la batteria è carica.
#			Queste costanti rappresentano rispettivamente i valori 0, 1, 2 e 3.
#
# ● XInput.set_vibration(forza_sinistra, forza_destra) fa vibrare il controller.
#			Imposta la forza a 0 per farlo smettere. Il valore forza va da 0 a 65535
#
#		Deadzone: Per evitare che imprecisioni sul pad facciano risultare analogici e
#		grilletti come premuti/mossi, è stata predisposta una "zona morta"
#		che impone una quantità minima di spostamento per specificare quando un
#		analogico è spostato rispetto al centro o quando il grilletto è premuto,
#		secondo le linee guida delle DirectX. Puoi modificare queste deadzone a
#   piacimento modificando le costanti LEFT_THUMB_DEADZONE, RIGHT_THUMB_DEADZONE
#   e TRIGGER_THRESHOLD.
#
# ■ IMPOSTAZIONI GIOCATORE
# È possibile definire le impostazioni del controller del giocatore che sono
# memorizzate in $game_system.
# ● xinput_key_set: restituisce l'hash contenenti le impostazioni della mappatura
#   dei pulsanti (inizialmente è come definito in DEFAULT_KEY_SET). Puoi anche
#   personalizzare i pulsanti, ad esempio
#   $game_system.ximput_key_set[:L] = :LEFT_THUMB imposterà la funzione L al tasto
#   L3 del controller.
# ● vibration_enabled? restituisce se la vibrazione è attiva
# ● set_vibration_enabled(valore) imposta la funzione di vibrazione
# ● set_vibration_rate(valore) imposta la potenza della vibrazione con un valore
#   da 0 a 100
# Nota: queste impostazioni non valgono se si usa direttamente XInput, bisogna
#	usare i comandi evento o il modulo Input.
#===============================================================================


#===============================================================================
# ** XInput_Settings
#-------------------------------------------------------------------------------
# Settings section
#===============================================================================
module XInput_Settings
  DEFAULT_KEY_SET = {
      :UP     => :DPAD_UP,
      :DOWN   => :DPAD_DOWN,
      :LEFT   => :DPAD_LEFT,
      :RIGHT  => :DPAD_RIGHT,
      :START  => :PAD_START, 	#not really used by RPG Maker
      :SELECT => :PAD_BACK,		#not used too
      :L      => :LEFT_SHOULDER,
      :R      => :RIGHT_SHOULDER,
      :A      => :PAD_Y,
      :B      => :PAD_B,
      :C      => :PAD_A,
      :X      => :PAD_X,
      :Y      => :LEFT_THUMB,
      :Z      => :RIGHT_THUMB
  }

  VOCABS = {
      :DPAD_UP        => 'D Su',
      :DPAD_DOWN      => 'D Giù',
      :DPAD_LEFT      => 'D Sinistra',
      :DPAD_RIGHT     => 'D Destra',
      :PAD_START      => 'Start',
      :PAD_BACK       => 'Indietro/Select',
      :LEFT_SHOULDER  => 'Dorsale sinistro',
      :RIGHT_SHOULDER => 'Dorsale destro',
      :PAD_A          => 'A',
      :PAD_B          => 'B',
      :LEFT_THUMB     => 'Levetta sinistra',
      :PAD_X          => 'X',
      :PAD_Y          => 'Y',
      :RIGHT_THUMB    => 'Levetta destra',
      :R_TRIG         => 'Grilletto destro',
      :L_TRIG         => 'Grilletto sinistro',
      :L_AXIS_X       => 'Analogico sinistro (asse X)',
      :L_AXIS_Y       => 'Analogico sinistro (asse Y)',
      :R_AXIS_X       => 'Analogico destro (asse X)',
      :R_AXIS_Y       => 'Analogico destro (asse Y)',
			:L_AXIS_LEFT		=> 'Analogico a sinistra',
			:L_AXIS_RIGHT		=> 'Analogico a destra',
			:L_AXIS_UP			=> 'Analogico su',
			:L_AXIS_DOWN		=> 'Analogico giù',
			:R_AXIS_LEFT		=> 'Analogico destro a sinistra',
			:R_AXIS_RIGHT		=> 'Analogico destro a destra',
			:R_AXIS_UP			=> 'Analogico destro su',
			:R_AXIS_DOWN		=> 'Analogico destro giù',
  }
	# How much far the analog stick will press for sense the direction
	ANALOG_DIRECTION_MIN = 16300 # max 32767
end

# ---------ATTENZIONE: MODIFICARE SOTTO QUESTO PARAGRAFO COMPORTA SERI RISCHI
#           PER IL CORRETTO FUNZIONAMENTO DELLO SCRIPT! -------------

#===============================================================================
# ** XInput
#-------------------------------------------------------------------------------
# Core module for controller connection
#===============================================================================
module XInput
  GET = Win32API.new('XINPUT9_1_0', 'XInputGetState', 'IP', 'V')
  SET = Win32API.new('XINPUT9_1_0', 'XInputSetState', 'IP', 'L')
  XINPUT_GBI = Win32API.new('Xinput1_4', 'XInputGetBatteryInformation', 'ILP', 'I')
  #--------------------------------------------------------------------------
  # * Battery constants
  #--------------------------------------------------------------------------
  BATTERY_DEVTYPE_GAMEPAD = 0x00
  BATTERY_TYPE_WIRED      = 0x01
  BATTERY_TYPE_ALKALINE   = 0x02
  BATTERY_TYPE_NIMH       = 0x03
  BATTERY_TYPE_UNKNOWN    = 0xFF
  BATTERY_LEVEL_EMPTY     = 0x00
  BATTERY_LEVEL_LOW       = 0x01
  BATTERY_LEVEL_MEDIUM    = 0x02
  BATTERY_LEVEL_FULL      = 0x03
  #--------------------------------------------------------------------------
  # * Button constants
  #--------------------------------------------------------------------------
  GAMEPAD_DPAD_UP         = 0x0001
  GAMEPAD_DPAD_DOWN       = 0x0002
  GAMEPAD_DPAD_LEFT       = 0x0004
  GAMEPAD_DPAD_RIGHT      = 0x0008
  GAMEPAD_START           = 0x0010
  GAMEPAD_BACK            = 0x0020
  GAMEPAD_LEFT_THUMB      = 0x0040
  GAMEPAD_RIGHT_THUMB     = 0x0080
  GAMEPAD_LEFT_SHOULDER   = 0x0100
  GAMEPAD_RIGHT_SHOULDER  = 0x0200
  GAMEPAD_A               = 0x1000
  GAMEPAD_B               = 0x2000
  GAMEPAD_X               = 0x4000
  GAMEPAD_Y               = 0x8000
  #--------------------------------------------------------------------------
  # * Deadzones
  #--------------------------------------------------------------------------
  LEFT_THUMB_DEADZONE     = 7849
  RIGHT_THUMB_DEADZONE    = 8689
  TRIGGER_THRESHOLD       = 30
  #--------------------------------------------------------------------------
  # * Error states
  #--------------------------------------------------------------------------
  ERROR_SUCCESS           = 0
  ERROR_DEVICE_NOT_CONNECTED = 1167
  #--------------------------------------------------------------------------
  # * Supported keys
  #--------------------------------------------------------------------------
  GAMEPAD_KEYS = {
      :DPAD_UP            => GAMEPAD_DPAD_UP,
      :DPAD_DOWN          => GAMEPAD_DPAD_DOWN,
      :DPAD_LEFT          => GAMEPAD_DPAD_LEFT,
      :DPAD_RIGHT         => GAMEPAD_DPAD_RIGHT,
      :PAD_START          => GAMEPAD_START,
      :PAD_BACK           => GAMEPAD_BACK,
      :LEFT_THUMB         => GAMEPAD_LEFT_THUMB,
      :RIGHT_THUMB        => GAMEPAD_RIGHT_THUMB,
      :RIGHT_SHOULDER     => GAMEPAD_RIGHT_SHOULDER,
      :LEFT_SHOULDER      => GAMEPAD_LEFT_SHOULDER,
      :PAD_A              => GAMEPAD_A,
      :PAD_B              => GAMEPAD_B,
      :PAD_X              => GAMEPAD_X,
      :PAD_Y              => GAMEPAD_Y
  }
  #--------------------------------------------------------------------------
  # * Gets the controller keys state
  # @param [Index] index
  # @return [XInput_State]
  #--------------------------------------------------------------------------
  def self.get_state(index = 0)
    buffer = ' ' * 16
    error = GET.call(index, buffer)
    error == ERROR_SUCCESS ? XInput_State.new(buffer) : nil
  end
  #--------------------------------------------------------------------------
  # * Gets the hash containing all the pressed keys
  # @param [Integer] index
  # @return [Hash]
  #--------------------------------------------------------------------------
  def self.get_key_state(index = 0)
    state = get_state(index)
    state != nil ? state.game_pad.keymap_state : {}
  end
  #--------------------------------------------------------------------------
  # * Sets the controller vibration
  # @param [Integer] l_strenght     value between 0 and 65535
  # @param [Integer] r_strenght     value between 0 and 65535
  # @param [Integer] index          controller index
  # @return [Integer]               ERROR_SUCCESS/ERROR_DEVICE_NOT_CONNECTED
  #--------------------------------------------------------------------------
  def self.set_vibration(l_strenght, r_strenght, index = 0)
    l_strenght = [l_strenght, 65535].min
    r_strenght = [r_strenght, 65535].min
    SET.call(index, [l_strenght, r_strenght].pack('SS'))
  end
  #--------------------------------------------------------------------------
  # * Returns if the controller is plugged in
  # @param [Integer] controller_index
  #--------------------------------------------------------------------------
  def self.controller_plugged_in?(controller_index = 0)
    get_state(controller_index) != nil
  end
  #--------------------------------------------------------------------------
  # * Gets the battery information
  # @param [Integer] index
  # @return [XInput_BatteryInformation]
  #--------------------------------------------------------------------------
  def self.get_battery_info(index = 0)
    buffer = ' ' * 8
    result = XINPUT_GBI.call(index, BATTERY_DEVTYPE_GAMEPAD, buffer)
    result == ERROR_SUCCESS ? XInput_BatteryInformation.new(buffer) : nil
  end
	#--------------------------------------------------------------------------
  # * Returns the default key set
  #--------------------------------------------------------------------------
	def self.default_key_set; XInput_Settings::DEFAULT_KEY_SET; end
end #xinput

#===============================================================================
# ** Vocab
#-------------------------------------------------------------------------------
# Gamepad keys vocabs
#===============================================================================
module Vocab
  #--------------------------------------------------------------------------
  # * Gamepad key vocab
  # @param [Symbol] key
  #--------------------------------------------------------------------------
  def self.gamepad_key(key)
    XInput_Settings::VOCABS[key]
  end
end #vocab

#===============================================================================
# ** XInput_State
#-------------------------------------------------------------------------------
# Controller state
#===============================================================================
class XInput_State
  attr_reader :packet_number
  #--------------------------------------------------------------------------
  # * Object initializazion
  # @param [String] input_data
  #--------------------------------------------------------------------------
  def initialize(input_data)
    inp = input_data.unpack('LSCCssss')
    @packet_number = inp[0]
		keys = inp[1]
		tl = adjust_trigger(inp[2], XInput::TRIGGER_THRESHOLD)
		tr = adjust_trigger(inp[3], XInput::TRIGGER_THRESHOLD)
    left = normalize(inp[4], inp[5], XInput::LEFT_THUMB_DEADZONE)
    right = normalize(inp[6], inp[7], XInput::RIGHT_THUMB_DEADZONE)
    lx = inp[4] * left; ly = -inp[5] * left
    rx = inp[6] * right; ry = -inp[7] * right
    @game_pad = Game_Pad.new(keys, tl, tr, lx.to_i, ly.to_i, rx.to_i, ry.to_i)
  end
  #--------------------------------------------------------------------------
  # * Returns the game pad status
  # @return [Game_Pad]
  #--------------------------------------------------------------------------
  def game_pad; @game_pad; end
  #--------------------------------------------------------------------------
  # * Checks if the analog stick is over the dead zone
  # @param [Integer] x
  # @param [Integer] y
  # @param [Integer] deadzone
  #--------------------------------------------------------------------------
  def normalize(x, y, deadzone)
    magnitude = Math.sqrt(x*x + y*y)
    if magnitude > deadzone
      magnitude = [magnitude, 32767].min
      magnitude -= deadzone
      normalized_magnitude = magnitude / (32767 - deadzone)
    else
      normalized_magnitude = 0
    end
    normalized_magnitude
  end
	#--------------------------------------------------------------------------
  # * Checks if the trigger is over the dead zone
  # @param [Integer] value
  # @param [Integer] threshold
  #--------------------------------------------------------------------------
	def adjust_trigger(value, threshold)
		return 0 if value <= threshold
		magnitude = 255 / (255 - threshold)
		((value - threshold) * magnitude).to_i
	end
end

#===============================================================================
# ** XInput_BatteryInformation
#-------------------------------------------------------------------------------
# Battery information container
#===============================================================================
class XInput_BatteryInformation
  attr_reader :battery_type   #1: Wired, 2: Alkhaline, 3: Nimh, 4: Unknown
  attr_reader :battery_level  #0: Empy,  1: Low, 2: Medium, 3: High
  #--------------------------------------------------------------------------
  # * Object initialization
  # @param [String] buffer
  #--------------------------------------------------------------------------
  def initialize(buffer)
    result = buffer.unpack('CC')
    @battery_type = result[0]
    @battery_level = result[1]
  end
  #--------------------------------------------------------------------------
  # * Gets if battery level is low
  #--------------------------------------------------------------------------
  def battery_low?
    wireless? && @battery_level <= XInput::BATTERY_LEVEL_LOW
  end
  #--------------------------------------------------------------------------
  # * Gets if the controller is wireless
  #--------------------------------------------------------------------------
  def wireless?
    @battery_type == XInput::BATTERY_TYPE_ALKALINE or
        @battery_type == XInput::BATTERY_TYPE_NIMH
  end
  #--------------------------------------------------------------------------
  # * Gets if the controller is wired
  #--------------------------------------------------------------------------
  def wired?
    @battery_type == XInput::BATTERY_TYPE_WIRED
  end
  #--------------------------------------------------------------------------
  # * To String (for screen printable)
  #--------------------------------------------------------------------------
  def to_s
    case @battery_type
      when XInput::BATTERY_TYPE_ALKALINE
        type = 'Alkaline'
      when XInput::BATTERY_TYPE_WIRED
        type = 'Wired'
      when XInput::BATTERY_TYPE_NIMH
        type = 'Nimh'
      else
        type = 'Unknown'
    end
    case @battery_level
      when XInput::BATTERY_LEVEL_EMPTY
        level = 'Empty'
      when XInput::BATTERY_LEVEL_LOW
        level = 'Low'
      when XInput::BATTERY_LEVEL_MEDIUM
        level = 'Medium'
      when XInput::BATTERY_LEVEL_FULL
        level = 'Full'
      else
        level = 'Unknown'
    end
    sprintf('Type: %s, Level: %s', type, level)
  end
end

#===============================================================================
# ** Game_Pad
#-------------------------------------------------------------------------------
# Gamepad keys structure
#===============================================================================
class Game_Pad
  attr_reader :buttons        #buttons pressed in integer value
  attr_reader :left_trigger   #LT key, value from 0 to 255
  attr_reader :right_trigger  #RT key, value from 0 to 255
  attr_reader :thumb_lx       #left analog X, value between -32768 and 32767
  attr_reader :thumb_ly       #left analog Y, value between -32768 and 32767
  attr_reader :thumb_rx       #right analog X, value between -32768 and 32767
  attr_reader :thumb_ry       #right analog Y, value between -32768 and 32767
  #--------------------------------------------------------------------------
  # * Object initialization
  # @param [String] buttons		integer with buttons pressed
  # @param [Integer] lt			left trigger value (0 to 255)
  # @param [Integer] rt			right trigger value (0 to 255)
  # @param [Integer] lx			left stick x axis (-32768 to 32767)
  # @param [Integer] ly			left stick y axis (-32768 to 32767)
  # @param [Integer] rx			right stick x axis (-32768 to 32767)
  # @param [Integer] ry			right stick y axis (-32768 to 32767)
  #--------------------------------------------------------------------------
  def initialize(buttons, lt, rt, lx, ly, rx, ry)
    @buttons = buttons
    @left_trigger = lt
    @right_trigger = rt
    @thumb_lx = lx
    @thumb_ly = ly
    @thumb_rx = rx
    @thumb_ry = ry
  end
  #--------------------------------------------------------------------------
  # * Returns true if the pad button is pressed
  # @param [Integer] button_const (integer value)
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def button_pressed?(button_const)
    @buttons | button_const == @buttons # or for bit comparator
  end
  #--------------------------------------------------------------------------
  # * Gets a keymap state with (true/false) if buttons, values if analog.
  # @return [Hash]
  #--------------------------------------------------------------------------
  def keymap_state
    if @keymap_state.nil?
      @keymap_state = {}
      XInput::GAMEPAD_KEYS.each_pair {|key, value|
        @keymap_state[key] = true if button_pressed?(value)
      }
      @keymap_state[:L_AXIS_X] = @thumb_lx if @thumb_lx != 0
      @keymap_state[:L_AXIS_Y] = @thumb_ly if @thumb_ly != 0
      @keymap_state[:R_AXIS_X] = @thumb_rx if @thumb_rx != 0
      @keymap_state[:R_AXIS_Y] = @thumb_ry if @thumb_ry != 0
      @keymap_state[:R_TRIG]   = @right_trigger if @right_trigger > 0
      @keymap_state[:L_TRIG]   = @left_trigger if @left_trigger > 0
			min = XInput_Settings::ANALOG_DIRECTION_MIN
			if @keymap_state[:L_AXIS_X]
				@keymap_state[:L_AXIS_RIGHT] = true if @keymap_state[:L_AXIS_X] > min
				@keymap_state[:L_AXIS_LEFT] = true if @keymap_state[:L_AXIS_X] < -min
			end
			if @keymap_state[:L_AXIS_Y]
				@keymap_state[:L_AXIS_DOWN] = true if @keymap_state[:L_AXIS_Y] > min
				@keymap_state[:L_AXIS_UP] = true if @keymap_state[:L_AXIS_Y] < -min
			end
			if @keymap_state[:R_AXIS_X]
				@keymap_state[:R_AXIS_RIGHT] = true if @keymap_state[:R_AXIS_X] > min
				@keymap_state[:R_AXIS_LEFT] = true if @keymap_state[:R_AXIS_X] < -min
			end
			if @keymap_state[:R_AXIS_Y]
				@keymap_state[:R_AXIS_DOWN] = true if @keymap_state[:R_AXIS_Y] > min
				@keymap_state[:R_AXIS_UP] = true if @keymap_state[:R_AXIS_Y] < -min
			end
    end
    @keymap_state
  end
  #--------------------------------------------------------------------------
  # * To string
  # @return [String]
  #--------------------------------------------------------------------------
  def to_s; keymap_state.to_s; end
end

#===============================================================================
# ** Game_System
#-------------------------------------------------------------------------------
# Controller settings container
#===============================================================================
class Game_System
  #--------------------------------------------------------------------------
  # * Custom key set
  # @param [Integer] controller_index
  # @return [Hash]
  #--------------------------------------------------------------------------
  def xinput_key_set(controller_index = 0)
    @xinput_key_set ||= create_default_key_set
    @xinput_key_set[controller_index]
  end
  #--------------------------------------------------------------------------
  # * Checks if the vibration is enabled
  # @param [Integer] controller_index
  #--------------------------------------------------------------------------
  def vibration_enabled?(controller_index = 0)
    @xinput_vibration ||= {}
    @xinput_vibration[controller_index] ||= true
  end
  #--------------------------------------------------------------------------
  # * Sets the vibration enable option
  # @param [Boolean] value
  # @param [Integer] controller_index
  #--------------------------------------------------------------------------
  def set_vibration_enabled(value, controller_index = 0)
    @xinput_vibration ||= {}
    @xinput_vibration[controller_index] = value
  end
  #--------------------------------------------------------------------------
  # * Keys conversion (for user key settings)
  # @param [Symbol] original_key
  # @param [Integer] controller_index
  #--------------------------------------------------------------------------
  def adjust_buttons(original_key, controller_index = 0)
    if xinput_key_set(controller_index).include?(original_key)
      xinput_key_set(controller_index)[original_key]
    else
      original_key
    end
  end
  #--------------------------------------------------------------------------
  # * Default key set initialization (from script settings)
  #--------------------------------------------------------------------------
  def create_default_key_set
    @xinput_key_set = {}
    (0..3).each {|pad_index|
      @xinput_key_set[pad_index] = XInput.default_key_set
    }
    @xinput_key_set
  end
  #--------------------------------------------------------------------------
  # * gets the vibration power settings
  #--------------------------------------------------------------------------
  def vibration_rate(pad_index = 0)
    @vibration_rate ||= [100] * 4
    @vibration_rate[pad_index]
  end
  #--------------------------------------------------------------------------
  # * Sets the vibration power setting
  # @param [Integer] rate
  # @param [Integer] pad_index
  #--------------------------------------------------------------------------
  def set_vibration_rate(rate, pad_index = 0)
    vibration_rate[pad_index] = [[0, rate].max, 100].min
  end
	#--------------------------------------------------------------------------
  # * Gets the vibration power
  # @param [Integer] pad_index
  #--------------------------------------------------------------------------
	def calc_vibration_power(pad_index = 0) 
    65535 * vibration_rate / 100
	end
end # game_system

#===============================================================================
# ** Input
#-------------------------------------------------------------------------------
# Input redefinition
#===============================================================================
module Input
  #--------------------------------------------------------------------------
  # * Variable initialization
  #--------------------------------------------------------------------------
  @key_timing = {0 => {}, 1 => {}, 2 => {}, 3 => {}}
  @key_state = {0 => {}, 1 => {}, 2 => {}, 3 => {}}
  @controller_plugged = [false] * 4
  @vibration_state = [0] * 4
  #--------------------------------------------------------------------------
  # * Method aliases
  #--------------------------------------------------------------------------
  class << self
    alias h87controller_update update
    alias h87controller_trigger? trigger?
    alias h87controller_press? press?
    alias h87controller_repeat? repeat?
  end
  #--------------------------------------------------------------------------
  # * Update process
  #--------------------------------------------------------------------------
  def self.update
    h87controller_update
    update_xinput
  end
  #--------------------------------------------------------------------------
  # * Game pad updating process
  #--------------------------------------------------------------------------
  def self.update_xinput
    update_keystate
    update_controller_used
    update_vibration
  end
  #--------------------------------------------------------------------------
  # * Returns the controller connection state
  # @param [Integer] pad_index
  # @return [Boolean]
  #--------------------------------------------------------------------------
  def self.controller_connected?(pad_index = 0)
    @controller_plugged[pad_index]
  end
  #--------------------------------------------------------------------------
  # * Keydown
  #--------------------------------------------------------------------------
  def self.trigger?(key, controller_index = 0)
    if controller_used?(controller_index)
      @last_input_used = :controller
      real_key = $game_system.adjust_buttons(key, controller_index)
      timing = @key_timing[controller_index][real_key]
      timing == 0
    else
      result = h87controller_trigger?(key)
      @last_input_used = :legacy if result
      result
    end
  end
  #--------------------------------------------------------------------------
  # * Key pressed
  #--------------------------------------------------------------------------
  def self.press?(key, pad_index = 0)
    if controller_used?(pad_index)
      @last_input_used = :controller
      @key_state[pad_index].include?($game_system.adjust_buttons(key, pad_index))
    else
      result = h87controller_press?(key)
      @last_input_used = :legacy if result
      result
    end
  end
  #--------------------------------------------------------------------------
  # * Direction pressed
  #--------------------------------------------------------------------------
  def self.dir4(controller_index = 0)
    return 2 if press?(:DOWN, controller_index)
    return 4 if press?(:LEFT, controller_index)
    return 6 if press?(:RIGHT, controller_index)
    return 8 if press?(:UP, controller_index)
    0
  end
  #--------------------------------------------------------------------------
  # * Eight directions pressed
  #--------------------------------------------------------------------------
  def self.dir8(controller_index = 0)
    return 1 if press?(:DOWN, controller_index) and press?(:LEFT, controller_index)
    return 3 if press?(:DOWN, controller_index) and press?(:RIGHT, controller_index)
    return 7 if press?(:UP, controller_index)   and press?(:LEFT, controller_index)
    return 9 if press?(:UP, controller_index)   and press?(:RIGHT, controller_index)
    dir4(controller_index)
  end
  #--------------------------------------------------------------------------
  # * Cursor moving
  #--------------------------------------------------------------------------
  def self.repeat?(key, controller_index = 0)
    if controller_used?(controller_index)
      @last_input_used = :controller
      real_key = $game_system.adjust_buttons(key, controller_index)
      timing = @key_timing[controller_index][real_key]
      timing != nil and (timing == 0 or timing == 30 or timing > 30 and timing % 5 == 0)
    else
      result = h87controller_repeat?(key)
      @last_input_used = :legacy if result
      result
    end
  end
  #--------------------------------------------------------------------------
  # * Checks if the controller is being used
  #--------------------------------------------------------------------------
  def self.controller_used?(controller_index = 0)
    @controller_used[controller_index]
  end
  #--------------------------------------------------------------------------
  # * Vibration update process
  #--------------------------------------------------------------------------
  def self.update_vibration
    (0..3).each {|pad_index|
      if @vibration_state[pad_index] > 0
        @vibration_state[pad_index] -= 1
        XInput.set_vibration(0, 0, pad_index) if @vibration_state[pad_index] == 0
      end
    }
  end
  #--------------------------------------------------------------------------
  # * Manually stops the vibration
  #--------------------------------------------------------------------------
  def self.stop_vibration(controller_index = 0)
    @vibration_state[controller_index] = 0
  end
  #--------------------------------------------------------------------------
  # * Starts the vibration with no time limit
  #--------------------------------------------------------------------------
  def self.start_vibration(l_strenght, r_strenght = l_strenght, controller_index = 0)
    l_strenght = [[0, l_strenght].max, 100].min * adjust_vibration(controller_index) / 100
    r_strenght = [[0, r_strenght].max, 100].min * adjust_vibration(controller_index) / 100
    @vibration_state[controller_index] = -1
    XInput.set_vibration(l_strenght, r_strenght, controller_index)
  end
  #--------------------------------------------------------------------------
  # * Pad keys update process
  #--------------------------------------------------------------------------
  def self.update_keystate
    @old_key_state = @key_state
    (0..3).each {|pad_index|
      update_keys(pad_index)
    }
  end
  #--------------------------------------------------------------------------
  # * Single pad update process
  #--------------------------------------------------------------------------
  def self.update_keys(controller_index)
    state = XInput.get_state(controller_index)
    if state
      @controller_plugged[controller_index] = true
      @key_state[controller_index] = state.game_pad.keymap_state
      @key_timing[controller_index].each_key { |key|
        @key_timing[controller_index][key] = nil unless @key_state[controller_index].keys.include?(key)
      }
      @key_state[controller_index].each_key {|key|
        if @old_key_state[controller_index].keys.include?(key)
          @key_timing[controller_index][key] ||= -1
          @key_timing[controller_index][key] += 1
        else
          @key_timing[controller_index][key] = 0
        end
      }
    else
      @controller_plugged[controller_index] = false
    end
  end
  #--------------------------------------------------------------------------
  # * Controller check update process
  #--------------------------------------------------------------------------
  def self.update_controller_used
    @controller_used = {}
    (0..3).each {|i|
      @controller_used[i] = @key_state[i].size > 0
    }
  end
  #--------------------------------------------------------------------------
  # * Returns the last used controls (:controller or :legacy)
  #--------------------------------------------------------------------------
  def self.used_control; @last_input_used; end
  #--------------------------------------------------------------------------
  # * Vibration activation
  # @param [Float] l_strenght       value from 0 to 100
  # @param [Float] r_strenght       value from 0 to 100
  # @param [Integer] timing         frames (1/60 second)
  # @param [Integer] pad_index      pad index
  #--------------------------------------------------------------------------
  def self.vibrate(l_strenght, r_strenght, timing, pad_index = 0)
    l_strenght = [[0, l_strenght].max, 100].min * adjust_vibration(pad_index) / 100
    r_strenght = [[0, r_strenght].max, 100].min * adjust_vibration(pad_index) / 100
    XInput.set_vibration(l_strenght, r_strenght, pad_index)
    @vibration_state[pad_index] = timing
  end
  #--------------------------------------------------------------------------
  # * Adjusts the vibration power due to user settings
  # @return [Integer]
  #--------------------------------------------------------------------------
  def self.adjust_vibration(pad_index = 0)
    $game_system.vibration_rate(pad_index)
  end
  #--------------------------------------------------------------------------
  # * Gets the left analog stick coordinates
  # @param [Integer] controller_index
  # @return [Array]
  #--------------------------------------------------------------------------
  def self.left_analog(controller_index = 0)
    result = {:x => 0, :y => 0}
    if @key_state[controller_index][:L_AXIS_X]
      result[:x] = @key_state[controller_index][:L_AXIS_X]
    end
    if @key_state[controller_index][:L_AXIS_Y]
      result[:y] = @key_state[controller_index][:L_AXIS_Y]
    end
    result
  end
  #--------------------------------------------------------------------------
  # * Gets the right analog stick coordinates
  # @param [Integer] controller_index
  # @return [Array]
  #--------------------------------------------------------------------------
  def self.right_analog(controller_index = 0)
    result = {:x => 0, :y => 0}
    if @key_state[controller_index][:R_AXIS_X]
      result[:x] = @key_state[controller_index][:R_AXIS_X]
    end
    if @key_state[controller_index][:R_AXIS_Y]
      result[:y] = @key_state[controller_index][:R_AXIS_Y]
    end
    result
  end
  #--------------------------------------------------------------------------
  # * Returns the left trigger value (value between 0 and 255)
  # @return [Integer]
  #--------------------------------------------------------------------------
  def self.left_trigger(controller_index = 0)
    if @key_state[controller_index][:L_TRIG]
      @key_state[controller_index][:L_TRIG]
    else
      0
    end
  end
  #--------------------------------------------------------------------------
  # * Returns the right trigger value (value between 0 and 255)
  # @return [Integer]
  #--------------------------------------------------------------------------
  def self.right_trigger(controller_index = 0)
    if @key_state[controller_index][:R_TRIG]
      @key_state[controller_index][:R_TRIG]
    else
      0
    end
  end
  #--------------------------------------------------------------------------
  # * Gets the battery level of a selected controller
  # return values: -1: wired controller; 0: empty, 1: low, 2: medium, 3: high
  # @return [Integer]
  #--------------------------------------------------------------------------
  def self.battery_level(controller_index = 0)
    return -1 if XInput.get_battery_info(controller_index).battery_type == 0
    XInput.get_battery_info(controller_index).battery_level
  end
end # input

#===============================================================================
# ** Game_Interpreter
#-------------------------------------------------------------------------------
# easy method calls
#===============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # * Call vibration process
  # @param [Integer] l_strenght
  # @param [Integer] r_strenght
  # @param [Integer] timing
  # @param [Integer] pad_index
  #--------------------------------------------------------------------------
  def controller_vibration(l_strenght, r_strenght, timing, pad_index = 0)
    Input.vibrate(l_strenght, r_strenght, timing, pad_index)
  end
  #--------------------------------------------------------------------------
  # * Starts the vibration with no time limit
  # @param [Integer] l_strenght
  # @param [Integer] r_strenght
  # @param [Integer] pad_index
  #--------------------------------------------------------------------------
  def start_vibration(l_strenght, r_strenght = l_strenght, pad_index = 0)
    Input.start_vibration(l_strenght, r_strenght, pad_index)
  end
  #--------------------------------------------------------------------------
  # * Stops the vibration
  #--------------------------------------------------------------------------
  def stop_vibration(pad_index = 0)
    Input.stop_vibration(pad_index)
  end
end # game_interpreter
