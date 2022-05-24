extends Node

var config_file = "res://config/configuration.json"

var config_dict = {
		"sound_volume":100,
		"server_ip":"127.0.0.1",
		"server_port":5008
	}


func _ready():
	load_config()


func load_config():
	var file = File.new()
	if(file.file_exists(config_file)):
		file.open(config_file,File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if(typeof(data) == TYPE_DICTIONARY):
			config_dict = data
			apply_config()
		else:
			printerr("corrupted configuration data!")
	else:
		save_config()


func apply_config():
	var sound_volume_db = linear2db(float(config_dict["sound_volume"]) / 100)
	var master_bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus_idx, sound_volume_db)
	Network.SERVER_IP = config_dict["server_ip"]
	Network.SERVER_PORT = config_dict["server_port"]


func save_config():
	var file = File.new()
	file.open(config_file,File.WRITE)
	file.store_string(to_json(config_dict))
	file.close()


func update_server_ip(new_ip:String):
	config_dict["server_ip"] = new_ip


func update_server_port(new_port:int):
	config_dict["server_port"] = new_port


func update_sound_volume(new_volume:int):
	config_dict["sound_volume"] = new_volume


func get_server_ip() -> String:
	return config_dict["server_ip"]


func get_server_port() -> int:
	return config_dict["server_port"]


func get_sound_volume() -> int:
	return config_dict["sound_volume"]
