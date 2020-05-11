require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    7.times do 
      letter = ("a".."z").to_a.sample
      @letters << letter
    end
    @letters
  end

  def score
    answer = params[:answer]
    startTime = Time.parse(params[:start_time])
    totalTime = Time.now - startTime
    if checkAnswerValid(answer, params[:letters])
      result = getResult(answer)
      if result["found"] == true
        @message = "Congrats! '#{answer}' is a valid english word!"
        @score = (result["length"] * 5 - totalTime / 2).truncate
      else
        @message = "Sorry but '#{answer}' is not a valid english word..."
        @score = 0
      end
    else
      lettersToDisplay = params[:letters].split(' ').to_a.join(", ")
      @message = "Sorry but '#{answer}' can't be built from #{lettersToDisplay}"
      @score = 0
    end
  end

  def getResult(answer)
    file = open("https://wagon-dictionary.herokuapp.com/#{answer}").read
    return JSON.parse(file)
  end

  def checkAnswerValid(answer, letters)
    letters.split(" ")
    answer.split('').all? { |letter| letters.include?(letter) }
  end
end
