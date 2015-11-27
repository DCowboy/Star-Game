# info child for objects TODO: Replace health label with a health bar
extends Node2D
var max_health
var health
var lbl_name
var bar_bg
var bar_health
var bar_energy
var offset
var margin = 5
var visibility

func _ready():
	visibility = get_node("VisibilityNotifier2D")
	bar_bg = get_node("bar_bg")
	bar_health = get_node("bar_bg/bar_health")
	bar_health.set_material(bar_health.get_material().duplicate(true))
	bar_energy = get_node("bar_bg/bar_energy")
	bar_energy.set_material(bar_energy.get_material().duplicate(true))
	lbl_name = get_node("lbl_name")
	var parent_rect = get_parent().get_item_rect()
	offset = Vector2(0, -parent_rect.size.height / 2)
	visibility.set_rect(Rect2(Vector2(0, 0), Vector2(parent_rect.size * 1.25)))
	
	if get_parent().get_name() != 'Player':
		bar_bg.hide()
		bar_health.hide()
		bar_energy.hide()
	if not visibility.is_on_screen():
		self.hide()
		get_parent().hide()
	set_process(true)

func _process(delta):
	set_rot(-get_parent().get_rot())
	health = get_parent().health
	max_health = get_parent().max_health
	if health != max_health:
		if bar_bg.is_visible() == false:
			bar_bg.show()
		bar_health.show()
		bar_health.get_material().set_shader_param("ratio",  float(health / max_health))
	lbl_name.set_pos(Vector2(lbl_name.get_pos().x, -bar_bg.get_texture().get_height() / 2 -lbl_name.get_size().height - margin))
	

func _on_VisibilityNotifier2D_enter_screen():
	self.show()
	get_parent().show()


func _on_VisibilityNotifier2D_exit_screen():
	self.hide()
	get_parent().hide()

