# Menubar

The MenuBar is a custom control node which serve to provide useful encapsulation for multiple MenuButtons, mainly for creating a [menu bar](https://en.wikipedia.org/wiki/Menu_bar).

As icing on the cake, it also makes setting shortcuts for items in these menus *not* a painful experience.

<br>

## Installation

Out of the zipped contents, move the addons folder to your project folder, and enable the plugin.
Alternatively, open the included project if you'd like to see it in action first.

<br>

## Usage

1. Create a ```MenuBar``` node. Upon creation it will do two things automatically:
   - Place itself at the top of the parent control with the top-wide preset.
   - Create a ```HBoxContainer``` child which will serve as the parent for all ```MenuButton```s

2. Add desired ```MenuButton```s as children of the ```HBoxContainer```.
   - **Note:** The node *names* do not matter and can be anything. What the ```MenuBar``` node cares about is the button's ```text``` property.

3. Add desired items to each individual MenuButton with their built in ```items``` array property.
   - You may also enable the ```switch_on_hover``` property. It is not required, but most menu bars function like this.
   - **Note:** The system functions using the ```ID``` property of each item. As such, they cannot be assumed to keep the value each had in the editor, as they are replaced at runtime. This is automatic, you do not need to set them yourself.

   ### If you don't wish to set any hotkeys, you may skip to step 7.

4. To initialize hotkey setup, click the ```scan_menus``` ""button"" in the MenuBar properties. The ```shortcut_dictionary``` property will be updated to match the menus you have placed. 

5. To set a shortcut, open ```shortcut_dictionary```, and find the menu which contains the item. Open that dictionary, and locate the item to recieve the shortcut. A ```InputEventKey``` object has been placed for you, simply open it and use the built in **[Configure]** button to set the key combination.


6. If you wish to remove a hotkey, simply reset the ```keycode``` property of the ```InputEventKey``` to 0.

7. Connect the "item_pressed" signal of the MenuBar to the node script you wish to process the item presses. Your root note is a good choice.

8. Use ```match(path)``` to redirect program flow to functions for each<sup>**</sup> menu item<sup>*</sup>

<sup>\*Included is an example project with this implementation. It's reccomended you take a look to see it in action, as well as how to edit item properties in response to action. Your implementation can be anything, I've just found this method to be simple and straightforward.</sup>

<sup>**The example project also shows how one function can service multiple menu items, so you may not need a function for every item individually if you use this method.</sup>

9. Done! Enjoy your menu bar. Add theme to taste.


<br>

## Limitations

### Radio Buttons

Currently there is no great way to handle radio buttons. The signal only gives the button pressed as in 90% of cases, that's the only one relevant. Radio buttons are the 10, however, as you must also disable the buttons that were *not* the one that was pressed.

The normal solution, a ```ButtonGroup``` does not work here as these buttons are embedded within the woefully inaccessible ```PopupMenu```, itself within a ```MenuButton```. As of now, radio buttons can function, with the limitation that **all** radio button within a given ```MenuButton``` must be treated as a single group. See example project for this in detail.

More complex code and retrival of data within ```MenuBar```'s script could be used as a workaround. That's stupid though, you shouldn't have to do that. As such, I intend my first update to this plugin to remedy this limitation.


## Plan

- Fix the radio button issue. I already know how to, I just need to do it.
- The above involves including Seperator items in the ```path```. But should it be done always? What if theres no seperators at all? Only for radio buttons? I'll have to think about it.
- Consider the ramifications of ```MenuBar``` extending ```HBoxContainer``` instead of ```Panel```. This removes the need for the weird ```HBoxContainer``` child, and (I think?) has no negative impact on functionality whatsoever.