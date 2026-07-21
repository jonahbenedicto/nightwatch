extends CharacterBody2D

@export var speed: float = 300.0
@export var acceleration: float = 1500.0
@export var friction: float = 2000.0
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

const WALK_ANIMATIONS: Dictionary[Vector2, String] = {
	Vector2(0,  -1): "walk_up",
	Vector2(0,   1): "walk_down",
	Vector2(-1,  0): "walk_left",
	Vector2(1,   0): "walk_right",
	Vector2(-1, -1): "walk_up_left",
	Vector2(1,  -1): "walk_up_right",
	Vector2(-1,  1): "walk_down_left",
	Vector2(1,   1): "walk_down_right",
}

const IDLE_ANIMATIONS: Dictionary[Vector2, String] = {
	Vector2(0,  -1): "idle_up",
	Vector2(0,   1): "idle_down",
	Vector2(-1,  0): "idle_left",
	Vector2(1,   0): "idle_right",
	Vector2(-1, -1): "idle_up_left",
	Vector2(1,  -1): "idle_up_right",
	Vector2(-1,  1): "idle_down_left",
	Vector2(1,   1): "idle_down_right",
}

var last_direction: Vector2 = Vector2.DOWN

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_animation()
	move_and_slide()

func handle_movement(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction != Vector2.ZERO:
		last_direction = direction
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

func handle_animation() -> void:
	var animations: Dictionary[Vector2, String]

	if velocity.length() > 0:
		animations = WALK_ANIMATIONS
	else:
		animations = IDLE_ANIMATIONS

	var direction: Vector2 = Vector2(round(last_direction.x), round(last_direction.y))
	var animation: String = animations.get(direction, "")

	if animation != "":
		animated_sprite_2d.play(animation)
