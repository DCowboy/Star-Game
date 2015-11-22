
extends CanvasLayer



func _ready():
	get_node("TextureFrame/gui_status_bg").set_scale(get_node("/root/globals").square_scale)
	pass


