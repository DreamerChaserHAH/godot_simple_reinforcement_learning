extends RigidBody

export var movespeed : float = 10;
export var checkingdistance : float = 5;

export var target_position : Vector3;

var starting_distance : float;

var input_vector : Vector2 = Vector2(0.0, 0.0);

func _ready():
	starting_distance = translation.distance_to(target_position);

func _process(_delta):
	var movement_vector : Vector2 = input_vector.normalized() * movespeed * _delta;
	add_force(Vector3(movement_vector.x, 0, movement_vector.y), Vector3.ZERO);
	get_distant_states()
	pass
	
func _input(event):
	input_vector = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_down", "ui_up"));
	
func get_score(actual_distance):
	return actual_distance / checkingdistance

func get_target_score(current_distance):
	return 1 - (current_distance / (starting_distance * 2))

func get_distant_states():
	var intersection_state = []
	var directional_vectors = [Vector3(0, 0, 1), Vector3(1, 0, 1), Vector3(1, 0, 0), Vector3(1, 0, -1), Vector3(0, 0, -1), Vector3(-1, 0, -1), Vector3(-1, 0, 0), Vector3(-1, 0, 1)]
	var space_state = get_world().direct_space_state
	
	var parent_node = get_parent().get_node("Line Drawer");
	parent_node.clear_array();
	
	for directional_vector in directional_vectors:
		var target_position = translation + checkingdistance * directional_vector.normalized();
		var raycast_state = space_state.intersect_ray(translation, target_position, [self])
		if (raycast_state as Dictionary).size() == 0:
			intersection_state.append(1.0)
			parent_node.add_line(translation, target_position);
		else:
			parent_node.add_line(translation, raycast_state.position);
			intersection_state.append(get_score(translation.distance_to(raycast_state.position)))
	
	parent_node.add_line(translation, target_position);
	intersection_state.append(get_target_score(translation.distance_to(target_position)))
	print(intersection_state)
	parent_node.update_draw_view();
	
	return intersection_state
