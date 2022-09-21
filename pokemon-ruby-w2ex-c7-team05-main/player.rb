# require neccesary files
require "colorize"
require_relative "pokemon"
require_relative "pokedex/pokemons"
require_relative "initial_messages"
require_relative "pokedex/moves"

class Player
  attr_reader :name_player, :pokemon_player, :pokemon_species, :name_pokemon

  # (Complete parameters)

  def initialize(name_player, level = 1, pokemon_species = "", name_pokemon = "")
    # Complete this
    @name_player = name_player
    @pokemon_player = Pokemon.new(name_pokemon, pokemon_species, level)
    # @pokemon_species = pokemon_species
    # @name_pokemon = name_pokemon
  end

  def select_move
    # Complete this
    puts "#{@pokemon_player.name}, #{'select'.blue} your move:\n\n"
    move = choose_action(@pokemon_player.moves)
    @pokemon_player.current_move = Pokedex::MOVES[move]
  end
end

# Create a class Bot that inherits from Player and override the select_move method
class Bot < Player
  def initialize(name_bot, level, pokemon_species = "", _name_pokemon = "")
    data = Pokedex::POKEMONS
    bot_list_pokemons = pokemon_species.empty? ? data.to_a.sample : data.find { |_n, d| d[:species] == pokemon_species }
    bot_pokemon = Hash[*bot_list_pokemons]
    bot_pokemon_keys = bot_pokemon.keys[0]
    level_bot = level

    super(name_bot, level_bot, bot_pokemon[bot_pokemon_keys][:species], bot_pokemon_keys.upcase)
  end

  def select_move
    # codigo aqui
    move = @pokemon_player.moves.sample
    @pokemon_player.current_move = Pokedex::MOVES[move]
  end
end
