require 'spec_helper'
require_relative '../sudoku'

describe Sudoku do
  describe '.initialize' do
    it 'creates empty board' do
      expect(subject).to be_a Sudoku
      expect(subject.tiles.count).to eq 81
    end
  end

  context 'valid tiles' do
    let(:valid_answer) {
      [
        5, 3, 4, 6, 7, 8, 9, 1, 2,
        6, 7, 2, 1, 9, 5, 3, 4, 8,
        1, 9, 8, 3, 4, 2, 5, 6, 7,
        8, 5, 9, 7, 6, 1, 4, 2, 3,
        4, 2, 6, 8, 5, 3, 7, 9, 1,
        7, 1, 3, 9, 2, 4, 8, 5, 6,
        9, 6, 1, 5, 3, 7, 2, 8, 4,
        2, 8, 7, 4, 1, 9, 6, 3, 5,
        3, 4, 5, 2, 8, 6, 1, 7, 9
      ]
    }
    subject{ Sudoku.new(valid_answer) }

    describe '#display_answers' do
      it 'displays all answers' do
        expected = <<~EOT
        -------------------------
        | 5 3 4 | 6 7 8 | 9 1 2 |
        | 6 7 2 | 1 9 5 | 3 4 8 |
        | 1 9 8 | 3 4 2 | 5 6 7 |
        |-------+-------+-------|
        | 8 5 9 | 7 6 1 | 4 2 3 |
        | 4 2 6 | 8 5 3 | 7 9 1 |
        | 7 1 3 | 9 2 4 | 8 5 6 |
        |-------+-------+-------|
        | 9 6 1 | 5 3 7 | 2 8 4 |
        | 2 8 7 | 4 1 9 | 6 3 5 |
        | 3 4 5 | 2 8 6 | 1 7 9 |
        -------------------------
        EOT
        expect{ subject.display_answers }.to output(expected).to_stdout
      end
    end

    describe '#neighbours' do
      it 'returns values from neighbouring cells' do
        expected = [
          [8, 5, 9, 7, 6, 1, 4, 2, 3],
          [5, 6, 1, 8, 4, 7, 9, 2, 3],
          [8, 5, 9, 4, 2, 6, 7, 1, 3]
        ]
        expect(subject.neighbours(27)).to eq expected
      end
    end

    describe '.check' do
      context 'valid' do
        it 'returns true for all unique' do
          unique_tiles = [1, 2, 3, 4, 5, 6, 7, 8, 9]
          expect(Sudoku.check(unique_tiles)).to be

          unique_has_nils = [1, 2, 3, 4, 5, nil, 7, 8, nil]
          expect(Sudoku.check(unique_has_nils)).to be
        end
      end

      context 'invalid' do
        it 'returns false for non-unique' do
          non_unique_tiles = [1, 2, 3, 4, 5, 6, 7, 7, 9]
          expect(Sudoku.check(non_unique_tiles)).not_to be

          nonunique_has_nils = [1, 2, 3, 4, 5, nil, 7, 7, nil]
          expect(Sudoku.check(nonunique_has_nils)).not_to be
        end
      end
    end

    describe '#valid?' do
      it 'returns true for all valid' do
        expect(subject.valid?(subject.tiles)).to be
      end
    end

    describe '#complete?' do
      it 'returns true for all filled' do
        expect(subject.complete?(subject.tiles)).to be
      end
    end

    describe '#build_puzzle!' do
      subject{ Sudoku.new }

      it 'builds a new puzzle' do
        subject.build_puzzle!

        expect(subject).to be_valid
        expect(subject).to be_complete
      end
    end
  end

  context 'invalid' do
    let(:invalid_answer) {
      [
        5, 3, 4, 6, 7, 8, 9, 1, 2,
        6, 7, 2, 1, 9, 5, 3, 4, 8,
        1, 9, 8, 3, 4, 2, 5, 6, 7,
        8, 5, 9, 6, 6, 1, nil, 2, 3,
        4, 2, 6, 8, 5, 3, 7, 9, 1,
        7, 1, 3, 9, 2, 4, 8, 5, nil,
        9, 6, 1, 5, 3, 7, 2, 8, 4,
        2, 8, 7, 4, 1, 9, 6, 3, 5,
        3, 4, 5, 8, 8, 6, 1, 7, nil
      ]
    }
    subject{ Sudoku.new(invalid_answer) }

    describe '.valid?' do
      it 'returns false for all valid' do
        expect(subject.valid?(subject.tiles)).not_to be
      end
    end

    describe '#complete?' do
      it 'returns false for some not filled' do
        expect(subject.complete?(subject.tiles)).not_to be
      end
    end
  end
end
