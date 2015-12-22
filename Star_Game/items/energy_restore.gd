
extends Area2D

var usable = true
var use_now = true
var owner = null
var life = 0
var lifetime = 3000

func _ready():
	set_scale(get_node("/root/globals").player_scale)
	if use_now == false:
		get_node("Sprite").show()
	set_process(true)
	pass


func _process(delta):
	life += 1
	var hits = get_overlapping_bodies()
	if hits.size() > 0:
		if hits[0].type == 'projectile':
			queue_free()
		elif use_now == true:
			owner = hits[0]
			use_item()
			queue_free()
		elif 'cargo' in hits[0]:
			owner = hits[0]
			hits[0].cargo.add_item(self)
			queue_free()


func use_item():
	owner.change_energy('add', 25)
	queue_free()
	