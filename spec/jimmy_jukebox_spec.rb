require 'jimmy_jukebox'
include JimmyJukebox

# we could override method to prevent songs from actually playing
# module JimmyJukebox
#   def system_yield_pid(*cmd)
#     pid = fork do
#       exec("sleep 3")                # don't actually play song
#       exit! 127
#     end
#     yield pid if block_given?
#     Process.waitpid(pid)
#     $?
#   end
# end

describe Jukebox do

  # THESE TESTS WORK ON MY LOCAL MACHINE, BUT I HAVE NOT MOCKED OUT THE MUSIC DIRECTORIES
  # THE TESTS SHOULD WORK ON YOUR MACHINE IF YOU HAVE A "~/Music" DIRECTORY TREE CONTAINING
  # AT LEAST A FEW OGG AND/OR MP3 FILES

  context "with no command line parameter" do

    before(:each) do
      ARGV.delete_if { |val| true }
    end

    it "can be instantiated" do
      jj = Jukebox.new
      jj.should_not be_nil
      jj.quit
    end

    it "does not complain when ogg123 & mpg123 both installed" do
      jj = Jukebox.new
      jj.should_receive(:`).with("which ogg123").and_return("/usr/bin/ogg123")
      jj.should_receive(:`).with("which mpg123").and_return("/usr/bin/mpg123")
      jj.should_not_receive(:puts)
      jj.send(:set_music_players)
      jj.instance_variable_get(:@ogg_player).should == "ogg123"
      jj.instance_variable_get(:@mp3_player).should == "mpg123"
      jj.quit
    end

    it "does not complain when ogg123 & mpg321 both installed but not mpg123" do
      jj = Jukebox.new
      jj.should_receive(:`).with("which ogg123").and_return("/usr/bin/ogg123")
      jj.should_receive(:`).with("which mpg123").and_return("")
      jj.should_receive(:`).with("which mpg321").and_return("/usr/bin/mpg321")
      jj.should_not_receive(:puts)
      jj.send(:set_music_players)
      jj.instance_variable_get(:@ogg_player).should == "ogg123"
      jj.instance_variable_get(:@mp3_player).should == "mpg321"
      jj.quit
    end

    it "complains when ogg123 installed but mpg123, mpg321, music123 & afplay not installed" do
      jj = Jukebox.new
      jj.instance_variable_set(:@ogg_player, nil)
      jj.instance_variable_set(:@mp3_player, nil)
      jj.should_receive(:`).at_least(:once).with("which ogg123").and_return("/usr/bin/ogg123")
      jj.should_receive(:`).at_least(:once).with("which mpg123").and_return("")
      jj.should_receive(:`).at_least(:once).with("which mpg321").and_return("")
      jj.should_receive(:`).at_least(:once).with("which music123").and_return("")
      jj.should_receive(:`).at_least(:once).with("which afplay").and_return("")
      jj.should_receive(:puts).with("*** YOU CANNOT PLAY MP3S -- YOU MIGHT WANT TO INSTALL MPG123 OR MPG321 ***")
      jj.send(:set_music_players)
      jj.instance_variable_get(:@ogg_player).should == "ogg123"
      jj.instance_variable_get(:@mp3_player).should be_false
      jj.quit
    end

    it "complains when mpg123 installed but ogg123, mpg321, music123 & afplay not installed" do
      jj = Jukebox.new
      jj.instance_variable_set(:@ogg_player, nil)
      jj.instance_variable_set(:@mp3_player, nil)
      jj.should_receive(:`).at_least(:once).with("which ogg123").and_return("")
      jj.should_receive(:`).at_least(:once).with("which music123").and_return("")
      jj.should_receive(:`).at_least(:once).with("which mpg123").and_return("/usr/bin/mpg123")
      jj.should_receive(:`).at_least(:once).with("which afplay").and_return("")
      jj.should_receive(:puts).with("*** YOU CANNOT PLAY OGG FILES -- YOU MIGHT WANT TO INSTALL OGG123 ***")
      jj.send(:set_music_players)
      jj.instance_variable_get(:@ogg_player).should be_false
      jj.instance_variable_get(:@mp3_player).should == "mpg123"
      jj.quit
    end

    it "complains when mpg321 installed but mpg123, music123, ogg123 & afplay not installed" do
      jj = Jukebox.new
      jj.instance_variable_set(:@ogg_player, nil)
      jj.instance_variable_set(:@mp3_player, nil)
      jj.should_receive(:`).at_least(:once).with("which ogg123").and_return("")
      jj.should_receive(:`).at_least(:once).with("which mpg123").and_return("")
      jj.should_receive(:`).at_least(:once).with("which music123").and_return("")
      jj.should_receive(:`).at_least(:once).with("which mpg321").and_return("/usr/bin/mpg321")
      jj.should_receive(:`).at_least(:once).with("which afplay").and_return("")
      jj.should_receive(:puts).with("*** YOU CANNOT PLAY OGG FILES -- YOU MIGHT WANT TO INSTALL OGG123 ***")
      jj.send(:set_music_players)
      jj.instance_variable_get(:@ogg_player).should be_false
      jj.instance_variable_get(:@mp3_player).should == "mpg321"
      jj.quit
    end

    it "prints message and exits when mpg123, mpg321, ogg123, music123 & afplay all not installed" do
      jj = Jukebox.new
      jj.instance_variable_set(:@ogg_player, nil)
      jj.instance_variable_set(:@mp3_player, nil)
      jj.should_receive(:`).at_least(:once).with("which ogg123").and_return("")
      jj.should_receive(:`).at_least(:once).with("which mpg123").and_return("")
      jj.should_receive(:`).at_least(:once).with("which music123").and_return("")
      jj.should_receive(:`).at_least(:once).with("which mpg321").and_return("")
      jj.should_receive(:`).at_least(:once).with("which afplay").and_return("")
      error_msg = "*** YOU CANNOT PLAY MP3S OR OGG FILES -- YOU MIGHT WANT TO INSTALL ogg123 AND mpg123/mpg321 BEFORE USING JIMMYJUKEBOX ***"
      jj.should_receive(:puts).with(error_msg)
      lambda { jj.send(:set_music_players) }.should raise_error SystemExit
      jj.quit
    end

    #it "raises exception when no songs available"
    #  lambda do
    #    jj = Jukebox.new
    #  end.should raise_error
    #end

    it "generates a non-empty song list" do
      jj = Jukebox.new
      jj.instance_variable_get(:@songs).should_not be_nil
      jj.instance_variable_get(:@songs).should_not be_empty
      jj.instance_variable_get(:@songs).length.should be > 0
    end

    it "generates a non-empty song list with only mp3 & ogg files" do
      jj = Jukebox.new
      jj.instance_variable_get(:@songs).each do |song|
        song.should match(/.*\.mp3|.*\.ogg/i)
      end
    end

    it "can play" do
      jj = Jukebox.new
      thread = Thread.new do
        jj.play
      end
      sleep 5
      jj.instance_variable_get(:@playing_pid).should_not be_nil
      jj.quit
    end

    it "can play_loop" do
      jj = Jukebox.new
      thread = Thread.new do
        jj.play_loop
      end
      sleep 5
      jj.loop.should be_true
      jj.playing_pid.should_not be_nil
      jj.quit
    end

    it "can skip a song" do
      jj = Jukebox.new
      thread = Thread.new do
        jj.play_loop
      end
      sleep 3
      song_1 = jj.playing_pid
      jj.skip_song
      sleep 3
      song_2 = jj.playing_pid
      jj.skip_song
      sleep 3
      song_3 = jj.playing_pid
      song_1.should_not == song_2 || song_2.should_not == song_3
      jj.quit
    end

    it "can pause the current song" do
      jj = Jukebox.new
      #jj.should_receive(:play).at_least(:once)
      #jj.should_receive(:pause_current_song).exactly(:once)
      thread = Thread.new do
        jj.play
      end
      sleep 5
      song_1 = jj.playing_pid
      jj.pause_current_song
      sleep 1
      song_2 = jj.playing_pid
      song_1.should == song_2
      jj.current_song_paused.should be_true
      jj.quit
    end

    it "can unpause a paused song" do
      jj = Jukebox.new
      #jj.should_receive(:play).at_least(:once)
      #jj.should_receive(:pause_current_song).exactly(:twice)
      #jj.should_receive(:unpause_current_song).exactly(:twice)
      thread = Thread.new do
        jj.play
      end
      sleep 5
      song_1 = jj.playing_pid
      jj.pause_current_song
      song_1 = jj.playing_pid
      jj.current_song_paused.should be_true
      jj.unpause_current_song
      song_2 = jj.playing_pid
      song_1.should == song_2
      jj.current_song_paused.should be_false
      jj.pause_current_song
      song_3 = jj.playing_pid
      song_2.should == song_3
      jj.current_song_paused.should be_true
      song_4 = jj.playing_pid
      song_3.should == song_4
      jj.unpause_current_song
      jj.current_song_paused.should be_false
      jj.quit
    end
  end

  context "with valid music directory as command line parameter" do

    before(:each) do
      ARGV.delete_if { |val| true }
      ARGV << File.expand_path("~/Music")
    end

    it "can skip a song" do
      jj = Jukebox.new
      thread = Thread.new do
        jj.play_loop
      end
      sleep 3
      song_1 = jj.playing_pid
      jj.skip_song
      sleep 3
      song_2 = jj.playing_pid
      jj.skip_song
      sleep 3
      song_3 = jj.playing_pid
      song_1.should_not == song_2 || song_2.should_not == song_3
      jj.quit
    end

  end

end
