
extends Sprite

# member variables here, example:
# var a=2
# var b="textvar"
var wait = 5

func _ready():
	set_process(true)
	pass

func _process(delta):
	wait -= 1
	if wait == 0:
		if get_frame() == 0:
			set_frame(7)
		else:
			set_frame(get_frame() - 1)
		wait = 5

