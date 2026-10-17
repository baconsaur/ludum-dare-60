extends Node2D

signal reached_exit

@export var cell_size = 20

var num_rows : int = 3
var num_cols : int = 3
var spawn_point : Vector2 = Vector2(0, 0)
var exit : Vector2 = Vector2(2, 2)
var player_obj = preload("res://scenes/player.tscn")
var cell_obj = preload("res://scenes/cell.tscn")
var grid = []
var player_pos = spawn_point
var unlocked_doors = []
var player = null

var test_map = preload("res://scripts/level_data/test.tres")

func _ready():
	
	var map_data = test_map.data
	for i in range(map_data.size()):
		grid.append([])
		for j in range(map_data[i].size()):
			var cell = cell_obj.instantiate()
			cell.switch_toggled.connect(toggle_switch.bind(cell))
			add_child(cell)
			grid[i].append(cell)
			cell.position = get_cell_pos(i, j)
			
			var cell_data = map_data[i][j]
			cell.configure(i, j, cell_data)
			if cell_data.get("spawn"):
				spawn_point = Vector2(i, j)
			elif cell_data.get("exit"):
				exit = Vector2(i, j)
	player = player_obj.instantiate()
	add_child(player)
	
	player.position = get_cell_pos(spawn_point.x, spawn_point.y)
	num_cols = map_data[0].size()
	num_rows = map_data[0][0].size()

func get_cell_pos(x, y):
	return Vector2(
		x * cell_size - num_rows * cell_size / 2,
		y * cell_size - num_cols * cell_size
	)

func move_player(movement):
	var next_cell = Vector2(
		clamp(player_pos.x + movement.x, 0, num_rows),
		clamp(player_pos.y + movement.y, 0, num_cols)
	)
	
	if next_cell.x >= grid.size() or next_cell.y >= grid[next_cell.x].size(): return
	
	if not grid[next_cell.x][next_cell.y].can_pass(
		player_pos - next_cell, unlocked_doors
	): return
	if not grid[player_pos.x][player_pos.y].can_pass(
		player_pos - next_cell * -1, unlocked_doors
	): return
	
	player_pos = next_cell
	player.position = get_cell_pos(player_pos.x, player_pos.y) - Vector2(cell_size / 2, 0)
	
	grid[player_pos.x][player_pos.y].trigger()
	
	if player_pos == exit:
		emit_signal("reached_exit")

func toggle_switch(cell):
	if cell.switch_id in unlocked_doors:
		unlocked_doors.erase(cell.switch_id)
	else:
		unlocked_doors.append(cell.switch_id)
	update_doors()

func update_doors():
	for row in grid:
		for cell in row:
			for blocker in cell.blockers:
				if blocker.get("door_id") in unlocked_doors:
					blocker.obj.self_modulate.a = 0.1
				else:
					blocker.obj.self_modulate.a = 1
					
