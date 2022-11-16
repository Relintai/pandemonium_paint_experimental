tool
extends PaintCanvas

var _mouse_down : bool = false

func draw(local_position : Vector2) -> void:
	var proj : PaintProject = get_paint_project()
	
	if !proj:
		print("!proj!")
	
	set_pixel(local_position.x, local_position.y, proj.current_color)

func is_local(var pos : Vector2) -> bool:
	if pos.x < 0 || pos.y < 0 || pos.x > size.x || pos.y > size.y:
		return false
		
	return true

func forward_canvas_gui_input(event: InputEvent) -> bool:
	if event is InputEventMouseButton:
		if event.button_index != BUTTON_LEFT:
			return false

		if _mouse_down:
			if !event.pressed:
				_mouse_down = false
		else:
			# This seems to be the easiest way to get local mouse position, 
			# even though the event is available
			var local_position : Vector2 = get_local_mouse_position()
			
			if is_local(local_position):
				_mouse_down = true
				return true

	if _mouse_down && event is InputEventMouseMotion:
		var local_position : Vector2 = get_local_mouse_position()
		
		if is_local(local_position):
			draw(local_position)
			update_textures()
			update()
			return true

	return false

func _ready() -> void:
	#temp
	resize(1, 1)
	resize(128, 128)
	
func _draw() -> void:
	draw_texture(get_image_texture(), Vector2())
	draw_texture(get_preview_image_texture(), Vector2())
