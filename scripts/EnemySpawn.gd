extends Position2D

export (Array, PackedScene) var Enemies
export(int, "Shooter", "Dodger", "Homer") var Enemy


func activate():
	return Enemies[Enemy].instance()