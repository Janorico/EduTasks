class_name Task

enum {
	RESULT_NAN = -1,
	RESULT_WRONG = 0,
	RESULT_CORRECT = 1,
}

func create() -> void:
	push_error("Not implemented!")

func get_text() -> String:
	push_error("Not implemented!")
	return ""

func check_result(r: String) -> int:
	if not r.is_valid_float():
		return RESULT_NAN
	var rf = snapped(r.to_float(), 0.1)
	return _check_result_f(rf)

func _check_result_f(_r: float) -> int:
	push_error("Not implemented!")
	return RESULT_NAN

# ----- MATH -----

class SimpleTermTask extends Task:
	var n1 := 0.0
	var n2 := 0.0
	
	func create() -> void:
		n1 = randi_range(10, 100)
		n2 = randi_range(10, 100)


class AddTask extends SimpleTermTask:
	func get_text() -> String:
		return "%d + %d = " % [n1, n2]
	
	func _check_result_f(r: float) -> int:
		return snappedf(n1 + n2, 0.1) == r


class SubtractTask extends SimpleTermTask:
	func get_text() -> String:
		return "%d - %d = " % [n1, n2]
	
	func _check_result_f(r: float) -> int:
		return snappedf(n1 - n2, 0.1) == r


class MultiplyTask extends SimpleTermTask:
	func get_text() -> String:
		return "%d \u00D7 %d = " % [n1, n2]
	
	func _check_result_f(r: float) -> int:
		return snappedf(n1 * n2, 0.1) == r


class DivideTask extends SimpleTermTask:
	func get_text() -> String:
		return "%d \u00F7 %d = " % [n1, n2]
	
	func _check_result_f(r: float) -> int:
		return snappedf(n1 / n2, 0.1) == r
