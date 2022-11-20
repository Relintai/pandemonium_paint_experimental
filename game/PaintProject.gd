tool
extends PaintProject

# Port the inspector plugin to c++ aswell

# remove old deprecated classes (PaintCanvasOutline, PaintColorGrid too)
# inherit both PaintVisualGrid and PaintCanvasBackground from PaintNode -> automatic easy resize

# Rename the method that is used to set the inspected PaintNodes in PaintCustomPropertyInspector

# New Tools:
# PaintCanvas: Pixel Scale canvas, should be able to set interpolation (just need gui)

# Make sure it works with touch

# NO Mouse pos for the canvas property inspector ? The canvas editor should be able to do it with an overlay like in the 3d scene
# NO PaintProject: Scale project ? (to px, or percent) (set scale for all sub nodes?) Might not work well, or just not like this
# NO PaintProject Add open image and texture property, if image dragged to it it creates a canvas from it, if no children also adds vis grid, and bg + resizses itself

# Eventually:
# Filters, vectors ...

