require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters]
    @word = params[:word].upcase

    buildable = @word.chars.all? { |letter| @word.count(letter) <= @letters.count(letter) }

    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    found = JSON.parse(URI.open(url).read)['found']

    @result = result(buildable, found, @word.length)

    session[:total_score] = (session[:total_score] || 0) + @score
  end

  private

  def result(buildable, found, length)
    if buildable && found
      @score = length**2
      'won'
    elsif found
      @score = 0
      'not buildable'
    else
      @score = 0
      'not in dict'
    end
  end
end
