
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
			if get_collider() != null and get_collider().get_name() != 'player':
				hit_by(get_collider())
			get_collider().hit_by(self)
			
	else:
		#setting explosion
		get_node("Sprite").hide()
		var explode = get_node("/root/globals").explosions.small_normal.instance()
		explode.set_pos(get_pos())
		self.replace_by(explode)


func hit_by(obj):
	if not exploding:
		if get_collider() != null and get_collider().get_type() == 'RigidBody2D':
			if get_collider().health > 0:
				get_collider().set_applied_force(direction * (acceleration + payload))

	exploding = true


	

	
	



func _on_Timer_timeout():
	live = false
	pass # replace with function body
