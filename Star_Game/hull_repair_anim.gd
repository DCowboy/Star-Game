
extends Sprite

var wait
var time = 0

func _ready():
	if get_hframes() == 2:
		wait = 30
	else:
		wait = 5
	set_process(true)


func _process(delta):
	time += 1
	if time == wait:
		if get_frame() == get_hframes() - 1:
			set_frame(0)
		else:
			set_frame(get_frame() + 1)
		time = 0