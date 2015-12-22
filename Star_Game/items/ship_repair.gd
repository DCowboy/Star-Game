
extends Area2D

var usable = true
var use_now = true
var owner = null
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
		elif use_now == true:
			owner = hits[0]
			use_item()
			queue_free()
		elif 'cargo' in hits[0]:
			owner = hits[0]
			hits[0].cargo.add_item(self)
			queue_free()
	if life >= lifetime:
		queue_free()


func use_item():
	owner.change_energy('add', 25)
	queue_free()
	