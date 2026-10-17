extends Node2D

var action_map = {
	Action.ActionType.UP: Vector2(0, -1),
	Action.ActionType.DOWN: Vector2(0, 1),
	Action.ActionType.LEFT: Vector2(-1, 0),
	Action.ActionType.RIGHT: Vector2(1, 0),
	Action.ActionType.NOOP: Vector2(0, 0),
}
var turn = 0
var level_success = false

@onready var board = $Board
@onready var machine = $CanvasLayer/MarginContainer/MachinePanel
@onready var turn_counter = $CanvasLayer/MarginContainer/Turn

func _ready():
	machine.action_performed.connect(perform_action)
	machine.actions_complete.connect(complete_actions)
	board.reached_exit.connect(complete_level)
	
func perform_action(action_type):
	board.move_player(action_map[action_type])
	turn += 1
	turn_counter.text = "Turn " + str(turn)

func complete_level():
	machine.action_tween.kill()
	level_success = true
	print_debug("good jorb")

func complete_actions():
	if level_success: return
	print_debug("oh no")
