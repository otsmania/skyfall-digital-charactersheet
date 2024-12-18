extends Camera2D
var zoomTarget: Vector2
@export var zoomSpeed : float = 6.6 

var dragStartPos = Vector2.ZERO
var dragStartCamPos = Vector2.ZERO
var isDragging : bool = false 

var minZoom = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	zoomTarget = zoom


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Zoom(delta)
	DragClick()
	


func Zoom(delta):
	if Input.is_action_just_pressed("CameraZoomIn"):
		zoomTarget *= 1.1
	
	if Input.is_action_just_pressed("CameraZoomOut") and zoom.x > minZoom:
		zoomTarget *= 0.9

	zoom = zoom.slerp(zoomTarget, zoomSpeed * delta)

func DragClick():
	if !isDragging and Input.is_action_just_pressed("CameraPan"):
		dragStartPos = get_viewport().get_mouse_position()
		dragStartCamPos = position
		isDragging = true
		print("dragging")
	
	if isDragging and Input.is_action_just_released("CameraPan"):
		isDragging = false
		print("drag release")
		
	if isDragging:
		var moveVector = get_viewport().get_mouse_position() - dragStartPos
		position = dragStartCamPos - moveVector * 1/zoom.x
		print("yeyoyoyo")
