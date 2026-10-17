extends Node2D

var action_map = {
	Action.ActionType.UP: "up",
	Action.ActionType.DOWN: "down",
	Action.ActionType.LEFT: "left",
	Action.ActionType.RIGHT: "right",
	Action.ActionType.NOOP: "noop",
}

@onready var machine = $CanvasLayer/MarginContainer/MachinePanel

func _ready():
	machine.action_performed.connect(perform_action)
	
func perform_action(action_type):
	print_debug(action_map[action_type])
