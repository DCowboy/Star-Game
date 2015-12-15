
extends Node2D

# member variables here, example:
# var a=2
var poor_dead_bastard

func _ready():
	pass

func wait(name, race):
	print('starting respawn wait')
	poor_dead_bastard = {'name':name, 'race':race}
	if poor_dead_bastard.race != 'neutral':
		get_node("Timer").start()
	


func _on_Timer_timeout():
	print('waiting over')
	get_node("Timer").stop()
	var respawn_pos
	if poor_dead_bastard.race == 'terran':
		respawn_pos = Vector2(-3545, 4015)
	else:
		respawn_pos = Vector2(0, 0)
	if poor_dead_bastard.name == 'Player':
		print('respawning')
		var spawn = get_node("/root/globals").object_types.player.instance()
		spawn.set_pos(respawn_pos)
		get_node("/root/client").add_child(spawn)
		
