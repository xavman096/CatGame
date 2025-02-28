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
var Number
var Duplicate

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
	SpawnPrefab()
	
	$Player.position = Vector2(2205, -16)
	print(CurrentPrefabs)

func _physics_process(_delta):
	if $Player.BoundryCollision == true and BoundryCooldown <= 0:
		RemovePrefab()
	
	BoundryCooldown = BoundryCooldown - 1

func RemovePrefab():
	if $Player.CharacterDirection == 1:
		CurrentPrefabs[0].queue_free()
		CurrentPrefabs.remove_at(0)
		BoundryCooldown = 60
		
	if $Player.CharacterDirection == -1:
		CurrentPrefabs[2].queue_free()
		CurrentPrefabs.remove_at(2)
		BoundryCooldown = 60
	
	BoundryCooldown = 60
	SpawnPrefab()

func SpawnPrefab():
	if StartingPrefab == true:
		for Iteration in 3:
			Number = RandomNumber.randi_range(0,4)
			while get_tree().get_root().get_node("Kitchen").has_node("Prefab" + str(Number)):
				Number = RandomNumber.randi_range(0,4)
				
			Duplicate = SpawnablePrefabs[Number].duplicate()
			Duplicate.name = 'Prefab' + str(Number)
			add_child(Duplicate)
			Duplicate.position = Vector2((1470 * Iteration), 0)
			CurrentPrefabs.insert(Iteration, Duplicate)
			
		StartingPrefab = false
		
	else:
		Number = RandomNumber.randi_range(0,4)
		while get_tree().get_root().get_node("Kitchen").has_node("Prefab" + str(Number)):
			Number = RandomNumber.randi_range(0,4)
			
		Duplicate = SpawnablePrefabs[Number].duplicate()
		Duplicate.name = 'Prefab' + str(Number)
		
		if $Player.CharacterDirection == 1:
			add_child(Duplicate)
			Duplicate.position = Vector2(($Player.BoundryPosition.x + 1512), 0)
			CurrentPrefabs.insert(2, Duplicate)
			
		if $Player.CharacterDirection == -1:
			add_child(Duplicate)
			Duplicate.position = Vector2(($Player.BoundryPosition.x - 3047), 0)
			CurrentPrefabs.insert(0, Duplicate)
		
		StartingPrefab = false
		$Player.BoundryCollision = false
		print(CurrentPrefabs)
