extends Node

var OvenPrefab
var BenchPrefab1
var BenchPrefab2
var BenchPrefab3
var BenchPrefab4
var CurrentPrefabs = []
var SpawnablePrefabs = []

var BoundryPosition 

var RandomNumber = RandomNumberGenerator.new()
var BoundryCooldown = 60

func _ready():

	OvenPrefab = get_node("OvenPrefab")
	BenchPrefab1 = get_node("BenchPrefab1")
	BenchPrefab2 = get_node("BenchPrefab2")
	BenchPrefab3 = get_node("BenchPrefab3")
	BenchPrefab4 = get_node("BenchPrefab4")
	
	SpawnablePrefabs = [OvenPrefab, BenchPrefab1, BenchPrefab2, BenchPrefab3, BenchPrefab4]
	
	BoundryPosition = $OvenPrefab/PrefabBoundry1.position
	
	for iteration in 3:
		SpawnPrefab(iteration)
	
	var Player = $Player
	Player.position = Vector2(1470, -16)
	
	print(CurrentPrefabs)

func _physics_process(_delta):
	if $Player.BoundryCollision == true and BoundryCooldown <= 0:
		if $Player.CharacterDirection == 1:
			CurrentPrefabs[0].queue_free()
			CurrentPrefabs.remove_at(0)
			SpawnPrefab(0)
			BoundryCooldown = 60
			$Player.BoundryCollision = false
		else:
			CurrentPrefabs[2].queue_free()
			CurrentPrefabs.remove_at(2)
			SpawnPrefab(2)
			BoundryCooldown = 60
			$Player.BoundryCollision = false
		
	BoundryCooldown = BoundryCooldown - 1

func SpawnPrefab(PrefabNumber):
		
	var Number = RandomNumber.randi_range(0,4)
	var Duplicate = SpawnablePrefabs[Number].duplicate()
	Duplicate.name = 'Prefab' + str(PrefabNumber)
	Duplicate.position = Vector2(BoundryPosition.x + (1470 * $Player.CharacterDirection), 0)
	add_child(Duplicate)
		
	CurrentPrefabs.insert(PrefabNumber, Duplicate)
