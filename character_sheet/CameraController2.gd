extends Camera2D

@export var zoomSpeed: float = 6.6
@export var minZoom: float = 1.0
@export var maxZoom: float = 5.0
@export var boundaries: Rect2 = Rect2(Vector2.ZERO, Vector2(1920, 1080))  # Define the camera movement boundaries

var zoomTarget: Vector2
var dragStartPos = Vector2.ZERO
var dragStartCamPos = Vector2.ZERO
var isDragging: bool = false

func _ready():
	zoomTarget = zoom

func _process(delta):
	handle_zoom(delta)
	handle_drag()
	clamp_camera_position()

func handle_zoom(delta):
	# Zoom in and out using input actions
	if Input.is_action_just_pressed("CameraZoomIn") and zoom.x < maxZoom:
		zoomTarget *= 1.1

	if Input.is_action_just_pressed("CameraZoomOut") and zoom.x > minZoom:
		zoomTarget *= 0.9

	# Interpolate smoothly towards the target zoom
	zoom = zoom.lerp(zoomTarget, zoomSpeed * delta)

	# Center camera if zooming out to minZoom
	if zoomTarget.x <= minZoom:
		zoomTarget = Vector2(minZoom, minZoom)  # Clamp to the minimum zoom
		position = boundaries.position + boundaries.size / 2  # Center camera

func handle_drag():
	# Start dragging
	if not isDragging and Input.is_action_just_pressed("CameraPan"):
		dragStartPos = get_viewport().get_mouse_position()
		dragStartCamPos = position
		isDragging = true
		print("Dragging started")

	# Stop dragging
	if isDragging and Input.is_action_just_released("CameraPan"):
		isDragging = false
		print("Dragging stopped")

	# Dragging logic
	if isDragging:
		var current_mouse_pos = get_viewport().get_mouse_position()
		var moveVector = current_mouse_pos - dragStartPos
		position = dragStartCamPos - moveVector / zoom.x
		

func clamp_camera_position():
	var viewport_size = get_viewport_rect().size
	var half_viewport_size = (viewport_size / 2) * zoom

	# Calculate minimum and maximum positions
	var min_x = boundaries.position.x + half_viewport_size.x
	var max_x = boundaries.position.x + boundaries.size.x - half_viewport_size.x
	var min_y = boundaries.position.y + half_viewport_size.y
	var max_y = boundaries.position.y + boundaries.size.y - half_viewport_size.y

	# Clamp each component individually
	var clamped_x = clamp(position.x, min_x, max_x)
	var clamped_y = clamp(position.y, min_y, max_y)

	# Update the camera's position
	position = Vector2(clamped_x, clamped_y)
