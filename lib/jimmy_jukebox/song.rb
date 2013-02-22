module JimmyJukebox

  class Song

    class InvalidSongFormatException < Exception; end
    class NoPlayingPidException < Exception; end
    class UnsupportedSongFormatException < Exception; end
    class CannotSpawnProcessException < Exception; end
    class SongTerminatedPrematurelyException < Exception; end

    attr_reader   :music_file
    attr_writer   :paused
    attr_accessor :player, :playing_pid

    def initialize(in_music_file)
      set_music_file(in_music_file)
      self.paused = false
      self.playing_pid = nil
    end

    def paused?
      @paused
    end

    def set_music_file(in_music_file)
      if in_music_file =~ /\.mp3$/i || in_music_file =~ /\.ogg$/i
        @music_file = in_music_file
      else
        raise InvalidSongFormatException, "JimmyJukebox plays only .mp3/.ogg files. #{in_music_file} is not valid"
      end
    end

    def grandchild_pid
      # returns grandchild's pid if the child process spawns a grandchild
      # if so, the child is probably "/bin/sh" and the grandchild is "mpg123" or similar
      gpid = `ps h --ppid #{playing_pid} -o pid`.strip.to_i
      gpid == 0 ? nil : gpid
    end

    def pause
      self.paused = true
      # jruby doesn't seem to handle system() correctly
      # trying backticks
      # system("kill -s STOP #{playing_pid}") if playing_pid
      if grandchild_pid
        `kill -s STOP #{grandchild_pid}`
      elsif playing_pid
        `kill -s STOP #{playing_pid}`
      else
        raise NoPlayingPidException, "*** Can't pause song because can't find playing_pid #{playing_pid} ***"
      end
    end

    def unpause
      self.paused = false
      # jruby doesn't seem to handle system() correctly
      # trying backticks
      #system("kill -s CONT #{playing_pid}") if playing_pid
      if grandchild_pid
        `kill -s CONT #{grandchild_pid}`
      elsif playing_pid
        `kill -s CONT #{playing_pid}`
      else
        raise NoPlayingPidException, "*** Can't unpause song because can't find playing_pid #{playing_pid} ***"
      end
    end

    def kill_playing_pid_and_children
      grandpid = grandchild_pid
      playpid = playing_pid
      if grandpid
        `kill #{grandpid}`
        p "killed #{grandpid}"
      end
      `kill #{playpid}`
    end

    def terminate
      self.paused = false
      self.player = nil
      if playing_pid
        kill_playing_pid_and_children
        self.playing_pid = nil
      else
        raise NoPlayingPidException, "*** Can't terminate song because can't find playing_pid #{playing_pid} ***"
      end
    end

    def set_player(user_config)
      if music_file =~ /\.mp3$/i
        self.player = user_config.mp3_player
      elsif music_file =~ /\.ogg$/i
        self.player = user_config.ogg_player
      else
        raise UnsupportedSongFormatException, "Attempted to play a file format this program cannot play"
      end
    end

    def play(user_config, jukebox)
      set_player(user_config)
      process_status = play_with_player
      process_status.exitstatus.to_i == 0 ? (self.playing_pid = nil) : (raise SongTerminatedPrematurelyException, "Experienced a problem playing a song")
    end

    def play_with_player
      p "Now playing '#{music_file}'"
      p "Press Ctrl-C to stop the music and exit this program"
      music_file_path = File.expand_path(music_file)
      run_command(player, music_file_path)
      p "playing_pid = " + playing_pid.to_s
      #system_yield_pid(player, music_file_path) do |pid|
      #  self.playing_pid = pid 
      #end
      #if $running_jruby
        Process.waitpid(playing_pid) # Waits for a child process to exit, returns its process id, and sets $? to a Process::Status object
      #else
      #  Process::waitpid(playing_pid)
      #end
      p "Stopped waiting"
      $? # return Process::Status object with instance methods .stopped?, .exited?, .exitstatus
    end

  end

  def run_command(command, arg)
    if $running_jruby
      pid = Spoon.spawnp(command,arg)
    else
      begin
        pid = POSIX::Spawn::spawn(command + ' ' + arg)
        #pgid = Process.getpgid(pid)
        #child = POSIX::Spawn::Child.new(command + ' ' + arg)
        #pid = child.status.pid
        
        # create and run block in subprocess (which will terminate with status 0), capture subprocess pid
        #pid = Process.fork do
        #  exec(command + ' ' + arg)  # replace new process with system call
        #  exit! 127                  # exit process and return exit status 127; should never be reached
        #end
      rescue NotImplementedError
        raise CannotSpawnProcessException, "*** Cannot play music because we found neither Spoon.spawnp (for JRuby) nor Process.fork (for MRI) ***"
      end
    end
    self.playing_pid = pid
  end

  # make system call and get pid so you can terminate process
  def system_yield_pid(command,arg)
    # would like to use Process.respond_to?(:fork) but JRuby mistakenly returns true
    if $running_jruby
      pid = Spoon.spawnp(command,arg)
    else
      begin
        #spawn(command + ' ' + arg)
        #pid = POSIX::Spawn::spawn(command + ' ' + arg)
        
        # create and run block in subprocess (which will terminate with status 0), capture subprocess pid
        pid = Process.fork do
          exec(command + ' ' + arg)  # replace new process with system call
          exit! 127                  # exit process and return exit status 127; should never be reached
        end
      rescue NotImplementedError
        raise CannotSpawnProcessException, "*** Cannot play music because we found neither Spoon.spawnp (for JRuby) nor Process.fork (for MRI) ***"
      end
    end
    yield pid if block_given? # call block, passing in the subprocess pid
  end

end
