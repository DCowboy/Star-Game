
extends Particles2D



func _ready():
	set_emitting(true)
	set_process(true)
	

func _process(delta):
	if not is_emitting():
		queue_free()