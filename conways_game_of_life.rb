class Game

  def initialize size, iterations, life=nil
    @size = size
    @iterations = iterations
    @life = life
    @board = Board.new @size, @life
    @board.to_s "Iteration - 0"
    iterate_life
  end

  def iterate_life
    @iterations.times do |i|
      new_life = @board.get_next_life_state
      new_board = Board.new @size, new_life
      new_board.to_s "Iteration - #{i+1}"
      @board = new_board
    end
  end

end

class Board

  def initialize size, life
    @size = size
    @life = life
    @board = Array.new(@size) { Array.new(@size) { Cell.new false  } }
    seed_life
  end

  def get_next_life_state
    @board.map.with_index do |row,x|
      row.map.with_index do |cell, y|
        should_be_alive?(cell, x,y) ? [x,y] : nil
      end.compact
    end.compact.flatten(1)
  end

  def should_be_alive? cell, x,y
    live_neighbours = @board.map.with_index do |row,i|
      row.map.with_index do |cell, j|
        cell.live? && (
            i == (x-1) && j == (y-1) ||
            i == (x-1) && j == y     ||
            i == (x-1) && j == (y+1) ||
            i == x     && j == (y-1) ||
            i == x     && j == (y+1) ||
            i == (x+1) && j == (y-1) ||
            i == (x+1) && j == y     ||
            i == (x+1) && j == (y+1)

          ) ? [i,j] : nil
      end.compact
    end.compact.reject! { |position| position.empty? }.flatten(1)
    ((cell.live? && live_neighbours.size == 2) || live_neighbours.size == 3) ? true : false
  end

  def seed_life
    @life.each { |x,y| @board[x][y].live! }
  end

  def to_s title
    system "clear"
    puts title
    @board.each { |row| puts row.map { |cell| cell.live? ? "#" : "." }.join(' ') }
    sleep 0.3
  end

end

class Cell
  def initialize live
    @live = live
  end

  def live!
    @live = true
  end

  def live?
    @live
  end

end

# Game.new 5,10, [[1,2],[2,2],[3,2]]
Game.new 4,10, [[1,1],[1,2],[2,1],[2,2]]
# Game.new 4,50, [[0,0],[0,1],[0,2],[0,3],[3,0],[3,1],[3,2],[3,3],[1,0],[1,3],[2,0],[2,3]]
