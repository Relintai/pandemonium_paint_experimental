tool
extends PaintCanvas

var _mouse_down : bool = false

var _actions_history : Array
var _redo_history : Array
var _current_action : PaintAction

var mouse_position : Vector2
#var canvas_position : Vector2
var canvas_mouse_position : Vector2
var cell_mouse_position : Vector2

var last_mouse_position : Vector2
#var last_canvas_position : Vector2
var last_canvas_mouse_position : Vector2
var last_cell_mouse_position : Vector2

func handle_draw(local_position : Vector2, event: InputEvent) -> void:
	var proj : PaintProject = get_paint_project()
	
	if !proj:
		print("!proj!")
	
	set_pixel(local_position.x, local_position.y, proj.current_color)

func get_current_color() -> Color:
	var proj : PaintProject = get_paint_project()
	
	if !proj:
		print("!proj!")
		return Color(1, 1, 1, 1)
	
	return proj.current_color

func handle_mouse_button_down(local_position : Vector2, event: InputEvent) -> void:
	if event.device == -1:
		mouse_position = get_global_mouse_position()
		cell_mouse_position = local_position
		
		last_mouse_position = mouse_position
		last_cell_mouse_position = local_position
		
	if current_tool == CUT:
		if !event.is_pressed():
			commit_action()
	elif current_tool == BUCKET:
		if !_current_action:
			_current_action = get_action()
			
		var arr : Array = Array()
		arr.push_back(cell_mouse_position)
		arr.push_back(last_cell_mouse_position)
		#STORE color here
		arr.push_back(get_current_color())
	elif current_tool == COLORPICKER:
		print("TODO")
	elif current_tool == PASTECUT:
		print("TODO")
	elif current_tool == PAINT:
		tool_process(local_position, event)
		

func do_action(arr : Array) -> void:
	if !_current_action:
		return
		
	_current_action.do_action(arr)
	update_textures()

func commit_action() -> void:
	if !_current_action:
		return
		
	_current_action.commit_action()
	
	_actions_history.push_back(_current_action)
	_redo_history.clear()
	
	if current_tool == CUT:
		print("TODO")
		return
		
	_current_action = null

func has_point(var pos : Vector2) -> bool:
	if pos.x < 0 || pos.y < 0 || pos.x > size.x || pos.y > size.y:
		return false
		
	return true

func get_action() -> PaintAction:
	var action : PaintAction = null
	
	if current_tool == PAINT:
		action = PencilAction.new()
		
	if action:
		action.paint_canvas = self
		
	return action

func _on_tool_changed() -> void:
	if current_tool == COLORPICKER:
		if _current_action:
			_current_action = null
		return
		
	_current_action = get_action()

func tool_process(local_position : Vector2, event: InputEvent) -> void:
	if current_tool == COLORPICKER:
		return
	
	if !_current_action:
		_current_action = get_action()
		
	if current_tool == PAINT:
		var arr : Array = Array()
		arr.push_back(cell_mouse_position)
		arr.push_back(last_cell_mouse_position)
		arr.push_back(get_current_color())
		
		do_action(arr)
	

func _forward_canvas_gui_input(event: InputEvent) -> bool:
	if event is InputEventMouseButton:
		if event.button_index != BUTTON_LEFT:
			return false

		if _mouse_down:
			if !event.pressed:
				_mouse_down = false
				commit_action()
		else:
			# This seems to be the easiest way to get local mouse position, 
			# even though the event is available
			var local_position : Vector2 = get_local_mouse_position()

			if has_point(local_position):
				_mouse_down = true
				handle_mouse_button_down(local_position, event)
				return true

	if event is InputEventMouseMotion:
		var local_position : Vector2 = get_local_mouse_position()
		
		mouse_position = get_global_mouse_position()
		cell_mouse_position = local_position
		
		if _mouse_down:
			if has_point(local_position):
				#handle_draw(local_position, event)
				cell_mouse_position = local_position
				
				tool_process(local_position, event)
				update_textures()
				update()
				
				last_mouse_position = mouse_position
				last_cell_mouse_position = local_position
				
				return true
				
		last_mouse_position = mouse_position
		last_cell_mouse_position = local_position

	return false

func _ready() -> void:
	#temp
	resize(1, 1)
	resize(128, 128)
	
	if !is_connected("current_tool_changed", self, "_on_tool_changed"):
		connect("current_tool_changed", self, "_on_tool_changed")
	
	_on_tool_changed()

func _draw() -> void:
	draw_texture(get_image_texture(), Vector2())
	draw_texture(get_preview_image_texture(), Vector2())
