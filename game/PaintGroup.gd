extends Node2D

# Collects all child PaintNodes and renders them to it's texture
# updates tex when a child changes
# PaintNodes will need to signal their parents when they changed

# update should run in process to save potential cycles
