class Rook
  
  def initialize( color, column, row )
    # Black or White
    @color = color
    # A-H
    @column = column
    # 1-8
    @row = row
    # Standard chess coordinate system
    @position = "#{ @column }#{ @row }"
    # Directions in which the piece can legally move
    @directions = [ move_backward, move_forward, move_left, move_right ]
    # Array of available moves on any given turn
    @available_moves = [  ]
  end

###########################################

# Alphanumeric coordinate transforms for all legal directions of travel
  def move_forward
    Proc.new { | spaces | "#{ @column }#{ forward( spaces ) }" }
  end

  def move_backward
    Proc.new { | spaces | "#{ @column }#{ backward( spaces ) }" }
  end

  def move_left
    Proc.new { | spaces | "#{ left( spaces ).chr }#{ @row }" }
  end

  def move_right
    Proc.new { | spaces | "#{ right( spaces ).chr }#{ @row }" }
  end

# Transforms for distance
  def left( spaces )
    @column.ord - spaces
  end

  def right( spaces )
    @column.ord + spaces
  end

  def forward( spaces )
    white? ? @row.to_i + spaces : @row.to_i - spaces
  end

  def backward( spaces )
    white? ? @row.to_i - spaces : @row.to_i + spaces
  end

###########################################

# Generate @available_moves at the end of each played turn

  def populate_available_moves
    # Reset available moves array
    @available_moves = [  ]
    # Figure out what moves are legal for a Queen in a given location on the board
    @directions.each { | direction | @available_moves << linear_movement( &direction ) }
  end

###########################################

# Move
  def linear_movement( spaces = 1, moves = [  ], &direction )
    # Define move as however many spaces in the given direction
    move = yield( spaces )
        # Ensure the move is on the board
    if  on_board?( move ) && 
        # Ensure the space is either empty or an opposing piece is being captured
        ( capture?( move ) || empty?( move ) ) && 
        # Catch if the previous space was a capture
        !capture?( moves[ -1 ] )
      moves << move
      # Recur
      linear_movement( spaces + 1, moves, &direction )
    else
      # Return moves array
      moves
    end
  end

###########################################
# Utility methods

  # Ensure the coordinates are on the board; bool
    def on_board?( position )
      position[ 0 ].ord >= 97 && 
      position[ 0 ].ord <= 104 && 
      position[ 1 ].to_i >= 1 && 
      position[ 1 ].to_i <= 8 && 
    end

  # See if another piece of the opposing color occupies the space; bool
    def capture?( position )
      ( white? && ( get_space( position ).token ) =~ /[prnbqk]/ ) || 
      ( !white? && ( get_space( position ).token ) =~ /[PRNBQK]/ )
    end

  # Check for B/W; bool true for white
    def white?
      @color == "White" ? true : false
    end

  # See if space is occupied by piece of same color; bool
    def empty?( *positions )
      positions.all? { | position | get_space( position ).token =~ /_/ }
    end

end
