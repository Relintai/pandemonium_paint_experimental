tool
extends PaintCanvas

var _mouse_down : bool = false
var _mouse_button_down : int = -1

var _actions_history : Array
var _redo_history : Array
var _current_action : PaintAction

var _picked_color : bool = false

var _selection_cells : PoolVector2iArray
var _selection_colors : PoolColorArray

var _cut_pos : Vector2i
var _cut_size : Vector2i

var _mouse_position : Vector2
var _canvas_mouse_position : Vector2
var _cell_mouse_position : Vector2

var _last_mouse_position : Vector2
var _last_canvas_mouse_position : Vector2
var _last_cell_mouse_position : Vector2

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

func update_mouse_position(local_position : Vector2, event: InputEvent) -> void:
	if event.device == -1:
		_mouse_position = get_global_mouse_position()
		_cell_mouse_position = local_position
		
		_last_mouse_position = _mouse_position
		_last_cell_mouse_position = local_position

func handle_left_mouse_button_down(local_position : Vector2, event: InputEvent) -> void:
	update_mouse_position(local_position, event)
		
	if current_tool == TOOL_CUT:
		if !event.is_pressed():
			commit_action()
	elif current_tool == TOOL_BUCKET:
		if !_current_action:
			_current_action = get_action()
			
		var arr : Array = Array()
		arr.push_back(_cell_mouse_position)
		arr.push_back(_last_cell_mouse_position)
		arr.push_back(get_current_color())
		
		do_action(arr)
		commit_action()
	elif current_tool == TOOL_COLORPICKER:
		var c : Color = get_pixel(_cell_mouse_position.x, _cell_mouse_position.y);

		if (c.a < 0.00001):
			return;

		_picked_color = true;

		var project : PaintProject = get_paint_project()
		
		if (project):
			project.current_color = c

	tool_process(local_position, event)

func handle_left_mouse_button_up(local_position : Vector2, event: InputEvent) -> void:
	if event.device == -1:
		_mouse_position = get_global_mouse_position()
		_cell_mouse_position = local_position
		
		_last_mouse_position = _mouse_position
		_last_cell_mouse_position = local_position
		
	if current_tool == TOOL_COLORPICKER:
		if (_picked_color):
			current_tool = get_previous_tool()
			_picked_color = false

	tool_process(local_position, event)

func handle_right_mouse_button_down(local_position : Vector2, event: InputEvent) -> void:
	update_mouse_position(local_position, event)
		
	if current_tool == TOOL_CUT:
		if !event.is_pressed():
			commit_action()
	elif current_tool == TOOL_COLORPICKER:
		current_tool = get_previous_tool()
	elif current_tool == TOOL_PASTECUT:
		commit_action()
		current_tool = TOOL_PENCIL
	elif current_tool == TOOL_BUCKET:
		current_tool = get_previous_tool()

	tool_process(local_position, event)

func draw_brush_preview() -> void:
	clear_preview()
	
	if current_tool == TOOL_PASTECUT:
#		for (int idx = 0; idx < _selection_cells.size(); ++idx) {
#			Vector2i pixel = _selection_cells[idx];
#			//if pixel.x < 0 || pixel.y < 0:
#			//	print(pixel);
#			Color color = _selection_colors[idx];
#			pixel -= _cut_pos + _cut_size / 2;
#			pixel += cell_mouse_position;
#			paint_canvas->_set_pixel_v(paint_canvas->tool_layer, pixel, color);
#		}
		for idx in range(_selection_cells.size()):
			var pixel : Vector2i = _selection_cells[idx];
			var color : Color = _selection_colors[idx];
			pixel -= _cut_pos + _cut_size / 2;
			pixel.x += _cell_mouse_position.x;
			pixel.y += _cell_mouse_position.y;
			set_preview_pixel_v(pixel, color)
			
		update_textures()
	elif current_tool == TOOL_BRUSH:
#			PoolVector2iArray pixels = BrushPrefabs::get_brush(selected_brush_prefab, brush_size_slider->get_value());
#
#			PoolVector2iArray::Read r = pixels.read();
#
#			for (int i = 0; i < pixels.size(); ++i) {
#				Vector2i pixel = r[i];
#				paint_canvas->_set_pixel(paint_canvas->tool_layer, cell_mouse_position.x + pixel.x, cell_mouse_position.y + pixel.y, _selected_color);
#				//print_error("ad " + String::num(cell_mouse_position.x + pixel.x) + " " + String::num(cell_mouse_position.y + pixel.y));
#			}
#
#			r.release();
			
		update_textures()
	elif current_tool == TOOL_RAINBOW:
		set_preview_pixel(_cell_mouse_position.x, _cell_mouse_position.y, Color(0.46875, 0.446777, 0.446777, 0.3));
		update_textures()
	elif current_tool == TOOL_COLORPICKER:
		set_preview_pixel(_cell_mouse_position.x, _cell_mouse_position.y, Color(0.866667, 0.847059, 0.847059, 0.3));
		update_textures()
	else:
		set_preview_pixel(_cell_mouse_position.x, _cell_mouse_position.y, get_current_color());
		update_textures()


#void PaintWindow::_draw_tool_brush() {
#	paint_canvas->tool_layer->clear();
#
#	switch (brush_mode) {
#		case Tools::PASTECUT: {
#			for (int idx = 0; idx < _selection_cells.size(); ++idx) {
#				Vector2i pixel = _selection_cells[idx];
#				//if pixel.x < 0 || pixel.y < 0:
#				//	print(pixel);
#				Color color = _selection_colors[idx];
#				pixel -= _cut_pos + _cut_size / 2;
#				pixel += cell_mouse_position;
#				paint_canvas->_set_pixel_v(paint_canvas->tool_layer, pixel, color);
#			}
#		} break;
#		case Tools::BRUSH: {
#			PoolVector2iArray pixels = BrushPrefabs::get_brush(selected_brush_prefab, brush_size_slider->get_value());
#
#			PoolVector2iArray::Read r = pixels.read();
#
#			for (int i = 0; i < pixels.size(); ++i) {
#				Vector2i pixel = r[i];
#				paint_canvas->_set_pixel(paint_canvas->tool_layer, cell_mouse_position.x + pixel.x, cell_mouse_position.y + pixel.y, _selected_color);
#				//print_error("ad " + String::num(cell_mouse_position.x + pixel.x) + " " + String::num(cell_mouse_position.y + pixel.y));
#			}
#
#			r.release();
#		} break;
#		case Tools::RAINBOW: {
#			paint_canvas->_set_pixel(paint_canvas->tool_layer, cell_mouse_position.x, cell_mouse_position.y, Color(0.46875, 0.446777, 0.446777, 0.196078));
#		} break;
#		case Tools::COLORPICKER: {
#			paint_canvas->_set_pixel(paint_canvas->tool_layer, cell_mouse_position.x, cell_mouse_position.y, Color(0.866667, 0.847059, 0.847059, 0.196078));
#		} break;
#		default: {
#			paint_canvas->_set_pixel(paint_canvas->tool_layer, cell_mouse_position.x, cell_mouse_position.y, _selected_color);
#		} break;
#	}
#
#	paint_canvas->update();
#}

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
	update_textures()
	
	if current_tool == TOOL_CUT:
		var ca : CutAction = _current_action;

		_cut_pos = ca.mouse_start_pos;
		_cut_size = ca.mouse_end_pos - ca.mouse_start_pos;

		_selection_cells.clear();
		_selection_colors.clear();

		_selection_cells.append_array(ca.redo_cells);
		_selection_colors.append_array(ca.redo_colors);
		
		current_tool = TOOL_PASTECUT

	_current_action = null

func redo_action() -> void:
	if (_redo_history.empty()):
		print("PaintCanvas: nothing to redo");
		return;

	var action : PaintAction = _redo_history[_redo_history.size() - 1];
	_redo_history.remove(_redo_history.size() - 1);

	if (!action):
		return;

	_actions_history.push_back(action);
	action.redo_action();
	update_textures()

	print("PaintCanvas: redo action");

func undo_action() -> void:
	if (_actions_history.empty()):
		print("PaintCanvas: nothing to undo");
		return;

	var action : PaintAction = _actions_history[_actions_history.size() - 1];
	_actions_history.remove(_actions_history.size() - 1);

	if (!action):
		return;

	_redo_history.push_back(action);
	action.undo_action();
	update_textures()
	
	print("PaintCanvas: undo action")

#void PaintWindow::redo_action_old() {
#	if (_redo_history.empty()) {
#		//print("nothing to redo");
#		return;
#	}
#
#	Ref<PaintAction> action = _redo_history[_redo_history.size() - 1];
#	_redo_history.remove(_redo_history.size() - 1);
#
#	if (!action.is_valid()) {
#		return;
#	}
#
#	_actions_history.push_back(action);
#	action->redo_action_old(paint_canvas);
#	paint_canvas->update();
#
#	//print("redo action");
#}

#void PaintWindow::undo_action_old() {
#	if (_actions_history.empty()) {
#		return;
#	}
#
#	Ref<PaintAction> action = _actions_history[_actions_history.size() - 1];
#	_actions_history.remove(_actions_history.size() - 1);
#
#	if (!action.is_valid()) {
#		return;
#	}
#
#	_redo_history.push_back(action);
#	action->undo_action_old(paint_canvas);
#	update();
#	paint_canvas->update();
#
#	//print("undo action")
#}

func has_point(var pos : Vector2) -> bool:
	if pos.x < 0 || pos.y < 0 || pos.x > size.x || pos.y > size.y:
		return false
		
	return true

func get_action() -> PaintAction:
	var action : PaintAction = null
	
	if current_tool == TOOL_PENCIL:
		action = PencilAction.new()
	elif current_tool == TOOL_BRUSH:
		action = BrushAction.new()
	elif current_tool == TOOL_LINE:
		action = LineAction.new()
	elif current_tool == TOOL_RAINBOW:
		action = RainbowAction.new()
	elif current_tool == TOOL_BUCKET:
		action = BucketAction.new()
	elif current_tool == TOOL_RECT:
		action = RectAction.new()
	elif current_tool == TOOL_DARKEN:
		action = DarkenAction.new()
	elif current_tool == TOOL_BRIGHTEN:
		action = BrightenAction.new()
	elif current_tool == TOOL_CUT:
		action = CutAction.new()
	elif current_tool == TOOL_PASTECUT:
		action = PasteCutAction.new()
		
	if action:
		action.paint_canvas = self
		
	return action

func _on_tool_changed() -> void:
	if current_tool == TOOL_COLORPICKER:
		if _current_action:
			_current_action = null
		return
	
	if get_previous_tool() == TOOL_CUT:
		clear_preview()
	
	_current_action = get_action()

func tool_process(local_position : Vector2, event: InputEvent) -> void:
	if current_tool == TOOL_COLORPICKER:
		return
	
	if !_current_action:
		_current_action = get_action()
		
	if current_tool == TOOL_PENCIL || current_tool == TOOL_LINE || current_tool == TOOL_RECT:
		var arr : Array = Array()
		
		arr.push_back(_cell_mouse_position)
		arr.push_back(_last_cell_mouse_position)
		
		if _mouse_button_down == BUTTON_LEFT:
			arr.push_back(get_current_color())
		elif _mouse_button_down == BUTTON_RIGHT:
			arr.push_back(Color(1, 1, 1, 0))
		
		do_action(arr)
	elif current_tool == TOOL_DARKEN || current_tool == TOOL_BRIGHTEN || current_tool == TOOL_CUT:
		var arr : Array = Array()
		
		arr.push_back(_cell_mouse_position)
		arr.push_back(_last_cell_mouse_position)
		arr.push_back(get_current_color())
		
		do_action(arr)
	elif current_tool == TOOL_BRUSH:
		var arr : Array = Array()
		
		arr.push_back(_cell_mouse_position)
		arr.push_back(_last_cell_mouse_position)
		
		if _mouse_button_down == BUTTON_LEFT:
			arr.push_back(get_current_color())
		elif _mouse_button_down == BUTTON_RIGHT:
			arr.push_back(Color(1, 1, 1, 0))
			
		arr.push_back(brush_prefab)
		arr.push_back(brush_size)
		
		do_action(arr)
	elif current_tool == TOOL_COLORPICKER:
		# Nothing to do here
		pass
	elif current_tool == TOOL_PASTECUT:
		var arr : Array = Array()

		arr.append(_cell_mouse_position);
		arr.append(_last_cell_mouse_position);
		arr.append(_selection_cells);
		arr.append(_selection_colors);
		arr.append(_cut_pos);
		arr.append(_cut_size);

		do_action(arr);
	elif current_tool == TOOL_RAINBOW:
		var arr : Array = Array()
		
		arr.push_back(_cell_mouse_position)
		arr.push_back(_last_cell_mouse_position)
		
		do_action(arr)

func _forward_canvas_gui_input(event: InputEvent) -> bool:
	if !is_visible_in_tree():
		return false
	
	if event is InputEventMouseButton:
		if _mouse_down && _mouse_button_down != event.button_index:
			# Ignore it, but consume the event from the editor
			return true
		
		if event.button_index != BUTTON_LEFT && event.button_index != BUTTON_RIGHT:
			return false
		
		# This seems to be the easiest way to get local mouse position, 
		# even though the event is available
		var local_position : Vector2 = get_local_mouse_position()
		
		if _mouse_down:
			if !event.pressed:
				_mouse_down = false
				_mouse_button_down = -1
				
				if _mouse_button_down == BUTTON_LEFT:
					handle_left_mouse_button_up(local_position, event)
				
				commit_action()
		else:
			if has_point(local_position):
				_mouse_down = true
				_mouse_button_down = event.button_index
				
				clear_preview()
				
				if _mouse_button_down == BUTTON_LEFT:
					handle_left_mouse_button_down(local_position, event)
				elif _mouse_button_down == BUTTON_RIGHT:
					handle_right_mouse_button_down(local_position, event)
					
				return true

	if event is InputEventMouseMotion:
		var local_position : Vector2 = get_local_mouse_position()

		_mouse_position = get_global_mouse_position()
		_cell_mouse_position = local_position
		
		if _mouse_down:
			if has_point(local_position):
				#handle_draw(local_position, event)
				_cell_mouse_position = local_position
				
				tool_process(local_position, event)
				update_textures()
				update()
				
				_last_mouse_position = _mouse_position
				_last_cell_mouse_position = local_position
				
				return true
		else:
			draw_brush_preview()
				
		_last_mouse_position = _mouse_position
		_last_cell_mouse_position = local_position
	
	if event is InputEventKey:
		if event.echo || !event.pressed:
			return false
			
		var scancode : int = event.get_physical_scancode_with_modifiers()
		
		var undo : bool = false
		if (scancode == (KEY_Z | KEY_MASK_CTRL)):
			undo = true
			
		var redo : bool = false
		if (scancode == (KEY_Z | KEY_MASK_CTRL | KEY_MASK_SHIFT)):
			redo = true
			
		if !undo && !redo:
			return false
		
		var local_position : Vector2 = get_local_mouse_position()
		
		if has_point(local_position):
			if redo:
				redo_action()
				return true
				
			if undo:
				undo_action()
				return true

	return false

func _ready() -> void:
	#temp
	#resize(1, 1)
	#resize(128, 128)
	
	if !is_connected("current_tool_changed", self, "_on_tool_changed"):
		connect("current_tool_changed", self, "_on_tool_changed")
	
	_on_tool_changed()

func _draw() -> void:
	draw_texture(get_image_texture(), Vector2())
	draw_texture(get_preview_image_texture(), Vector2())
