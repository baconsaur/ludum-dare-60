extends Control

@export var turn_length : float = 1.
@export var max_actions : int = 10

var action_obj = preload("res://scenes/action.tscn")

@onready var actions = $MachineSections/ActionSection/Actions
@onready var execute_button = $MachineSections/Execute
@onready var cards = $MachineSections/ActionSection/CardSection/Cards

func _on_execute_pressed() -> void:
	if actions.get_child_count() == 0:
		return
		
	execute_button.disabled = true
	toggle_cards(true)
	
	var tween = get_tree().create_tween()

	for action in actions.get_children():
		# TODO
		tween.tween_callback(action.perform_action).set_delay(turn_length)

	await tween.finished
	toggle_cards(false)

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
	
	if actions.get_child_count() >= max_actions:
		toggle_cards(true)

func _on_up_pressed() -> void:
	add_action("up")

func _on_down_pressed() -> void:
	add_action("down")

func _on_left_pressed() -> void:
	add_action("left")

func _on_right_pressed() -> void:
	add_action("right")
