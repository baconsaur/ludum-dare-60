extends Node2D

var coords = Vector2()
var direction_map = {
	"up": Vector2(0, -1),
	"down": Vector2(0, 1),
	"left": Vector2(-1, 0),
	"right": Vector2(1, 0),
}
var wall_obj = preload("res://scenes/wall.tscn")
var blockers = []

func configure(x, y, data):
	coords = Vector2(x, y)
	if data.get("spawn"):
		self_modulate = Color.GREEN
	elif data.get("exit"):
		self_modulate = Color.RED
	
	var wall_data = data.get("walls")
	if not wall_data: return
	
	for wall in wall_data:
		var new_wall = wall_obj.instantiate()
		add_child(new_wall)
		new_wall.global_position = global_position
		blockers.append(wall.direction)
		match wall.direction:
			"up":
				pass
			"down":
				new_wall.flip_v = true
			"left":
				new_wall.rotation_degrees = -90
			"right":
				new_wall.rotation_degrees = 90

func can_pass(from_direction):
	for blocker in blockers:
		if direction_map[blocker] == from_direction:
			return false
	
	return true
