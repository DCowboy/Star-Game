# info child for objects
extends Node2D
var max_health
var health
var max_energy
var energy
var lbl_name
var bar_bg
var bar_health
var full_health = Color(0.0, 1.0, 0.0, 1.0)
var bar_energy
var full_energy = Color(0.0, 0.0, 1.0, 1.0)
var margin = 5
var visibility

func _ready():
	visibility = get_node("VisibilityNotifier2D")
	bar_bg = get_node("bar_bg")
	bar_health = get_node("bar_bg/bar_health")
	bar_health.set_material(bar_health.get_material().duplicate(true))
	bar_health.get_material().set_shader_param("col", full_health)
	bar_energy = get_node("bar_bg/bar_energy")
	bar_energy.set_material(bar_energy.get_material().duplicate(true))
	bar_energy.get_material().set_shader_param("col", full_energy)
	lbl_name = get_node("lbl_name")
	var parent_rect = get_parent().get_item_rect()
	visibility.set_rect(Rect2(Vector2(0, 0), Vector2(parent_rect.size * 1.25)))
	
	if get_parent().name != 'Player':
		bar_bg.hide()
		bar_health.hide()
		bar_energy.hide()
	else:
		bar_bg.show()
		bar_health.show()
		bar_energy.show()
	if not visibility.is_on_screen():
		self.hide()
		get_parent().hide()

	set_process(true)

func _process(delta):
	max_health = get_parent().max_health
	max_energy = get_parent().max_energy
	set_rot(-get_parent().get_rot())
	health = get_parent().health
	energy = get_parent().energy
	if health != max_health:
		if bar_bg.is_visible() == false:
			bar_bg.show()
			bar_health.show()
		status_bar('health')
	else:
		if get_parent().name != 'Player':
			bar_health.hide()
		else:
			bar_health.show()
	if energy != max_energy:
		if bar_bg.is_visible() == false:
			bar_bg.show()
			bar_energy.show()
		status_bar('energy')
	else:
		if get_parent().name != 'Player':
			bar_energy.hide()
		else:
			bar_energy.show()
	lbl_name.set_pos(Vector2(lbl_name.get_pos().x, -bar_bg.get_texture().get_height() / 2 -lbl_name.get_size().height - margin))
	
func status_bar(type):
	var color
	var full
	var light
	var heavy
	var critical
	var ratio
	if type == 'health':
		full = full_health
		light = Color(1.0, 1.0, 0.0, 1.0)
		heavy = Color(0.75, 0.25, 0.05, 1.0)
		critical = Color(1.0, 0.0, 0.0, 1.0)
		ratio = float(health / max_health)
		bar_health.get_material().set_shader_param("ratio",  ratio)
	elif type == 'energy':
		full = full_energy
		light = Color(0.0, 0.25, 0.75, 1.0)
		heavy = Color(0.0, 0.50, 0.75, 1.0)
		critical = Color(0.0, 1.0, 1.0, 1.0)
		ratio = float(energy / max_energy)
		bar_energy.get_material().set_shader_param("ratio",  ratio)
	
	
	if ratio == 1:
		color = full
	elif ratio > .67:
		color = light
	elif ratio > .34:
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
	get_parent().hide()

