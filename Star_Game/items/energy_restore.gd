
extends Area2D

const name = 'energy_restore'
var use_now = true
var owner = null
var life = 0
var lifetime = 3000

func _ready():
	set_scale(get_node("/root/player").scale)
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
	var hits = get_overlapping_bodies()
	if hits.size() > 0:
		if 'projectiles' in hits[0].get_groups():
			queue_free()
		elif 'station_defense' in hits[0].get_groups():
			pass 
		elif use_now == true:
			owner = hits[0]
			use_item()
		elif 'cargo' in hits[0]:
			if hits[0].cargo.check_room():
				get_parent().remove_child(self)
				hits[0].cargo.add_item(self)
			else:
				pass
	if life >= lifetime:
		queue_free()


func use_item():
	owner.change_energy('add', 25)
	queue_free()

