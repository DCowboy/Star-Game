
extends KinematicBody2D

var direction
var acceleration
var shot_acceleration = 250
var payload = 25
var exploding = false
var live = true


func _ready():
	acceleration += shot_acceleration
	set_fixed_process(true)


func _fixed_process(delta):
	#move and check for collisions if not exploding
	if not exploding and live:
		move(direction * acceleration * delta)

		if is_colliding():
			#if hit, explode
			if get_collider() != null:
			get_collider().hit_by(self)
			if get_collider() != null and get_collider().get_type() == 'RigidBody2D':
				if get_collider().health > 0:
					get_collider().set_applied_force(direction * (acceleration + payload))
			exploding = true
	else:
		#setting explosion if it hits something or times out
		get_node("Sprite").hide()
		var explode = get_node("/root/globals").explosions.small_normal.instance()
		explode.set_pos(get_pos())
		self.replace_by(explode)


func _on_Timer_timeout():
	live = false
