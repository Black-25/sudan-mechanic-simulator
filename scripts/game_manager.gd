extends Node3D

const GAME_TITLE = "SUDAN MECHANIC SIMULATOR"
const WORKSHOP_SCENE = preload("res://scenes/workshop.tscn")
const PLAYER_SCENE = preload("res://scenes/player.tscn")
const CONTROLS_SCRIPT = preload("res://scripts/mobile_controls.gd")
const CAMERA_SCRIPT = preload("res://scripts/camera_controller.gd")

var player: CharacterBody3D
var game_started: bool = false


func _ready() -> void:
	print(GAME_TITLE)

	if not InputMap.has_action("interact"):
		InputMap.add_action("interact")

	setup_environment()
	create_workshop()
	create_player()
	create_mobile_controls()

	game_started = true


func setup_environment() -> void:
	var world_environment = WorldEnvironment.new()
	var environment = Environment.new()

	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.45, 0.58, 0.72)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.8, 0.8, 0.8)
	environment.ambient_light_energy = 0.8

	world_environment.environment = environment
	add_child(world_environment)

	var sun = DirectionalLight3D.new()
	sun.name = "Sun"
	sun.rotation_degrees = Vector3(-45, -30, 0)
	sun.light_energy = 1.2
	add_child(sun)


func create_workshop() -> void:
	var workshop = WORKSHOP_SCENE.instantiate()
	workshop.name = "Workshop"
	add_child(workshop)


func create_player() -> void:
	player = PLAYER_SCENE.instantiate() as CharacterBody3D
	player.name = "Adam"
	player.position = Vector3(0, 0, 3)
	add_child(player)

	var camera_arm = SpringArm3D.new()
	camera_arm.name = "CameraArm"
	camera_arm.position = Vector3(0, 1.5, 0)
	camera_arm.spring_length = 5.0
	camera_arm.set_script(CAMERA_SCRIPT)
	player.add_child(camera_arm)

	var camera = Camera3D.new()
	camera.name = "Camera3D"
	camera.current = true
	camera_arm.add_child(camera)


func create_mobile_controls() -> void:
	var canvas = CanvasLayer.new()
	canvas.name = "MobileControlsLayer"
	add_child(canvas)

	var controls = Control.new()
	controls.name = "MobileControls"
	controls.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	controls.set_script(CONTROLS_SCRIPT)
	canvas.add_child(controls)


func start_game() -> void:
	game_started = true
	print("Adam's journey begins!")


func get_game_status() -> Dictionary:
	return {
		"title": GAME_TITLE,
		"started": game_started,
		"player": "Adam"
	}
