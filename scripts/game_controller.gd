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
var levels = []
var current_level = 0
var board_obj = preload("res://scenes/board.tscn")
var board = null

@onready var machine = $CanvasLayer/MarginContainer/MachinePanel
@onready var turn_counter = $CanvasLayer/MarginContainer/Turn
@onready var reset_modal = $CanvasLayer/MarginContainer/Reset
@onready var reset_button = $CanvasLayer/MarginContainer/Reset/VBoxContainer/Reset
@onready var retry_button = $CanvasLayer/MarginContainer/Reset/VBoxContainer/Retry
@onready var next_button = $CanvasLayer/MarginContainer/Reset/VBoxContainer/Next
@onready var end_text = $CanvasLayer/MarginContainer/Reset/VBoxContainer/Label

func _ready():
	var level_list = []
	for level in ResourceLoader.list_directory("res://scripts/level_data/"):
		if level.contains("level") and level.ends_with(".tres"):
			level_list.append(level)
	level_list.sort()
	levels = level_list
	
	var level_data = load("res://scripts/level_data/" + levels[current_level])
	setup_board(level_data)
	
	machine.action_performed.connect(perform_action)
	machine.actions_complete.connect(complete_actions)

func setup_board(level_data):
	board = board_obj.instantiate()
	add_child(board)
	board.configure_level(level_data.data)
	board.reached_exit.connect(complete_level)

func perform_action(action_type):
	board.move_player(action_map[action_type])
	turn += 1
	turn_counter.text = "Turn " + str(turn)

func complete_level():
	machine.action_tween.kill()
	level_success = true
	
	await get_tree().create_timer(1.0).timeout
	
	board.queue_free()
	
	if current_level + 1 >= levels.size():
		end_text.text = "YOU WIN :)"
		reset_button.visible = true
		retry_button.visible = false
		next_button.visible = false
		reset_modal.visible = true
		return
	
	end_text.text = "GOOD JOB"
	next_button.visible = true
	reset_button.visible = false
	retry_button.visible = false
	reset_modal.visible = true

func init_level():
	var next_level = load("res://scripts/level_data/" + levels[current_level])
	setup_board(next_level)
	level_success = false
	turn = 0
	turn_counter.text = "Turn " + str(turn)
	machine.reset()
	reset_modal.visible = false

func complete_actions():
	if level_success: return
	end_text.text = "YOU LOSE :("
	reset_button.visible = false
	retry_button.visible = true
	next_button.visible = false
	reset_modal.visible = true

func _on_reset_pressed() -> void:
	get_tree().reload_current_scene()

func _on_retry_pressed() -> void:
	init_level()

func _on_next_pressed() -> void:
	current_level += 1
	init_level()
