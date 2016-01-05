# info parent for objects
extends Node2D

var max_health
var health
var max_energy
var energy
var lbl_name
var bar_bg
var bar_health
var full_health = Color(0.25, 1.0, 0.0, 1.0)
var bar_energy
var full_energy = Color(0.25, 0.0, 1.0, 1.0)
var margin = 5
var visibility
var scale_set = false
var normal_texture
var owner

func _ready():
	normal_texture = load('res://media/circular_hud_bg.tex')
	
	visibility = get_node("VisibilityNotifier2D")
	bar_bg = get_node("status_bar_holder/bar_bg")
	bar_health = get_node("status_bar_holder/bar_bg/bar_health")
	bar_health.set_material(bar_health.get_material().duplicate(true))
	bar_health.get_material().set_shader_param("col", full_health)
	bar_energy = get_node("status_bar_holder/bar_bg/bar_energy")
	bar_energy.set_material(bar_energy.get_material().duplicate(true))
	bar_energy.get_material().set_shader_param("col", full_energy)
	lbl_name = get_node("name_holder")
	var parent_rect = get_parent().get_item_rect()
	visibility.set_rect(Rect2(Vector2(0, 0), Vector2(parent_rect.size * 1.25)))
	if not visibility.is_on_screen():
		self.hide()
		get_parent().hide()

	lbl_name.hide()
	set_process(true)

func _process(delta):
	if owner == null:
		owner = get_parent().owner
	#set the scale of the label name to readable depending on the size of the ship
	if scale_set == false:
		lbl_name.set_scale(get_node("/root/player").scale)
		lbl_name.set_pos(Vector2(0, -normal_texture.get_height() / 2 - margin))
		scale_set = true
	#max health and energy might change so left here until decided
	max_health = get_parent().max_health
	max_energy = get_parent().max_energy
	#counter parent rotation and get current health and energy
	set_rot(-get_parent().get_rot())
	health = get_parent().health
	energy = get_parent().energy
	#only show if belongs to the player or health is less than 100%
	if get_parent().owner.name == 'player' or 'station_defense' in get_parent().get_groups() or health != max_health:
		if bar_bg.get_normal_texture() == null:
			bar_bg.set_normal_texture(normal_texture)
			bar_health.show()
		status_bar('health')
	else:
		if bar_bg.is_visible() == true:
			bar_bg.set_normal_texture(null)
			bar_health.hide()

	#only show energy if belongs to the player
	if ('owner' in get_parent() and get_parent().owner.name == 'player') or 'station_defense' in get_parent().get_groups():
		if bar_bg.is_visible() == false:
			bar_bg.show()
		if bar_energy.is_visible() == false:
			bar_energy.show()
		status_bar('energy')
	else:
		if bar_energy.is_visible() == true:
			bar_energy.hide()
	

	
	
func status_bar(type):
	var color
	var full
	var light
	var heavy
	var critical
	var ratio
	if type == 'health':
		full = full_health
		light = Color(0.5, 0.75, 0.0, 1.0)
		heavy = Color(0.75, 0.5, 0.0, 1.0)
		critical = Color(1.0, 0.25, 0.0, 1.0)
		ratio = float(health / max_health)
		bar_health.get_material().set_shader_param("ratio",  ratio)
	elif type == 'energy':
		full = full_energy
		light = Color(0.5, 0.0, 0.75, 1.0)
		heavy = Color(0.75, 0.0, 0.5, 1.0)
		critical = Color(1.0, 0.0, 0.25, 1.0)
		ratio = float(energy / max_energy)
		bar_energy.get_material().set_shader_param("ratio",  ratio)
	
	
	if ratio >= .95:
		color = full
	elif ratio >= .6:
		color = light
	elif ratio >= .33:
		color = heavy
	else:
		color = critical
	if type == 'health':
		bar_health.get_material().set_shader_param("col", color)
	elif type == 'energy':
		bar_energy.get_material().set_shader_param("col", color)


func _on_VisibilityNotifier2D_enter_screen():
	self.show()
	get_parent().show()


func _on_VisibilityNotifier2D_exit_screen():
	self.hide()
	if not 'station_defense'in get_parent().get_groups():
		get_parent().hide()
