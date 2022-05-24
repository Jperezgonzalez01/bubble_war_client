extends Node2D


func _on_TouchScreenButton_pressed():
	InputManager.press_android_shoot_button()


func _on_TouchScreenButton_released():
	InputManager.release_android_shoot_button()
