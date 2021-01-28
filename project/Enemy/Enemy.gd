class_name Enemy
extends KinematicBody2D

enum Side {LEFT, RIGHT}

export var direction := Vector2(0.25,1)
export var speed := 200

var _ignore
var side = Side.LEFT

func _ready():
	match side:
		Side.LEFT:
			direction.x *= -1
		Side.RIGHT:
			direction.x *= 1

func _physics_process(delta):
	_ignore = move_and_collide(direction*speed*delta)

func hit():
	print("ouch")

func _draw():
	draw_circle(Vector2.ZERO, 10, Color.brown)
