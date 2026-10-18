extends Control
signal action_performed
signal actions_complete

@export var turn_length : float = 1.
@export var max_actions : int = 15

var action_obj = preload("res://scenes/action.tscn")
var action_tween = null

@onready var actions = $MachineSections/ActionSection/Actions
@onready var execute_button = $MachineSections/Execute
@onready var undo_button = $MachineSections/ActionSection/HBoxContainer/Undo
@onready var cards = $MachineSections/ActionSection/Cards

func _on_execute_pressed() -> void:
	if actions.get_child_count() == 0:
		return
		
	execute_button.disabled = true
	undo_button.disabled = true
	toggle_cards(true)
	
	action_tween = get_tree().create_tween()

	for action in actions.get_children():
		action_tween.tween_callback(func():
			action.perform_action()
			emit_signal("action_performed", action.action_type)
		).set_delay(turn_length / 2)
		action_tween.tween_interval(turn_length / 2)

	await action_tween.finished
	action_tween = null
	emit_signal("actions_complete")

func toggle_cards(disable : bool):
	for card in cards.get_children():
		card.disabled = disable

func add_action(action_type):
	if actions.get_child_count() >= max_actions:
		return

	var action = action_obj.instantiate()
	action.set_action(action_type)
	actions.add_child(action)
	update_queue()
	
func update_queue():
	if actions.get_child_count() > 0:
		execute_button.disabled = false
		undo_button.disabled = false
	else:
		execute_button.disabled = true
		undo_button.disabled = true
	
	if actions.get_child_count() >= max_actions:
		toggle_cards(true)
	else:
		toggle_cards(false)

func reset():
	for action in actions.get_children():
		action.queue_free()
	
	execute_button.disabled = true
	undo_button.disabled = true
	toggle_cards(false)

func _on_up_pressed() -> void:
	add_action("up")

func _on_down_pressed() -> void:
	add_action("down")

func _on_left_pressed() -> void:
	add_action("left")

func _on_right_pressed() -> void:
	add_action("right")

func _on_wait_pressed() -> void:
	add_action(null)

func _on_undo_pressed() -> void:
	if not actions.get_child_count(): return
	
	var last_action = actions.get_child(-1)
	actions.remove_child(last_action)
	last_action.queue_free()
	
	update_queue()
