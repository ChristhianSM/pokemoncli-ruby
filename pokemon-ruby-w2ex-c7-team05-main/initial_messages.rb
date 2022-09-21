require "colorize"
def optain_name_player
  my_name = gets.chomp
  while my_name.length.zero?
    puts "Please, put a name correct"
    puts "First, what is your name?"
    print "> "
    my_name = gets.chomp
  end
  my_name.capitalize
end

def message_welcome
  puts "#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#".green
  puts "#$#$#$#$#$#$#$ #{' ' * 30}#$#$#$#$#$#$#$ ".green
  puts "#$##$##$##$ --- #{' ' * 7} Pokemon Ruby#{' ' * 7} --- #$##$##$#$#".green
  puts "#$#$#$#$#$#$#$ #{' ' * 30}#$#$#$#$#$#$#$ ".green
  puts "#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#\n\n".green
  puts "Hello there! Welcome to the world of POKEMON! My name is OAK! \nPeople call me the POKEMON PROF!\n\n"
  puts "This world is inhabited by creatures called POKEMON! For some"
  puts "people, POKEMON are pets. Others use them #{'for'.blue} fights. Myself..."
  puts "I study POKEMON as a profession."
  puts "First, what is your name?"
  print "> "
  optain_name_player
end

def second_message(my_name)
  starters = ["bulbasaur", "charmander", "squirtle"]
  puts "Right! So your name is #{my_name.capitalize}!"
  puts "Your very own POKEMON legend is about to unfold! A world of"
  puts "dreams and adventures with POKEMON awaits! Let's go!"
  puts "Here, #{my_name.capitalize}! There are 3 POKEMON here! Haha!"
  puts "When I was young, I was a serious POKEMON trainer."
  puts "In my old age, I have only 3 left, but you can have one! Choose!\n"
  choose_action(starters).capitalize
end

def message_name_pokemon(my_pokemon)
  puts ""
  puts "You selected #{my_pokemon.upcase}. Great choice!"
  puts "Give your pokemon a name?"
  print "> "
  gets.chomp.capitalize
end

def choose_action(options)
  puts " "
  options.each_with_index do |value, index|
    print "#{index + 1}. #{value.capitalize}        "
  end
  puts "\n"
  print "> "
  action = gets.chomp.downcase
  until options.include?(action)
    puts "Invalid action"
    print "> "
    action = gets.chomp.downcase
  end
  action
end

def print_menu(my_name, pokemon)
  puts "#{my_name.upcase}, raise your young #{pokemon.pokemon_player.name.upcase} by making it fight!"
  puts "When you feel ready you can challenge BROCK, the PEWTER's GYM LEADER"
end

# Messages Battle
def print_start_message_train(player_pokemon, bot_pokemon)
  puts "#{player_pokemon.name_player} challenge #{bot_pokemon.name_player} #{'for'.blue} training"
  puts "#{bot_pokemon.name_player} has a #{bot_pokemon.pokemon_player.name} level #{bot_pokemon.pokemon_player.level}"
  puts "What #{'do'.blue} you want to #{'do'.blue} now?"
  options = ["fight", "leave"]
  choose_action(options).downcase
end

def calculate_asteris(current_hp, hp_total)
  asterisk_color = 1
  points_for_asterisk = hp_total / 10.0  # 50 / 10   -> 5

  asterisk_color += 1 while asterisk_color * points_for_asterisk < current_hp

  asterisk_white = 10 - asterisk_color
  [asterisk_color, asterisk_white]
end

def calculate_color_hp(current_hp, hp_total)
  color = ""

  return color = :green if current_hp > hp_total * 0.6 && hp_total * 0.6 <= hp_total

  return color = :yellow if current_hp > hp_total * 0.3 && hp_total * 0.3 < hp_total * 0.6

  return color = :red if current_hp.positive? && current_hp < hp_total * 0.3

  color
end

def print_message_status(player, player_pokemon, bot, bot_player)
  hp_total_player = player_pokemon.stats[:hp]
  hp_total_bot = bot_player.stats[:hp]
  hp_current_player = player_pokemon.current_hp.floor
  hp_current_bot = bot_player.current_hp

  return unless player_pokemon.current_hp.positive? && bot_player.current_hp.positive?

  color = calculate_color_hp(hp_current_player, hp_total_player)
  a_color, a_white = calculate_asteris(hp_current_player, hp_total_player)
  puts "#{player}'s #{player_pokemon.name.upcase} - Level #{player_pokemon.level}"
  print "HP: #{hp_current_player.floor.to_s.colorize(color)} "
  print "#{'*' * a_color}".to_s.colorize(color)
  puts  "#{'*' * a_white}".to_s.colorize(:white)
  puts ""

  color = calculate_color_hp(hp_current_bot, hp_total_bot)
  a_color, a_white = calculate_asteris(hp_current_bot, hp_total_bot)
  puts "#{bot}'s #{bot_player.name.capitalize} - Level #{bot_player.level}"
  print "HP: #{hp_current_bot.floor.to_s.colorize(color)} "
  print "#{'*' * a_color}".to_s.colorize(color)
  puts  "#{'*' * a_white}".to_s.colorize(:white)
  puts "\n\n"
end

def print_message_start_battle(player_pokemon, bot_pokemon)
  player = player_pokemon.name_player
  player_pokemon = player_pokemon.pokemon_player
  bot = bot_pokemon.name_player
  bot_player = bot_pokemon.pokemon_player
  puts "#{bot} sent out #{bot_player.name.upcase}!"
  puts "#{player} sent out #{player_pokemon.name.upcase}!"
  puts "-------------------Battle Start!-------------------\n\n"
  print_message_status(player, player_pokemon, bot, bot_player)
end

def print_start_message_leader(player_pokemon, bot_pokemon)
  puts "#{player_pokemon.name_player} challenge the Gym Leader Brock for a fight!"
  puts "#{bot_pokemon.name_player} has a #{bot_pokemon.pokemon_player.name} level #{bot_pokemon.pokemon_player.level}"
  puts "What #{'do'.blue} you want to #{'do'.blue} now?"
  options = ["fight", "leave"]
  choose_action(options).downcase
end
