require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @grid = []
    aux_grid = []

    vowels = %w[A E I O U]

    alphabet = ('A'..'Z').to_a
    non_vowels = alphabet.reject { |letter| vowels.include?(letter) }

    number_of_vowels = 4
    number_of_vowels.times { |_i| aux_grid << vowels.sample }
    (10 - number_of_vowels).times { |_i| aux_grid << non_vowels.sample }

    @grid = aux_grid.sample(10)
  end

  def score
    @user_word = params[:user_word]
    @grid = params[:grid].split

    @grid_hash = hash_count(@grid)
    @user_hash = hash_count(@user_word.upcase.split(''))

    @user_hash.each_key do |key|
      unless !@check_grid.nil? || @grid_hash.key?(key) && @user_hash[key] <= @grid_hash[key]
        @check_grid = "Sorry, but '#{@user_word}' can't be built out of '#{params[:grid]}'."
      end
    end

    url = "https://dictionary.lewagon.com/#{@user_word}"
    api_response = URI.open(url).read
    word_json = JSON.parse(api_response)

    if word_json["found"]
      @length = word_json[""]
    else
      @check_word = ''
    end

    raise

    @result = "Congratulations! '#{@user_word}' is a valid word!" unless @check_grid

  end

  private

  def hash_count(array)
    hash = {}

    array.each do |letter|
      hash[letter] = 0 unless hash.key?(letter)

      hash[letter] += 1
    end

    hash
  end
end
