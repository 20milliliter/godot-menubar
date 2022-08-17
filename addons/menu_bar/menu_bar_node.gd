@tool
extends Panel

#region Editor
func _enter_tree():
	if Engine.is_editor_hint():
		if get_node_or_null("MenuBarMenuButtons") == null:
			init()

func init():
	self.set_deferred("offset_right", 0)
	self.anchor_right = 1
	
	var menu_stack = HBoxContainer.new()
	menu_stack.name = "MenuBarMenuButtons"
	self.add_child(menu_stack)
	menu_stack.set_owner(get_tree().get_edited_scene_root())

	menu_stack.anchor_bottom = 1
	menu_stack.size_flags_horizontal = SIZE_EXPAND_FILL

@export var scan_menus = false
func _process(_delta):
	if Engine.is_editor_hint():
		if scan_menus:
			scan_menus = false
			build_shortcut_dictionary_from_menubuttons()
			self.notify_property_list_changed()
			print("Rebuilt Shortcut Dictionary")

@export var shortcut_dictionary : Dictionary
func build_shortcut_dictionary_from_menubuttons():
	var old_shortcuts = shortcut_dictionary.duplicate(true)
	shortcut_dictionary.clear()
	var all_items_on_bar = $MenuBarMenuButtons.get_children()
	for item in all_items_on_bar:
		if not item is MenuButton: continue
		var menu_popup = item.get_popup()
		var old_options_dict = old_shortcuts.get(item.text)
		var menu_dict = build_dictionary_from_individual_menu(menu_popup, old_options_dict)
		shortcut_dictionary[item.text] = menu_dict
			
func build_dictionary_from_individual_menu(menu:PopupMenu, old) -> Dictionary:
	var option_dict = {}
	for index in menu.get_item_count():
		if menu.is_item_separator(index): continue
		var option_text = menu.get_item_text(index)
		var previous_option = old.get(option_text) if old != null else null
		if previous_option != null:
			option_dict[option_text] = previous_option
		else:
			option_dict[option_text] = InputEventKey.new()
	return option_dict
#endregion

#region Runtime
func _ready():
	if not Engine.is_editor_hint():
		setup_menu_bar()
	return

var gId_to_parent_menuButton = {}
func setup_menu_bar():
	gId_to_parent_menuButton.clear()

	var all_menus_on_bar = $MenuBarMenuButtons.get_children()
	for menu in all_menus_on_bar:
		if menu is MenuButton: 
			setup_single_menu(menu)

func setup_single_menu(menu:MenuButton):
	var menu_popup = menu.get_popup()
	menu_popup.connect("id_pressed", convert_menuButton_signal)
	var menu_dictionary = shortcut_dictionary.get(menu.text)

	for item_idx in menu_popup.item_count:
		if menu_popup.is_item_separator(item_idx): 
			menu_popup.set_item_id(item_idx, 1337)
			continue
		var shortcut = menu_dictionary[menu_popup.get_item_text(item_idx)] if menu_dictionary != null else null
		setup_option(menu, item_idx, shortcut)
		

var global_id_count = 0
func setup_option(menu_button:MenuButton, local_index:int, shortcut_inputevent:InputEventKey):
	var popup_menu = menu_button.get_popup()
	var option_name = popup_menu.get_item_text(local_index)
	popup_menu.set_item_id(local_index, global_id_count)
	#gID -> PopupMenu
	gId_to_parent_menuButton[global_id_count] = menu_button
	global_id_count += 1
	
	#Set Shortcut if one exists
	if shortcut_inputevent == null or shortcut_inputevent.keycode == 0: return
	var shortcut = Shortcut.new()
	shortcut.events = [shortcut_inputevent]
	popup_menu.set_item_shortcut(local_index, shortcut)

func convert_menuButton_signal(gId_of_item_pressed:int):
	var menu = gId_to_parent_menuButton[gId_of_item_pressed]
	var popup_menu = menu.get_popup()
	var local_index = popup_menu.get_item_index(gId_of_item_pressed)
	
	#Find Prev Sep
	var seperator_index = -1
	for idx in range(local_index, -1, -1):
		if popup_menu.is_item_separator(idx): 
			seperator_index = idx
			break
	
	#Find Next Sep
	var next_sep_index = popup_menu.get_item_count()
	for idx in range(local_index, next_sep_index):
		if popup_menu.is_item_separator(idx): 
			next_sep_index = idx
			break
	
	var section_indices = range(seperator_index + 1, next_sep_index)
	
	var path = menu.text
	if seperator_index != -1: path += "/%s" % popup_menu.get_item_text(seperator_index)
	path += "/%s" % popup_menu.get_item_text(local_index)
	emit_signal("item_pressed", path, popup_menu, local_index, section_indices)
	if get_signal_connection_list("item_pressed").size() == 0:
		print(path + " was pressed.")

signal item_pressed(path:String, popup_menu:PopupMenu, item_index:int, section_indices:Array)
#endregion
