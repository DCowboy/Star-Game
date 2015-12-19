
extends Area2D

var life = 0
var lifetime = 600

func _ready():
	set_process(true)
	pass


func _process(delta):
	life += 1
	var hits = get_overlapping_bodies()
	if hits.size() > 0:
		if hits[0].type == 'projectile':
			queue_free()
		else:
			hits[0].change_energy('add', 25)
			queue_free()
	if life >= lifetime:
		queue_free()