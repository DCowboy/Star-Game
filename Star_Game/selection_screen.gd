
extends Panel
var globals
var client
var player
var ship

var explanation
var choice

func _ready():
	globals = get_node("/root/globals")
	client = preload('res://client.scn')
	player = get_node("/root/player")
	explanation = get_node("explanation")
	choice = get_node("choice")
	ship = {}


func _on_terran_interceptor_mouse_enter():
	explanation.set_text('Terran Interceptor: Currently does the same damn thing as every ship you see here')



func _on_terran_interceptor_mouse_exit():
	explanation.set_text('')



func _on_terran_corvette_mouse_enter():
	explanation.set_text('Terran Corvette: Currently does the same damn thing as every ship you see here')



func _on_terran_corvette_mouse_exit():
	explanation.set_text('')



func _on_terran_warship_mouse_enter():
	explanation.set_text('Terran Warship: Currently does the same damn thing as every ship you see here')

	
	
func _on_terran_warship_mouse_exit():
	explanation.set_text('')


func _on_terran_interceptor_toggled( pressed ):
	ship = {'hull': preload('res://ships/terran_interceptor/terran_interceptor.scn'),
			'status': preload('res://ships/terran_interceptor/terran_interceptor_status.scn').instance(),
			'cargo': preload('res://ships/small_normal_inventory.scn').instance()}
	choice.set_text('Current Choice: Terran Interceptor')


	
func _on_terran_corvette_pressed():
	ship = {'hull': preload('res://ships/terran_corvette/terran_corvette.scn'),
			'status': preload('res://ships/terran_corvette/terran_corvette_status.scn').instance(),
			'cargo': preload('res://ships/medium_normal_inventory.scn').instance()}
	choice.set_text('Current Choice: Terran Corvette')



func _on_terran_warship_pressed():
	ship = {'hull': preload('res://ships/terran_warship/terran_warship.scn'),
			'status': preload('res://ships/terran_warship/terran_warship_status.scn').instance(),
			'cargo': preload('res://ships/large_normal_inventory.scn').instance()}
	choice.set_text('Current Choice: Terran Warship')


func _on_confirm_pressed():
	if ship != null:
		player.ships.append(ship)
		player.current_ship = ship.hull
		player.current_ship_instance.status = ship.status
		player.current_ship_instance.cargo = ship.cargo
		for child in get_children():
			child.queue_free()
		call_deferred('replace_by', client.instance())
	else:
		get_node("explanation").set_text('Need to choose a ship before you can start! Dumbass!')


