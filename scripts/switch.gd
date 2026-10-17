extends Sprite2D

var up_sprite = preload("res://sprites/switch.png")
var down_sprite = preload("res://sprites/switch_down.png")
var is_pressed = false

func toggle():
	is_pressed = !is_pressed
	
	if is_pressed:
		texture = down_sprite
	else:
		texture = up_sprite
