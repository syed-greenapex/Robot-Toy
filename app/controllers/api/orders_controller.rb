class Api::OrdersController < ApplicationController
  before_action :set_default_values, only: [:create]
  def create
    if params[:command].present?
      render json: location(params[:command]), status: :ok
    end
  end

  private

  DIRECTIONS = [:north, :east, :south, :west]

  def set_default_values
    @x = 0
    @y = 0
    @facing = nil
  end

  def place(x,y,facing)
    @x = x
    @y = y
    @facing = facing.downcase.to_sym
  end

  def move
    case @facing
    when :north
      @y += 1 if @y < 5
    when :east
      @x += 1 if @x < 5
    when :south
      @y -= 1 if @y > 0
    when :west
      @x -= 1 if @x > 0
    end
  end

  def left
    @facing = DIRECTIONS[(DIRECTIONS.index(@facing) - 1) % 4]
  end

  def right
    @facing = DIRECTIONS[(DIRECTIONS.index(@facing) + 1) % 4]
  end

  def report
    { "location": [@x,@y, "#{@facing.to_s.upcase}"] }
  end

  def location(commands)
    commands.each do |command|
      case command
      when /^place (\d+),(\d+),\s*([a-zA-Z]+)$/i
        place($1.to_i,$2.to_i,$3)
      when "MOVE"
        move
      when "LEFT"
        left
      when "RIGHT"
        right
      when "REPORT"
        return report
      end
    end
  end
end
