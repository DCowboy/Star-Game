
extends KinematicBody2D

var direction
var acceleration
var shot_acceleration = 250
var payload = 5
var exploding = false
var live = 3
var time = 0



func hit(obj):
	if not exploding:
		get_node("Sprite/Particles2D").set_emitting(true)
		if get_collider().get_type() == 'RigidBody2D':
			get_collider().set_applied_force(direction * acceleration  * payload)
	exploding = true





func _fixed_process(delta):
	move(direction * acceleration * delta)
	time += delta
	
	if is_colliding():
		hit(get_collider())

	
	if exploding or time > live:
		if not get_node("Sprite/Particles2D").is_emitting():
			free()


func _ready():
	acceleration += shot_acceleration
	set_fixed_process(true)
	print(self.get_type())