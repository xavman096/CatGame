extends Node

var OvenPrefab
var BenchPrefab1
var BenchPrefab2
var BenchPrefab3
var BenchPrefab4

var RandomNumber = RandomNumberGenerator.new()

func _ready():
	
	OvenPrefab = get_node("OvenPrefab")
	BenchPrefab1 = get_node("BenchPrefab1")
	BenchPrefab2 = get_node("BenchPrefab2")
	BenchPrefab3 = get_node("BenchPrefab3")
	BenchPrefab4 = get_node("BenchPrefab4")
	
	var SpawnablePrefabs = [OvenPrefab, BenchPrefab1, BenchPrefab2, BenchPrefab3, BenchPrefab4]
		
	var Duplicate = SpawnablePrefabs[RandomNumber.randi_range(0,4)].duplicate()
	Duplicate.position = Vector2(0, 0)
	
	add_child(Duplicate)
	
