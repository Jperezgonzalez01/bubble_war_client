extends Node2D


func _ready():
	GuiKeyBinding.setup_keys()
	$server_ip_LineEdit.set_text(Configuration.get_server_ip())
	$server_port_LineEdit.set_text(str(Configuration.get_server_port()))
	$sound_volume_HSlider.set_value(Configuration.get_sound_volume())
	$sound_volume_value.set_text(str(Configuration.get_sound_volume()))

func _on_Back_Button_pressed():
	Global.goto_scene("res://scenes/Initial_Menu.tscn")


func _on_server_ip_LineEdit_focus_exited():
	Configuration.update_server_ip($server_ip_LineEdit.get_text())
	Configuration.apply_config()
	Configuration.save_config()


func _on_server_port_LineEdit_focus_exited():
	Configuration.update_server_port(int($server_port_LineEdit.get_text()))
	Configuration.apply_config()
	Configuration.save_config()


func _on_sound_volume_HSlider_value_changed(value):
	$sound_volume_value.set_text(str(value))


func _on_sound_volume_HSlider_focus_exited():
	Configuration.update_sound_volume(int($sound_volume_HSlider.get_value()))
	Configuration.apply_config()
	Configuration.save_config()
