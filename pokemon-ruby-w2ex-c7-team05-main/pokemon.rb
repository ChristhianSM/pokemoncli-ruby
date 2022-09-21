# require neccesary files
require "colorize"
require_relative "pokedex/pokemons"

class Pokemon
  attr_reader :name, :species, :type, :level, :stats, :experience_points, :moves, :base_exp, :gain_exp, :effort_values
  attr_accessor :current_hp, :current_move, :effort_points

  # include neccesary modules

  # (complete parameters)
  def initialize(name, specie, level = 1)
    # Retrieve pokemon info from Pokedex and set instance variables
    # Calculate Individual Values and store them in instance variable
    # Create instance variable with effort values. All set to 0
    # Store the level in instance variable
    # If level is 1, set experience points to 0 in instance variable.
    # If level is not 1, calculate the minimum experience point for that level and store it in instance variable.
    # Calculate pokemon stats and store them in instance variable
    pokemon_details = Pokedex::POKEMONS[specie]
    @name = name.length.zero? ? pokemon_details[:species] : name
    @species = specie
    @type = pokemon_details[:type]
    @base_exp = pokemon_details[:base_exp]
    @growth_rate = pokemon_details[:growth_rate]
    @base_stats = pokemon_details[:base_stats]
    @moves = pokemon_details[:moves]
    @level = level
    @individual_stats = obtain_individual_stats_initial
    @effort_points = pokemon_details[:effort_points]
    # @gain_effort_points = nil
    @effort_values = obtain_individual_effort_values
    @experience_points = @level > 1 ? obtain_experience(@level).floor : 0
    @gain_exp = nil
    @next_exp_level = obtain_experience(@level + 1).floor
    @stats = obtain_individual_initial_stats

    @current_hp = nil
    @current_move = nil
  end

  # Modificar metodo
  def obtain_experience(level)
    return (5 * (level**3)) / 4 if @growth_rate == :slow

    return ((1.2 * (level**3)) + (100 * level) - (15 * (level**2)) - 140) if @growth_rate == :medium_slow

    return level**3 if @growth_rate == :medium_fast

    (4 * (level**3)) / 5
  end

  # obtener stats
  def obtain_stats(value)
    symbol = value.to_sym
    if symbol == :hp
      ((((2 * @base_stats[symbol]) + @individual_stats[symbol] + @effort_values[symbol]) * @level / 100) + @level + 10)
    else
      symbol = value.to_sym
      ((((2 * @base_stats[symbol]) + @individual_stats[symbol] + @effort_values[symbol]) * @level / 100) + 5).floor
    end
  end

  def prepare_for_battle
    # Complete this
    @current_hp = @stats[:hp]
    @current_move = nil
  end

  def receive_damage(damage)
    # Complete this
    @current_hp -= damage
  end

  def fainted?
    # Complete this
    !@current_hp.positive?
  end

  def attack(target)
    # Print attack message 'Tortuguita used MOVE!'
    puts "#{@name} used #{@current_move[:name]}!"

    # Accuracy check
    random_number = rand(1..100)
    hits = @current_move[:accuracy] >= random_number

    # If the movement is not missed
    if hits
      # -- Calculate base damage
      is_special_move = Pokedex::SPECIAL_MOVE_TYPE.include?(@current_move[:type])
      offe_st = is_special_move ? @stats[:special_attack] : @stats[:attack]
      t_deff_stat = is_special_move ? target.stats[:special_defense] : target.stats[:defense]

      damage = ((((2 * @level / 5.0) + 2).floor * offe_st * @current_move[:power] / t_deff_stat).floor / 50.0).floor + 2

      # -- Critical Hit check
      # -- If critical, multiply base damage and print message 'It was CRITICAL hit!'
      damage *= critical_damage

      # -- Effectiveness check
      # -- Mutltiply damage by effectiveness multiplier and round down. Print message if neccesary
      damage *= damage_final(@current_move[:type], target.type, target.name)

      # -- Inflict damage to target and print message "And it hit [target name] with [damage] damage""
      puts "And it hit #{target.name} with #{damage.floor.to_s.red} damage"

      target.receive_damage(damage)
      # puts "Hits #{character.name} and #{@current_move[:power]} damage"
    else
      # Else, print "But it MISSED!"
      puts "#{@name.to_s.red} #{'failed to hit'.red} #{target.name.red} #{'and didn`t cause any damage'.red}"
    end
  end

  def increase_stats(target)
    # Increase stats base on the defeated pokemon and print message "#[pokemon name] gained [amount] experience points"
    @gain_exp = (target.base_exp * target.level / 7.0).floor
    @experience_points += @gain_exp
    @next_exp_level = obtain_experience(@level + 1)

    # If the new experience point are enough to level up, do it and print
    # message "#[pokemon name] reached level [level]!" # -- Re-calculate the stat
    return unless @experience_points >= @next_exp_level

    level_counter = 1
    level_counter += 1 while @experience_points > obtain_experience(@level + level_counter + 1)

    @level += level_counter
    puts "#{@name} reached level #{@level}!"
    imcrement_stats_pokemon
  end

  # private methods:
  # Create here auxiliary methods
  def obtain_individual_stats_initial
    {
      hp: rand(0..31),
      attack: rand(0..31),
      defense: rand(0..31),
      special_attack: rand(0..31),
      special_defense: rand(0..31),
      speed: rand(0..31)
    }
  end

  def obtain_individual_effort_values
    {
      hp: 0,
      attack: 0,
      defense: 0,
      special_attack: 0,
      special_defense: 0,
      speed: 0
    }
  end

  def obtain_individual_initial_stats
    {
      hp: obtain_stats("hp").floor,
      attack: obtain_stats("attack"),
      defense: obtain_stats("defense"),
      special_attack: obtain_stats("special_attack"),
      special_defense: obtain_stats("special_defense"),
      speed: obtain_stats("speed")
    }
  end

  def critical_damage
    number_random = 5
    if number_random == rand(1..16)
      message_critical = "It was a CRITICAL hit!"
      puts message_critical.red
      return 1.5
    end

    1
  end

  def damage_final(pokemon_one, pokemon_two, name_pokemon)
    # pokemon_one -> Representa el tipo de ataque que se efectuo, si es tackle es normal, si es bubble es agua
    # pokemon_two -> Representa el tipo de pokemon que es, charmander es de tipo fuego
    multiplier_list = Pokedex::TYPE_MULTIPLIER
    arr_multiplicador = multiplier_list.select do |item|
      pokemon_one == item[:user] && pokemon_two.include?(item[:target])
    end

    number = 1
    arr_multiplicador.each { |element| number *= element[:multiplier] } unless arr_multiplicador.length.zero?

    # ---- "It's not very effective..." when effectivenes is less than or equal to 0.5
    puts "It'#{'s not very effective...'.yellow}" if [0.5].include?(number)

    # ---- "It's super effective!" when effectivenes is greater than or equal to 1.5
    puts "It'#{'s super effective!'.red}" if number >= 2

    # ---- "It doesn't affect [target name]!" when effectivenes is 0
    puts "It doesn't affect #{name_pokemon}!" if number.zero?

    number
  end

  def imcrement_stats_pokemon
    @stats = {
      hp: obtain_stats("hp").floor,
      attack: obtain_stats("attack"),
      defense: obtain_stats("defense"),
      special_attack: obtain_stats("special_attack"),
      special_defense: obtain_stats("special_defense"),
      speed: obtain_stats("speed")
    }
  end

  def gain_effort_points(target)
    @effort_values[target.effort_points[:type]] = target.effort_points[:amount]
  end
end
