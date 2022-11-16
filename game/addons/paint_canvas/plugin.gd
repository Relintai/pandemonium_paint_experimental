tool
extends EditorPlugin

var ColorGridInspectorPlugin

var active_canvas : PaintCanvas = null
var ip : EditorInspectorPlugin

func handles(object: Object) -> bool:
	return object is PaintCanvas

func edit(object: Object) -> void:
	active_canvas = object

func _enter_tree() -> void:
	ColorGridInspectorPlugin = load("res://addons/paint_canvas/color_grid_inxpector_plugin.gd")
	
	ip = ColorGridInspectorPlugin.new()
	add_inspector_plugin(ip)
	
	#get_tree().connect("node_removed", self, "on_node_removed")
	
#	var paint_editor_plugin : EditorPlugin = Engine.get_global("PaintEditorPlugin")
#
#	if paint_editor_plugin:
#		var sidebar : PaintSidebar = paint_editor_plugin.get_sidebar()
		
		#print(sidebar)

func _exit_tree() -> void:
	if ip:
		remove_inspector_plugin(ip)
	
#	var paint_editor_plugin : EditorPlugin = Engine.get_global("PaintEditorPlugin")
#
#	if paint_editor_plugin:
#		var sidebar : PaintSidebar = paint_editor_plugin.get_sidebar()
		
		#print(sidebar)
