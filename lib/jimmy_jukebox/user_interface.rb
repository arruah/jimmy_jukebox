jj = Jukebox

play_loop_thread = Thread.new do
  jj.play_loop
end

display_string = "Press 'p' to (un)pause, 'q' to quit, or 's' to skip the song"
begin
  while true do
    puts display_string
    line = Readline.readline('> ', true)
    case line.strip
    when "q"
      puts "Quit requested"
      jj.quit
      Thread.main.exit
    when "p"
      if play_loop_thread && jj.current_song.paused
        puts "Unpause requested"
        jj.unpause_current_song
      elsif play_loop_thread
        puts "Pause requested"
        jj.pause_current_song
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
  exit
end

play_loop_thread.join
