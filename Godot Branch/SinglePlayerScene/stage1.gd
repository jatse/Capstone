extends Spatial

#Scene variables
# warning-ignore:unused_class_variable
var GRAVITY = 1
var PLAYER_BULLET = preload("res://Assets/PlayerBullet.tscn")
var SPARKS = preload("res://Assets/Sparks.tscn")

func spawnProjectile(playerType, proj_trans):
	if playerType == "player":
		var projectile = PLAYER_BULLET.instance()
		projectile.transform = proj_trans
		add_child(projectile)
	
func spawnSparks(spark_loc):
	var sparks = SPARKS.instance()
	sparks.transform = spark_loc
	add_child(sparks)
	