extends Node2D
signal switch_toggled

@export var door_colors = [Color.BLUE, Color.HOT_PINK, Color.ORANGE_RED, Color.BLUE_VIOLET] # TODO

var coords = Vector2()
var direction_map = {
	"up": Vector2(0, -1),
	"down": Vector2(0, 1),
	"left": Vector2(-1, 0),
	"right": Vector2(1, 0),
}
var wall_obj = preload("res://scenes/wall.tscn")
var switch_obj = preload("res://scenes/switch.tscn")
var blockers = []
var switch_id = null
var switch = null

func configure(x, y, data):
	coords = Vector2(x, y)
	if data.get("spawn"):
		self_modulate = Color.GREEN_YELLOW
	elif data.get("exit"):
		self_modulate = Color.RED
	
	var wall_data = data.get("walls", [])
	
	for wall in wall_data:
		var new_wall = wall_obj.instantiate()
		add_child(new_wall)
		new_wall.global_position = global_position
		var door_id = wall.get("door_id")
		if door_id:
			new_wall.self_modulate = door_colors[door_id]
		else:
			new_wall.self_modulate = Color.DIM_GRAY
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
		switch.self_modulate = door_colors[switch_id]

func trigger():
	if not switch: return
	switch.toggle()
	emit_signal("switch_toggled")

func can_pass(from_direction, unlocked_doors):
	var success = true
	for blocker in blockers:
		if direction_map[blocker.direction] == from_direction:
			success = false
			if blocker.door_id and blocker.door_id in unlocked_doors:
				return true
	
	return success
