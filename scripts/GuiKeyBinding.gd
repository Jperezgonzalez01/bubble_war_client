extends CanvasLayer

var file_name = "res://config/keybinding.json"

var key_dict = {
		"shoot":32,
		"move_left":65,
		"move_right":68,
		"move_up":87,
		"move_down":83
	}


func _ready():
	load_keys()


#We'll use this when the game loads
func load_keys():
	var file = File.new()
	if(file.file_exists(file_name)):
		delete_old_keys()
		file.open(file_name,File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if(typeof(data) == TYPE_DICTIONARY):
			key_dict = data
			setup_keys()
		else:
			printerr("corrupted keybindings data!")
	else:
		#NoFile, so lets save the default keys now
		save_keys()


func delete_old_keys():
	#Remove the old keys
	for i in key_dict:
		var oldkey = InputEventKey.new()
		oldkey.scancode = int(self.key_dict[i])
		InputMap.action_erase_event(i,oldkey)


func setup_keys():
	for i in key_dict:
		for j in get_tree().get_nodes_in_group("button_keys"):
			if(j.action_name == i):
				j.text = OS.get_scancode_string(key_dict[i])
		var newkey = InputEventKey.new()
		newkey.scancode = int(key_dict[i])
		InputMap.action_add_event(i,newkey)


func save_keys():
	var file = File.new()
	file.open(file_name,File.WRITE)
	file.store_string(to_json(key_dict))
	file.close()
