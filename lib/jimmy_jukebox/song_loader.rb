require 'open-uri'
require 'fileutils'
require 'yaml'

module JimmyJukebox

  module SongLoader

    DEFAULT_MUSIC_ROOT_DIR = "~/Music"
    MP3_OGG_REGEXP = /\.mp3$|\.ogg$/i

    def self.original_dixieland_jazz_band(save_dir = DEFAULT_MUSIC_ROOT_DIR + "/JAZZ/Original_Dixieland_Jazz_Band")
      songs = YAML::load_file(File.dirname(__FILE__) + "/OriginalDixielandJazzBand.yml")
      download_songs(songs, save_dir)
    end

    def self.benny_goodman(save_dir = DEFAULT_MUSIC_ROOT_DIR + "/JAZZ/Benny_Goodman")
      songs = [
               "http://www.archive.org/download/BennyGoodmanQuartetAndTrio/AfterYouveGone-BennyGoodmanGeneKrupaTeddyWilson1935.mp3",
               "http://www.archive.org/download/BennyGoodmanQuartetAndTrio/BodySoul-BennyGoodmanGeneKrupaTeddyWilsoncarnegieHall1938.mp3",
               "http://www.archive.org/download/BennyGoodmanQuartetAndTrio/Moonglow-BennyGoodmanGeneKrupaTeddyWilsonLionelHampton1936.mp3",
               "http://www.archive.org/download/BennyGoodmanQuartetAndTrio/Whispering-BennyGoodmanGeneKrupaTeddyWilsonLionelHampton1936.mp3",
               "http://www.archive.org/download/BennyGoodman1-10of275/BenPollacBandJackTeagardenBennyGoodman-DeedIDo1929.mp3",
               "http://www.archive.org/download/BennyGoodman1-10of275/BenPollackHisCaliforniansWithBennyGoodman-deedIDo1927.mp3",
               "http://www.archive.org/download/BennyGoodman1-10of275/BenSelvinsKnickerbockersclarinetebennyGoodman-TodoEsParaTi1931.mp3",
               "http://www.archive.org/download/BennyGoodman1-10of275/BennyGoodman-ASmo-o-o-othOne.mp3",
               "http://www.archive.org/download/BennyGoodman1-10of275/BennyGoodman-AStringOfPearls.mp3",
               "http://www.archive.org/download/BennyGoodman1-10of275/BennyGoodman-Ac-dcCurrent.mp3",
               "http://www.archive.org/download/BennyGoodman1-10of275/BennyGoodman-AfraidToDream1937.mp3",
               "http://www.archive.org/download/BennyGoodman1-10of275/BennyGoodman-AfterYouveGone.mp3",
               "http://www.archive.org/download/BennyGoodman1-10of275/BennyGoodman-AlexandersRagtimeBand.mp3",
               "http://www.archive.org/download/BennyGoodman11-20of275/BennyGoodman-AllOfMe1937.mp3",
               "http://www.archive.org/download/BennyGoodman11-20of275/BennyGoodman-AllTheCatsJoinIn.mp3",
               "http://www.archive.org/download/BennyGoodman11-20of275/BennyGoodman-AllTheCatsdisney.mp3",
               "http://www.archive.org/download/BennyGoodman11-20of275/BennyGoodman-Always.mp3",
               "http://www.archive.org/download/BennyGoodman11-20of275/BennyGoodman-AlwaysAndAlways.mp3",
               "http://www.archive.org/download/BennyGoodman11-20of275/BennyGoodman-AmIBlue1937.mp3",
               "http://www.archive.org/download/BennyGoodman11-20of275/BennyGoodman-Amapola.mp3",
               "http://www.archive.org/download/BennyGoodman11-20of275/BennyGoodman-AndTheAnglesSing.mp3",
               "http://www.archive.org/download/BennyGoodman11-20of275/BennyGoodman-AnythingForYou.mp3",
               "http://www.archive.org/download/BennyGoodman11-20of275/BennyGoodman-BachGoesToTown.mp3",
               "http://www.archive.org/download/BennyGoodman21-30of275/BennyGoodman-BackHomeAgainInIndiana.mp3",
               "http://www.archive.org/download/BennyGoodman21-30of275/BennyGoodman-BeautifulChanges1937.mp3",
               "http://www.archive.org/download/BennyGoodman21-30of275/BennyGoodman-BeethovenLoEscribioPeroTieneSwing.mp3",
               "http://www.archive.org/download/BennyGoodman21-30of275/BennyGoodman-BigJohnSpecial1937.mp3",
               "http://www.archive.org/download/BennyGoodman21-30of275/BennyGoodman-BlueSkies1937.mp3",
               "http://www.archive.org/download/BennyGoodman21-30of275/BennyGoodman-BlueSkiesLongVer.mp3",
               "http://www.archive.org/download/BennyGoodman21-30of275/BennyGoodman-BodyAndSoul.mp3",
               "http://www.archive.org/download/BennyGoodman21-30of275/BennyGoodman-BoyMeetsGirl.mp3",
               "http://www.archive.org/download/BennyGoodman21-30of275/BennyGoodman-BreakfastFeud.mp3",
               "http://www.archive.org/download/BennyGoodman21-30of275/BennyGoodman-BulletsFly1937.mp3",
               "http://www.archive.org/download/BennyGoodman21-30of275/BennyGoodmanOrch-KeepOnDoinWhatYoureDoin.mp3",
               "http://www.archive.org/download/BennyGoodman21-30of275/BennyGoodmanOrch-PutThatKissBackWhereYouFoundIt.mp3",
               "http://www.archive.org/download/BennyGoodman21-30of275/BennyGoodmanOrch-ShirleyStepsOut1947.mp3",
               "http://www.archive.org/download/BennyGoodman31-40of275/BennyGoodman-ByMyself.mp3",
               "http://www.archive.org/download/BennyGoodman31-40of275/BennyGoodman-CamelHop.mp3",
               "http://www.archive.org/download/BennyGoodman31-40of275/BennyGoodman-Changes.mp3",
               "http://www.archive.org/download/BennyGoodman31-40of275/BennyGoodman-CharliesDream.mp3",
               "http://www.archive.org/download/BennyGoodman31-40of275/BennyGoodman-ChristopherColumbus.mp3",
               "http://www.archive.org/download/BennyGoodman31-40of275/BennyGoodman-Clarinetitis.mp3",
               "http://www.archive.org/download/BennyGoodman31-40of275/BennyGoodman-CrazyRhythm.mp3",
               "http://www.archive.org/download/BennyGoodman31-40of275/BennyGoodman-DamfinoName1937.mp3",
               "http://www.archive.org/download/BennyGoodman31-40of275/BennyGoodman-DarktownStruttersBall1937.mp3",
               "http://www.archive.org/download/BennyGoodman31-40of275/BennyGoodman-DarnThatDream1940.mp3",
               "http://www.archive.org/download/BennyGoodman41-50of275/BennyGoodman-Dearest.mp3",
               "http://www.archive.org/download/BennyGoodman41-50of275/BennyGoodman-DidYouMeanIt1936.mp3",
               "http://www.archive.org/download/BennyGoodman41-50of275/BennyGoodman-DigaDigaDoo.mp3",
               "http://www.archive.org/download/BennyGoodman41-50of275/BennyGoodman-DixielandBand1935.mp3",
               "http://www.archive.org/download/BennyGoodman41-50of275/BennyGoodman-DontBeThatWay.mp3",
               "http://www.archive.org/download/BennyGoodman41-50of275/BennyGoodman-DownhillSpecial.mp3",
               "http://www.archive.org/download/BennyGoodman41-50of275/BennyGoodman-DowntownCampMeetin1937.mp3",
               "http://www.archive.org/download/BennyGoodman41-50of275/BennyGoodman-DreamALittleDreamOfMe.mp3",
               "http://www.archive.org/download/BennyGoodman41-50of275/BennyGoodman-FarewellMyLove1937.mp3",
               "http://www.archive.org/download/BennyGoodman41-50of275/BennyGoodman-GershwinMedly.mp3",
               "http://www.archive.org/download/BennyGoodman51-60of275/BennyGoodman-GetHappy.mp3",
               "http://www.archive.org/download/BennyGoodman51-60of275/BennyGoodman-GirlOfMyDreams1937.mp3",
               "http://www.archive.org/download/BennyGoodman51-60of275/BennyGoodman-GoneWithWhatWind.mp3",
               "http://www.archive.org/download/BennyGoodman51-60of275/BennyGoodman-GoodbyeshowClosing.mp3",
               "http://www.archive.org/download/BennyGoodman51-60of275/BennyGoodman-GoodnightMyLove.mp3",
               "http://www.archive.org/download/BennyGoodman51-60of275/BennyGoodman-GoodyGoody.mp3",
               "http://www.archive.org/download/BennyGoodman51-60of275/BennyGoodman-GottaBeThisOrThat1945.mp3",
               "http://www.archive.org/download/BennyGoodman51-60of275/BennyGoodman-GottaBeThisOrThat1945Live.mp3",
               "http://www.archive.org/download/BennyGoodman51-60of275/BennyGoodman-HanfordStarr1943.mp3",
               "http://www.archive.org/download/BennyGoodman51-60of275/BennyGoodman-HappySessionBlues.mp3",
               "http://www.archive.org/download/BennyGoodman61-70of275/BennyGoodman-HappySessionBlues.mp3",
               "http://www.archive.org/download/BennyGoodman61-70of275/BennyGoodman-HeAintGotRhythm.mp3",
               "http://www.archive.org/download/BennyGoodman61-70of275/BennyGoodman-HoneysuckleRose.mp3",
               "http://www.archive.org/download/BennyGoodman61-70of275/BennyGoodman-HoorayForHollywood1936soundtrack.mp3",
               "http://www.archive.org/download/BennyGoodman61-70of275/BennyGoodman-HouseHop1936.mp3",
               "http://www.archive.org/download/BennyGoodman61-70of275/BennyGoodman-ICantGiveYouAnythingButLoveBaby1937.mp3",
               "http://www.archive.org/download/BennyGoodman61-70of275/BennyGoodman-IWarmUp.mp3",
               "http://www.archive.org/download/BennyGoodman61-70of275/BennyGoodman-IfDreamsComeTrue1937ver.mp3",
               "http://www.archive.org/download/BennyGoodman61-70of275/BennyGoodman-IfDreamsComeTrue1938ver.mp3",
               "http://www.archive.org/download/BennyGoodman61-70of275/BennyGoodman-IfIHadYou.mp3",
               "http://www.archive.org/download/BennyGoodman71-80of275/BennyGoodman-IfYouHaventGotAGirl.mp3",
               "http://www.archive.org/download/BennyGoodman71-80of275/BennyGoodman-IllGetBy.mp3",
               "http://www.archive.org/download/BennyGoodman71-80of275/BennyGoodman-ImComingVirginiacarnegieHall.mp3",
               "http://www.archive.org/download/BennyGoodman71-80of275/BennyGoodman-ImGonnaLoveThatGuy1945.mp3",
               "http://www.archive.org/download/BennyGoodman71-80of275/BennyGoodman-ImGonnaSitRightDownAndWriteMyselfALetter.mp3",
               "http://www.archive.org/download/BennyGoodman71-80of275/BennyGoodman-Instruntamental1937.mp3",
               "http://www.archive.org/download/BennyGoodman71-80of275/BennyGoodman-ItDontMeanAThing1932.mp3",
               "http://www.archive.org/download/BennyGoodman71-80of275/BennyGoodman-ItsBeenSoLonginstrumental1936.mp3",
               "http://www.archive.org/download/BennyGoodman71-80of275/BennyGoodman-ItsOnlyAPaperMoon.mp3",
               "http://www.archive.org/download/BennyGoodman71-80of275/BennyGoodman-ItsTightLikeThat.mp3",
               "http://www.archive.org/download/BennyGoodman71-80of275/BennyGoodmanOrch-TappinTheBarrel1934.mp3",
               "http://www.archive.org/download/BennyGoodman71-80of275/BennyGoodmanOrchVhelenWard-TooGoodToBeTrue.mp3",
               "http://www.archive.org/download/BennyGoodman81-90of275/BennyGoodman-JapaneseSandman.mp3",
               "http://www.archive.org/download/BennyGoodman81-90of275/BennyGoodman-JerseyBounce1942.mp3",
               "http://www.archive.org/download/BennyGoodman81-90of275/BennyGoodman-Josephine1937.mp3",
               "http://www.archive.org/download/BennyGoodman81-90of275/BennyGoodman-KingPorterStomp1935.mp3",
               "http://www.archive.org/download/BennyGoodman81-90of275/BennyGoodman-LaughingAtLife1937.mp3",
               "http://www.archive.org/download/BennyGoodman81-90of275/BennyGoodman-LetsDancehisThemeSong.mp3",
               "http://www.archive.org/download/BennyGoodman81-90of275/BennyGoodman-LifeGoesToAParty1937.mp3",
               "http://www.archive.org/download/BennyGoodman81-90of275/BennyGoodman-LifeGoesToAPartyshorterVer.mp3",
               "http://www.archive.org/download/BennyGoodman81-90of275/BennyGoodman-LimeHouseBlues.mp3",
               "http://www.archive.org/download/BennyGoodman81-90of275/BennyGoodman-LittleBrownJug.mp3",
               "http://www.archive.org/download/BennyGoodman91-100of275/BennyGoodman-LochLomond.mp3",
               "http://www.archive.org/download/BennyGoodman91-100of275/BennyGoodman-LoveMeOrLeaveMe1937.mp3",
               "http://www.archive.org/download/BennyGoodman91-100of275/BennyGoodman-MakinWhoopie1937.mp3",
               "http://www.archive.org/download/BennyGoodman91-100of275/BennyGoodman-MelancholyBaby1935.mp3",
               "http://www.archive.org/download/BennyGoodman91-100of275/BennyGoodman-MemoriesOfYou.mp3",
               "http://www.archive.org/download/BennyGoodman91-100of275/BennyGoodman-MinnieTheMoochersWeddingDay1937.mp3",
               "http://www.archive.org/download/BennyGoodman91-100of275/BennyGoodman-MissionToMoscow.mp3",
               "http://www.archive.org/download/BennyGoodman91-100of275/BennyGoodman-Moonglow.mp3",
               "http://www.archive.org/download/BennyGoodman91-100of275/BennyGoodman-MoonlightOnTheHighway1937.mp3",
               "http://www.archive.org/download/BennyGoodman91-100of275/BennyGoodman-MyHomeInIndiana1949.mp3",
               "http://www.archive.org/download/BennyGoodman101-110of275/BennyGoodman-MyMelancholyBaby.mp3",
               "http://www.archive.org/download/BennyGoodman101-110of275/BennyGoodman-NoOtherOne1936.mp3",
               "http://www.archive.org/download/BennyGoodman101-110of275/BennyGoodman-NobodysSweetheart.mp3",
               "http://www.archive.org/download/BennyGoodman101-110of275/BennyGoodman-NotThatICare.mp3",
               "http://www.archive.org/download/BennyGoodman101-110of275/BennyGoodman-OhLadyBeGood1935.mp3",
               "http://www.archive.org/download/BennyGoodman101-110of275/BennyGoodman-Ooooo-ohBoom.mp3",
               "http://www.archive.org/download/BennyGoodman101-110of275/BennyGoodman-Peckin.mp3",
               "http://www.archive.org/download/BennyGoodman101-110of275/BennyGoodman-PleaseBeKind.mp3",
               "http://www.archive.org/download/BennyGoodman101-110of275/BennyGoodman-PoorButterfly.mp3",
               "http://www.archive.org/download/BennyGoodman101-110of275/BennyGoodman-RapsodyInBlue.mp3",
               "http://www.archive.org/download/BennyGoodman111-120of275/BennyGoodman-PuttinOnTheRitz.mp3",
               "http://www.archive.org/download/BennyGoodman111-120of275/BennyGoodman-Remember1935.mp3",
               "http://www.archive.org/download/BennyGoodman111-120of275/BennyGoodman-RiotGoesToAParty1937.mp3",
               "http://www.archive.org/download/BennyGoodman111-120of275/BennyGoodman-RockinTheTown1937.mp3",
               "http://www.archive.org/download/BennyGoodman111-120of275/BennyGoodman-Rollem.mp3",
               "http://www.archive.org/download/BennyGoodman111-120of275/BennyGoodman-Room1411GoingToTown.mp3",
               "http://www.archive.org/download/BennyGoodman111-120of275/BennyGoodman-RoseOfWashingtonSquare.mp3",
               "http://www.archive.org/download/BennyGoodman111-120of275/BennyGoodman-RoseRoom1939.mp3",
               "http://www.archive.org/download/BennyGoodman111-120of275/BennyGoodman-Sandman.mp3",
               "http://www.archive.org/download/BennyGoodman111-120of275/BennyGoodman-SantaClausCameInTheSpring.mp3",
               "http://www.archive.org/download/BennyGoodman121-130of275/BennyGoodman-Scarecrow.mp3",
               "http://www.archive.org/download/BennyGoodman121-130of275/BennyGoodman-SentimentalJourney.mp3",
               "http://www.archive.org/download/BennyGoodman121-130of275/BennyGoodman-SevenComeEleven.mp3",
               "http://www.archive.org/download/BennyGoodman121-130of275/BennyGoodman-Shivers.mp3",
               "http://www.archive.org/download/BennyGoodman121-130of275/BennyGoodman-ShowYourLinenMissRichardson1939.mp3",
               "http://www.archive.org/download/BennyGoodman121-130of275/BennyGoodman-SilhouettedInTheMoonlight.mp3",
               "http://www.archive.org/download/BennyGoodman121-130of275/BennyGoodman-SingMeASwingSongandLetMeDance1936.mp3",
               "http://www.archive.org/download/BennyGoodman121-130of275/BennyGoodman-SingSingSing1938.mp3",
               "http://www.archive.org/download/BennyGoodman121-130of275/BennyGoodman-Smiles1937.mp3",
               "http://www.archive.org/download/BennyGoodman121-130of275/BennyGoodman-SnokeRings.mp3",
               "http://www.archive.org/download/BennyGoodman141-150of275/BennyGoodman-SoManyMemories1937.mp3",
               "http://www.archive.org/download/BennyGoodman141-150of275/BennyGoodman-SomeDaySweetheart1937.mp3",
               "http://www.archive.org/download/BennyGoodman141-150of275/BennyGoodman-SomebodyElseIsTakingMyPlace1942.mp3",
               "http://www.archive.org/download/BennyGoodman141-150of275/BennyGoodman-SomebodyStoleMyGallongVer.mp3",
               "http://www.archive.org/download/BennyGoodman141-150of275/BennyGoodman-SomebodyStoleMyGalshortVer.mp3",
               "http://www.archive.org/download/BennyGoodman141-150of275/BennyGoodman-SomethingNew.mp3",
               "http://www.archive.org/download/BennyGoodman141-150of275/BennyGoodman-SouthOfTheBorder.mp3",
               "http://www.archive.org/download/BennyGoodman141-150of275/BennyGoodman-SpinningWheel.mp3",
               "http://www.archive.org/download/BennyGoodman141-150of275/BennyGoodman-StLouisBlues.mp3",
               "http://www.archive.org/download/BennyGoodman141-150of275/BennyGoodman-Stardust1937.mp3",
               "http://www.archive.org/download/BennyGoodman151-160of275/BennyGoodman-Stardust1937.mp3",
               "http://www.archive.org/download/BennyGoodman151-160of275/BennyGoodman-StealinApples.mp3",
               "http://www.archive.org/download/BennyGoodman151-160of275/BennyGoodman-StompinAtTheSavoy.mp3",
               "http://www.archive.org/download/BennyGoodman151-160of275/BennyGoodman-SugarFootStomp1937.mp3",
               "http://www.archive.org/download/BennyGoodman151-160of275/BennyGoodman-SweetAliceBlueGown1937.mp3",
               "http://www.archive.org/download/BennyGoodman151-160of275/BennyGoodman-SweetLorraine1938.mp3",
               "http://www.archive.org/download/BennyGoodman151-160of275/BennyGoodman-SweetStranger1937.mp3",
               "http://www.archive.org/download/BennyGoodman151-160of275/BennyGoodman-SweetStrangershorterVer.mp3",
               "http://www.archive.org/download/BennyGoodman151-160of275/BennyGoodman-SweetSueJustYou1936.mp3",
               "http://www.archive.org/download/BennyGoodman151-160of275/BennyGoodman-SwingLowSweetCharriot1937.mp3",
               "http://www.archive.org/download/BennyGoodman161-170of275/BennyGoodman-SwingSax.mp3",
               "http://www.archive.org/download/BennyGoodman161-170of275/BennyGoodman-SwingtimeInTheRockies1937.mp3",
               "http://www.archive.org/download/BennyGoodman161-170of275/BennyGoodman-SwingtimeInTheRockieslongerVer.mp3",
               "http://www.archive.org/download/BennyGoodman161-170of275/BennyGoodman-Symphony1946.mp3",
               "http://www.archive.org/download/BennyGoodman161-170of275/BennyGoodman-TaintWhatYouDocarnegieHall.mp3",
               "http://www.archive.org/download/BennyGoodman161-170of275/BennyGoodman-TakeMyWord.mp3",
               "http://www.archive.org/download/BennyGoodman161-170of275/BennyGoodman-ThatMoonIsHereAgain1937.mp3",
               "http://www.archive.org/download/BennyGoodman161-170of275/BennyGoodman-TheDarktownStruttersBall.mp3",
               "http://www.archive.org/download/BennyGoodman161-170of275/BennyGoodman-TheGloryOfLove1936victor78rpm.mp3",
               "http://www.archive.org/download/BennyGoodman161-170of275/BennyGoodman-TheKingdomOfSwing.mp3",
               "http://www.archive.org/download/BennyGoodman171-180of275/BennyGoodman-TheNaughtyWaltz1937.mp3",
               "http://www.archive.org/download/BennyGoodman171-180of275/BennyGoodman-TheVarsityDrag.mp3",
               "http://www.archive.org/download/BennyGoodman171-180of275/BennyGoodman-ThemeSong.mp3",
               "http://www.archive.org/download/BennyGoodman171-180of275/BennyGoodman-ThreeLittleWordslive.mp3",
               "http://www.archive.org/download/BennyGoodman171-180of275/BennyGoodman-TigerRagVer2.mp3",
               "http://www.archive.org/download/BennyGoodman171-180of275/BennyGoodman-VibraphoneBlues1935.mp3",
               "http://www.archive.org/download/BennyGoodman171-180of275/BennyGoodman-WaitingForKatie.mp3",
               "http://www.archive.org/download/BennyGoodman171-180of275/BennyGoodman-WalkJennyWalk1937.mp3",
               "http://www.archive.org/download/BennyGoodman171-180of275/BennyGoodman-WangWangBlues.mp3",
               "http://www.archive.org/download/BennyGoodman171-180of275/BennyGoodman-tisAutumn.mp3",
               "http://www.archive.org/download/BennyGoodman181-190of275/BennyGoodman-WatchWhatHappensFromTheUmbrellasOfCherbourg.mp3",
               "http://www.archive.org/download/BennyGoodman181-190of275/BennyGoodman-WhenBuddhaSmiles.mp3",
               "http://www.archive.org/download/BennyGoodman181-190of275/BennyGoodman-Whispering1936.mp3",
               "http://www.archive.org/download/BennyGoodman181-190of275/BennyGoodman-WhollyCats.mp3",
               "http://www.archive.org/download/BennyGoodman181-190of275/BennyGoodman-Windy.mp3",
               "http://www.archive.org/download/BennyGoodman181-190of275/BennyGoodman-WolverineBlues1928firstRecord.mp3",
               "http://www.archive.org/download/BennyGoodman181-190of275/BennyGoodman-YouAndIKnow1937.mp3",
               "http://www.archive.org/download/BennyGoodman181-190of275/BennyGoodman-YouAre.mp3",
               "http://www.archive.org/download/BennyGoodman181-190of275/BennyGoodmanAllStars-AfterYoureGone1944Vdisc.mp3",
               "http://www.archive.org/download/BennyGoodman181-190of275/BennyGoodmanvDisc-Perfidia1943.mp3",
               "http://www.archive.org/download/BennyGoodman191-200of275/BennyGoodmanAllStars-AfterYoureGone1944Vdisc.mp3",
               "http://www.archive.org/download/BennyGoodman191-200of275/BennyGoodmanAllStars-DarktownStruttersBall1944Vdisc.mp3",
               "http://www.archive.org/download/BennyGoodman191-200of275/BennyGoodmanAllStars-Halaluya1944Vdisc.mp3",
               "http://www.archive.org/download/BennyGoodman191-200of275/BennyGoodmanAllStarsVmildredBailey-TheFoolishThings1944Vdisc.mp3",
               "http://www.archive.org/download/BennyGoodman191-200of275/BennyGoodmanBuddyClark-BasinStreetBlues1935.mp3",
               "http://www.archive.org/download/BennyGoodman191-200of275/BennyGoodmanCountBasie-IFoundANewBaby.mp3",
               "http://www.archive.org/download/BennyGoodman191-200of275/BennyGoodmanForDisney-rare_vbr.mp3",
               "http://www.archive.org/download/BennyGoodman191-200of275/BennyGoodmanGeneKrupa-DrumBoogie.mp3",
               "http://www.archive.org/download/BennyGoodman191-200of275/BennyGoodmanQuartetVlenaHorne-BluesInMyFlat1938.mp3",
               "http://www.archive.org/download/BennyGoodman191-200of275/BennyGoodmanTrioTeddyWilson-BodyAndSoul.mp3",
               "http://www.archive.org/download/BennyGoodman201-210of275/BennyGoodmanGeneKrupaTeddyWilson-CantHelpLovinThatMan1937.mp3",
               "http://www.archive.org/download/BennyGoodman201-210of275/BennyGoodmanGeneKrupaTeddyWilson-WhereOrWhen1937.mp3",
               "http://www.archive.org/download/BennyGoodman201-210of275/BennyGoodmanGeneKrupaTeddyWilson-Who1937.mp3",
               "http://www.archive.org/download/BennyGoodman201-210of275/BennyGoodmanGeneKrupaTeddyWilsonLionelHampton-AHandFullOfKeys1937.mp3",
               "http://www.archive.org/download/BennyGoodman201-210of275/BennyGoodmanGeneKrupaTeddyWilsonLionelHampton-Avalon1937.mp3",
               "http://www.archive.org/download/BennyGoodman201-210of275/BennyGoodmanGeneKrupaTeddyWilsonLionelHampton-BodyAndSoul1937.mp3",
               "http://www.archive.org/download/BennyGoodman201-210of275/BennyGoodmanGeneKrupaTeddyWilsonLionelHampton-CaprichoPaganini1941.mp3",
               "http://www.archive.org/download/BennyGoodman201-210of275/BennyGoodmanGeneKrupaTeddyWilsonLionelHampton-Caravan1937.mp3",
               "http://www.archive.org/download/BennyGoodman201-210of275/BennyGoodmanGeneKrupaTeddyWilsonLionelHampton-ClarinetALaKing1941.mp3",
               "http://www.archive.org/download/BennyGoodman201-210of275/BennyGoodmanGeneKrupaTeddyWilsonLionelHampton-DearOldSouthland1937.mp3",
               "http://www.archive.org/download/BennyGoodman211-220of275/BennyGoodmanGeneKrupaTeddyWilsonLionelHampton-Dinah1937.mp3",
               "http://www.archive.org/download/BennyGoodman211-220of275/BennyGoodmanGeneKrupaTeddyWilsonLionelHampton-DingDongDaddy1937.mp3",
               "http://www.archive.org/download/BennyGoodman211-220of275/BennyGoodmanGeneKrupaTeddyWilsonLionelHampton-EverybodyLovesMyBaby1937.mp3",
               "http://www.archive.org/download/BennyGoodman211-220of275/BennyGoodmanGeneKrupaTeddyWilsonLionelHampton-HouseHop1937.mp3",
               "http://www.archive.org/download/BennyGoodman211-220of275/BennyGoodmanGeneKrupaTeddyWilsonLionelHampton-IdLikeToSeeSomeMoreOfSamoa1937.mp3",
               "http://www.archive.org/download/BennyGoodman211-220of275/BennyGoodmanGeneKrupaTeddyWilsonLionelHampton-InTheShadeOfTheAppleTree1937.mp3",
               "http://www.archive.org/download/BennyGoodman211-220of275/BennyGoodmanGeneKrupaTeddyWilsonLionelHampton-JamSession1937.mp3",
               "http://www.archive.org/download/BennyGoodman211-220of275/BennyGoodmanGeneKrupaTeddyWilsonLionelHampton-JumpinSwing1937.mp3",
               "http://www.archive.org/download/BennyGoodman211-220of275/BennyGoodmanGeneKrupaTeddyWilsonLionelHampton-LaCucarocha1937.mp3",
               "http://www.archive.org/download/BennyGoodman211-220of275/BennyGoodmanGeneKrupaTeddyWilsonLionelHampton-LimehouseBlues1937.mp3",

               "http://www.archive.org/download/BennyGoodman251-260of275/BennyGoodmanJackTeagarden-DavenportBlues.mp3",
               "http://www.archive.org/download/BennyGoodman251-260of275/BennyGoodmanJackTeagarden-Dinah.mp3",
               "http://www.archive.org/download/BennyGoodman251-260of275/BennyGoodmanJackTeagarden-Idaho1942.mp3",
               "http://www.archive.org/download/BennyGoodman251-260of275/BennyGoodmanJackTeagarden-Indiana.mp3",
               "http://www.archive.org/download/BennyGoodman251-260of275/BennyGoodmanJackTeagarden-JunkMan.mp3",
               "http://www.archive.org/download/BennyGoodman251-260of275/BennyGoodmanJackTeagarden-KeepASongInYourSoul.mp3",
               "http://www.archive.org/download/BennyGoodman251-260of275/BennyGoodmanJackTeagarden-StrutMissLizzie1929.mp3",
               "http://www.archive.org/download/BennyGoodman251-260of275/BennyGoodmanJackTeagarden-SweetGeorgiaBrown.mp3",
               "http://www.archive.org/download/BennyGoodman251-260of275/BennyGoodmanJackTeagarden-TexasTeaParty.mp3",
               "http://www.archive.org/download/BennyGoodman251-260of275/BennyGoodmanJackTeagarden-TheSheikOfAraby.mp3",
               "http://www.archive.org/download/BennyGoodman261-270of275/BennyGoodmanJackTeagardenVbillieHoliday-MyMothersSon-in-law1933.mp3",
               "http://www.archive.org/download/BennyGoodman261-270of275/BennyGoodmanJackTeagardenVhelenWard-ItHadToBeYou.mp3",
               "http://www.archive.org/download/BennyGoodman261-270of275/BennyGoodmanLionelHampton-AfterYouveGone.mp3",
               "http://www.archive.org/download/BennyGoodman261-270of275/BennyGoodmanLionelHampton-FlyingHome.mp3",
               "http://www.archive.org/download/BennyGoodman261-270of275/BennyGoodmanStanKentonHarryJames-OneOClockJump.mp3",
               "http://www.archive.org/download/BennyGoodman261-270of275/BennyGoodmanTeddyWilson-BodyAndSoul1949.mp3",
               "http://www.archive.org/download/BennyGoodman261-270of275/BennyGoodmanTeddyWilson-ByeByeBlues1949.mp3",
               "http://www.archive.org/download/BennyGoodman261-270of275/BennyGoodmanTeddyWilson-DamfinoName1949.mp3",
               "http://www.archive.org/download/BennyGoodman261-270of275/BennyGoodmanTeddyWilsonGeneKrupa-SoRare1937.mp3",
               "http://www.archive.org/download/BennyGoodman261-270of275/BennyGoodmanTeddyWilsonGeneKrupa-TigerRag1936.mp3",
               "http://www.archive.org/download/BennyGoodman271-275of275/BennyGoodmanTeddyWilsonGeneKrupa-WhispersInTheDark1937.mp3",
               "http://www.archive.org/download/BennyGoodman271-275of275/BennyGoodmanTeddyWilsonGeneKrupaLionelHampton-NobodysSweetheart.mp3",
               "http://www.archive.org/download/BennyGoodman271-275of275/BennyGoodmanVaaronZigman-AlwaysAndAlways.mp3",
               "http://www.archive.org/download/BennyGoodman271-275of275/BennyGoodmanVbillieHolidayJackTeagarden-MyMothersSon-in-law1933.mp3",
               "http://www.archive.org/download/BennyGoodman271-275of275/BennyGoodmanVbudFreemanJoeVenuti-DoinTheUptownLowdown.mp3",
               "http://www.archive.org/download/BennyGoodman271-275of275/BennyGoodmanVcharlieChristian-SoloFlight.mp3",
               "http://www.archive.org/download/BennyGoodman271-275of275/BennyGoodmanVcharlieChristianCountBasie-IFoundANewBaby1941.mp3",
               "http://www.archive.org/download/BennyGoodman271-275of275/BennyGoodmanVhelenForest-BirdsOfAFeather1941.mp3",
               "http://www.archive.org/download/BennyGoodman271-275of275/BennyGoodmanVhelenForest-CabinInTheSky1943.mp3",
               "http://www.archive.org/download/BennyGoodman271-275of275/BennyGoodmanVhelenForest-DayInDayOut1939.mp3",


               "http://www.archive.org/download/BennyGoodman281-290of390/BennyGoodmanVartLund-Tangerine.mp3",
               "http://www.archive.org/download/BennyGoodman281-290of390/BennyGoodmanVhelenForest-DeepInADream1939.mp3",
               "http://www.archive.org/download/BennyGoodman281-290of390/BennyGoodmanVhelenForest-HowHighTheMoon.mp3",
               "http://www.archive.org/download/BennyGoodman281-290of390/BennyGoodmanVhelenForest-ImAlwaysChasingRainbows.mp3",
               "http://www.archive.org/download/BennyGoodman281-290of390/BennyGoodmanVhelenForest-ItNeverEnteredMyMind.mp3",
               "http://www.archive.org/download/BennyGoodman281-290of390/BennyGoodmanVhelenForest-Perfedia1941.mp3",
               "http://www.archive.org/download/BennyGoodman281-290of390/BennyGoodmanVhelenForest-ShakeDownTheStars.mp3",
               "http://www.archive.org/download/BennyGoodman281-290of390/BennyGoodmanVhelenForest-SmokeGetsInYourEyes.mp3",
               "http://www.archive.org/download/BennyGoodman281-290of390/BennyGoodmanVhelenForest-SoftAsSpring1941.mp3",
               "http://www.archive.org/download/BennyGoodman281-290of390/BennyGoodmanVhelenForest-TakingAChanceOnLove1940.mp3",
               "http://www.archive.org/download/BennyGoodman291-300of390/BennyGoodmanVhelenForest-Yours.mp3",
               "http://www.archive.org/download/BennyGoodman291-300of390/BennyGoodmanVhelenWard-AllMyLife1936.mp3",
               "http://www.archive.org/download/BennyGoodman291-300of390/BennyGoodmanVhelenWard-DixielandBand.mp3",
               "http://www.archive.org/download/BennyGoodman291-300of390/BennyGoodmanVhelenWard-EenyMeenyMineyMo1935.mp3",
               "http://www.archive.org/download/BennyGoodman291-300of390/BennyGoodmanVhelenWard-GeeButYoureSwell1937.mp3",
               "http://www.archive.org/download/BennyGoodman291-300of390/BennyGoodmanVhelenWard-GoodyGoody1936.mp3",
               "http://www.archive.org/download/BennyGoodman291-300of390/BennyGoodmanVhelenWard-ImShootingHigh1935.mp3",
               "http://www.archive.org/download/BennyGoodman291-300of390/BennyGoodmanVhelenWard-ItsBeenSoLong.mp3",
               "http://www.archive.org/download/BennyGoodman291-300of390/BennyGoodmanVhelenWard-NightWind1935.mp3",
               "http://www.archive.org/download/BennyGoodman291-300of390/BennyGoodmanVhelenWard-SingMeASwingSongandLetMeDance.mp3",
               "http://www.archive.org/download/BennyGoodman301-310of390/BennyGoodmanVhelenWard-SmokeDreams1937.mp3",
               "http://www.archive.org/download/BennyGoodman301-310of390/BennyGoodmanVhelenWard-TheGloryOfLove1936.mp3",
               "http://www.archive.org/download/BennyGoodman301-310of390/BennyGoodmanVhelenWard-TheresASmallHotel.mp3",
               "http://www.archive.org/download/BennyGoodman301-310of390/BennyGoodmanVhelenWard-TheseFoolishThingsRemindMeOfYou1936.mp3",
               "http://www.archive.org/download/BennyGoodman301-310of390/BennyGoodmanVhelenWard-TooGoodToBeTrue1936.mp3",
               "http://www.archive.org/download/BennyGoodman301-310of390/BennyGoodmanVhelenWard-YouCameToMyRescue.mp3",
               "http://www.archive.org/download/BennyGoodman301-310of390/BennyGoodmanVhelenWard-YouTurnedTheTablesOnMe1936.mp3",
               "http://www.archive.org/download/BennyGoodman301-310of390/BennyGoodmanVhelenWard-YoureAHeavenlyThing.mp3",
               "http://www.archive.org/download/BennyGoodman301-310of390/BennyGoodmanVjohnnyMercer-CuckooInTheClock.mp3",
               "http://www.archive.org/download/BennyGoodman301-310of390/BennyGoodmanVlenaHorne-BluesInMyFlat1938.mp3",


               "http://www.archive.org/download/BennyGoodman321-330of390/BennyGoodmanVmarthaTilton-DixielandBand1937.mp3",
               "http://www.archive.org/download/BennyGoodman321-330of390/BennyGoodmanVmarthaTilton-FarewellMyLove1937.mp3",
               "http://www.archive.org/download/BennyGoodman321-330of390/BennyGoodmanVmarthaTilton-IHitchedMyWagonToAStar1937.mp3",
               "http://www.archive.org/download/BennyGoodman321-330of390/BennyGoodmanVmarthaTilton-ILetASongGoOutOfMyHeart.mp3",
               "http://www.archive.org/download/BennyGoodman321-330of390/BennyGoodmanVmarthaTilton-IMustSeeAnnieTonight1939.mp3",
               "http://www.archive.org/download/BennyGoodman321-330of390/BennyGoodmanVmarthaTilton-IWantToBeInWinchelsColumn1937.mp3",
               "http://www.archive.org/download/BennyGoodman321-330of390/BennyGoodmanVmarthaTilton-IfItsTheLastThingIDo1937.mp3",
               "http://www.archive.org/download/BennyGoodman321-330of390/BennyGoodmanVmarthaTilton-InTheStillOfTheNight1937.mp3",
               "http://www.archive.org/download/BennyGoodman321-330of390/BennyGoodmanVmarthaTilton-ItsWonderful1937.mp3",
               "http://www.archive.org/download/BennyGoodman321-330of390/BennyGoodmanVmarthaTilton-IveGotThatOldFeeling1937.mp3",
               "http://www.archive.org/download/BennyGoodman331-340of390/BennyGoodmanVmarthaTilton-LadyBeGood1937.mp3",
               "http://www.archive.org/download/BennyGoodman331-340of390/BennyGoodmanVmarthaTilton-LochLomond1937.mp3",
               "http://www.archive.org/download/BennyGoodman331-340of390/BennyGoodmanVmarthaTilton-MeMyselfAndI1937.mp3",
               "http://www.archive.org/download/BennyGoodman331-340of390/BennyGoodmanVmarthaTilton-OnceInAWhile1937.mp3",
               "http://www.archive.org/download/BennyGoodman331-340of390/BennyGoodmanVmarthaTilton-OnceInAwhile.mp3",
               "http://www.archive.org/download/BennyGoodman331-340of390/BennyGoodmanVmarthaTilton-PleaseBeKind.mp3",
               "http://www.archive.org/download/BennyGoodman331-340of390/BennyGoodmanVmarthaTilton-PopcornMan1937.mp3",
               "http://www.archive.org/download/BennyGoodman331-340of390/BennyGoodmanVmarthaTilton-SoManyMemories1937.mp3",
               "http://www.archive.org/download/BennyGoodman331-340of390/BennyGoodmanVmarthaTilton-StardustOnTheMoon1937.mp3",
               "http://www.archive.org/download/BennyGoodman331-340of390/BennyGoodmanVmarthaTilton-SweetSomeone1937.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390/BennyGoodmanVmarthaTilton-ThanksForTheMemories.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390/BennyGoodmanVmarthaTilton-TheLadyIsATramp1937.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390/BennyGoodmanVmarthaTilton-TheMoonGotInMyEyes1937.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390/BennyGoodmanVmarthaTilton-WhatALittleMoonlightCanDo.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390/BennyGoodmanVmarthaTilton-WhatHaveYouGotThatGetsMe1938.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390/BennyGoodmanVmarthaTilton-YouShowedMeTheWay1937.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390/BennyGoodmanVmarthaTilton-YouTookTheWordsRightOutOfMyHeart1937.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390/BennyGoodmanVmarthaTilton-YoureMyDesire1937.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390/BennyGoodmanVmildredBailey-BluebirdsInTheMoonlight.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390/BennyGoodmanVmildredBailey-DarnThatDream1940.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390_718/BennyGoodmanVmildredBailey-IThoughtAboutYou.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390_718/BennyGoodmanVmildredBailey-TherellBeAJubilee.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390_718/BennyGoodmanVpattyPage-Confess1949.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390_718/BennyGoodmanVpattyPage-LittleWhiteLies1949.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390_718/BennyGoodmanVpattyPage-TheManILove1949.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390_718/BennyGoodmanVpeggyLee-BluesInTheNight1941.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390_718/BennyGoodmanVpeggyLee-DameUnaVidaSencilla.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390_718/BennyGoodmanVpeggyLee-DontLetMeBeLonelyTonight.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390_718/BennyGoodmanVpeggyLee-ElmersTune.mp3",
               "http://www.archive.org/download/BennyGoodman341-350of390_718/BennyGoodmanVpeggyLee-GiveMeTheSimpleLife1946.mp3",
               "http://www.archive.org/download/BennyGoodman351-360of390/BennyGoodmanVpeggyLee-BluesInTheNight.mp3",
               "http://www.archive.org/download/BennyGoodman351-360of390/BennyGoodmanVpeggyLee-IGotItBadandThatAintGood.mp3",
               "http://www.archive.org/download/BennyGoodman351-360of390/BennyGoodmanVpeggyLee-IfYouBuildABetterMousetrap.mp3",
               "http://www.archive.org/download/BennyGoodman351-360of390/BennyGoodmanVpeggyLee-JustTheWayYouAre.mp3",
               "http://www.archive.org/download/BennyGoodman351-360of390/BennyGoodmanVpeggyLee-LetsDoItletsFallInLove1941.mp3",
               "http://www.archive.org/download/BennyGoodman351-360of390/BennyGoodmanVpeggyLee-MyOldFlame.mp3",
               "http://www.archive.org/download/BennyGoodman351-360of390/BennyGoodmanVpeggyLee-NotMine.mp3",
               "http://www.archive.org/download/BennyGoodman351-360of390/BennyGoodmanVpeggyLee-SmokeGetsInYourEyes.mp3",
               "http://www.archive.org/download/BennyGoodman351-360of390/BennyGoodmanVpeggyLee-SomebodyElseIsTakingMyPlace1942.mp3",
               "http://www.archive.org/download/BennyGoodman351-360of390/BennyGoodmanVpeggyLee-SunnySideOfTheStreet.mp3",
               "http://www.archive.org/download/BennyGoodman361-370of390/BennyGoodmanVpeggyLee-TheLampOfMemory1942.mp3",
               "http://www.archive.org/download/BennyGoodman361-370of390/BennyGoodmanVpeggyLee-TheWayYouLookTonight.mp3",
               "http://www.archive.org/download/BennyGoodman361-370of390/BennyGoodmanVpeggyLee-WellMeetAgain.mp3",
               "http://www.archive.org/download/BennyGoodman361-370of390/BennyGoodmanVpeggyLee-WinterWeather1941.mp3",
               "http://www.archive.org/download/BennyGoodman361-370of390/BennyGoodmanVrosemaryClooney-HowLongHasThisBeenGoingOn.mp3",
               "http://www.archive.org/download/BennyGoodman361-370of390/BennyGoodmanVrosemaryClooney-MemoriesOfYou.mp3",
               "http://www.archive.org/download/BennyGoodman361-370of390/BennyGoodmanVruthEtting-TenCentsADance1930.mp3",
               "http://www.archive.org/download/BennyGoodman361-370of390/BennyGoodmanVsmithBallew-HelpYourselfToHappiness1931.mp3",
               "http://www.archive.org/download/BennyGoodman361-370of390/BennyGoodmanVswingKids-FlatFootFloogee.mp3",
               "http://www.archive.org/download/BennyGoodman361-370of390/BennyGoodmanVswingKids-GoodnightMyLove.mp3",
               "http://www.archive.org/download/BennyGoodman371-380of390/BennyGoodmanVswingKids-SwingtimeInTheRockies.mp3",
               "http://www.archive.org/download/BennyGoodman371-380of390/BennyGoodmanVtommyTaylor-Anything1941.mp3",
               "http://www.archive.org/download/BennyGoodman371-380of390/BennyGoodmanVtommyTaylor-OneLovelyYesterday1941.mp3",
               "http://www.archive.org/download/BennyGoodman371-380of390/BennyGoodmanWoodieHermanHarryJames-BackBeetBoogie.mp3",
               "http://www.archive.org/download/BennyGoodman371-380of390/BennyGoodmansBoys-ThatsA-plenty1928.mp3",
               "http://www.archive.org/download/BennyGoodman371-380of390/BennyGoodmansBoys-WolverineBlues1928.mp3",



               "http://www.archive.org/download/BennyGoodman-276-286/BennyGoodman-BlueSkies.mp3",
               "http://www.archive.org/download/BennyGoodman-276-286/BennyGoodman-LifeGoesToAParty.mp3",
               "http://www.archive.org/download/BennyGoodman-276-286/BennyGoodman-MoreThanYouKnow.mp3",
               "http://www.archive.org/download/BennyGoodman-276-286/BennyGoodman-TheNaughtyWaltz.mp3",
               "http://www.archive.org/download/BennyGoodman-276-286/BennyGoodman-ThePopcornMan.mp3",
               "http://www.archive.org/download/BennyGoodman-276-286/BennyGoodman-VienneVienne.mp3",
               "http://www.archive.org/download/BennyGoodman-276-286/BennyGoodman-YouShowedMeTheWay.mp3",
               "http://www.archive.org/download/BennyGoodman-276-286/BennyGoodmanOrch-HeAintGotRhythm.mp3",
               "http://www.archive.org/download/BennyGoodman-276-286/BennyGoodmanOrchVethelWaters-Heatwave1934.mp3",
               "http://www.archive.org/download/BennyGoodman-276-286/BennyGoodmanOrchVmildredBailey-DarnThatDream1939.mp3",
               "http://www.archive.org/download/BennyGoodman-276-286/BennyGoodmanOrchVmildredBailey-IThoughtAboutYou1939.mp3",
               "http://www.archive.org/download/BennyGoodman-286-290/BennyGoodmanOrchVmildredBailey-IThoughtAboutYou1939.mp3",
               "http://www.archive.org/download/BennyGoodman-286-290/BennyGoodmanOrchVmildredBailey-OldPappy1934.mp3",
               "http://www.archive.org/download/BennyGoodman-286-290/BennyGoodmanVmarthaTilton-IfItsTheLastThingIDo.mp3",
               "http://www.archive.org/download/BennyGoodman-286-290/BennyGoodmanVmarthaTilton-OnceInAWhile.mp3",
               "http://www.archive.org/download/Benny-Goodman1935scarce/BennyGoodman-MelancholyBaby1935.mp3",
               "http://www.archive.org/download/Benny-Goodman1935scarce/BennyGoodman-VibraphonBlues1935incomplete.mp3"
      ]
      download_songs(songs, save_dir)
    end

    def self.lionel_hampton(save_dir = DEFAULT_MUSIC_ROOT_DIR + "/JAZZ/Lionel_Hampton")
      songs = YAML::load_file(File.dirname(__FILE__) + "/LionelHampton.yml")
      download_songs(songs, save_dir)
    end

    def self.charlie_christian(save_dir = DEFAULT_MUSIC_ROOT_DIR + "/JAZZ/Charlie_Christian")
      songs = YAML::load_file(File.dirname(__FILE__) + "/CharlieChristian.yml")
      download_songs(songs, save_dir)
    end

    def self.dizzy_gillespie(save_dir = DEFAULT_MUSIC_ROOT_DIR + "/JAZZ/Dizzy_Gillespie")
      songs = YAML::load_file(File.dirname(__FILE__) + "/DizzyGillespie.yml")
      download_songs(songs, save_dir)
    end

    def self.top_music_dir(save_dir)
      full_path_name = File.expand_path(save_dir)
      home_regexp = /^(\/home\/[^\/]*\/[^\/]*)(\/.*)*$/
      full_path_name = full_path_name.match(home_regexp)[1] if full_path_name =~ home_regexp
      full_path_name
    end

    def self.version_of_song_in_any_dir?(song_filename, save_dir)
      #existing_files =  Dir.chdir(top_music_dir(save_dir)) {
      #  Dir.glob("**/*")
      #}
      existing_files = Dir.glob(File.join(top_music_dir(save_dir), '**', '*' ))
      existing_files.delete_if { |f| !f.match(MP3_OGG_REGEXP) }       # delete unless .mp3, .MP3, .ogg or .OGG
      existing_files.map! { |f| File.basename(f) }    # strip any path info preceding the filename
      existing_files.map! { |f| f.gsub(MP3_OGG_REGEXP,"") }           # strip extensions
      existing_files.include?(song_filename.gsub(MP3_OGG_REGEXP,""))  # does extensionless song_filename exist in directory?
    end

    def self.create_save_dir(save_dir)
      return if File.directory?(save_dir)
      begin
        FileUtils.mkdir_p(save_dir)
      rescue SystemCallError
        puts "WARNING: Unable to create #{save_dir}"
        raise
      end
    end

    private

    def self.download_songs(songs, save_dir)
      save_dir = File.expand_path(save_dir)
      create_save_dir(save_dir) unless File.directory?(save_dir)
      #Dir.chdir(save_dir)
      songs.each do |song_url|
        song_basename = File.basename(song_url)
        next if version_of_song_in_any_dir?(song_basename, save_dir)
        puts "Downloading #{song_basename}"
        open(File.join(save_dir,song_basename), 'wb') do |dst|
          open(song_url) do |src|
            dst.write(src.read)
          end
        end
      end
    end

    def self.version_of_song_in_current_dir?(song_filename)
      existing_files = Dir.entries(".").delete_if { |f| !f.match(MP3_OGG_REGEXP) }  # delete unless .mp3, .MP3, .ogg or .OGG
      existing_files.map! { |f| f.gsub(MP3_OGG_REGEXP,"") }                         # strip extensions
      existing_files.include?(song_filename.gsub(MP3_OGG_REGEXP,"")) ? true : false # does extensionless song_filename exist in directory?
    end

  end

end