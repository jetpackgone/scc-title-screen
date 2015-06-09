#==============================================================================
# +++ MOG - Hijiri Title Screen (v1.0) +++
#==============================================================================
# By Moghunter 
# http://www.atelier-rgss.com/
#==============================================================================
# Tela de título animada com o tema da Hijiri Byakuren, para os fans de Touhou.
# Naturalmente é possível customizar qualquer tipo de personagem.
#==============================================================================
module MOG_HIJIRI_TITLE_SCRREN
  BACKGROUND_SCROLL_SPEED = [0,0]
  COMMAND_POSITION = [-10, 350]
  FG_POSITION = [130, -110]
  FG1_POSITION = [0, 0]
  FG2_POSITION = [130, -110]
  FG3_POSITION = [130, -110]
  BG1_POSITION = [-55, 352]
  BG2_POSITION = [-55, 235]
  BG3_POSITION = [-55, 170]
  BG4_POSITION = [-55, -15]
  FULLSCREEN_POSITION = [262, 370]
  VERSION_POSITION = [465, 352]
  $LOGO = false
  LOGO_DURATION = 2
  TRASITION_DURATION = 45
  MOVIE = "Logo"
  LOGO_ME = ["logo", 100, 100] #[Logo Sound, Volume, Pitch]
end

$imported = {} if $imported.nil?
$imported[:mog_hijiri_title_screen] = true

#==============================================================================
# ■ Scene Title
#==============================================================================
class Scene_Title
  include MOG_HIJIRI_TITLE_SCRREN
  @fade = 0
  @move_x = 0
  @move_y = 0
  @direction = 0
  $count = 0
  $stayfocused = 0
  #--------------------------------------------------------------------------
  # ● Main
  #--------------------------------------------------------------------------        
  def main
      execute_logo if $LOGO
      Graphics.play_movie("Movies/" + MOVIE) if $LOGO
      $data_system.title_bgm.play
      Graphics.update
      Graphics.freeze
      execute_setup
      execute_loop
      dispose
      $LOGO = false

  end  
  
  #--------------------------------------------------------------------------
  # ● Execute Setup
  #--------------------------------------------------------------------------        
  def execute_setup
      @phase = 0
      @active = false
      @continue_enabled = DataManager.save_file_exists?
      @com_index = @continue_enabled ? 1 : 0
      @com_index_old = @com_index
      @com_index_max = 1
      create_sprites
  end
  
  #--------------------------------------------------------------------------
  # ● Execute Lopp
  #--------------------------------------------------------------------------        
  def execute_loop
    Graphics.transition(TRASITION_DURATION)
    play_title_music   
    loop do
      Input.update
      update
      Graphics.update
      break if SceneManager.scene != self
    end
  end
      
 end
 
 
#==============================================================================
# ■ Scene Title
#==============================================================================
class Scene_Title
  #--------------------------------------------------------------------------
  # ● Execute Logo
  #--------------------------------------------------------------------------    
  def execute_logo
    RPG::ME.new(*LOGO_ME).play
    Graphics.transition
    create_logo
    loop do
      Input.update
      update_logo
      Graphics.update
      break if !@logo_phase
    end
    dispose_logo
  end
  
  #--------------------------------------------------------------------------
  # ● Create Logo
  #--------------------------------------------------------------------------      
  def create_logo
      @logo = Sprite.new
      @logo.z = 100
      @logo.opacity = 0
      @logo_duration = [0,60 * LOGO_DURATION]
      @logo.bitmap = Cache.title1("Logo") rescue nil
      @logo_phase = @logo.bitmap != nil ? true : false      
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Logo
  #--------------------------------------------------------------------------       
  def dispose_logo      
      Graphics.freeze
      @logo.bitmap.dispose if @logo.bitmap != nil
      @logo.dispose
  end
  
  #--------------------------------------------------------------------------
  # ● Update Logo
  #--------------------------------------------------------------------------      
  def update_logo  
      return if !@logo_phase
      update_logo_command
      if @logo_duration[0] == 0
         @logo.opacity += 5
         @logo_duration[0] = 1 if @logo.opacity >= 255
       elsif @logo_duration[0] == 1
         @logo_duration[1] -= 1
         @logo_duration[0] = 2 if @logo_duration[1] <= 0
       else  
         @logo.opacity -= 5
         @logo_phase = false if @logo.opacity <= 0
       end
  end
  
  #--------------------------------------------------------------------------
  # ● Update Logo Command
  #--------------------------------------------------------------------------      
  def update_logo_command
      return if @logo_duration[0] == 2
      if Input.trigger?(:C) or Input.trigger?(:B)
         @logo_duration = [2,0]
         RPG::ME.fade(600)
      end
  end
  
end

#==============================================================================
# ■ Scene Title
#==============================================================================
class Scene_Title
  
  #--------------------------------------------------------------------------
  # ● Create Sprites
  #--------------------------------------------------------------------------          
  def create_sprites
      create_background
      create_commands
      create_fullscreen
      create_version
      create_FG2
      create_FG3
      create_BG1
      create_BG2
      create_BG3
      create_BG4
  end
    
  #--------------------------------------------------------------------------
  # ● Create Background
  #--------------------------------------------------------------------------            
  def create_background
      @background = Plane.new
      @background.bitmap = Cache.title1("FG1light")
      @background_scroll = [BACKGROUND_SCROLL_SPEED[0],BACKGROUND_SCROLL_SPEED[1],0]
      @background.z = 10
  end

  #--------------------------------------------------------------------------
  # ● Create Foreground Objects
  #-------------------------------------------------------------------------- 
  def create_FG2
      @FG2 = Sprite.new
      @FG2.bitmap = Cache.title1("FG2lampblur")
      @FG2.ox = @FG2.bitmap.width / 2
      @FG2.oy = @FG2.bitmap.height / 2
      @FG2.x = @FG2.ox + FG2_POSITION[0]
      @FG2.y = @FG2.oy + FG2_POSITION[1]
      @FG2.z = 9
      @FG2.blend_type = 0
      @FG2.opacity = 255
  end  
                
  def create_FG3
      @FG3 = Sprite.new
      @FG3.bitmap = Cache.title1("FG3lamp")
      @FG3.ox = @FG3.bitmap.width / 2
      @FG3.oy = @FG3.bitmap.height / 2
      @FG3.x = @FG3.ox + FG3_POSITION[0]
      @FG3.y = @FG3.oy + FG3_POSITION[1]
      @FG3.z = 8
      @FG3.blend_type = 0
      @FG3.opacity = 255 - @FG2.opacity
    end
    
  #--------------------------------------------------------------------------
  # ● Create Background Objects
  #-------------------------------------------------------------------------- 
  def create_BG1
      @BG1 = Sprite.new
      @BG1.bitmap = Cache.title1("BG1road")
      @BG1.ox = @BG1.bitmap.width / 2
      @BG1.oy = @BG1.bitmap.height / 2
      @BG1.x = @BG1.ox + BG1_POSITION[0]
      @BG1.y = @BG1.oy + BG1_POSITION[1]
      @BG1.z = 6
      @BG1.blend_type = 0
      @BG1.opacity = 255
  end

  def create_BG2
      @BG2 = Sprite.new
      @BG2.bitmap = Cache.title1("BG2cat")
      @BG2.ox = @BG2.bitmap.width / 2
      @BG2.oy = @BG2.bitmap.height / 2
      @BG2.x = @BG2.ox + BG2_POSITION[0]
      @BG2.y = @BG2.oy + BG2_POSITION[1]
      @BG2.z = 5
      @BG2.blend_type = 0
      @BG2.opacity = 255
  end

  def create_BG3
      @BG3 = Sprite.new
      @BG3.bitmap = Cache.title1("BG3fence")
      @BG3.ox = @BG3.bitmap.width / 2
      @BG3.oy = @BG3.bitmap.height / 2
      @BG3.x = @BG3.ox + BG3_POSITION[0]
      @BG3.y = @BG3.oy + BG3_POSITION[1]
      @BG3.z = 5
      @BG3.blend_type = 0
      @BG3.opacity = 255
  end
    
  def create_BG4
      @BG4 = Sprite.new
      @BG4.bitmap = Cache.title1("BG4tree")
      @BG4.ox = @BG4.bitmap.width / 2
      @BG4.oy = @BG4.bitmap.height / 2
      @BG4.x = @BG4.ox + BG4_POSITION[0]
      @BG4.y = @BG4.oy + BG4_POSITION[1]
      @BG4.z = 5
      @BG4.blend_type = 0
      @BG4.opacity = 255
  end
  
  #--------------------------------------------------------------------------
  # ● Create Layout
  #--------------------------------------------------------------------------              
  def create_fullscreen
      @fullscreen = Sprite.new
      @fullscreen.bitmap = Cache.title1("fullscreen")
      @fullscreen.ox = @fullscreen.bitmap.width / 2
      @fullscreen.oy = @fullscreen.bitmap.height / 2
      @fullscreen.x = @fullscreen.ox + FULLSCREEN_POSITION[0]
      @fullscreen.y = @fullscreen.oy + FULLSCREEN_POSITION[1]
      @fullscreen.z = 20
      @fullscreen.opacity = 255
  end

  def create_version
      @version = Sprite.new
      @version.bitmap = Cache.title1("version")
      @version.ox = @version.bitmap.width / 2
      @version.oy = @version.bitmap.height / 2
      @version.x = @version.ox + VERSION_POSITION[0]
      @version.y = @version.oy + VERSION_POSITION[1]
      @version.z = 20
      @version.opacity = 150
  end
    
  #--------------------------------------------------------------------------
  # ● Create Commands
  #--------------------------------------------------------------------------                
  def create_commands
      @com = []
      for index in 0...2
          @com.push(Title_Commands.new(nil,index))
      end 
  end
 
end

#==============================================================================
# ■ Title Commands
#==============================================================================
class Title_Commands < Sprite
  include MOG_HIJIRI_TITLE_SCRREN
  
  #--------------------------------------------------------------------------
  # ● Initialize
  #--------------------------------------------------------------------------  
  def initialize(viewport = nil,index)
    super(viewport)
    @index = index
    @float = [0,0,0]
    self.bitmap = Cache.title1("Command" + index.to_s)
    self.ox = self.bitmap.width / 2
    self.oy = self.bitmap.height / 2 
    @org_pos = [COMMAND_POSITION[0] + self.ox,
      COMMAND_POSITION[1] + self.oy + (self.bitmap.height + 2) * index,
      self.ox - 24]
    self.x = @org_pos[0] + 20 # - self.bitmap.width - (self.bitmap.width * index)
    self.y = @org_pos[1]
    self.z = 25
    self.opacity = 120
    self.visible = true
    @next_pos = [@org_pos[0],@org_pos[1]]
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------  
  def dispose_sprites
    self.bitmap.dispose
  end
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------              
  def update_sprites(index,active)
    #return if !active 
    if index == @index
      self.opacity += 10 
      @next_pos[0] = @org_pos[0]
      update_float_effect   
    else
      self.opacity -= 10 if self.opacity > 120
      #@next_pos[0] = @org_pos[2]
      @float = [0,0,0]
    end  
    #update_slide(0, @next_pos[0])
    #update_slide(1,@org_pos[1] + @float[0])
  end
  
 #--------------------------------------------------------------------------
 # ● Update Slide
 #--------------------------------------------------------------------------                       
  def update_slide(type,np)
    cp = type == 0 ? self.x : self.y
    sp = 3 + ((cp - np).abs / 10)
    if cp > np 
      cp -= sp
      cp = np if cp < np
    elsif cp < np 
      cp += sp
      cp = np if cp > np
    end     
    self.x = cp if type == 0
    self.y = cp if type == 1
  end
  
  #--------------------------------------------------------------------------
  # ● Update Float Effect
  #--------------------------------------------------------------------------                
  def update_float_effect
    @float[2] += 1
    return if @float[2] < 5
    @float[2] = 0
    @float[1] += 1
    case @float[1]
      when 1..5
        @float[0] -= 1
      when 6..15   
        @float[0] += 1
      when 16..20  
        @float[0] -= 1
      else  
        @float[0] = 0
        @float[1] = 0
    end
  end
  
end

#==============================================================================
# ■ Scene Title
#==============================================================================
class Scene_Title
  
  #--------------------------------------------------------------------------
  # ● Dispose
  #--------------------------------------------------------------------------          
  def dispose
    Graphics.freeze
    dispose_background
    dispose_fullscreen
    dispose_version
    dispose_commands
    dispose_FG2
    dispose_FG3
    dispose_BG1
    dispose_BG2
    dispose_BG3
    dispose_BG4
  end
    
  #--------------------------------------------------------------------------
  # ● Dispose Background
  #--------------------------------------------------------------------------            
  def dispose_background
    @background.bitmap.dispose
    @background.dispose      
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Foreground Objects
  #--------------------------------------------------------------------------            
  def dispose_FG2
    return if @FG2 == nil
    @FG2.bitmap.dispose
    @FG2.dispose
  end
  
  def dispose_FG3
    return if @FG3 == nil
    @FG3.bitmap.dispose
    @FG3.dispose
  end  

  #--------------------------------------------------------------------------
  # ● Dispose Background Objects
  #-------------------------------------------------------------------------- 
  def dispose_BG1
    return if @BG1 == nil
    @BG1.bitmap.dispose
    @BG1.dispose
  end
  
  def dispose_BG2
    return if @BG2 == nil
    @BG2.bitmap.dispose
    @BG2.dispose
  end

  def dispose_BG3
    return if @BG3 == nil
    @BG3.bitmap.dispose
    @BG3.dispose
  end
  
  def dispose_BG4
    return if @BG4 == nil
    @BG4.bitmap.dispose
    @BG4.dispose
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Layout
  #--------------------------------------------------------------------------              
  def dispose_fullscreen
    @fullscreen.bitmap.dispose
    @fullscreen.dispose
  end  
    
  def dispose_version
    @version.bitmap.dispose
    @version.dispose
  end
  
  #--------------------------------------------------------------------------
  # ● Dispose Commands
  #--------------------------------------------------------------------------                
  def dispose_commands
    @com.each {|sprite| sprite.dispose_sprites }
  end  
 
end

#==============================================================================
# ■ Scene Title
#==============================================================================
class Scene_Title
  
  #--------------------------------------------------------------------------
  # ● Update Sprites
  #--------------------------------------------------------------------------          
  def update_sprites
    update_background
    update_graphics
    update_commands
    update_fullscreen
  end
    
  #--------------------------------------------------------------------------
  # ● Update Background
  #--------------------------------------------------------------------------            
  def update_background
    @background_scroll[2] += 1
    return if @background_scroll[2] < 4
    @background_scroll[2] = 0
    @background.ox += @background_scroll[0]
    @background.oy += @background_scroll[1]
  end  
  
  #--------------------------------------------------------------------------
  # ● Update Graphics
  #--------------------------------------------------------------------------            
  def update_graphics
    if @fade == 0
      @FG2.opacity -= 5 * rand(3)
      @FG3.opacity = 255 - @FG2.opacity if !($stayfocused == 90)
      @fade = 1 if @FG2.opacity <= 0 && $stayfocused == 90
      $stayfocused = 0 if $stayfocused == 90
      $stayfocused += 1
    else
      @FG2.opacity += 5 * rand(3)
      @FG3.opacity = 255 - @FG2.opacity 
      @fade = 0 if @FG2.opacity >= 255
    end
    
    if $count == 1
      @x_direction = rand(2) # 1 if positive, else negative
      @y_direction = rand(2) # 1 if positive, else negative
    end
    
    if @x_direction == 1
      @BG4.x += 1 unless @BG4.x == @BG4.ox + BG4_POSITION[0] + 1 
      @BG3.x += 1 unless @BG3.x == @BG3.ox + BG3_POSITION[0] + 2 || $count/3 == 0
      @BG2.x += 1 unless @BG2.x == @BG2.ox + BG2_POSITION[0] + 3 || $count/2 == 0
      @BG1.x += 1 unless @BG1.x == @BG1.ox + BG1_POSITION[0] + 4 || $count/1 == 0
      @FG2.x += 1 unless @FG2.x == @FG2.ox + FG2_POSITION[0] + 6
      @FG3.x += 1 unless @FG3.x == @FG3.ox + FG3_POSITION[0] + 6
    else
      @BG4.x -= 1 unless @BG4.x == @BG4.ox + BG4_POSITION[0]
      @BG3.x -= 1 unless @BG3.x == @BG3.ox + BG3_POSITION[0] || $count/3 == 0
      @BG2.x -= 1 unless @BG2.x == @BG2.ox + BG2_POSITION[0] || $count/2 == 0
      @BG1.x -= 1 unless @BG1.x == @BG1.ox + BG1_POSITION[0] || $count/1 == 0
      @FG2.x -= 1 unless @FG2.x == @FG2.ox + FG2_POSITION[0]
      @FG3.x -= 1 unless @FG3.x == @FG3.ox + FG3_POSITION[0]
    end

    if @y_direction == 1
      @BG4.y += 1 unless @BG4.y == @BG4.oy + BG4_POSITION[1] + 1
      @BG3.y += 1 unless @BG3.y == @BG3.oy + BG3_POSITION[1] + 2 || $count/3 == 0
      @BG2.y += 1 unless @BG2.y == @BG2.oy + BG2_POSITION[1] + 3 || $count/2 == 0
      @BG1.y += 1 unless @BG1.y == @BG1.oy + BG1_POSITION[1] + 4 || $count/1 == 0
      @FG2.y += 1 unless @FG2.y == @FG2.oy + FG2_POSITION[1] + 6 
      @FG3.y += 1 unless @FG3.y == @FG3.oy + FG3_POSITION[1] + 6 
    else
      @BG4.y -= 1 unless @BG4.y == @BG4.oy + BG4_POSITION[1]
      @BG3.y -= 1 unless @BG3.y == @BG3.oy + BG3_POSITION[1] || $count/3 == 0
      @BG2.y -= 1 unless @BG2.y == @BG2.oy + BG2_POSITION[1] || $count/2 == 0
      @BG1.y -= 1 unless @BG1.y == @BG1.oy + BG1_POSITION[1] || $count/1 == 0
      @FG2.y -= 1 unless @FG2.y == @FG2.oy + FG2_POSITION[1] 
      @FG3.y -= 1 unless @FG3.y == @FG3.oy + FG3_POSITION[1] 
    end
    $count = 0 if $count == 6
    $count += 1
  end
  
  def update_fullscreen
    if $fade == 0
      @fullscreen.opacity -= 2
      $fade = 1 if @fullscreen.opacity <= 155
    else
      @fullscreen.opacity += 2
      $fade = 0 if @fullscreen.opacity >= 255
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Update Commands
  #--------------------------------------------------------------------------                
  def update_commands
      @com.each {|sprite| sprite.update_sprites(@com_index,@active)}
  end
    
end

#==============================================================================
# ■ Scene Title
#==============================================================================
class Scene_Title
  
  #--------------------------------------------------------------------------
  # ● Update
  #--------------------------------------------------------------------------          
  def update
      update_command
      update_sprites
  end
  
  #--------------------------------------------------------------------------
  # ● Update Command
  #--------------------------------------------------------------------------          
  def update_command
      update_key
      refresh_index if @com_index_old != @com_index
  end
    
  #--------------------------------------------------------------------------
  # ● Update Key
  #--------------------------------------------------------------------------            
  def update_key
      if Input.trigger?(:DOWN)
         add_index(1) 
      elsif Input.trigger?(:UP)
         add_index(-1)
      elsif Input.trigger?(:C)  
         select_command
      end  
  end
  
  #--------------------------------------------------------------------------
  # ● Select Command
  #--------------------------------------------------------------------------              
  def select_command
      case @com_index
         when 0; command_new_game
         when 1; command_continue
      end
  end
  
  #--------------------------------------------------------------------------
  # ● Add Index
  #--------------------------------------------------------------------------              
  def add_index(value = 0)
      if !@continue_enabled and @com_index == 0
        @com_index = 0 if value == 1
        @com_index = 0 if value == -1
      end
      @com_index += value
      @com_index = 0 if @com_index > @com_index_max
      @com_index = @com_index_max if @com_index < 0
  end
  
  #--------------------------------------------------------------------------
  # ● Refresh Index
  #--------------------------------------------------------------------------            
  def refresh_index
      @com_index_old = @com_index
      Sound.play_cursor
  end
  
  #--------------------------------------------------------------------------
  # ● Command New Game
  #--------------------------------------------------------------------------            
  def command_new_game
      Sound.play_ok
      DataManager.setup_new_game
      fadeout_all
      $game_map.autoplay
      SceneManager.goto(Scene_Map)      
  end

  #--------------------------------------------------------------------------
  # ● Command Continue
  #--------------------------------------------------------------------------            
  def command_continue
      if !@continue_enabled
         Sound.play_cancel
         return
      else   
         Sound.play_ok
      end  
      SceneManager.call(Scene_Load)
  end    
  
  #--------------------------------------------------------------------------
  # ● Command Shutdown
  #--------------------------------------------------------------------------            
  def command_shutdown
      Sound.play_ok
      fadeout_all
      SceneManager.exit    
  end

  #--------------------------------------------------------------------------
  # ● Command gallery
  #--------------------------------------------------------------------------  
  def command_gallery
    Sound.play_ok
    Graphics.fadeout(time * Graphics.frame_rate / 1000)
    SceneManager.call(Character_Gallery)
  end
  
  #--------------------------------------------------------------------------
  # ● play_title_music
  #--------------------------------------------------------------------------
  def play_title_music
      $data_system.title_bgm.play
      RPG::BGS.stop
      RPG::ME.stop
  end  
  
  #--------------------------------------------------------------------------
  # ● Fadeout_all
  #--------------------------------------------------------------------------
  def fadeout_all(time = 500)
      RPG::BGM.fade(time)
      RPG::BGS.fade(time)
      RPG::ME.fade(time)
      Graphics.fadeout(time * Graphics.frame_rate / 1000)
      RPG::BGM.stop
      RPG::BGS.stop
      RPG::ME.stop
  end  
  
end