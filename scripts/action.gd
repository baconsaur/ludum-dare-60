class_name Action
extends Control

enum ActionType {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	NOOP,
}

@export var action_type : ActionType = ActionType.NOOP

var type_map = {
	"up": ActionType.UP,
	"down": ActionType.DOWN,
	"left": ActionType.LEFT,
	"right": ActionType.RIGHT,
	null: ActionType.NOOP,
}

func set_action(action_name=null):
	action_type = type_map[action_name]

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
