class_name CarrierObject extends DynamicObject


@onready var marker_2d: Marker2D = $Marker2D
@export var carried_obj: DynamicObject

func _ready() -> void:
	if carried_obj:
		carried_obj.set_collision_layer_value(3, false)

func _physics_process(delta: float) -> void:
	if carried_obj:
		carried_obj.global_position = marker_2d.global_position
