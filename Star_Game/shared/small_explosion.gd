
extends Particles2D
var sound


func _ready():
#	if str(get_name()).find('large_explosion') != -1:
		
	if str(get_name()).find('small_explosion') != -1:
		sound = get_node("/root/globals").sound_effects.instance()
		add_child(sound)
		sound.play('small_explosion')
	set_emitting(true)
	set_process(true)
	

func _process(delta):

	if not is_emitting():
		queue_free()