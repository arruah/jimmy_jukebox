require 'jimmy_jukebox'
include JimmyJukebox

jj = Jukebox.new

play_loop_thread = Thread.new do
  jj.play_loop
end

input_thread = Thread.new do
  display_string = "Press 'p' to (un)pause, 'q' to quit, or 's' to skip the song"
  begin
    while true do
      puts display_string
      line = Readline.readline('> ', true)
      case line.strip
      when "q"
        puts "Quit requested"
        playing_pid = jj.playing_pid if play_loop_thread && jj.playing_pid
        play_loop_thread.exit
        Process.kill("SIGHUP",playing_pid) if playing_pid
        Thread.main.exit
      when "p"
        if play_loop_thread && jj.current_song_paused
          puts "Unpause requested"
          jj.unpause_current_song
          #play_loop_thread.run
        elsif play_loop_thread
          puts "Pause requested"
          jj.pause_current_song
          #play_loop_thread.stop
        else
          raise "Can't find play_loop_thread"
        end
        puts display_string
      when "s"
        puts "Skip song requested"
        jj.skip_song
      else
        puts display_string
      end
    end
  rescue Interrupt => e
    puts "\nMusic terminated by user"
    system('stty', jj.stty_save)
    exit
  end
end

play_loop_thread.join
input_thread.join

