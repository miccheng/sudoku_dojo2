require 'pry'
require 'set'

class Sudoku
  attr_reader :tiles

  BOARD_SIZE = 9
  GRID_WIDTH = 3
  DEFAULT_BLANKS = 40

  def initialize(default_tiles = [], blank_slots = [], num_blanks = DEFAULT_BLANKS)
    @tiles = default_tiles.empty? ? blank_board : default_tiles
    @blank_slots = blank_slots unless blank_slots.empty?
    @num_blanks = num_blanks
  end

  def neighbours(index)
    row_index, col_index, grid_index = coord_of(index)

    [
      row(row_index),
      column(col_index),
      grid(grid_index)
    ]
  end

  def build_puzzle!
    @tiles = blank_board
    puts 'Unable to fill cells' unless do_fill_cell(0)

    display_puzzle
  end

  def display_answers
    display_board(@tiles)
  end

  def display_puzzle
    puzzle = @tiles.dup

    blank_slots.each { |index| puzzle[index] = nil }

    display_board(puzzle)
  end

  def self.check(tiles)
    tiles.compact.uniq == tiles.compact
  end

  def valid?(tiles = @tiles)
    all_candidates = (1..BOARD_SIZE).each_with_object([]) do |n, m|
      m << row(n, tiles)
      m << column(n, tiles)
      m << grid(n, tiles)

    end

    all_candidates.map { |candidate| Sudoku.check(candidate) }.all?
  end

  def complete?(tiles = @tiles)
    tiles.compact == tiles
  end

  private

  def do_fill_cell(index)
    neighbouring_values = Set.new(neighbours(index).flatten.compact)
    available_candidates = (1..9).to_a - neighbouring_values.to_a.sort

    available_candidates.shuffle.each do |n|
      @tiles[index] = n

      return true if index == (@tiles.count - 1) || do_fill_cell(index + 1)
    end

    @tiles[index] = nil
    false
  end

  def display_board(tiles = @tiles)
    puts '-------------------------'
    (1..BOARD_SIZE).each do |n|
      puts display_line(row(n, tiles))
      puts '|-------+-------+-------|' if (n % 3).zero? && n < 9
    end
    puts '-------------------------'
  end

  def display_line(tiles)
    str = '|'
    tiles.each_with_index do |tile, index|
      str += " #{tile.nil? ? ' ' : tile}"
      str += ' |' if ((index + 1) % 3).zero?
    end

    str
  end

  def coord_of(index)
    start_index = (index + 1)

    row_index = (start_index / BOARD_SIZE.to_f).ceil

    col_index = start_index % BOARD_SIZE
    col_index = 9 if col_index.zero?

    grid_y = (row_index / GRID_WIDTH.to_f).ceil
    grid_x = (col_index / GRID_WIDTH.to_f).ceil
    grid_index = ((grid_y - 1) * GRID_WIDTH) + grid_x

    [row_index, col_index, grid_index]
  end

  def row(index, tiles = @tiles)
    start_index = (index - 1)
    start_from = (start_index * BOARD_SIZE)
    tiles.slice(start_from, BOARD_SIZE)
  end

  def column(index, tiles = @tiles)
    start_index = (index - 1)
    col_indexes = (BOARD_SIZE - 1).times.each_with_object([start_index]) do |_, m|
      m << (m.last + BOARD_SIZE)
    end

    tiles.values_at(*col_indexes)
  end

  def grid(index, tiles = @tiles)
    row_index = (index / GRID_WIDTH.to_f).ceil
    start_row = ((row_index - 1) * GRID_WIDTH) + 1

    rows = (start_row..start_row+2).map { |n| row(n, tiles) }

    col_offset = index % 3
    col_offset = 3 if col_offset.zero?
    col_start_index = (col_offset - 1) * GRID_WIDTH

    rows.map { |row| row[col_start_index..(col_start_index + 2)] }.flatten
  end

  def blank_board
    Array.new(81)
  end

  def blank_slots
    max_index = (BOARD_SIZE * BOARD_SIZE) - 1
    @blank_slots ||= (0..max_index).to_a.sample(@num_blanks)
  end
end
