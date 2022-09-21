require_relative "initial_messages"
require_relative "pokedex/moves"

class Battle
  # (complete parameters)
  def initialize(player_pokemon, bot_pokemon)
    # Complete this
    @player_pokemon = player_pokemon
    @bot_pokemon = bot_pokemon
    @pokemon_of_player = @player_pokemon.pokemon_player
    @pokemon_of_bot = @bot_pokemon.pokemon_player
  end

  def start
    # Prepare the Battle (print messages and prepare pokemons)
    @pokemon_of_player.prepare_for_battle
    @pokemon_of_bot.prepare_for_battle
    print_message_start_battle(@player_pokemon, @bot_pokemon)
    until @pokemon_of_player.fainted? || @pokemon_of_bot.fainted?
      @player_pokemon.select_move
      @bot_pokemon.select_move
      first = select_first(@pokemon_of_player, @pokemon_of_bot)
      second = first == @pokemon_of_player ? @pokemon_of_bot : @pokemon_of_player
      puts "--------------------------------------------------\n"
      first.attack(second)
      puts "--------------------------------------------------"

      unless second.fainted?
        second.attack(first)
        puts "--------------------------------------------------"
        print_message_status(@player_pokemon.name_player, @player_pokemon.pokemon_player, @bot_pokemon.name_player,
                             @bot_pokemon.pokemon_player)
      end
      puts ""
    end

    winner = @pokemon_of_player.fainted? ? @pokemon_of_bot : @pokemon_of_player
    loser = winner == @pokemon_of_player ? @pokemon_of_bot : @pokemon_of_player

    if @pokemon_of_player.fainted?
      puts "#{@pokemon_of_player.name.upcase} FAINTED!"
    else
      puts "#{@pokemon_of_bot.name.upcase} FAINTED!"
    end
    puts "-------------------------------------------------"

    winner.gain_effort_points(loser)
    winner.increase_stats(loser)

    if @pokemon_of_bot.fainted?
      puts "#{@pokemon_of_player.name.upcase} WINS!"
      puts "#{@pokemon_of_player.name.upcase} gained #{@pokemon_of_player.gain_exp} experience points"
    end

    puts "--------------------Battle Ended!-----------------"
  end

  def select_first(pokemon_of_player, pokemon_of_bot)
    player_move = pokemon_of_player.current_move
    bot_move = pokemon_of_bot.current_move

    return pokemon_of_player if player_move[:priority] > bot_move[:priority]

    return pokemon_of_bot if player_move[:priority] < bot_move[:priority]

    return pokemon_of_player if pokemon_of_player.stats[:speed] > pokemon_of_bot.stats[:speed]

    return pokemon_of_bot if pokemon_of_player.stats[:speed] < pokemon_of_bot.stats[:speed]

    [pokemon_of_player, pokemon_of_bot].sample
  end
end
