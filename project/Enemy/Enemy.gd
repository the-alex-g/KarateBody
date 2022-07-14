class_name Enemy
extends KinematicBody2D

signal game_over
signal dead

enum Side {LEFT, RIGHT}

onready var _throwback_tween = $ThrowbackTween as Tween

export var direction := Vector2(0.25,1)
export var speed := 200
export var throwback_distance := 100

var side = Side.LEFT
var _moving := true
var _health := 1

func _ready():
	match side:
		Side.LEFT:
			direction.x *= -1
		Side.RIGHT:
			direction.x *= 1


func _physics_process(delta:float)->void:
	if _moving:
		# warning-ignore:return_value_discarded
		move_and_collide(direction*speed*delta)


func hit(damage_dealt:int, additional_throwback:int)->void:
	_health -= damage_dealt
	_moving = false
	_throwback_tween.interpolate_property(
		self,
		"position",
		null,
		position - direction * (throwback_distance + additional_throwback),
		0.2,
		Tween.TRANS_QUAD
	)
	_throwback_tween.start()


func _draw()->void:
	draw_circle(Vector2.ZERO, 10, Color.brown)


func _on_ThrowbackTween_tween_all_completed()->void:
	if _health <= 0:
		emit_signal("dead")
		queue_free()
	else:
		_moving = true


func _on_VisibilityNotifier2D_screen_exited()->void:
	if _health > 0:
		emit_signal("game_over")
		queue_free()
