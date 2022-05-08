extends Node


var current_scene = null


func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	get_tree().set_auto_accept_quit(false)


func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)


func goto_scene_modifying_variable(path, variable_name, variable_value):
	call_deferred("_deferred_modifying_variable", path, variable_name, variable_value)


func goto_scene_modifying_variables(path, variable_names, variable_values):
	call_deferred("_deferred_modifying_variables", path, variable_names, variable_values)


func _deferred_modifying_variables(path, variable_names, variable_values):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	
	if variable_names != null and variable_values != null and variable_names.size() == variable_values.size():
		for i in range(variable_names.size()):
			current_scene.set(variable_names[i], variable_values[i])


func _deferred_modifying_variable(path, variable_name, variable_value):
	_deferred_modifying_variables(path, [variable_name], [variable_value])


func _deferred_goto_scene(path):
	_deferred_modifying_variables(path, null, null)


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST and current_scene.get_name() == "initial_menu":
		get_tree().quit()
	
