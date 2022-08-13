extends Control

#The main receiving function that reroutes the signal to wherever it should go.
func _on_menu_bar_item_pressed(path, popup_menu, item_index):
	match(path):
		# Note the option to leave out data that is not relevant.
		"Buttons/Button1" : handle_button1() 
		"Buttons/Button2" : handle_button2()
		"Checkboxes/Check1" : handle_check1(popup_menu, item_index)
		"Checkboxes/Check2" : handle_check2(popup_menu, item_index)
		# Note the option for one function to service multiple items.
		"Radio/Radio1", "Radio/Radio2", "Radio/Radio3": handle_radiomenu(popup_menu, item_index)
		_: print(path)

func handle_button1():
	print("Button1 pressed.")
	
func handle_button2():
	print("Button2 pressed.")

func handle_check1(popup_menu, item_index):
	# A checkbox can be easily toggled like this.
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
	# A radio group can be handled by unchecking all radio items in the menu, then checking the one pressed.
	# This is kinda dumb, also limiting. See readme for details: A fix for this is known and planned.
	for idx in popup_menu.item_count:
		if !popup_menu.is_item_radio_checkable(idx): return
		popup_menu.set_item_checked(idx, false)
	popup_menu.set_item_checked(item_index, true)
		
	print("Option %s picked." % (item_index + 1))
