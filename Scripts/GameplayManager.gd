extends Node

var OvenPrefab
var BenchPrefab1
var BenchPrefab2
var BenchPrefab3
var BenchPrefab4
var CurrentPrefabs = []
var SpawnablePrefabs = []

var BoundryPosition
var BoundryCooldown = 60

var RandomNumber = RandomNumberGenerator.new()

var StartingPrefab

func _ready():

	OvenPrefab = get_node("OvenPrefab")
	BenchPrefab1 = get_node("BenchPrefab1")
	BenchPrefab2 = get_node("BenchPrefab2")
	BenchPrefab3 = get_node("BenchPrefab3")
	BenchPrefab4 = get_node("BenchPrefab4")
	
	SpawnablePrefabs = [OvenPrefab, BenchPrefab1, BenchPrefab2, BenchPrefab3, BenchPrefab4]
	
	BoundryPosition = $OvenPrefab/PrefabBoundry1.position
	
	StartingPrefab = true
	SpawnPrefab(0)
	
	var Player = $Player
	Player.position = Vector2(1470, -16)
	
	print(CurrentPrefabs)

func _physics_process(_delta):
	if $Player.BoundryCollision == true and BoundryCooldown <= 0:
		SpawnPrefab(0)
	
	BoundryCooldown = BoundryCooldown - 1

func SpawnPrefab(PrefabNumber):
	if StartingPrefab == true:
		for Iteration in 3:
			var Number = RandomNumber.randi_range(0,4)
			var Duplicate = SpawnablePrefabs[Number].duplicate()
			Duplicate.name = 'Prefab' + str(Iteration)
			Duplicate.position = Vector2((1470 * Iteration), 0)
			add_child(Duplicate)
			CurrentPrefabs.insert(Iteration, Duplicate)
			
		StartingPrefab = false
	else:
		var Number = RandomNumber.randi_range(0,4)
		var Duplicate = SpawnablePrefabs[Number].duplicate()
		Duplicate.name = 'Prefab' + str(Number)
		if $Player.CharacterDirection == 1:
			Duplicate.position = Vector2(($Player.BoundryPosition.x + 1470), 0)
		else:
			Duplicate.position = Vector2(($Player.BoundryPosition.x - 1470), 0)
		add_child(Duplicate)
		CurrentPrefabs.insert(PrefabNumber, Duplicate)
		
		StartingPrefab = false
		$Player.BoundryCollision = false
		RemovePrefab()
	
func RemovePrefab():
	if $Player.CharacterDirection == 1:
		CurrentPrefabs[0].queue_free()
		CurrentPrefabs.remove_at(0)
		BoundryCooldown = 60
		print(CurrentPrefabs)
	else:
		CurrentPrefabs[2].queue_free()
		CurrentPrefabs.remove_at(2)
		BoundryCooldown = 60
		print(CurrentPrefabs)
		
