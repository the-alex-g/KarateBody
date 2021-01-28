extends Node2D

const _Enemy := preload("res://Enemy/Enemy.tscn")

export var _enemy_spawn_delay := 1

func _ready():
	randomize()
	$Timer.wait_time = _enemy_spawn_delay

func _on_Timer_timeout():
	spawn_enemy()

func spawn_enemy():
	var _enemy := _Enemy.instance()
	_enemy.position = Vector2.ZERO
	var side := randi()%2
	match side:
		0:
			_enemy.side = _enemy.Side.LEFT
		1:
			_enemy.side = _enemy.Side.RIGHT
	$Enemies.add_child(_enemy)
