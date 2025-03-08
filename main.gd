extends Node

@export var mob_scene: PackedScene
var score

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	pass

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("mobs", "queue_free")
	$Music.stop()
	$DeathSound.play()

func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Prepra-se")
	$Music.play()

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	var mob_spawn = $MobPath/MobSpawnLocation
	mob_spawn.progress_ratio = randf()
	var direction = mob_spawn.rotation + PI / 2
	mob.position = mob_spawn.position
	direction += randf_range(-PI/4, PI/4)
	mob.rotation = direction
	mob.linear_velocity = Vector2(randf_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	add_child(mob)
