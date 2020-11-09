require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('a'..'z').to_a.sample }
  end

  def validword?(proposition)
    url = open("https://wagon-dictionary.herokuapp.com/#{proposition}")
    json = JSON.parse(url.read)
    json['found']
  end

  def fitletters?(proposition, letters)
    array = []
    proposition.each_char do |char|
      array << char if letters.include?(char)
    end
    array.length == proposition.length
  end

  def score
    @letters = params[:letters]
    @proposition = params[:longestword]

    if fitletters?(@proposition, @letters) && validword?(@proposition)
      @score = "Congratulations! #{@proposition.upcase} is a valid Enlish word."
    elsif fitletters?(@proposition, @letters)
      @score = "Sorry but #{@proposition.upcase} does not seem to be a valid English word..."
    else
      @score = "Sorry but #{@proposition.upcase} can't be build out of #{@letters.upcase}."
    end
  end
end
