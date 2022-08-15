extends Control

#The main receiving function that reroutes the signal to wherever it should go.
func _on_menu_bar_item_pressed(path, popup_menu, item_index, section_indices):
	match(path):
		# Note the option to leave out data that is not relevant.
		"Buttons/Button1" : handle_button1() 
		"Buttons/Seperator/Button2" : handle_button2()
		"Checkboxes/Check1" : handle_check1(popup_menu, item_index)
		"Checkboxes/Check2" : handle_check2(popup_menu, item_index)
		# Note the option for one function to service multiple items.
		"Radio/Section1/Radio1", "Radio/Section1/Radio2": handle_radiomenu1(popup_menu, item_index, section_indices)
		"Radio/Section2/Radio3", "Radio/Section2/Radio4": handle_radiomenu2(popup_menu, item_index, section_indices)
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
	
	
func handle_radiomenu1(popup_menu, item_index, section_indices):
	for idx in section_indices:
		if !popup_menu.is_item_radio_checkable(idx): return
		popup_menu.set_item_checked(idx, false)
	popup_menu.set_item_checked(item_index, true)
		
	print("Section 1: Option %s picked." % (section_indices.find(item_index) + 1))
	
func handle_radiomenu2(popup_menu, item_index, section_indices):
	for idx in section_indices:
		if !popup_menu.is_item_radio_checkable(idx): return
		popup_menu.set_item_checked(idx, false)
	popup_menu.set_item_checked(item_index, true)
		
	print("Section 2: Option %s picked." % (section_indices.find(item_index) + 1))
