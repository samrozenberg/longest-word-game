# frozen_string_literal: true

require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def valid_attempt
    params[:answer].upcase.chars.all? do |letter|
      params[:letters].include?(letter) && params[:answer].upcase.count(letter) <= params[:letters].count(letter)
    end
  end

  def score
    @result = if valid_attempt
                attempt_url = "https://wagon-dictionary.herokuapp.com/#{params[:answer]}"
                api_file_tranformed = URI.open(attempt_url).read
                parsed = JSON.parse(api_file_tranformed)
                if parsed['found']
                  'The word is valid according to the grid and is an English word.'
                else
                  'The word is valid according to the grid, but is not a valid English word.'
                end
              else
                'The word can’t be built out of the original grid.'
              end
  end
end
