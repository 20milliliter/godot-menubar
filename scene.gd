extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_menu_bar_item_pressed(path, popup_menu, item_index):
	match(path):
		"Buttons/Button1" : handle_button1(popup_menu, item_index)
		"Buttons/Button2" : handle_button2(popup_menu, item_index)
		"Checkboxes/Check1" : handle_check1(popup_menu, item_index)
		"Checkboxes/Check2" : handle_check2(popup_menu, item_index)
		"Radio/Radio1", "Radio/Radio2", "Radio/Radio3": handle_radiomenu(popup_menu, item_index)
		_: print(path)

func handle_button1(popup_menu, item_index):
	print("Button1 pressed.")
	
func handle_button2(popup_menu, item_index):
	print("Button2 pressed.")

func handle_check1(popup_menu, item_index):
	var item_checked = !popup_menu.is_item_checked(item_index)
	popup_menu.set_item_checked(item_index, item_checked)
	
	if item_checked: 
		print("Check1 checked.")
	else: 
		print("Check1 unchecked.")
	
	
func handle_check2(popup_menu, item_index):
	var item_checked = !popup_menu.is_item_checked(item_index)
	popup_menu.set_item_checked(item_index, item_checked)
	
	if item_checked: 
		print("Check2 checked.")
	else: 
		print("Check2 unchecked.")
	
	
func handle_radiomenu(popup_menu, item_index):
	for idx in popup_menu.item_count:
		if !popup_menu.is_item_radio_checkable(idx): return
		popup_menu.set_item_checked(idx, false)
	popup_menu.set_item_checked(item_index, true)
		
	print("Option %s picked." % (item_index + 1))
