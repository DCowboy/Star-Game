
extends Sprite

var map_size = Rect2(0,0,0,0)
var objects
var edges = {}
var images = {}


func _ready():
	#get size of map
	map_size = self.get_item_rect()
	"""TODO: create child edge sprites at half width
	and half height of viewport and hold those in mirrors
	rather than reference numbers"""
	
	"""create rectangles to check and list where mirrors
	should go"""
	var edge_area =['top_left', 'top', 'top_right',
	'center_left', 'center_right', 'bottom_left',
	'bottom', 'bottom_right']
	for edge in edge_area:
		edges[edge] = make_edge(edge)
	#load object group
	objects = get_tree().get_nodes_in_group('objects')
	set_process(true)


func _process(delta):
	"""check whether to make mirror images and where
	or to wrap them if they go out of bounds"""
	for obj in objects:
		#get relevant object info
		var obj_region = null
		var obj_rect = Rect2(0, 0, 0, 0)
		var obj_texture = obj.get_texture()
		var obj_scale = obj.get_scale()
		var obj_name = obj.get_name()
		var obj_rot = obj.get_rot()
		if obj_name == 'player':
			obj_rect = obj.get_item_rect()
			obj_rect.pos = obj.get_parent().get_pos()
			obj_region = obj.get_region_rect()
		else:
			obj_rect = obj.get_item_rect()
			obj_rect.pos = obj.get_pos()

		for edge in edges:
			"""check objects against edges and make
			mirror images if needed"""
			var edge_rect = Rect2(edges[edge].rect)
			if edge_rect.intersects(obj_rect):
				if not images.has(obj_name):
					add_img(obj_texture, obj_scale, \
					obj_name, edges[edge].mirrors, \
					obj_region, obj_rot)
			else:
				if images.has(obj_name):
					for n in images[obj_name]:
						n.free()
					images.erase(obj_name)
					pass
		#wrap objects if they go out of bounds
		check_bounds(obj)



func add_img(tex, scale, name, mirrors, region, rot):
	var copies = []
	for n in mirrors:
		var position = Vector2(\
		self.get_child(n).get_pos())
		var new_sprite = Sprite.new()
		new_sprite.set_texture(tex)
		if not region == null:
			new_sprite.set_region(true)
			new_sprite.set_region_rect(region)
		new_sprite.set_scale(scale)
		new_sprite.set_pos(position)
		new_sprite.set_rot(rot)
		self.add_child(new_sprite)
		copies.append(new_sprite)
	images[name] = copies


func make_edge(loc):
	"""NOTE: refactor by renaming edge h/w to
	corner h/w. Use viewport for those measurements:
	get_viewport.get_rect().size.width / 2
	get_viewport.get_rect().size.height / 2
	Then create side_x and side_y as:
	main_rect.size.width - corner_w * 2, corner_h
	main_rect.size.height - corner_h * 2. corner_w
	This should allow for any size viewport and any 
	size map. """
	
	#helper function to set up edge info
	var info = {}
	var mirrors = []
	#get main edge
	var main_rect = self.get_item_rect()
	#basic units that edges can be measured in
	var edge_w = main_rect.size.width / 4
	var edge_h = main_rect.size.height / 4
	#rect to hold the rect info
	var rect = Rect2(0, 0, 0, 0)
	"""set up the edge rect and mirrors according to
	its location"""
	if loc == 'top_left':
		rect.pos.x = main_rect.pos.x
		rect.pos.y = main_rect.pos.y
		rect.size.width = edge_w
		rect.size.height = edge_h
		mirrors = [0, 1, 2]
	elif loc == 'top':
		rect.pos.x = main_rect.pos.x + edge_w
		rect.pos.y = main_rect.pos.y
		rect.size.width = edge_w * 2
		rect.size.height = edge_h
		mirrors = [3]
	elif loc == 'top_right':
		rect.pos.x = main_rect.size.width / 2 - edge_w
		rect.pos.y = main_rect.pos.y
		rect.size.width = edge_w
		rect.size.height = edge_h
		mirrors = [4, 5, 6]
	elif loc == 'center_left':
		rect.pos.x = main_rect.pos.x
		rect.pos.y = main_rect.pos.y + edge_h
		rect.size.width = edge_w
		rect.size.height = edge_h * 2
		mirrors = [7]
	elif loc == 'center_right':
		rect.pos.x = main_rect.size.width / 2 - edge_w
		rect.pos.y = main_rect.pos.y + edge_h
		rect.size.width = edge_w
		rect.size.height = edge_h * 2
		mirrors = [8]
	elif loc == 'bottom_left':
		rect.pos.x = main_rect.pos.x
		rect.pos.y = main_rect.size.height / 2 - edge_h
		rect.size.width = edge_w
		rect.size.height = edge_h
		mirrors = [9, 10, 11]
	elif loc == 'bottom':
		rect.pos.x = main_rect.pos.x + edge_w
		rect.pos.y = main_rect.size.height / 2 - edge_h
		rect.size.width = edge_w * 2
		rect.size.height = edge_h
		mirrors = [12]
	elif loc == 'bottom_right':
		rect.pos.x = main_rect.size.width / 2 - edge_w
		rect.pos.y = main_rect.size.height / 2 - edge_h
		rect.size.width = edge_w
		rect.size.height = edge_h
		mirrors = [13, 14, 15]
	#stuff info into a dictionary and return it
	info['rect'] = rect
	info['mirrors'] = mirrors
	return info


func check_bounds(obj):
	var check = Vector2(0, 0)
	var pos = Vector2(0, 0)	
	if obj.get_name() == 'player':
		check = obj.get_parent().get_pos()
	else:
		check = obj.get_pos()
	var min_x = map_size.pos.x 
	var min_y = map_size.pos.y 
	var max_x = map_size.size.width / 2 
	var max_y = map_size.size.height / 2
	if check.x < min_x:
		pos.x = max_x
	elif check.x > max_x:
		pos.x = min_x
	else:
		pos.x = check.x
	if check.y < min_y:
		pos.y = max_y
	elif check.y > max_y:
		pos.y = min_y
	else:
		pos.y = check.y
		
	if obj.get_name() == 'player':
		pos = obj.get_parent().set_pos(pos)
	else:
		pos = obj.set_pos(pos)