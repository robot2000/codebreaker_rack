require 'bundler/setup'
require 'codebreaker'
require_relative './score_board'

class App 
  
  DATA_FOLDER = 'data'
  SCOREBOARD_FILE = 'scoreboard.marsh'

   attr_reader :hint_value

  def initialize(file_name)
    data_folder = File.expand_path('../' + DATA_FOLDER, File.dirname(__FILE__));
    @game_file = data_folder + '/' + file_name
    game_init

    @hint_value = @game.hint_value
    @score_board_file = data_folder + '/' + SCOREBOARD_FILE
    @score_board = ScoreBoard.new(@score_board_file)
    @saved = false
  end

  def prev_results
    @game.guess
  end

  def check(suspect)
    @game.check(suspect)
    File.open(@game_file, 'w') {|f| f.write(Marshal.dump(@game)) }
  end

  def game_status
    @game.game_status
  end

  def score
    @game.score
  end

  def save(name)
    @score_board.add_result(score, name)
  end

  def score_board
    @score_board.scores
  end

  def hint
    @hint_value = @game.hint
    File.open(@game_file, 'w') {|f| f.write(Marshal.dump(@game)) }
  end

  private

  def game_init
    if File.exist?(@game_file)
      @game = Marshal.load(File.read(@game_file))
    else
      @game = Codebreaker::Game.new
      @game.start
      File.open(@game_file, 'w') {|f| f.write(Marshal.dump(@game)) }
    end
  end
end
