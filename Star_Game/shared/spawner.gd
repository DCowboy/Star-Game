
extends Node

# member variables here, example:
# var a=2
var poor_dead_bastard

func _ready():
	
	pass

func wait(name, race):
	poor_dead_bastard = {'name':name, 'race':race}
	if poor_dead_bastard.race != 'neutral':
		get_node("Timer").start()
	


func _on_Timer_timeout():
	get_node("Timer").stop()
	var respawn_pos
	if poor_dead_bastard.race == 'blue':
		respawn_pos = Vector2(-3545, 4015)
	if poor_dead_bastard.name == 'Player':
		var spawn = get_node("/root/globals").object_types.player.instance()
		spawn.set_pos(respawn_pos)
		get_node("/root/client").add_child(spawn)
		
	pass

	
	pass # replace with function body
