extends Control
signal action_performed
signal actions_complete

@export var turn_length : float = 1.
@export var max_actions : int = 15

var action_obj = preload("res://scenes/action.tscn")
var card_obj = preload("res://scenes/card.tscn")
var action_tween = null
var card_held = null

@onready var actions = $MachineSections/ActionSection/PanelContainer/Actions
@onready var execute_button = $MachineSections/Execute
@onready var undo_button = $MachineSections/ActionSection/HBoxContainer/Undo
@onready var cards = $MachineSections/ActionSection/Cards
@onready var lever_animator = $MachineSections/Execute/AnimationPlayer
@onready var card_animator = $MachineSections/ActionSection/HBoxContainer/CardSlot/Card/AnimationPlayer
@onready var card_sound = $MachineSections/ActionSection/CardSound
@onready var turn_sound = $TurnSound
@onready var canvas = get_node("../..")

func _process(delta: float) -> void:
	if card_held and Input.is_action_just_pressed("drop_card"):
		card_held.queue_free()
		card_held = null
	
func _on_execute_pressed() -> void:
	if actions.get_child_count() == 0:
		return

	if card_held:
		card_held.queue_free()
		card_held = null
		
	execute_button.disabled = true
	undo_button.disabled = true
	toggle_cards(true)
	lever_animator.play("pull")

func execute():
	action_tween = get_tree().create_tween()

	for action in actions.get_children():
		action_tween.tween_callback(func():
			turn_sound.play()
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

func get_card(direction):
	if card_held:
		card_held.queue_free()
	card_held = card_obj.instantiate()
	card_held.set_card(direction)
	canvas.add_child(card_held)
	
	card_sound.play()
	card_animator.play("flash_slot")

func register_action():
	if not card_held: return
	
	add_action(card_held.type)
	card_held.queue_free()
	card_held = null

func _on_up_pressed() -> void:
	get_card("up")

func _on_down_pressed() -> void:
	get_card("down")

func _on_left_pressed() -> void:
	get_card("left")

func _on_right_pressed() -> void:
	get_card("right")

func _on_undo_pressed() -> void:
	if not actions.get_child_count(): return
	
	var last_action = actions.get_child(-1)
	actions.remove_child(last_action)
	last_action.queue_free()
	card_animator.play("eject")
	
	update_queue()

func _on_card_slot_pressed() -> void:
	card_animator.stop()
	if card_held:
		card_animator.play("feed")
		canvas.remove_child(card_held)
