extends Node2D
signal switch_toggled

@export var door_colors = [Color("#e34262"), Color("#457cd6"), Color("#6d8c32"), Color("#f2b63d")]

var coords = Vector2()
var direction_map = {
	"up": Vector2(0, -1),
	"down": Vector2(0, 1),
	"left": Vector2(-1, 0),
	"right": Vector2(1, 0),
}
var wall_obj = preload("res://scenes/wall.tscn")
var switch_obj = preload("res://scenes/switch.tscn")
var exit_obj = preload("res://scenes/exit.tscn")
var blockers = []
var switch_id = null
var switch = null

func configure(x, y, data):
	coords = Vector2(x, y)
	if data.get("exit"):
		var exit = exit_obj.instantiate()
		add_child(exit)
	
	var wall_data = data.get("walls", [])
	
	for wall in wall_data:
		var new_wall = wall_obj.instantiate()
		add_child(new_wall)
		new_wall.global_position = global_position
		var door_id = wall.get("door_id")
		if door_id:
			new_wall.self_modulate = door_colors[abs(door_id) - 1]
		else:
			new_wall.self_modulate = Color("#1b1b1b")
		blockers.append({
			"direction": wall.direction,
			"door_id": door_id,
			"obj": new_wall,
		})
		match wall.direction:
			"up":
				pass
			"down":
				new_wall.flip_v = true
			"left":
				new_wall.rotation_degrees = -90
			"right":
				new_wall.rotation_degrees = 90
		
	switch_id = data.get("switch_id")
	if switch_id:
		switch = switch_obj.instantiate()
		add_child(switch)
		switch.global_position = global_position
		switch.self_modulate = door_colors[switch_id - 1]

func trigger():
	if not switch: return
	switch.toggle()
	emit_signal("switch_toggled")

func can_pass(from_direction, unlocked_doors):	
	for blocker in blockers:
		if direction_map[blocker.direction] == from_direction:
			if blocker.door_id and blocker.door_id in unlocked_doors:
				return true
			elif blocker.door_id and blocker.door_id < 0 and !(abs(blocker.door_id) in unlocked_doors):
				return true
			return false
	return true
