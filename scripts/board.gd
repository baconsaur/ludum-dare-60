extends Node2D

signal reached_exit

@export var num_rows : int = 3
@export var num_cols : int = 3
@export var spawn_point : Vector2 = Vector2(0, 0)
@export var exit : Vector2 = Vector2(2, 2)

var cell_obj = preload("res://scenes/cell.tscn")
var grid = []
var player_pos = spawn_point

func _ready():
	for i in range(num_rows):
		grid.append([])
		for j in range(num_cols):
			var cell = cell_obj.instantiate()
			add_child(cell)
			grid[i].append(cell)
			cell.position = get_cell_pos(i, j)
			if Vector2(i, j) == player_pos:
				cell.modulate = Color.GREEN
			elif Vector2(i, j) == exit:
				cell.modulate = Color.RED

func get_cell_pos(x, y):
	return Vector2(x * 20 - num_rows * 10, y * 20 - num_cols * 10)

func move_player(movement):
	grid[player_pos.x][player_pos.y].modulate = Color.WHITE
	player_pos = Vector2(
		clamp(player_pos.x + movement.x, 0, num_rows),
		clamp(player_pos.y + movement.y, 0, num_cols)
	)
	grid[player_pos.x][player_pos.y].modulate = Color.GREEN

	if player_pos == exit:
		emit_signal("reached_exit")
