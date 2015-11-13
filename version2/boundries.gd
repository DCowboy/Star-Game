
extends ReferenceFrame

var map_size 
var objects
var fixed
var edges = {}
var mirrors = {}


func add_mirrors(edge_name, edge_info, object):
	var copies = []
	for offset in edge_info.offsets:
		var new_sprite = Sprite.new()
		if object.get_type() == 'KinematicBody2D':
			new_sprite.set_texture(object.get_child(0).get_texture())
			new_sprite.set_region(true)
			new_sprite.set_region_rect(object.get_child(0).get_region_rect())
		else:
			new_sprite.set_texture(object.get_texture())
		new_sprite.set_scale(object.get_scale())
		new_sprite.set_pos(object.get_pos() + offset)
		new_sprite.set_rot(object.get_rot())
		get_parent().add_child(new_sprite)
		copies.append(new_sprite)
	mirrors[object.get_name() + edge_name] = copies


func check_edges():
	for obj in objects:
		var obj_rect = obj.get_item_rect()
		obj_rect.pos = obj.get_pos()
		for edge in edges:
			if edges[edge].rect.intersects(obj_rect):
				if not mirrors.has(obj.get_name() + edge):
					add_mirrors(edge, edges[edge], obj)
			else:
				if mirrors.has(obj.get_name() + edge):

					for n in mirrors[obj.get_name() + edge]:
						n.free()
					mirrors.erase(obj.get_name() + edge)


func check_bounds():
	for obj in objects:
		if not obj in fixed:
			var pos = obj.get_pos()
			var new_pos = obj.get_pos()
			if pos.x <= -map_size.size.width / 2 + 1:
				new_pos.x = map_size.size.width / 2 - 1
			elif pos.x >= map_size.size.width / 2 - 1:
				new_pos.x = -map_size.size.width / 2 + 1
			if pos.y <= -map_size.size.height / 2 + 1:
				new_pos.y = map_size.size.height / 2 - 1
			elif pos.y >= map_size.size.height / 2 - 1:
				new_pos.y = -map_size.size.height / 2 + 1

			if pos != new_pos:
				obj.set_pos(new_pos)


func _fixed_process(delta):
	check_bounds()
	check_edges()
	
	
func make_edge(loc):
	var info = {}
	var pos_diff = []
	var corner_rect = Rect2(Vector2(0, 0), get_viewport_rect().size / 2)
	var center_x_rect = Rect2(0, 0, map_size.size.width - corner_rect.size.width *2, corner_rect.size.height)
	var center_y_rect = Rect2(0, 0, corner_rect.size.width, map_size.size.height - corner_rect.size.height * 2)
	var this_rect = Rect2(0, 0, 0, 0)
	
	if loc == 'top_left':
		this_rect.size = corner_rect.size
		this_rect.pos = -map_size.size / 2
		pos_diff = [Vector2(0, map_size.size.height),
		Vector2(map_size.size.width, map_size.size.height),
		Vector2(map_size.size.width, 0)]
	elif loc == 'top_center':
		this_rect.size = center_x_rect.size
		this_rect.pos = Vector2(-map_size.size.width / 2 + corner_rect.size.width, -map_size.size.height / 2)
		pos_diff = [Vector2(0, map_size.size.height)]
	elif loc == 'top_right':
		this_rect.size = corner_rect.size
		this_rect.pos = Vector2(map_size.size.width / 2 - corner_rect.size.width, -map_size.size.height / 2)
		pos_diff = [Vector2(-map_size.size.width, 0),
		Vector2(-map_size.size.width, -map_size.size.height),
		Vector2(0, -map_size.size.height)]
	elif loc == 'center_left':
		this_rect.size = center_y_rect.size
		this_rect.pos = Vector2(-map_size.size.width / 2, -map_size.size.height / 2 + corner_rect.size.height)
		pos_diff = [Vector2(map_size.size.width, 0)]
	elif loc == 'center_right':
		this_rect.size = center_y_rect.size
		this_rect.pos = Vector2(map_size.size.width / 2 - corner_rect.size.width, -map_size.size.height / 2 + corner_rect.size.height)
		pos_diff = [Vector2(-map_size.size.width, 0)]
	elif loc == 'bottom_left':
		this_rect.size = corner_rect.size
		this_rect.pos = Vector2(-map_size.size.width / 2 + corner_rect.size.width, map_size.size.height / 2 - corner_rect.size.height)
		pos_diff = [Vector2(map_size.size.width, 0),
		Vector2(map_size.size.width, -map_size.size.height),
		Vector2(0, -map_size.size.height)]
	elif loc == 'bottom_center':
		this_rect.size = center_x_rect.size
		this_rect.pos = Vector2(-map_size.size.width / 2 + corner_rect.size.width, map_size.size.height / 2 - corner_rect.size.height)
		pos_diff = [Vector2(0, -map_size.size.height)]
	elif loc == 'bottom_right':
		this_rect.size = corner_rect.size
		this_rect.pos = map_size.size / 2 - corner_rect.size
		pos_diff = [Vector2(0, -map_size.size.height),
		Vector2(-map_size.size.width, -map_size.size.height),
		Vector2(-map_size.size.width, 0)]
	info['rect'] = this_rect
	info['offsets'] = pos_diff
	return info
	pass

func _ready():
	map_size = get_item_rect()
	objects = get_tree().get_nodes_in_group('object')
	fixed = get_tree().get_nodes_in_group('fixed')
	
	for edge in ['top_left', 'top_center', 'top_right',
	'center_left', 'center_right',
	'bottom_left', 'bottom_center', 'bottom_right']:
		edges[edge] = make_edge(edge)
	set_fixed_process(true)