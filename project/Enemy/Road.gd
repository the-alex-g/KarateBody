extends Node2D

const _Enemy := preload("res://Enemy/Enemy.tscn")

onready var _enemy_spawn_timer = $EnemySpawnTimer as Timer
onready var _enemy_container = $Enemies as Node2D
onready var _enemy_spawn_point = $EnemySpawnPoint as Position2D

export var enemy_spawn_delay := 1

func _ready()->void:
	randomize()
	_enemy_spawn_timer.wait_time = enemy_spawn_delay


func _on_Timer_timeout()->void:
	spawn_enemy()


func spawn_enemy()->void:
	var enemy := _Enemy.instance()
	enemy.position = _enemy_spawn_point.position
	var side := randi()%2
	match side:
		0:
			enemy.side = enemy.Side.LEFT
		1:
			enemy.side = enemy.Side.RIGHT
	_enemy_container.add_child(enemy)
	# warning-ignore:return_value_discarded
	enemy.connect("game_over", self, "_on_Enemy_game_over", [], CONNECT_ONESHOT)
# warning-ignore:return_value_discarded
	enemy.connect("dead", get_parent(), "_on_Enemy_dead", [], CONNECT_ONESHOT)


func _on_Enemy_game_over()->void:
	print("You losed!")
	_enemy_spawn_timer.stop()
