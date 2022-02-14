class GamesController < ApplicationController
  def new
    chars = ('A'..'Z').to_a
    @letters = (0...10).map { chars.sample }
  end

  def score
    @letters = params[:letters]
    @word = params[:word].upcase

    buildable = buildable?(@word.split(''), @letters.split(''))

    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    found = JSON.parse(URI.open(url).read)['found']

    @result = result(buildable, found)
  end

  private

  def buildable?(word, letters)
    buildable = true
    word.each do |w|
      w_index = letters.index(w)
      if w_index
        letters.delete_at(w_index)
      else
        buildable = false
      end
    end
    buildable
  end

  def result(buildable, found)
    if buildable && found
      'won'
    elsif found
      'not buildable'
    else
      'not in dict'
    end
  end
end
