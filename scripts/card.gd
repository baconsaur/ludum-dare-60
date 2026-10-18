extends TextureRect

@export var offset = Vector2(-16, -40)

var type = "up"
var texture_map = {
	"up": preload("res://sprites/card_up.png"),
	"down": preload("res://sprites/card_down.png"),
	"left": preload("res://sprites/card_left.png"),
	"right": preload("res://sprites/card_right.png"),
}

func _process(_delta: float) -> void:
	position = get_global_mouse_position() + offset

func set_card(direction):
	type = direction
	texture = texture_map[type]
