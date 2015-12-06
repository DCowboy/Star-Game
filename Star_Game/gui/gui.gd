
extends CanvasLayer
var map_name


func _ready():
	map_name = get_node("map_and_missions/Label")
	map_name.set_text(get_node("/root/globals").map_name)
	pass




func _on_TextureButton_pressed():
	pass # replace with function body
