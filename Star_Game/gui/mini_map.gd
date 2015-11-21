
extends Node

var main_viewport
var texture
var pings


func _ready():
	main_viewport = get_node("/root/globals").main_viewport
	get_node("Viewport").set_rect(Rect2(Vector2(0, 0), main_viewport.size / 4))
	get_node("display").set_size(Vector2(main_viewport.size / 8))
	get_node("display").set_pos(Vector2(main_viewport.size.width * .75, 0))

	set_fixed_process(true)



func _fixed_process(delta):
	texture = get_node("Viewport").get_render_target_texture()
	get_node("display").set_texture(texture)
	get_node("Viewport/Sprite").set_rot(get_node("/root/globals").rotate)
	pings = get_node("/root/globals").pings
	get_pings()

func get_pings():
	for child in range(2, get_node("Viewport").get_child_count() - 1):
		get_node("Viewport").remove_child(get_node("Viewport").get_child(child))
	for ping in pings:
		
		var dot = get_node("/root/globals").mini_map_icons.instance()
		dot.set_pos((ping.get_pos() - get_node("/root/globals").player_pos) / 8)
		if ping in get_tree().get_nodes_in_group('friendly'):
			dot.set_region_rect(Rect2(8, 0, 8, 8))
		if ping in get_tree().get_nodes_in_group('target'):
			dot.set_region_rect(Rect2(16, 0, 8, 8))
		else:
			dot.set_region_rect(Rect2(0, 0, 8, 8))
			dot.set_rot(ping.get_rot())
		get_node("Viewport").add_child(dot)
		print(get_node("Viewport").get_child_count())