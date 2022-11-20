tool
extends PaintProject

# the new tool should not take space when empty
# Port the inspector plugin to c++ aswell

# remove old deprecated classes (PaintCanvasOutline, PaintColorGrid too)
# inherit both PaintVisualGrid and PaintCanvasBackground from PaintNode -> automatic easy resize
# Rename the paint project editor which is present for all nodes to PaintNode editor

# Rename the method that is used to set the inspected PaintNodes in PaintCustomPropertyInspector

# PaintCanvas -> Only consume events if the current tool is select (probably should only route them in the plugin)

# PaintProject Add open image and texture property, if image dragged to it it creates a canvas from it, if no children
# also adds vis grid, and bg + resizses itself

# New Tools:
# PaintProject: Load image as new canvas, with proper gui
# PaintProject: Scale project ? (to px, or percent) (set scale for all sub nodes?) Might not work well, or just not like this
# PaintCanvas: Pixel Scale canvas, should be able to set interpolation (just need gui)
# PaintCanvas -> LoadCanvasImage, exportCanvasImage -> TOOL
# Mouse pos for the canvas property inspector
# PaintProject: Move run properties to the inspector.
# PaintProject: ExportImage -> dialog instead of text field # + run property. Can keel the field to save path though

# Eventually:
# Filters, vectors ...

