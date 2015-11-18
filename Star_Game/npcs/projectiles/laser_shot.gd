
extends KinematicBody2D

var direction
var acceleration
var shot_acceleration = 250
var payload = 25
var explosion
var exploding = false
var live = true



func _ready():
	explosion = preload('res://shared/small_explosion.scn')
	acceleration += shot_acceleration
	set_fixed_process(true)


func _fixed_process(delta):
	if not exploding:
		move(direction * acceleration * delta)

		if is_colliding():
			print('hit ' + get_collider())
			if get_collider() != null and get_collider().get_name() != 'player':
				hit_by(get_collider())
			get_collider().hit_by(self)
			

	if exploding or not live:
		get_node("Sprite").hide()
		var explode = explosion.instance()
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
