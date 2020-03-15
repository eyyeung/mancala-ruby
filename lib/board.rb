require_relative "./player.rb"
class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @player1=Player.new(name1,1)
    @player2=Player.new(name2,2)
    @cups=Array.new(14){[]}
    place_stones
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    @cups.each_with_index do |ele,i|
      unless i==6||i==13
        4.times {ele<<:stone}
      end
    end
  end

  def valid_move?(start_pos)
    raise 'Invalid starting cup' if !start_pos.between?(0,13)
    raise 'Starting cup is empty' if @cups[start_pos].length==0
    true
  end

  def make_move(start_pos, current_player_name)
    stones=@cups[start_pos].dup
    @cups[start_pos].clear()
    if current_player_name==@player1.name
      opponent_cup=13
      own_cup=6
    elsif current_player_name==@player2.name
      opponent_cup=6
      own_cup=13
    else
      raise "Not a valid player"
    end
    new_pos=(start_pos+1)%14
    while stones.length>0
      old_pos=new_pos
      @cups[new_pos]<<stones.pop if new_pos!=opponent_cup
      new_pos=(new_pos+1)%14
    end
    render
    next_turn(old_pos)
  end

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    if @cups[ending_cup_idx].length-1==0 && !(ending_cup_idx==6||ending_cup_idx==13)
      return :switch
    elsif ending_cup_idx==6||ending_cup_idx==13
      return :prompt
    else
      return ending_cup_idx
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    @cups[0..5].all?{|cup|cup.length==0} || @cups[7..12].all?{|cup|cup.length==0}
  end

  def winner
      player1_score=@cups[6].length
      player2_score=@cups[13].length
      if player1_score>player2_score
        return @player1.name
      elsif player1_score==player2_score
        return :draw
      else
        return @player2.name
      end
  end

end
