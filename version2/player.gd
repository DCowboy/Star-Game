
extends KinematicBody2D
var engage = false
var thrust = 1
var velocity = Vector2(0, 0)
var max_velocity = 4
var rotate


func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION):

		var mouse_pos = Vector2(event.pos.x \
		- get_viewport().get_rect().size.width / 2, \
		event.pos.y \
		- get_viewport().get_rect().size.height / 2)
#		var mouse_pos = event.pos
		rotate = get_viewport_rect().\
		pos.angle_to_point(mouse_pos)
		self.set_rot(rotate)
		
	if event.is_action("accelerate"):
		if event.is_pressed():
			engage = true
		else:
			engage = false
	elif event.is_action("decelerate"):
		if event.is_pressed():
			velocity = Vector2(0, 0)
	


func _fixed_process(delta):
	if (engage == true):
		velocity.x += -cos(rotate + deg2rad(90))\
		* thrust * delta
		velocity.y += sin(rotate + deg2rad(90))\
		* thrust * delta
	else:
		pass
	if abs(velocity.x) > max_velocity:
		if velocity.x > 0:
			velocity.x = max_velocity
		else:
			velocity.x = -max_velocity
	if abs(velocity.y) > max_velocity:
		if velocity.y > 0:
			velocity.y = max_velocity
		else:
			velocity.y = -max_velocity
	move(-velocity)

func _ready():
	set_fixed_process(true)
	set_process_input(true)