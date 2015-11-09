
extends Sprite
var engage = false
var thrust = 2
var velocity = Vector2(0, 0)
var max_velocity = 16
var rotate
var lbl_coord


func _ready():
	lbl_coord = get_parent().get_node("coordinates")
	set_process(true)
	set_process_input(true)


func _process(delta):
	var pos = get_parent().get_pos()
	if (engage == true):
		velocity.x += cos(rotate + deg2rad(90))\
		* thrust * delta
		velocity.y += -sin(rotate + deg2rad(90))\
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
	pos += velocity
	get_parent().set_pos(pos)

	lbl_coord.text = 'Coordinates: ' \
	+ str(int(get_parent().get_pos().x)) + ', '\
	+ str(int(get_parent().get_pos().y))
	
func _input(event):
	if (event.type == InputEvent.MOUSE_MOTION):
		var mouse_pos = Vector2(event.pos.x \
		- get_viewport().get_rect().size.width / 2, \
		event.pos.y \
		- get_viewport().get_rect().size.height / 2)
		rotate = self.get_pos().angle_to_point(mouse_pos)
		self.set_rot(rotate)
		
	if event.is_action("accelerate"):
		if event.is_pressed():
			engage = true
		else:
			engage = false