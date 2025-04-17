extends Node

var PlayerScore = 0

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

var FruitNumberGenerator = RandomNumberGenerator.new()
var FruitNumber
var FruitDuplicate
var FruitExists = false
var FruitDropSpot
var FruitArray = []
var Apple
var Pear
var Banana
var Bowlpopped = false
var FruitDespawnTimer = 800

var StartingPrefab

func _ready():

	OvenPrefab = get_node("OvenPrefab")
	BenchPrefab1 = get_node("BenchPrefab1")
	BenchPrefab2 = get_node("BenchPrefab2")
	BenchPrefab3 = get_node("BenchPrefab3")
	BenchPrefab4 = get_node("BenchPrefab4")
	SpawnablePrefabs = [OvenPrefab, BenchPrefab1, BenchPrefab2, BenchPrefab3, BenchPrefab4]
	BoundryPosition = $OvenPrefab/PrefabBoundry1.position
	
	Apple = get_node("AppleArea")
	Pear = get_node("PearArea")
	Banana = get_node("BananaArea")
	FruitArray = [Apple, Pear, Banana]
	
	StartingPrefab = true
	SpawnPrefab()
	
	$Player.position = Vector2(2205, -16)
	
func _physics_process(_delta):
	if $Player.BoundryCollision == true and BoundryCooldown <= 0:
		RemovePrefab()
	BoundryCooldown = BoundryCooldown - 1
	
	if $Player.PlayerAttacked == true:
		FruitScatter()
		$Player.PlayerAttacked = false
		
	if Bowlpopped == true:
		if FruitDespawnTimer <= 0:
			print("Removing Fruit")
			print(FruitArray)
			print("Array size is 0")
			for i in FruitArray:
				i.position = $FruitBowlArea.position
			FruitDespawnTimer = 800
			Bowlpopped = false
		FruitDespawnTimer = FruitDespawnTimer - 1
		
func RemovePrefab():
	if $Player.CharacterDirection == 1:
		if FruitExists == true:
			if FruitDuplicate.position == Vector2(CurrentPrefabs[0].position.x + 736, -64):
				FruitDuplicate.queue_free()
				FruitExists = false
		CurrentPrefabs[0].queue_free()
		CurrentPrefabs.remove_at(0)
		BoundryCooldown = 60
		
	if $Player.CharacterDirection == -1:
		if FruitExists == true:
			if FruitDuplicate.position == Vector2(CurrentPrefabs[2].position.x + 736, -64):
				FruitDuplicate.queue_free()
				FruitExists = false
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
			
		if FruitExists == false:
			if Number != 0:
				FruitNumber = FruitNumberGenerator.randi_range(0,1)
			if FruitNumber == 0:
				FruitDuplicate = $FruitBowlArea.duplicate()
				FruitDuplicate.name = 'FruitDuplicate'
				FruitDuplicate.position = Vector2((Duplicate.position.x + 736), -64)
				add_child(FruitDuplicate)
				FruitExists = true
				Bowlpopped = false
				FruitArray = [Apple, Pear, Banana]
				print("Fruit Spawned")
		$Player.BoundryCollision = false
		
func FruitScatter():
	if $Player.AttackedObject == "FruitBowl":
		for i in range(0,3):
			FruitDropSpot = RandomNumberGenerator.new().randf_range(FruitDuplicate.position.x - 300, FruitDuplicate.position.x + 300)
			FruitArray[i].position = Vector2(FruitDropSpot, FruitDuplicate.position.y + 100)
			Bowlpopped = true
		get_node("FruitDuplicate").queue_free()
		FruitExists = false
		$Player.AttackedObject = ""
	
	if $Player.AttackedObject == "Apple":
		FruitArray.erase("Apple")
		var AppleScore = $ScoreManager.duplicate()
		AppleScore.name = "AppleScore"
		add_child(AppleScore)
		AppleScore.position = Vector2($AppleArea.position.x, $AppleArea.position.y - 200)
		AppleScore.get_child(0).play("ScoreAnimation")
		Apple.position = $FruitBowlArea.position
		PlayerScore = PlayerScore + 100
		if AppleScore.get_child(0).is_playing() == false:
			AppleScore.queue_free()
		$Player.AttackedObject = ""
	
	if $Player.AttackedObject == "Pear":
		FruitArray.erase("Pear")
		var PearScore = $ScoreManager.duplicate()
		PearScore.name = "PearScore"
		add_child(PearScore)
		PearScore.position = Vector2($PearArea.position.x, $PearArea.position.y - 200)
		PearScore.get_child(0).play("ScoreAnimation")
		Pear.position = $FruitBowlArea.position
		PlayerScore = PlayerScore + 100
		if PearScore.get_child(0).is_playing() == false:
			PearScore.queue_free()
		$Player.AttackedObject = ""
		
	if $Player.AttackedObject == "Banana":
		FruitArray.erase("Banana")
		var BananaScore = $ScoreManager.duplicate()
		BananaScore.name = "BananaScore"
		add_child(BananaScore)
		BananaScore.position = Vector2($BananaArea.position.x, $BananaArea.position.y - 200)
		BananaScore.get_child(0).play("ScoreAnimation")
		Banana.position = $FruitBowlArea.position
		PlayerScore = PlayerScore + 100
		if BananaScore.get_child(0).is_playing() == false:
			BananaScore.queue_free()
		$Player.AttackedObject = ""
