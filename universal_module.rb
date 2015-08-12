$imported = {} if $imported == nil
$imported["H87_UniversalModule"] = 1.6
=begin
 ==============================================================================
  ■ Holy87's Universal Module
      version 1.6.2 - EN
      User difficulty: ★★★
      License: CC-BY. Everyone can distribute this script and use in their free
      and commercial games. Credit required.

  ■ This module helps to expand to new levels your scripts and games, allowing
    you to create unique features unthinkable before, in the simplies possible
    method. What you can do with this script?
    ● Saving universal variables that not depend on the savegame
    ● Obtain system information, like screen resolution, system language,
      Windows version, user name, documents folder path etc..
    ● Download a file and/or obtain response from a web server in the easiest
      way
    ● Obtain and set game version information
    ● Coding and decoding strings in Base64 or ROT13
    ● And other features!
 ==============================================================================
  ■ Compatibility
    DataManager -> alias load_normal_database, load_battle_test_database
    Scene_Base  -> alias update
    Window_Base -> alias update
 ==============================================================================
  ■ Installation
    Install this script under Materials, above Main and all scripts that use
    the Universal Module
 ==============================================================================
  ■ Istructions
    Use those methods from script calls or inside your scripts: when you see
    square brackets [] it means that that parameter is optional.
   
  ▼ Universal variables
    The $game_settings global variable saves and stores in game_settings.rvdata2
    file (in the gmae folder) a value that not depends on the savegame. You can
    use this script to save settings in the title screen or unlock an extra option
    when the player ends the game.
    Substantially, the Game_Settings class is an hash, so you can use a key to
    store and load a value. For example:
 
    ● $game_settings[key] = value
      Saves the value with the key. The data is automatically stored when you
      assign a value, but sometimes you need to manually update the file when
      for example the value is an object and you may chang a property in that
      object. So use $game_settings.save to force save.
 
    ● $game_settings[key]
      returns the value provided by key

    The data is autmatical
      
    ● You can set up the game version by creating a file in the project's
      folder with "version.ini" name, and write inside the version value
      like 1.0.2.5. You can call the game version with the
      $game_system.game_version method call.
      Ex. version = $game_system.game_version
      print version.major => 1
      print version.minor => 0
      print version.build => 2
      print version.revision => 5
      print version => 1.0.2.5
      print version > "1.0.1.7" => false

      vers2 = Version.new("2.0")
      print version < vers2 => true
 
  ▼ System calls
 
    ● Win.version:
      returns a float with the Windows kernel version.
        5.0 -> Windows 2000
        5.1 -> Windows Xp
        5.2 -> Windows Xp (64 bit)
        6.0 -> Windows Vista
        6.1 -> Windows 7
        6.2 -> Windows 8
        6.3 -> Windows 8.1
        10.0-> Windows 10
 
    ● Win.username
      Returns a string with the actual user name of Windows account.
      I.E. print Win.username => "Francesco"
 
    ● Win.homepath
      Returns the user path. I.E.:
      C:/Users/username/                      from Windows Vista
      C:/Documents and Settings/username      in Windows 2000 and Xp
 
    ● Win.getFolderPath([symbol])
      Returns a folder path defined by symbol:
        :docs -> My Documents folder
        :imgs -> My Pictures folder
        :dskt -> Desktop folder
        :musc -> Music folder
        :vdeo -> Movies folder
        :prog -> Program Files folder (C:\Program Files (x86))
        * if a symbol is not defined, it means :docs

        Example:
        print Win.getFolderPath(:dskt) => "C:/Users/Francesco/Desktop"
 
    ● Win.shutdown[(mode)]
      Shuts down the PC, settings by mode (0 for default):
        0: normal shutdown
        1: reset
        2: hybernate
 
    ● Win.open(filepath)
      Opens a folder or a file. Specify the path in filepath
        Win.open(C:/Windows/system32/calc.exe) opens calculator
        Win.open(Win.getFolderPath(:imgs)) it will open the Images
        folder
 
    ● Win.temp_flush(nomefile)
      Deletes the temporary data of the file name (if downloaded more
      times) This method is not used anymore.
      
    ● Win.language
      Returns a int code with the system language in use. For the complete
      code list, see this link below:
      http://support.microsoft.com/kb/193080
 
    ● Win.screen_resolution
      returns an array with two integers containing the screen resolution
      (es. [1024,730]). You may know that this method doesn't return the
      full resolution, but only the screen part not covered by the taskbar.
 
    ● Screen.resize(width, height)
      Change the game screen size. This method NOT changes the game resolution,
      only makes the screen bigger.
      
  ▼ String methods
  
    ● println
      like print, but adds automatically \n at the end of the string
    
    ● String.random([lenght])
      Returns a random string. If lenght is not defined, then the string
      is 4
      Examples:
      print String.random     #=> ajpf
      print String.random(7)  #=> opetnpg
      
    ● crypt_rot13
      Crypts a string in ROT13 format (moves all characters by 13 steps
      in the alphabet). Recall this method on the same string to decode
      print "Casa".crypt_rot13    #=> "Pnfn"
      print "Pnfn".crypt_rot13    #=> "Casa"
      
    ● Base64.encode(string) and Base64.decode(string)
      Returns a string coded in Base64 for interchange of web data
      Per other info: wikipedia.org/wiki/Base64
 
  ▼ Internet and HTTP
  
    ----------------------------------------------------------------------------
    * Simplified method for sync operations
    ----------------------------------------------------------------------------
    The async methods allow an easy handle for download and internet responses,
    so you can use less code possible and be more efficient. Those methods can
    be only used within Scene and Window classes, if you want to use in your
    custom classes, then include the Async_Downloads module.
    
    ● download_async(url, method[, folder, priority])
      Starts a download from url. It launchs automatically the method when the
      download is completed.
      Examples:
      download_async("www.mysite.com/image.jpg", method(:image_downloaded))
      (you must defined the image_downloaded method also)
      The file download is slow, to not slow the game. If you want speed up
      the download, set true in priority
      
    ● get_response_async(url, method, priority)
      Starts the reception of a web service response from the URL, and launches
      the defined method when the response is received. Unlike the previous,
      the method that will be called must have an input parameter, that will
      be the string that you receive from the internet call.      
      
    ● abort_download(filename)
      Cancels the file download.
      
    ● download_status(filename)
      Retrns a number from 0 to 100 that represents the download progress.
      
    ----------------------------------------------------------------------------
    * Complex methods for downloads
    ----------------------------------------------------------------------------
    Questi metodi possono essere usati ovunque e permettono una gestione più
    complessa e funzionale dei download. Possono anche essere usati affiancati
    ai metodi più semplici.
    
    ● await_response(url)
      Send a request to a web server and wait for the response, then returns
      the value. Example:
      print await_response(www.mysite.com)
      This code will print the HTML code of mysite.com.
 
    ● HTTP.domain
      returns your main server domain (configured below).
    
    ● HTTP.download(url[,folderpath[,low_priority]])
      Downloads a file from url. If the folderpath is omitted, it will store the
      file in the game_folder ("./"). Example:
      HTTP.download("http://www.miosito.it/immagine.png","./Graphics/Pictures")
        it will download immagine.png in the Pictures folder.
      HTTP.download("http://www.miosito.it/immagine.png")
        it will download the immagine.png file in game folder.
      HTTP.download(HTTP.domain+"/immagine.png", Win.getFolderPath(:dskt))
        it will download immagine.png from mysite.com on my desktop.
      You can set true to download the file more slowly, but you will have
      less game shuttering.
      
    ● HTTP.get_server_response(url, response_name)
      Sent a request to url and stores the response in an hash with
      response_name key.
      
    ● HTTP.await_response(url)
      Like await_response
      
    ● HTTP.response(response_name)
      Returns the response stored.
 
    ● HTTP.downloaded?(filename/response_name)
      Returns true if the response is obtained or the file is downloaded.
      Returns false if is not completely downloaded or the download isn't
      started.
      
    ● HTTP.progress(filename)
      Return the download progress of filename (from 0.0 to 100.0)
 
    ● HTTP.filesize(nomefile)
      returns the file size of the downloading file
 
    ● HTTP.sizeloaded(nomefile)
      returns the downloaded data of the file in bit. You may divide per 8
      to obtain the byte size.
 
    ● HTTP.time_passed(nomefile)
      returns the time passed from the start of the download
 
    ● HTTP.downloads
      returns an hash containing all the download instances
 
    ● HTTP.completed
      returns the number of completed downloads
      
    ● HTTP.get_file_size(url)
      returns the file size on a weblink
 
    ● HTTP.file_good?(nomefile)
      checks if the file is good
 
    ● Browser.open(url)
      opens your default browser on the url.
=end

#==============================================================================
module H87_ModConfig
  HTTPDOMAIN = "http://mysite.com"
  SETTINGNAME = "game_settings.rvdata2"
  VERSIONFILE = "version.ini"
end
#==============================================================================
# ** Win
#------------------------------------------------------------------------------
#  Questo modulo gestisce le chiamate di sistema e recupera informazioni sul
#  computer
#==============================================================================
module Win
  #-----------------------------------------------------------------------------
  # *Nome Utente Windows
  # Restituisce il nome utente di Windows
  #-----------------------------------------------------------------------------
  def self.username
    name = " " * 128  
    size = "128"  
    Win32API.new('advapi32','GetUserName',['P','P'],'I').call(name,size)
    username = name.unpack("A*") 
    return username[0] 
  end  
  # -------------------------------------------------------------------------- 
  # * Restituisce la cartella utente di Windows
  # --------------------------------------------------------------------------
  def self.homepath
    name = " " * 128  
    size = "128"  
    username = "\0" * 256 #userprofile
    Win32API.new('kernel32', 'GetEnvironmentVariable', %w(p p l), 'l').call("userprofile", username, 256)
    username.delete!("\0")
    return username.gsub("\\","/")
  end 
  # -------------------------------------------------------------------------- 
  # * Restituisce il percorso di una cartella del computer
  # --------------------------------------------------------------------------
  def self.getFolderPath(symbol = :docs)
    case symbol
    when :user; index = 40
    when :docs; index = 5
    when :imgs; index = 39
    when :musc; index = 13
    when :vdeo; index = 14
    when :strp; index = 2
    when :prog; index = 38
    when :appd; index = 28
    else; index = 0
    end
    path = "\0" * 128  
    Win32API.new('shell32', 'SHGetFolderPath', 'LLLLP', 'L').call(0, index, 0, 2, path)
    return path.delete("\0").gsub("\\","/")
  end
  # -------------------------------------------------------------------------- 
  # * Restituisce la larghezza della cornice della finestra
  # --------------------------------------------------------------------------
  def self.window_frame_width
    return Win32API.new("user32", "GetSystemMetrics", ['I'],'I').call(7)
  end
  # -------------------------------------------------------------------------- 
  # * Restituisce l'altezza della barra del titolo
  # --------------------------------------------------------------------------
  def self.window_title_height
    return Win32API.new("user32", "GetSystemMetrics", ['I'],'I').call(4)
  end
  #-----------------------------------------------------------------------------
  # * Elimina il file temporaneo per aggiornarlo prima di un download.
  #   inserire il nome del file.
  #-----------------------------------------------------------------------------
  def self.temp_flush(nomefile)
    if version < 6
      path = homepath+"/Impostazioni locali/Temporary Internet Files"
      unless File.directory?(path)
        path = homepath+"/Local Settings/Temporary Internet Files"
        return unless File.directory?(path)
      end
      fetch_folder_for_delete(path,nomefile)
    else
      path = homepath+"/AppData/Local/Microsoft/Windows/Temporary Internet Files/Content.IE5"
      unless File.directory?(path)
        path = cartella_utente_win+"/AppData/Local/Microsoft/Windows/INetCache/IE"
      end
      return unless File.directory?(path)
      Dir.foreach(path) {|x|                        #per ogni file nel percorso
        next if x == "." or x == ".."               #passa al prossimo se è ind.
        if File.directory?(path+"/"+x)              #se il file è una cartella
          folder = path+"/"+x                       #entra nella cartella
          fetch_folder_for_delete(folder,nomefile)
        end
      }
    end
  end
  # -------------------------------------------------------------------------- 
  # * Cerca nella cartella il file da cancellare
  #   path: directory
  #   nomefile: file da cancellare
  # --------------------------------------------------------------------------
  def self.fetch_folder_for_delete(path,nomefile)
    Dir.foreach(path) {|y|                  #per ogni file nella cartella
      next if File.directory?(path+"/"+y)   #passa al prossimo se è una c.
      if no_ext(nomefile) == y[0..no_ext(nomefile).size-1]#se l'inizio del nome corrisp.
        begin
          File.delete(path+"/"+y)             #eliminalo
        rescue
          next
        end
      end
    }
  end
  # -------------------------------------------------------------------------- 
  # * Restituisce la versione di Windows in uso
  # --------------------------------------------------------------------------
  def self.version
    gvex = Win32API.new( 'kernel32', 'GetVersionEx', ['P'], 'I' )
    s = [20+128, 0, 0, 0, 0, '' ].pack('LLLLLa128')
    gvex.call( s );
    a = s.unpack( 'LLLLLa128' )
    indice = a[1].to_f;dec = a[2].to_f/10
    return indice + dec
  end
  #-----------------------------------------------------------------------------
  # * Restituisce il nome del file senza estensione.
  #-----------------------------------------------------------------------------
  def self.no_ext(nomefile)
    nome = nomefile.split(".")
    return nome[0]
  end
  #-----------------------------------------------------------------------------
  # * Restituisce un array di larghezza e altezza della parte utilizzabile dello
  #   schermo: non conta lo spazio della barra delle applicazioni.
  #-----------------------------------------------------------------------------
  def self.screen_resolution
    x = Win32API.new("user32", "GetSystemMetrics", ['I'],'I').call(16)
    y = Win32API.new("user32", "GetSystemMetrics", ['I'],'I').call(17)
    return [x,y]
  end
  #-----------------------------------------------------------------------------
  # * Restituisce un intero come codice della lingua del sistema
  #-----------------------------------------------------------------------------
  def self.language
    return Win32API.new("kernel32", "GetUserDefaultLCID", [], 'I').call
  end
  #-----------------------------------------------------------------------------
  # * Restituisce la data attuale
  #-----------------------------------------------------------------------------
  def self.datenow(partition = -1)
    date = Time.now
    case partition
    when -1
      return sprintf("%d/%d/%d",date.day,date.month,date.year)
    when 0
      return date.day
    when 1
      return date.month
    when 2
      return date.year
    end
  end
  #-----------------------------------------------------------------------------
  # * Restituisce l'ora attuale
  #-----------------------------------------------------------------------------
  def self.timenow(partition = -1)
    date = Time.now
    case partition
    when -1
      return sprintf("%d:%d",date.hour,date.min)
    when 0
      return date.hour
    when 1
      return date.min
    when 2
      return date.sec
    end
  end
  #-----------------------------------------------------------------------------
  # * arresta il computer in modalità diverse.
  #-----------------------------------------------------------------------------
  def self.shutdown(mode = 0)
    string = "system "
    case mode
    when 0
      string += "-s"
    when 1
      string += "-r"
    when 2
      string += "-h"
    end
    system(string)
  end  
end #win

#==============================================================================
# ** Screen
#------------------------------------------------------------------------------
#  Questo modulo gestisce il ridimensionamento della finestra di gioco
#==============================================================================
module Screen
  #-----------------------------------------------------------------------------
  # * ridimensiona la finestra e la centra
  #   width = nuova larghezza
  #   height = nuova altezza
  #-----------------------------------------------------------------------------
  def self.resize(width ,height)
    #API
    getSystemMetrics = Win32API.new("user32", "GetSystemMetrics", 'I', 'I')
    moveWindow = Win32API.new("user32","MoveWindow",['l','i','i','i','i','l'],'l')
    findWindowEx = Win32API.new("user32","FindWindowEx",['l','l','p','p'],'i')
    this_window = findWindowEx.call(0,0,"RGSS Player",0)
    res_x = Win.screen_resolution[0] #risoluzione x
    res_y = Win.screen_resolution[1] #risoluzione y
    width += Win.window_frame_width*2
    height += Win.window_frame_width*2 + Win.window_title_height
    new_x = [(res_x-width)/2, 0].max #ottiene la nuova coordinata, ma non
    new_y = [(res_y-height)/2, 0].max#fa passare oltre il bordo
    moveWindow.call(this_window, new_x, new_y, width, height, 1)
  end
end #screen

#==============================================================================
# ** HTTP
#------------------------------------------------------------------------------
#  Questo modulo permette di interfacciarsi ad internet e gestire i download.
#  Ringraziamenti: Berka (il codice è ispirato al suo)
#==============================================================================
module HTTP  
  SetPrClass = Win32API.new('kernel32','SetPriorityClass','pi','i').call(-1,128)
  InternetOpenA = Win32API.new("wininet",'InternetOpenA','plppl','l').call('',0,'','',0)
  InternetConnectA = Win32API.new("wininet",'InternetConnectA','lplpplll','l')
  InternetOpenUrl = Win32API.new("wininet",'InternetOpenUrl','lppllp','l')
  InternetReadFile = Win32API.new("wininet",'InternetReadFile','lpip','l')
  InternetCloseHandle = Win32API.new("wininet",'InternetCloseHandle','l','l')
  HttpQueryInfo = Win32API.new("wininet",'HttpQueryInfo','llppp','i')
  #--------------------------------------------------------------------------
  # * Scarica un file da internet in un thread separato
  # url = indirizzo completo del nome del file
  # folder = cartella dove depositare il file scaricato
  #--------------------------------------------------------------------------
  def self.download(url, folder = "./", low_priority = false, filename = nil, save = true)
    #inizializzazione
    @downloaded = 0 if @downloaded.nil?
    @downloads = {} if @downloads.nil?
    @counter = -1 if @counter.nil?
    @size = {} if @size.nil?
    @received = {} if @received.nil?
    @timepassed = {} if @timepassed.nil?
    @response = {} if @response.nil?
    @completed = {} if @completed.nil?
    
    #ottenimento dell'indirizzo
    address = url.split('/')
    server = address[2]
    root = address[3..address.size].join('/')
    filename = address[-1] if filename == nil
    
    #crezione del thread
    @downloads[filename] = Thread.start(url,folder, save){|url,folder,save|
      txt = ""
      t = Time.now
      "Serv f" if(e=InternetConnectA.call(InternetOpenA,server,80,'','',3,1,0))==0
      file = InternetOpenUrl.call(InternetOpenA,url,nil,0,0,0)
      HttpQueryInfo.call(file,5,k="\0"*1024,[k.size-1].pack('l'),nil)
      @received[filename] = 0
      @size[filename] = k.delete!("\0").to_i
      loop do
        buffer = " "*1024
        n = 0
        r = InternetReadFile.call(file,buffer,1024,o=[n].pack('i!'))
        n = o.unpack('i!')[0]
        txt<<buffer[0,n]
        @response[filename] = txt if !save
        @received[filename] = txt.size
        if r&&n==0
          break
        end
        sleep(0.001) if low_priority
      end
      #creazione del file nel percorso
      if save
        if File.directory?(folder)
          obj = File.open(folder + filename,'wb')<<txt
          obj.close #chiusura del file
        else
          string = "%s non è un percorso valido, pertanto %s non verrà salvato."
          println sprintf(string, folder, filename)
        end
      end
      @received[filename] = @size[filename]
      @completed[filename] = true
      @downloaded += @received[filename]
      InternetCloseHandle.call(file)
      sleep(0.01)
      @timepassed[filename] = Time.now-t
      }
  end
  #--------------------------------------------------------------------------
  # * Ottiene la dimensione di un file remoto in modo asincrono
  #--------------------------------------------------------------------------
  def self.get_file_size_async(url)
    @filesize = {} if @filesize.nil?
    Thread.start(url){|url|
      @filesize[url] = get_file_size(url)
    }
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se la dimensione del file è stata ottenuta
  #--------------------------------------------------------------------------
  def self.size_get?(url)
    return false if @filesize.nil?
    return @filesize[url] != nil?
  end
  #--------------------------------------------------------------------------
  # * Ottiene la dimensione di un file remoto
  #--------------------------------------------------------------------------
  def self.get_file_size(url)
    file = InternetOpenUrl.call(InternetOpenA,url,nil,0,0,0)
    HttpQueryInfo.call(file,5,k="\0"*1024,[k.size-1].pack('l'),nil)
    InternetCloseHandle.call(file)
    return k.delete!("\0").to_i
  end
  #--------------------------------------------------------------------------
  # * Ottiene la risposta del server e la piazza nell'array delle rispose
  #   url: indirizzo della richiesta
  #   response_name: nome della risposta (per poterla leggere)
  #   low_priority: priorità (false se normale, true se bassa)
  #--------------------------------------------------------------------------
  def self.get_server_response(url, response_name, low_priority = false)
    download(url, "", low_priority, response_name, false)
  end
  #--------------------------------------------------------------------------
  # * Restituisce direttamente il testo di risposta dal server, interrompendo
  #   l'esecuzione del gioco fino a quando non arriva la risposta.
  #   url: indirizzo della richiesta
  #--------------------------------------------------------------------------
  def self.await_get_server_response(url)
    response = "response"
    @response.delete(response) if @response != nil
    @received.delete(response) if @received != nil
    @downloads.delete(response) if @downloads != nil
    download(url, "", false, response, false)
    loop {break if downloaded?(response)}
    return @response[response]
  end
  class << self; alias await_response await_get_server_response; end
  #--------------------------------------------------------------------------
  # * Restituisce true se il file è scaricato.
  # filename: nome del file
  #--------------------------------------------------------------------------
  def self.downloaded?(filename)
    return false if @received.nil?
    return false if @received[filename].nil?
    return false if @size[filename].nil?
    return true if @received[filename] >= @size[filename]
    return true if progress(filename) >= 100
    return true if progress(filename).to_s == "NaN"
    return true if @completed[filename]
    return false
  end
  #--------------------------------------------------------------------------
  # * Restituisce la grandezza del file da scaricare in byte
  # filename: nome del file
  #--------------------------------------------------------------------------
  def self.filesize(filename)
    return 0 if @size.nil?
    return 0 if @size[filename].nil?
    return @size[filename]
  end
  #--------------------------------------------------------------------------
  # * Restituisce la quantità di byte scaricati
  # filename: nome del file
  #--------------------------------------------------------------------------
  def self.sizeloaded(filename)
    return 0 if @received.nil?
    return 0 if @received[filename].nil?
    return @received[filename]
  end
  #--------------------------------------------------------------------------
  # * Restituisce la percentuale di progresso del download
  # filename: nome del file
  #--------------------------------------------------------------------------
  def self.progress(filename)
    @received = {} if @received.nil?
    return 0 if @received[filename].nil?
    return @received[filename].to_f/@size[filename]*100
  end
  #--------------------------------------------------------------------------
  # * Restituisce l'hash dei download
  #--------------------------------------------------------------------------
  def downloads
    return {} if @downloads.nil?
    return @downloads
  end
  #--------------------------------------------------------------------------
  # * Restituisce il numero di secondi che ci sono voluti per scaricare
  #--------------------------------------------------------------------------
  def self.time_passed(filename)
    return 0 if @timepassed[filename] == nil
    return @timepassed[filename]
  end
  #--------------------------------------------------------------------------
  # * Restituisce il numero dei download completati
  #--------------------------------------------------------------------------
  def self.completed
    return 0 if @downloaded.nil?
    return @downloaded
  end
  #--------------------------------------------------------------------------
  # * Restituisce la risposta dal server
  #   response_name: id della risposta
  #--------------------------------------------------------------------------
  def self.response(response_name)
    return 0 if @response.nil? || @response[response_name].nil?
    return @response[response_name]
  end
  #--------------------------------------------------------------------------
  # * Restituisce i download
  #--------------------------------------------------------------------------
  def self.downloads
    @downloads ||= {}
    return @downloads
  end
  #--------------------------------------------------------------------------
  # * Restituisce il dominio principale
  #--------------------------------------------------------------------------
  def self.domain
    H87_ModConfig::HTTPDOMAIN
  end
  #--------------------------------------------------------------------------
  # * Controlla se il file scaricato è buono e restituisce true o false
  #--------------------------------------------------------------------------
  def self.file_good?(filename)
    if File.exist? (filename) #apre il file in sola lett.
      File.open(filename,"r") do |f|
      f.lineno = 1 # imposta la riga n.1
      txt = f.gets
      return check_response(txt)
      end
    else
      return false
    end
  end
  #--------------------------------------------------------------------------
  # * Restituisce true se il testo non è vuoto
  #--------------------------------------------------------------------------
  def self.check_response(text)
    return false if text == "" or text.nil?
    first = text[0].chr
    return false if first == "" or first == nil
    return true
  end
end #http

#==============================================================================
# ** Async_Downloads
#------------------------------------------------------------------------------
#  Dev'essere incluso nelle classi che fanno uso dei metodi download_async.
#==============================================================================
module Async_Downloads
  #--------------------------------------------------------------------------
  # * Scarica un file in modo asincrono lanciando automaticamente il metodo.
  #   url:          indirizzo del file
  #   method_name:  nome del metodo, in simbolo (ad es. :apri)
  #   low:          true se è a bassa incidenza, false altrimenti
  #   folder:       percorso del file di salvataggio
  #--------------------------------------------------------------------------
  def download_async(url, method, folder = "./", low = true)
    filename = url.split('/')[-1]
    if filename.downcase.include? ".php"
      println "Questo URL chiama un file PHP, pertanto non verrà salvato."
      println "Utilizzare invece il metodo get_repsonse_async."
      return
    end
    @async_downloads = {} if @async_downloads.nil?
    @async_downloads[filename] = method
    HTTP.download(url, folder, low)
  end
  #--------------------------------------------------------------------------
  # * Ottiene la risposta di un servizio web in modo asincrono, lanciando
  #   automaticamente il metodo associato.
  #   url:          indirizzo della richiesta
  #   method_name:  nome del metodo, in simbolo (ad es. :apri)
  #   low:          true se è a bassa incidenza, false altrimenti
  #   response_id:  id della risposta.
  #--------------------------------------------------------------------------
  def get_response_async(url, method, low = true, response_id = String.random(20))
    @async_responses = {} if @async_responses.nil?
    @async_responses[response_id] = method
    HTTP.get_server_response(url, response_id, low)
  end
  #--------------------------------------------------------------------------
  # * Restituisce direttamente la stringa di risposta dal server
  #   url: indirizzo della richiesta
  #--------------------------------------------------------------------------
  def await_response(url)
    return HTTP.await_get_server_response(url)
  end
  #--------------------------------------------------------------------------
  # * Controlla i download e lancia il metodo associato se completato.
  #--------------------------------------------------------------------------
  def check_async_downloads
    return if @async_downloads.nil? || @async_downloads.size == 0
    @async_downloads.each_key do |key|
      if HTTP.downloaded?(key)
        @async_downloads[key].call
        @async_downloads.delete(key)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Controlla le risposte e lancia il metodo associato quando ricevuta.
  #--------------------------------------------------------------------------
  def check_async_requests
    return if @async_responses.nil? || @async_responses.size == 0
    @async_responses.each_key do |key|
      if HTTP.downloaded?(key) && HTTP.response(key) != nil
        @async_responses[key].call(HTTP.response(key))
        @async_responses.delete(key)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Cancella un download o l'attesa di una risposta
  #   filename: nome del file o id della risposta
  #--------------------------------------------------------------------------
  def abort_download(filename)
    Thread.kill(HTTP.downloads(filename))
  end
  #--------------------------------------------------------------------------
  # * Restituisce la percentuale di download da 0 a 100
  #   filename: nome del file
  #--------------------------------------------------------------------------
  def download_status(filename)
    status = HTTP.progress(filename)
    return [[0, status].max, 100].min.to_i
  end
end

#==============================================================================
# ** Modulo Browser per aprire il browser predefinito del PC
#==============================================================================
module Browser
  #--------------------------------------------------------------------------
  # * apre il browser
  #   url: url impostato
  #--------------------------------------------------------------------------
  def self.open(url)
    #controlla che ci siano prefissi
    if url[0..6] != "http://" and url[0..7] != "https://"
      open_url = "http://"+url
    else
      open_url = url
    end
    shell = Win32API.new("Shell32", "ShellExecute", ['L', 'P', 'P', 'P','P', 'L'], 'L')
    Thread.new{shell.call(0, "open", open_url, 0, 0, 1)}
    sleep(0.01)
    SceneManager.exit
  end
end #browser

#==============================================================================
# ** Modulo Browser per la codifica/decodifica di stringhe in Base64
#==============================================================================
module Base64
  #--------------------------------------------------------------------------
  # * Restituisce una stringa decodificata da Base64
  #     string: stringa da decodificare
  #--------------------------------------------------------------------------
  def self.decode(string)
    return string.gsub(/\s+/, "").unpack("m")[0]
  end
  #--------------------------------------------------------------------------
  # * Restituisce una stringa codificata in Base64
  #     string: stringa da codificare
  #--------------------------------------------------------------------------
  def self.encode(string)
    return [string].pack("m")
  end
end #base64

#==============================================================================
# ** Classe Settings (per le impostazioni comuni ai salvataggi)
#==============================================================================
class H87_Settings
  #--------------------------------------------------------------------------
  # * restituisce l'elemento corrispondente al parametro
  #--------------------------------------------------------------------------
  def [](param)
    @settings[param]
  end
  #--------------------------------------------------------------------------
  # * inizializzazione
  #--------------------------------------------------------------------------
  def initialize
    @settings = {}
  end
  #--------------------------------------------------------------------------
  # * cambia o aggiunge un elemento dell'hash
  #--------------------------------------------------------------------------
  def []=(param_name,value)
    @settings[param_name] = value
    save
  end
  #--------------------------------------------------------------------------
  # * Registra i dati salvati
  #--------------------------------------------------------------------------
  def save
    save_data($game_settings,DataManager.settings_path)
  end
end #settings

#==============================================================================
# ** Game_Version
#------------------------------------------------------------------------------
# Questa classe è d'appoggio per gestire la versione del gioco.
#==============================================================================
class Game_Version
  include Comparable        #per la verifica delle versioni se maggiore o minore
  attr_accessor :major      #numero di major release
  attr_accessor :minor      #numero di minor release
  attr_accessor :build      #numero di versione build
  attr_accessor :revision   #numero di revisione
  #--------------------------------------------------------------------------
  # * Inizializzazione
  #     version_string: versione in stringa (ad es. 1.5.3.1)
  #--------------------------------------------------------------------------
  def initialize(version_string, starting_major = 1)
    @major = starting_major
    @minor = 0
    @build = 0
    @revision = 0
    version_string.gsub!(/\s\n\r/,"")
    return unless version_string =~ /[\d]+([\.[\d]]*)/
    version_string = version_string.split(".")
    @major = version_string[0].to_i
    return if version_string[1].nil?
    @minor = version_string[1].to_i
    return if version_string[2].nil?
    @build = version_string[2].to_i
    return if version_string[3].nil?
    @revision = version_string[3].to_i
  end
  #--------------------------------------------------------------------------
  # * Restituisce la versione attuale del gioco
  #--------------------------------------------------------------------------
  def self.now
    if File.exist?(H87_ModConfig::VERSIONFILE)
      file = File.open(H87_ModConfig::VERSIONFILE,"r")
      str = file.read
      file.close
      return Game_Version.new(str)
    else
      return Game_Version.new("1.0.0.0")
    end
  end
  #--------------------------------------------------------------------------
  # * Compara una versione o una stringa con se stessa
  #--------------------------------------------------------------------------
  def <=> other
    return self <=> Game_Version.new(other) if other.is_a?(String)
    return self.major <=> other.major if self.major != other.major
    return self.minor <=> other.minor if self.minor != other.minor
    return self.build <=> other.build if self.build != other.build
    return self.revision <=> other.revision
  end
  #--------------------------------------------------------------------------
  # * restituisce la versione in stringa
  #--------------------------------------------------------------------------
  def to_s
    return sprintf("%d.%d.%d.%d", @major, @minor, @build, @revision)
  end
end #game_version

#==============================================================================
# ** RPG::System -> aggiunta del metodo per la versione del gioco
#==============================================================================
class Game_System
  #--------------------------------------------------------------------------
  # * Restituisce la versione del gioco attuale
  #--------------------------------------------------------------------------
  def game_version
    return Game_Version.now
  end
end #rpg_system

#==============================================================================
# ** DataManager -> aggiunta dei metodi per caricare i settaggi
#==============================================================================
module DataManager
  #--------------------------------------------------------------------------
  # * alias
  #--------------------------------------------------------------------------
  class << self
    alias h87set_load_n_db load_normal_database
    alias h87set_load_b_db load_battle_test_database
  end
  # -------------------------------------------------------------------------- 
  # * caricamento nd
  # --------------------------------------------------------------------------
  def self.load_normal_database
    load_h87settings
    h87set_load_n_db
  end
  # -------------------------------------------------------------------------- 
  # * caricamento btd
  # --------------------------------------------------------------------------
  def self.load_battle_test_database
    load_h87settings
    h87set_load_b_db
  end
  # -------------------------------------------------------------------------- 
  # * restituisce il percorso delle impostazioni
  # --------------------------------------------------------------------------
  def self.settings_path
    H87_ModConfig::SETTINGNAME
  end
  #--------------------------------------------------------------------------
  # * carica le impostazioni universali
  #--------------------------------------------------------------------------
  def self.load_h87settings
    return if $game_settings
    if File.exist?(settings_path)
      $game_settings = load_data(settings_path)
    else
      $game_settings = H87_Settings.new
      save_data($game_settings,settings_path)
    end
  end
end #datamanager

#==============================================================================
# ** Aggiunta di alcuni metodi utili per le stringhe
#==============================================================================
class String
  #--------------------------------------------------------------------------
  # * Metodo Random: restituisce una stringa a caso
  #   size: numero di caratteri della stringa
  #--------------------------------------------------------------------------
  def self.random(size = 4)
    stringa = rand(36**size).to_s(36)
    return stringa
  end
  #--------------------------------------------------------------------------
  # * Restituisce la stessa stringa ma crittografata in ROT13
  #   http://it.wikipedia.org/wiki/ROT13
  #--------------------------------------------------------------------------
  def crypt_rot13
    return self.tr("A-Za-z", "N-ZA-Mn-za-m")
  end
end #fine della stringa

#==============================================================================
# ** Inclusione dei metodi asincroni in Scene_Base
#==============================================================================
class Scene_Base
  include Async_Downloads # inclusione del modulo
  #--------------------------------------------------------------------------
  # * Alias del metodo d'aggiornamento
  #--------------------------------------------------------------------------
  alias h87_module_update update unless $@
  def update
    h87_module_update
    check_async_downloads #controlla i download
    check_async_requests  #controlla le richieste
  end
end #scene_base

#==============================================================================
# ** Inclusione dei metodi asincroni in Window_Base
#==============================================================================
class Window_Base
  include Async_Downloads # inclusione del modulo
  #--------------------------------------------------------------------------
  # * Alias del metodo d'aggiornamento
  #--------------------------------------------------------------------------
  alias h87_module_update update unless $@
  def update
    h87_module_update
    check_async_downloads #controlla i download
    check_async_requests  #controlla le richieste
  end
end #scene_base

class Object
  #--------------------------------------------------------------------------
  # * Metodo di stampa riga
  #--------------------------------------------------------------------------
  def println(*args)
    print(*args, "\n")
  end
  #--------------------------------------------------------------------------
  # * Metodi di conversione Base64
  #--------------------------------------------------------------------------
  def base64_encode(string); Base64.encode(string); end
  def base64_decode(string); Base64.decode(string); end
  #--------------------------------------------------------------------------
  # * Restituisce direttamente la stringa di risposta dal server
  #   url: indirizzo della richiesta
  #--------------------------------------------------------------------------
  def await_response(url)
    return HTTP.await_get_server_response(url)
  end
end
