@tool
extends EditorPlugin

func _enter_tree():
	# Initialization of the plugin goes here.
	# Add the new type with a name, a parent type, a script and an icon.
	var name = "MenuBar"
	var parent = "Panel"
	var script = preload("menu_bar_node.gd")
	var icon = preload("icon.png")
	add_custom_type(name, parent, script, icon)

func _exit_tree():
	# Clean-up of the plugin goes here.
	# Always remember to remove it from the engine when deactivated.
	remove_custom_type("MenuBar")
