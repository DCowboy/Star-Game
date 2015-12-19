
extends Area2D

var life = 0
var lifetime = 3000
var time = 0
var switch_time = 40
var anim 
func _ready():
	set_scale(get_node("/root/globals").player_scale)
	anim = get_node("Sprite")
	set_process(true)
	pass


func _process(delta):
	life += 1
	time += 1
	if time >= switch_time:
		if anim.get_frame() == anim.get_hframes() -1:
			anim.set_frame(0)
		else:
			anim.set_frame(anim.get_frame() + 1)
		time = 0
	var hits = get_overlapping_bodies()
	if hits.size() > 0:
		if hits[0].type == 'projectile':
			queue_free()
		else:
			hits[0].change_health('add', 25)
			queue_free()
	if life >= lifetime:
		queue_free()

