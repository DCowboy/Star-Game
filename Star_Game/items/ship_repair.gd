
extends Area2D

const name = 'ship_repair'
var usable = true
var use_now = true
var owner = null
var life = 0
var lifetime = 3000
var time = 0
var switch_time = 40
var anim 
func _ready():
	set_scale(get_node("/root/player").scale)
	anim = get_node("body")
	if use_now == false:
		get_node("bubble").show()
	else:
		get_node("bubble").hide()
	set_process(true)
	pass


func _process(delta):
	if str(get_parent().get_name()).find('slot') == -1:
		life += 1
	else:
		life = 0
	time += 1
	if time >= switch_time:
		if anim.get_frame() == anim.get_hframes() -1:
			anim.set_frame(0)
		else:
			anim.set_frame(anim.get_frame() + 1)
		time = 0
	var hits = get_overlapping_bodies()
	if hits.size() > 0:
		if 'projectiles' in hits[0].get_groups():
			queue_free()
		elif 'station_defense' in hits[0].get_groups():
			pass 
		elif use_now == true:
			owner = hits[0]
			use_item()
			queue_free()
		elif 'cargo' in hits[0]:
			if hits[0].cargo.check_room():
				get_parent().remove_child(self)
				hits[0].cargo.add_item(self)
			else:
				print('no space available!')
	if life >= lifetime:
		queue_free()


func use_item():
	owner.change_health('add', 25)
	queue_free()
	

func _on_bubble_toggled( pressed ):
	if str(get_parent().get_name()).find('slot') != -1:
		get_parent().get_parent().currently_used.erase(self)
		use_item()
	else:
		pass
