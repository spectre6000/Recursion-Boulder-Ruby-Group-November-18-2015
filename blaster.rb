class Gun

  def initialize
    @power_ups = 0
    @bullets = 0
  end

  def collect_power_up( strength )
    @power_ups += strength
  end

  def collect_ammo( quantity )
    @bullets += quantity
  end

  def sound( noise )
    puts noise
  end

end

class Ultrablaster < Gun

  def shoot( level = @power_ups, ammo = @bullets )
    fire( "PEW!", level ) if ammo > 0 && level > 0
    fire( "click", level ) if ammo <= 0 && level > 0
  end

  def fire( gun_sound, level )
    sound( gun_sound )
    @bullets -= 1 if @bullets > 0
    shoot( level - 1 )
  end

end

gun = Ultrablaster.new

gun.collect_power_up( 5 )
gun.collect_ammo( 9 )

puts( "first shot:")
gun.shoot 

puts( "second shot:")
gun.shoot

puts( "third shot:")
gun.shoot
