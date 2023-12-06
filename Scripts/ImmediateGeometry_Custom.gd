extends ImmediateGeometry

var lines = []

func clear_array():
	lines.clear();

func add_line(start_pos : Vector3, end_pos: Vector3):
	lines.append([start_pos, end_pos])
	
func update_draw_view():
	clear()
	# drawing_class.set_color(Color.red);
	for line_coord in lines:
		begin(Mesh.PRIMITIVE_LINES)
		set_color(Color.red)
		add_vertex(line_coord[0])
		add_vertex(line_coord[1])
		end()
