class_name PlacementTask extends TaskItem


@export var objects_per_area: int = 1
@export var objects_in_area: Array
@export var all_areas_clear: bool = false

func verify_cleared(target_areas: Array[TargetArea]):
	var cleared_areas: Array[TargetArea] = []
	for area in target_areas:
		if area.area_clear:
			cleared_areas.append(area)
			
	if cleared_areas.size() == target_areas.size():
		all_areas_clear = true
	else:
		all_areas_clear = false
