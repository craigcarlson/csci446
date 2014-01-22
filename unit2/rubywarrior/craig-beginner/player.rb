# #Craig Carlson
# #CSCI 446
# #Unit 2 Ruby Warrior
#Instance Var: there are a lot of inctance variables but there is one on line 32
#Class Var: Line 16
#Constants: Lines 19 & 20
#Array: Line 28
#Hash: Line 23
#Functions:
#Comments:

require 'pp'

class Player
  #Class Variables
  @last_known_health = nil

  #Two Constants
  RUNAWAY=(20 * 0.60).to_i
  STRONGHEALTH=(20 * 0.80).to_i

  #Here we have an hash of symbols
  OBJECTS=[ :stairs, :empty, :wall, :captive, :enemy ]

  #This look functoin allows the warrior to look around make moves based on what he or she sees
  def look(spaces)
  	#Here we have an array
    vision = {}

    spaces.each_with_index { |space, index|
      #instance variable
      distance = index.succ
      entity = OBJECTS.select { |type|
        space.send "#{type.to_s}?".to_sym
      }.first
      raise "woah" unless entity
      vision[:nearest] = entity unless vision[:nearest]
      if vision[entity]
        vision[entity] << distance
      else
        vision[entity] = [distance]
      end

      nearest_entity_key = "nearest_#{entity.to_s}".to_sym
      vision[nearest_entity_key] = distance unless vision[nearest_entity_key]
      
      #This adds the items that he sees to the array
      if vision[:view]
        vision[:view] << entity
      else
        vision[:view] = [entity]
      end
    }

    vision
  end

  #This is the primary function
  def play_turn(warrior)
  	#Determine if the warrior wa hurt during the last round
    @last_known_health = warrior.health unless @last_known_health
    took_damage = @last_known_health > warrior.health

    if warrior.feel.wall?
      warrior.pivot!
    elsif warrior.feel.enemy?
      warrior.attack!
    elsif warrior.feel.captive?
      warrior.rescue!
    else
      i_spy = [:backward, :forward].reduce({}) { |area, direction|
        area[direction] = look warrior.look(direction)
        area
      }

      if took_damage
        if warrior.health <= RUNAWAY
          warrior.walk! :backward
        else
          warrior.walk! :forward
        end
      elsif warrior.health < STRONGHEALTH
        warrior.rest!
      #If there are bad guys in front and behind then this deals with that by looking in multiple directions
      else
        if [:backward, :forward].all? { |dir| i_spy[dir][:enemy] } 
          if i_spy[:backward][:nearest_enemy] > i_spy[:forward][:nearest_enemy]
            warrior.pivot!
          else
            warrior.walk!
          end
        else
          warrior.walk!
        end
      end
    end
    @last_known_health = warrior.health
  end
end
