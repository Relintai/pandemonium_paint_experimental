tool
extends EditorPlugin

func _enter_tree() -> void:
	var paint_editor_plugin : EditorPlugin = Engine.get_global("PaintEditorPlugin")
	
	if paint_editor_plugin:
		var sidebar : PaintSidebar = paint_editor_plugin.get_sidebar()
		
		#print(sidebar)


func _exit_tree() -> void:
	var paint_editor_plugin : EditorPlugin = Engine.get_global("PaintEditorPlugin")
	
	if paint_editor_plugin:
		var sidebar : PaintSidebar = paint_editor_plugin.get_sidebar()
		
		#print(sidebar)


#func _enter_tree() -> void:
#	for c in get_parent().get_children():
#		if c is EditorPlugin:
#			var ep : EditorPlugin = c as EditorPlugin
#
#			if ep.get_class() == "PaintEditorPlugin":
#				print(ep.get_class())
