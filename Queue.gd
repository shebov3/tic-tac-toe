class_name Queue extends Object

var queue = []

func enqueue(element):
	queue.append(element)

func dequeue():
	if queue.size() > 0:
		return queue.pop_front()
	else:
		return null

func _to_string() -> String:
	var string = ''
	for element in queue:
		string += str(element)
	return string

func peek():
	if queue.size() > 0:
		return queue[0]
	else:
		return null

func is_empty():
	return queue.size() == 0

func clear():
	queue.clear()
