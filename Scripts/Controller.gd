class_name GameController
extends Node2D

const BALL_COUNT := 1

@export var tex_sprites: Texture2D

var player_paddle: PaddleEntity
var enemy_paddle: PaddleEntity
var balls: Array[BallEntity]

var score: int
var computer_score: int

@onready var score_label = get_node("%ScoreLabel")


func _enter_tree() -> void:
	Constants.init()
	randomize()


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	var canvas_rid := get_canvas_item()

	score = 0
	computer_score = 0

	player_paddle = PaddleEntity.new(canvas_rid, tex_sprites, true)
	enemy_paddle = PaddleEntity.new(canvas_rid, tex_sprites, false)

	for _i in range(BALL_COUNT):
		var ball := BallEntity.new(canvas_rid, tex_sprites)
		ball.on_score.connect(self.__handle_score_update)

		balls.append(ball)


func _unhandled_input(event: InputEvent) -> void:
	player_paddle._input(event)


func _physics_process(delta: float) -> void:
	var closest_ball_x := 0.0
	var closest_ball_y := 0.0

	for ball in balls:
		ball._update(delta)

		__handle_collision(ball, player_paddle)
		__handle_collision(ball, enemy_paddle)

		var x := ball.transform.origin.x

		if x <= closest_ball_x:
			continue

		closest_ball_x = x
		closest_ball_y = ball.transform.origin.y

	enemy_paddle.set_target(closest_ball_y)

	player_paddle._update(delta)
	enemy_paddle._update(delta)


## Handlers ##


func __handle_score_update(player_scored: bool) -> void:
	if player_scored:
		score += 1
	else:
		computer_score += 1

	score_label.text = "Score: %d | %d" % [score, computer_score]


func __handle_collision(ball: BallEntity, paddle: PaddleEntity) -> void:
	if !ball.is_touching(paddle):
		return

	var normal := paddle.get_normal()

	var hit_dir: Vector2 = (ball.transform.origin - paddle.transform.origin).normalized()
	var hit_dot: float = hit_dir.dot(normal)

	ball.GET_AWAY_FROM(paddle)

	if hit_dot < 0.55:
		return

	ball.bounce_velocity(normal)
