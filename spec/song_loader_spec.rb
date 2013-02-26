require 'spec_helper'
require 'rspec/mocks'
require 'fakeweb' # apparently must be required before fakefs
FakeWeb.allow_net_connect = false
gem 'fakefs', require: 'fakefs/safe'
require 'fakefs/safe'
require 'jimmy_jukebox/song'
require 'jimmy_jukebox/song_loader'

describe "SongLoader" do

  it "should have a SUPPORTED_MUSIC_TYPES of '/\.mp3$|\.ogg$/i'" do
    SongLoader::MUSIC_TYPES.should == /\.mp3$|\.ogg$/i
  end

end

describe SongLoader.new do

  include FakeFS::SpecHelpers

  let(:song1_url) { 'http://archive.org/fletcher_henderson/song1.mp3' }
  let(:song2_url) { 'http://archive.org/fletcher_henderson/song2.ogg' }
  let(:song3_url) { 'http://archive.org/fletcher_henderson/song3.mp3' }
  let(:song4_url) { 'http://archive.org/fletcher_henderson/song4.ogg' }
  let(:song5_url) { 'http://archive.org/fletcher_henderson/song5.mp3' }
  let(:song1) { Song.new('~/Music/JAZZ/fletcher_henderson/song1.mp3') }
  let(:song2) { Song.new('~/Music/JAZZ/fletcher_henderson/song2.ogg') }
  let(:song3) { Song.new('~/Music/JAZZ/fletcher_henderson/song3.mp3') }
  let(:song4) { Song.new('~/Music/JAZZ/fletcher_henderson/song4.ogg') }
  let(:song5) { Song.new('~/Music/JAZZ/fletcher_henderson/song5.mp3') }

  before(:each) do
    ARGV.clear
    @sl = JimmyJukebox::SongLoader.new
  end

  describe "#create_save_dir" do

    it "should create a directory" do
      topdir = File.join("/home","user_name4","Music")
      subdir = File.join(topdir, "rock", "Beatles")
      File.directory?(subdir).should be_false
      @sl.create_save_dir(subdir)
      File.directory?(subdir).should be_true
    end

  end

  describe "#version_of_song_in_any_dir?" do

    it "should return true if song in top of directory tree" do
      topdir = "/home/user_name1/Music"
      songname = "Paperback_Writer.mp3"
      File.directory?(topdir).should be_false
      FileUtils.mkdir_p(topdir)
      File.directory?(topdir).should be_true
      Dir.chdir(topdir)
      File.exists?(songname).should be_false
      FileUtils.touch(songname)
      File.exists?(songname).should be_true
      @sl.version_of_song_in_any_dir?(songname,topdir).should be_true
    end

    it "should return true if song in subdirectory" do
      topdir = "/home/user_name2/Music"
      subdir = File.join(topdir, "rock", "Beatles")
      songname = "Paperback_Writer.mp3"
      File.directory?(subdir).should be_false
      FileUtils.mkdir_p(subdir)
      FileUtils.touch(File.join(subdir, songname))
      File.exists?(File.join(subdir, songname)).should be_true
      @sl.version_of_song_in_any_dir?(songname,subdir).should be_true
    end

    it "should return false if song not in directory tree" do
      topdir = "/home/user_name3/Music"
      subdir = File.join(topdir, "rock", "Beatles")
      songname = "Paperback_Writer.mp3"
      FileUtils.mkdir_p(subdir)
      File.exists?(File.join(subdir, songname)).should be_false
      @sl.version_of_song_in_any_dir?(songname,subdir).should be_false
    end

  end

  describe "test defaults" do

    it "should have a user_config" do
      @sl.user_config.should_not be_nil
    end

    it "should have a user_config with a non-nil default_music_dir" do
      @sl.user_config.default_music_dir.should == File.expand_path("~/Music")
    end

  end

  describe "#original_dixieland_jazz_band without dirname" do
  
    context "no songs yet downloaded" do

      before(:each) do
        @sl.stub!(:version_of_song_in_any_dir?).and_return(false)
        @sl.stub!(:all_subdir_files).and_return([])
        YAML.stub!(:load_file).and_return([song1_url, song2_url, song3_url, song4_url, song5_url])
      end

      context "without max_songs" do

        it "should try to download all songs" do
          @sl.should_receive(:open).exactly(5).times
          @sl.send(:original_dixieland_jazz_band)
        end

      end

      context "with max_songs" do

        it "should try to download only max_songs songs" do
          @sl.should_receive(:open).exactly(3).times
          @sl.send(:original_dixieland_jazz_band, 3)
        end

      end

    end

  end

  describe "#charlie_christian without dirname" do
   
    context "two songs downloaded" do

      before(:each) do
        @sl.stub!(:check_downloaded_song_size).and_return(nil)
        save_dir = @sl.user_config.default_music_dir + artist_name_to_subdir_name("charlie_christian")
        FileUtils.mkdir_p save_dir
        FileUtils.touch File.join(save_dir, File.basename(song1.music_file))
        FileUtils.touch File.join(save_dir, File.basename(song2.music_file))
        YAML.stub!(:load_file).and_return([song1_url, song2_url, song3_url, song4_url, song5_url])
      end

      context "without max_songs" do

        it "should try to download only missing songs" do
          @sl.should_receive(:open).exactly(3).times
          @sl.charlie_christian
        end

      end

      context "with max_songs" do

        it "should try to download only missing songs until hitting max_num" do
          @sl.should_receive(:open).exactly(2).times
          @sl.charlie_christian(4)
        end

      end

    end

    context "all songs already downloaded" do

      before(:each) do
        @sl.stub!(:check_downloaded_song_size).and_return(nil)
        save_dir = @sl.user_config.default_music_dir + artist_name_to_subdir_name("charlie_christian")
        FileUtils.mkdir_p save_dir
        FileUtils.touch File.join(save_dir, File.basename(song1.music_file))
        FileUtils.touch File.join(save_dir, File.basename(song2.music_file))
        FileUtils.touch File.join(save_dir, File.basename(song3.music_file))
        FileUtils.touch File.join(save_dir, File.basename(song4.music_file))
        FileUtils.touch File.join(save_dir, File.basename(song5.music_file))
        YAML.stub!(:load_file).and_return([song1_url, song2_url, song3_url, song4_url, song5_url])
      end

      it "should not download any songs" do
        @sl.should_not_receive(:open)
        @sl.charlie_christian
      end

    end

  end

  describe "#dizzy_gillespie with dirname" do

    it "should try to download three songs" do
      pending "have not yet implemented way to specify artist-specific directory"
      dirname = File.expand_path(@sl.instance_variable_get(:@user_config).default_music_dir + '/JAZZ/Dizzy_Gillespie')
      @sl.stub!(:version_of_song_in_any_dir?).and_return(false)
      @sl.should_receive(:open).exactly(3).times
      @sl.dizzy_gillespie(dirname)
    end

    it "should successfully download three songs" do
      pending "use FakeWeb"
      FakeWeb.register_uri(:any, "http://www.archive.org/download/DizzyGillespie-GroovinHigh/02.GroovinHigh.mp3", :response => "/home/james/Music/JAZZ/Dizzy_Gillespie/Groovin' High 1945.mp3")
      FakeWeb.register_uri(:any, "http://www.archive.org/download/DizzyGillespie-Manteca/01Manteca.ogg", :response => "/home/james/Music/JAZZ/Dizzy_Gillespie/01Manteca.ogg")
      FakeWeb.register_uri(:any, "http://www.archive.org/download/DizzyGillespieLouisArmstrong-UmbrellaMan/DizzyGillespieLouisArmstrong-UmbrellaMan.mp3", :response => "/home/james/Music/JAZZ/Dizzy_Gillespie/DizzyGillespieLouisArmstrong-UmbrellaMan.mp3")
      dirname = File.expand_path("/home/user_name6/non-existent-dir")
      File.exists?(dirname).should be_false
      @sl.dizzy_gillespie(dirname)
      File.exists?(dirname + "/02.GroovinHigh.mp3").should be_true
      File.exists?(dirname + "/01Manteca.ogg").should be_true
      File.exists?(dirname + "/DizzyGillespieLouisArmstrong-UmbrellaMan.mp3").should be_true
      FakeWeb.clean_registry
    end

  end

  describe ".downloadable" do

    it "returns an array with all downloadable songs" do
      songs = [song1_url, song2_url, song3_url, song4_url, song5_url]
      current_songs = [File.basename(song2.music_file), File.basename(song5.music_file)]
      SongLoader.new.downloadable(songs, current_songs).should == [song1_url, song3_url, song4_url]
    end
  end

  describe "call to non-existent method" do

    it "should raise NoMethodError" do
      lambda { @sl.non_existent_method }.should raise_error(NoMethodError)
    end

  end

end
