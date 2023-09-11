require 'open-uri'
require 'net/http'
require 'json'

class GamesController < ApplicationController
  def new
    session[:score] ||= 0
    vowels = %w(A I O U E)
    @letters = []
    4.times { @letters << (vowels).sample }
    6.times { @letters << (('A'..'Z').to_a - vowels).sample }
    @letters.shuffle
  end

  def english_word
    url = URI("https://wagon-dictionary.herokuapp.com/#{@answer}")
    response = Net::HTTP.get(url)
    word = JSON.parse(response)
    word['found']
  end

  def letter_in_grid
    @answer.chars.sort.all? { |letter| @grid.include?(letter) }
  end

  def score
    @grid = params[:grid]
    @answer = params[:word]
    @result = if !letter_in_grid
                "Sorry, but #{@answer.upcase} cant be built out of #{@grid}."
              elsif !english_word
                "Sorry but #{@answer.upcase} does not seem to be an English word."
              else
                word_length = @answer.length
                game_score = word_length
                session[:score] += game_score
                @result = "Congratulations! #{@answer.upcase} is a valid English word."
              end
  end
end
