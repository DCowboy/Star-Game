
extends Panel
var globals
var client
var player
var ship
var race
var scale
var movie_mode = false

var explanation
var choice

func _ready():
	globals = get_node("/root/globals")
	client = preload('res://client.scn')
	player = get_node("/root/player")
	explanation = get_node("explanation")
	choice = get_node("choice")
	ship = {}


func _on_confirm_pressed():
	if 'hull' in ship:
		if movie_mode:
			globals.movie_mode = true
			player.add_controls(preload('res://npcs/small_npc_controls.gd').new())
		else:
			player.add_controls(preload('res://player/player_control.gd').new())
		player.race = race
		player.scale = scale
		player.ships.append(ship)
		player.current_ship = ship.hull
		player.current_ship_instance.status = ship.status
		player.current_ship_instance.cargo = ship.cargo
		for child in get_children():
			child.queue_free()
		call_deferred('replace_by', client.instance())
	else:
		get_node("explanation").set_text('Need to choose a ship before you can start! Dumbass!')


func _on_chentia_fighter_mouse_enter():
		explanation.set_text('Chentia Fighter:\n'\
						+ 'Size: small \n' \
						+ 'view is closest to playfield \n' \
						+ 'equipped with small cannon. \n' \
						+ 'spawns at Chentia Station.')


func _on_chentia_fighter_mouse_exit():
	explanation.set_text('')


func _on_terran_interceptor_mouse_enter():
	explanation.set_text('Terran Interceptor:\n'\
						+ 'Size: small \n' \
						+ 'view is closest to playfield \n' \
						+ 'equipped with small cannon. \n' \
						+ 'spawns at Terran Station.')



func _on_terran_interceptor_mouse_exit():
	explanation.set_text('')



func _on_terran_corvette_mouse_enter():
	explanation.set_text('Terran Corvette:\n'\
						+ 'Size: medium \n' \
						+ 'view of playfield is 1.5 times larger than small ship \n' \
						+ 'still uses small cannon so range feels somewhat short. \n' \
						+ 'spawns at Terran Station.')



func _on_terran_corvette_mouse_exit():
	explanation.set_text('')



func _on_terran_warship_mouse_enter():
	explanation.set_text('Terran Warship:\n' \
						+ 'Size: large \n' \
						+ 'view of playfield is 2 times that of small ship \n' \
						+ 'Still uses small cannon, so range feels really short. \n' \
						+ 'spawns at Terran Station.')

	
	
func _on_terran_warship_mouse_exit():
	explanation.set_text('')


func _on_chentia_fighter_toggled( pressed ):
	race = 'chentia'
	scale = Vector2(1, 1)
	ship = {'hull': preload('res://ships/chentia_fighter/chentia_fighter.scn'),
			'status': preload('res://ships/chentia_fighter/chentia_fighter_status.scn').instance(),
			'cargo': preload('res://ships/small_normal_inventory.scn').instance()}
	choice.set_text('Current Choice: Chentia Fighter')


func _on_terran_interceptor_toggled( pressed ):
	race = 'terran'
	scale = Vector2(1, 1)
	ship = {'hull': preload('res://ships/terran_interceptor/terran_interceptor.scn'),
			'status': preload('res://ships/terran_interceptor/terran_interceptor_status.scn').instance(),
			'cargo': preload('res://ships/small_normal_inventory.scn').instance()}
	choice.set_text('Current Choice: Terran Interceptor')


	
func _on_terran_corvette_pressed():
	race = 'terran'
	scale = Vector2(1.5, 1.5)
	ship = {'hull': preload('res://ships/terran_corvette/terran_corvette.scn'),
			'status': preload('res://ships/terran_corvette/terran_corvette_status.scn').instance(),
			'cargo': preload('res://ships/medium_normal_inventory.scn').instance()}
	choice.set_text('Current Choice: Terran Corvette')



func _on_terran_warship_pressed():
	race = 'terran'
	scale = Vector2(2, 2)
	ship = {'hull': preload('res://ships/terran_warship/terran_warship.scn'),
			'status': preload('res://ships/terran_warship/terran_warship_status.scn').instance(),
			'cargo': preload('res://ships/large_normal_inventory.scn').instance()}
	choice.set_text('Current Choice: Terran Warship')



func _on_movie_mode_toggled( pressed ):
	if movie_mode:
		movie_mode = false
	else:
		movie_mode = true



func _on_movie_mode_mouse_enter():
	explanation.set_text('if toggled, uses the current AI being worked on. Player does nothing but watch.')


func _on_movie_mode_mouse_exit():
	explanation.set_text('')
