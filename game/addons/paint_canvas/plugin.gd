tool
extends EditorPlugin

var active_canvas : PaintCanvas = null

func handles(object: Object) -> bool:
	return object is PaintCanvas

func edit(object: Object) -> void:
	active_canvas = object

func forward_canvas_gui_input(event: InputEvent) -> bool:
	if !active_canvas:
		return false
		
	#Temp!
	if active_canvas.get_script() == null:
		return false
		
	return active_canvas.forward_canvas_gui_input(event)

func on_node_removed(node: Node) -> void:
	if node == active_canvas:
		active_canvas = null

func _enter_tree() -> void:
	get_tree().connect("node_removed", self, "on_node_removed")
	
	var paint_editor_plugin : EditorPlugin = Engine.get_global("PaintEditorPlugin")
	
	if paint_editor_plugin:
		var sidebar : PaintSidebar = paint_editor_plugin.get_sidebar()
		
		#print(sidebar)

func _exit_tree() -> void:
	var paint_editor_plugin : EditorPlugin = Engine.get_global("PaintEditorPlugin")
	
	if paint_editor_plugin:
		var sidebar : PaintSidebar = paint_editor_plugin.get_sidebar()
		
		#print(sidebar)
