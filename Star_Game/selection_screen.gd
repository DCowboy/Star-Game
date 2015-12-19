
extends Panel

var client

func _ready():
	client = preload('res://client.scn')
	pass


func _on_terran_corvette_mouse_enter():
	get_node("explanation").set_text('Terran Corvette: Currently does the same damn thing as every ship you see here')
	pass # replace with function body


func _on_terran_corvette_mouse_exit():
	get_node("explanation").set_text('')
	pass # replace with function body


func _on_terran_warship_mouse_enter():
	get_node("explanation").set_text('Terran Warship: Currently does the same damn thing as every ship you see here')
	pass # replace with function body
	
	
func _on_terran_warship_mouse_exit():
	get_node("explanation").set_text('Terran Warship: Currently does the same damn thing as every ship you see here')
	pass # replace with function body
	
	
func _on_terran_corvette_pressed():
	get_node("/root/globals").player['ship'] = get_node("/root/globals").ships.terran_corvette.scene
	get_node("/root/globals").player['status'] = get_node("/root/globals").ships.terran_corvette.status
	get_node("choice").set_text('Current Choice: Terran Corvette')
	pass # replace with function body


func _on_terran_warship_pressed():
	get_node("/root/globals").player['ship'] = get_node("/root/globals").ships.terran_warship.scene
	get_node("/root/globals").player['status'] = get_node("/root/globals").ships.terran_warship.status
	get_node("choice").set_text('Current Choice: Terran Warship')
	pass # replace with function body


func _on_confirm_pressed():
	if get_node("/root/globals").player.ship != null:
		for child in get_children():
			child.queue_free()
		call_deferred('replace_by', client.instance())
	else:
		get_node("explanation").set_text('Need to choose a ship before you can start! Dumbass!')
	pass # replace with function body
