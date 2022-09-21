# require neccesary file
require "colorize"
require_relative "initial_messages"
require_relative "pokedex/pokemons"
require_relative "player"
require_relative "pokemon"
require_relative "battle"

class Game
  def start
    # Create a welcome method(s) to get the name, pokemon and pokemon_name from the user
    my_name = message_welcome

    # Then create a Player with that information and store it in @player
    my_pokemon = second_message(my_name)
    my_name_pokemon = message_name_pokemon(my_pokemon)

    # Create instance Player
    player_pokemon = Player.new(my_name, 1, my_pokemon, my_name_pokemon)

    # Suggested game flow
    print_menu(my_name, player_pokemon)
    puts "-----------------------Menu-----------------------"
    action_list = ["stats", "train", "leader", "exit"]
    action = choose_action(action_list).capitalize

    until action == "Exit"
      case action
      when "Train"
        train(player_pokemon)
        action = choose_action(action_list).capitalize
        puts " "
      when "Leader"
        challenge_leader(player_pokemon)
        action = choose_action(action_list).capitalize
        puts " "
      when "Stats"
        show_stats(player_pokemon)
        action = choose_action(action_list).capitalize
      end
    end

    goodbye
  end

  def train(player_pokemon)
    # Complete this
    # Creamos un arreglo para simular el nombre de los bots
    name_random = ["Ash", "Misty", "Gary", "James", "Jessie"].sample

    # Creamos una instancia de boot, pero de acuerdo al nivel del usuario
    level_player = player_pokemon.pokemon_player.level
    initial_level = 1
    final_level = level_player + 3
    initial_level = level_player > 3 ? level_player - 2 : initial_level

    bot_pokemon = Bot.new(name_random, rand(initial_level...final_level))
    option = print_start_message_train(player_pokemon, bot_pokemon)

    if option == "fight"
      battle = Battle.new(player_pokemon, bot_pokemon)
      battle.start
    end
    puts "-----------------------Menu-----------------------"
  end

  def challenge_leader(player_pokemon)
    # Complete this
    brook = Bot.new("Brock", 10, "Onix", "Onix")
    option = print_start_message_leader(player_pokemon, brook)
    if option == "fight"
      battle = Battle.new(player_pokemon, brook)
      battle.start
    end
    return unless brook.pokemon_player.fainted?

    puts "Congratulation! You have won the game!"
    puts "You can #{'continue'.green} training your Pokemon if you want"
    puts "-----------------------Menu-----------------------"
  end

  def show_stats(my_pokemon)
    # Complete this
    my_pokemon = my_pokemon.pokemon_player
    print_stats(my_pokemon)
    puts "-----------------------Menu-----------------------"
  end

  def print_stats(my_pokemon)
    puts "\n#{my_pokemon.name}: "
    puts "Kind: #{my_pokemon.species}"
    puts "Level: #{my_pokemon.level}"
    puts "Type: #{my_pokemon.type.join(', ')} \nStats: "
    puts "HP : #{my_pokemon.stats[:hp]}"
    puts "Attack: #{my_pokemon.stats[:attack]}"
    puts "Defense: #{my_pokemon.stats[:defense]}"
    puts "Special Attack: #{my_pokemon.stats[:special_attack]}"
    puts "Special Defense: #{my_pokemon.stats[:special_defense]}"
    puts "Speed: #{my_pokemon.stats[:speed]}"
    puts "Experience Points: #{my_pokemon.experience_points}"
  end

  def goodbye
    # Complete this
    puts "\nThanks for playing Pokemon Ruby"
    puts "This game was created with love by:"
    puts "- Farromeque Ricalde Cielo "
    puts "- Montoya Castañeda David"
    puts "- Silupú Moscol Christhian"
    puts "- Tordoya Suca José Luis"
    puts "* Gracias Andree por hacernos sufrir y llorar lagrimas de sangre :V, pero lo logramos :D".red
  end
end

game = Game.new
game.start
