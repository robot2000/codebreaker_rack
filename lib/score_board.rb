class ScoreBoard
  
  attr_reader :scores

  def initialize(file_name)
    @scoreboard_file = file_name
    @scores = load_score
  end

  def load_score
    if File.exist?(@scoreboard_file)
      Marshal.load(File.read(@scoreboard_file)).sort {|a, b|
        b[:val] <=> a[:val]
      }
    else
      [{name: 'some Player', val: 0}]
    end
  end

  def add_result(val, name)
    name = "Player_#{@scores.count}" if name.to_s.empty?
    @scores[@scores.count] = {name: name, val:val}
    File.open(@scoreboard_file, 'w') {|f| f.write(Marshal.dump(@scores)) }
  end
end
