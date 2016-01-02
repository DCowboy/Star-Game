#need to fix
extends Node2D
const type = 'cannon'
var owner
var ammo
var shot_count = 0
var fire_delay = 0
var fire_rate = 15
var fire_range
var payload_modifier = 0
var globals
var player

func _ready():
	globals = get_node("/root/globals")
	player = get_node("/root/player")
	ammo = preload('res://npcs/projectiles/laser_shot.scn')
	owner = get_parent().get_parent().get_parent()
	fire_range = owner.fire_range
	payload_modifier = owner.payload_modifier
	set_process(true)


func _process(delta):
	if fire_delay > 0:
		fire_delay -= 1



func fire():
	if fire_delay <= 0:
		#make player have to press button again to shoot again
		fire_delay = fire_rate
		#fire cost
		owner.energy -= .25
		#create shot and send it off
		var shot = ammo.instance()
		#there has got to be a better way to set the position correctly
		var weapon_size = get_node('Sprite').get_texture().get_size()
		shot.set_pos(get_global_pos() - Vector2(0, weapon_size.y / 2).rotated(owner.get_rot()))
		shot.origin = shot.get_pos()
		shot.set_rot(owner.get_rot())
		shot.direction = Vector2(cos(owner.get_rot() + deg2rad(90)), -sin(owner.get_rot() + deg2rad(90)))
		shot.acceleration = owner.get_linear_velocity().length()
		#sets a unique name to later be identified if needed
		shot.set_name(shot.get_name() + ' ' + str(shot_count))
		shot.owner = owner
		shot.fire_range = fire_range + owner.get_linear_velocity().length()
		shot.payload_modifier = payload_modifier
		add_to_group('object', true)
		globals.current_map.add_child(shot)
		PS2D.body_add_collision_exception(shot.get_rid(),owner.get_rid())
		PS2D.body_add_collision_exception(shot.get_rid(), player.home_station.defender.get_rid())
		shot_count += 1
		#reset counter to reuse numbers for unique name
		if shot_count >= 25:
			shot_count = 0
			