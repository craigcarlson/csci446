class Player
  def play_turn(warrior)

	    if warrior.feel.enemy?
	    	warrior.attack!
	    elsif warrior.feel.captive?
	    	warrior.rescue!
	    else
	    	if warrior.health < 15 && warrior.health >= @@lastTurnHealth
	    		warrior.rest!
	    	else
	    		warrior.walk!
	    	end
	    end

	    @@lastTurnHealth = warrior.health
  end
end
