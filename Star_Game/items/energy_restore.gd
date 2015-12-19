
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process(true)
	pass


func _process(delta):
	var hits = get_overlapping_bodies()
	if hits.size() > 0:
		if hits[0].type == 'projectile':
			queue_free()
		else:
			hits[0].change_energy('add', 25)
			queue_free()