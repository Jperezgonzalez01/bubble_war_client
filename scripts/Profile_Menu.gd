extends Node2D

var boosts_list = []
var current_selected_boost = -1
var current_online_player = null

func _ready():
	current_online_player = Network.get_online_player_info()
	if current_online_player != null:
		$name_value_label.set_text(str(current_online_player["NAME"]))
		$score_value_label.set_text(str(current_online_player["TOTAL_SCORE"]))
		$selected_boost_value_label.set_text(str(current_online_player["SELECTED_BOOST_NAME"]))
		Network.s_get_all_boosts(get_instance_id())


func set_boosts_list(new_boosts_list):
	boosts_list = new_boosts_list
	$Boosts_ItemList.clear()
	for boost in boosts_list:
		var image_texture = ImageTexture.new()
		var stream_texture = load(boost["image_path"])
		var image = stream_texture.get_data()
		image.lock()
		image_texture.create_from_image(image)
		var selectable = true if boost["min_score"] <= current_online_player["TOTAL_SCORE"] else false
		$Boosts_ItemList.add_item("Name: " + str(boost["name"]) + ", Min. Score: " + str(boost["min_score"]), image_texture, selectable)
		if current_online_player != null and boost["name"] == current_online_player["SELECTED_BOOST_NAME"]:
			$Boosts_ItemList.select($Boosts_ItemList.get_item_count() - 1)

func _on_Back_Button_pressed():
	Global.goto_scene("res://scenes/Initial_Menu.tscn")


func _on_Boosts_ItemList_item_selected(index):
	if $Boosts_ItemList.is_item_selectable(index):
		current_selected_boost = index


func _on_Boosts_ItemList_nothing_selected():
	current_selected_boost = -1


func _on_Select_Boost_Button_pressed():
	if current_online_player != null:
		if current_selected_boost != -1:
			var selected_item_text = $Boosts_ItemList.get_item_text(current_selected_boost)
			var selected_boost_id = -1
			for boost in boosts_list:
				var text = "Name: " + str(boost["name"]) + ", Min. Score: " + str(boost["min_score"])
				if selected_item_text == text:
					selected_boost_id = boost["id"]
					$selected_boost_value_label.set_text(str(boost["name"]))
			if selected_boost_id != -1:
				Network.s_update_selected_boost(current_online_player["ID"], selected_boost_id)
		else:
			$selected_boost_value_label.set_text("...")
			Network.s_update_selected_boost(current_online_player["ID"], null)
