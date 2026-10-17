class_name Action
extends TextureButton

enum ActionType {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	NOOP,
}

@export var action_type : ActionType = ActionType.NOOP

var action_sprites = {
	Action.ActionType.UP: preload("res://ui/sprites/up_action.png"),
	Action.ActionType.DOWN: preload("res://ui/sprites/down_action.png"),
	Action.ActionType.LEFT: preload("res://ui/sprites/left_action.png"),
	Action.ActionType.RIGHT: preload("res://ui/sprites/right_action.png"),
	Action.ActionType.NOOP: preload("res://ui/sprites/noop_action.png"),
}
var type_map = {
	"up": ActionType.UP,
	"down": ActionType.DOWN,
	"left": ActionType.LEFT,
	"right": ActionType.RIGHT,
	null: ActionType.NOOP,
}

func set_action(action_name=null):
	action_type = type_map[action_name]
	texture_normal = action_sprites[action_type]

func perform_action():
	match action_type:
		ActionType.UP:
			queue_free()
		ActionType.DOWN:
			queue_free()
		ActionType.LEFT:
			queue_free()
		ActionType.RIGHT:
			queue_free()
		ActionType.NOOP:
			queue_free()
