extends Sprite2D

var O = load("res://O.png")
var X = load("res://X.png")

var Board = [[null, null, null],
			 [null, null, null],
			 [null, null, null]]
# in bot's prespective -> 1: Win, 0: Draw, -1: Lose, null: Can't Decide
func Advantage(board):
	for i in range(3):
		if board[i][0] == board[i][1] and board[i][1] == board[i][2] and board[i][0] != null:
			return -1 if board[i][0] == "X" else 1
		if board[0][i] == board[1][i] and board[1][i] == board[2][i] and board[0][i] != null:
			return -1 if board[0][i] == "X" else 1
		if board[0][0] == board[1][1] and board[1][1] == board[2][2] and board[0][0] != null:
			return -1 if board[0][0] == "X" else 1
		if board[0][2] == board[1][1] and board[1][1] == board[2][0] and board[0][2] != null:
			return -1 if board[0][2] == "X" else 1
	if len(ValidMoves(board)) == 0:
		return 0
	else:
		return null

func MakeBoard(board, moves: Array):
	var newBoard = board.duplicate(true)
	for move in moves:
		newBoard[move.row][move.col] = move.player
	return newBoard

func ValidMoves(board) -> Array:
	var validMoves: Array[Move] = []
	var x_count = 0
	var o_count = 0
	
	for row in board:
		for cell in row:
			if cell == "X":
				x_count += 1
			elif cell == "O":
				o_count += 1
	
	var player = "X" if x_count == o_count else "O"
	
	for row in range(len(board)):
		for col in range(len(board[row])):
			if board[row][col] == null:
				validMoves.append(Move.new(row, col, player))
	
	return validMoves

func GameOver():
	await get_tree().create_timer(1).timeout
	Board = [[null,null,null],[null,null,null],[null,null,null]]
	for child in get_children():
		child.Played = false
		child.CanPlay = false
		child.get_node("Sprite2D").texture = null
		ClearVisualization()

func Play(row, col):
	if Advantage(Board) == -1:
		await GameOver()
		return
	Board[row][col] = "O"
	var slot = get_node(str(row, col))
	slot.Played = true
	var sprite = slot.get_node("Sprite2D")
	sprite.texture = O
	sprite.modulate.a = 1
	if Advantage(Board) == 1:
		await GameOver()

func BestMove(Board ,Moves):
	var bestMove
	var adv = -2
	
	for move in Moves:
		var newBoard = MakeBoard(Board, [move])
		if Advantage(newBoard) and Advantage(newBoard) <= adv: continue
		adv = Advantage(newBoard)
		bestMove = move
	return bestMove

func RAND():
	var validMoves = ValidMoves(Board)
	if len(validMoves) == 0: return
	var rand = randi_range(0,len(validMoves)-1)
	Play(validMoves[rand].row, validMoves[rand].col)

func LOGIC():
	var validMoves = ValidMoves(Board)
	if len(validMoves) == 0: await GameOver();return
	
	var nextMove = BestMove(Board, validMoves)
	
	Play(nextMove.row, nextMove.col)


func BFS():
	var valid_moves = ValidMoves(Board)

	if len(valid_moves) == 0:
		return await GameOver()

	var queue = Queue.new()
	for move in valid_moves:
		queue.enqueue([move])

	var WinningSequence
	var TieSequence
	while not queue.is_empty():
		var sequence = queue.dequeue()
		var CurrentBoard = MakeBoard(Board, sequence)
		var advantage = Advantage(CurrentBoard)
		
		if advantage:
			if advantage == 1:
				WinningSequence = sequence
				break
			elif advantage == 0:
				TieSequence = sequence
				

		var nextValidMoves = ValidMoves(CurrentBoard)
		for move in nextValidMoves:
			var newSequence = sequence.duplicate(true)
			newSequence.append(move)
			queue.enqueue(newSequence)
	if WinningSequence:
		Play(WinningSequence[0].row, WinningSequence[0].col)
		Visualize(WinningSequence)
	elif TieSequence:
		Play(TieSequence[0].row, TieSequence[0].col)
		Visualize(TieSequence)
	else:
		RAND()

func DFS():
	var valid_moves = ValidMoves(Board)

	if len(valid_moves) == 0:
		return await GameOver()

	var stack = Stack.new()
	for move in valid_moves:
		stack.push([move])

	var WinningSequence
	var TieSequence
	while not stack.is_empty():
		var sequence = stack.pop()
		var CurrentBoard = MakeBoard(Board, sequence)
		var advantage = Advantage(CurrentBoard)
		
		if advantage:
			if advantage == 1:
				WinningSequence = sequence
				break
			elif advantage == 0:
				TieSequence = sequence
				

		var nextValidMoves = ValidMoves(CurrentBoard)
		for move in nextValidMoves:
			var newSequence = sequence.duplicate(true)
			newSequence.append(move)
			stack.push(newSequence)
	if WinningSequence:
		Play(WinningSequence[0].row, WinningSequence[0].col)
		Visualize(WinningSequence)
	elif TieSequence:
		Play(TieSequence[0].row, TieSequence[0].col)
		Visualize(TieSequence)
	else:
		ClearVisualization()
		RAND()


func IDS(MaxDepth = 5):
	var valid_moves = ValidMoves(Board)

	if len(valid_moves) == 0:
		return await GameOver()

	var stack = Stack.new()
	for move in valid_moves:
		stack.push([move])

	var WinningSequence
	var TieSequence
	var CurrentDepth = 0
	while not stack.is_empty():
		var sequence = stack.pop()
		var CurrentBoard = MakeBoard(Board, sequence)
		var advantage = Advantage(CurrentBoard)
		
		if advantage:
			if advantage == 1:
				WinningSequence = sequence
				break
			elif advantage == 0:
				TieSequence = sequence
		for move in ValidMoves(CurrentBoard):
			var newSequence = sequence.duplicate(true)
			newSequence.append(move)
			if len(newSequence) > MaxDepth: continue
			stack.push(newSequence)
	
	if WinningSequence:
		Play(WinningSequence[0].row, WinningSequence[0].col)
		Visualize(WinningSequence)
	elif TieSequence:
		Play(TieSequence[0].row, TieSequence[0].col)
		Visualize(TieSequence)
	else:
		ClearVisualization()
		RAND()
		
func UCS():
	var valid_moves = ValidMoves(Board)

	if len(valid_moves) == 0:
		return await GameOver()

	var priority_queue = PriorityQueue.new()
	for move in valid_moves:
		priority_queue.enqueue([move], 0)

	var WinningSequence = null
	var TieSequence = null

	while not priority_queue.is_empty():
		var dequeued = priority_queue.dequeue()
		var sequence = dequeued["sequence"]
		var cost = dequeued["cost"]

		var CurrentBoard = MakeBoard(Board, sequence)
		var advantage = Advantage(CurrentBoard)
		if advantage:
			if advantage == 1:
				WinningSequence = sequence
				break
			elif advantage == 0:
				TieSequence = sequence

		var nextValidMoves = ValidMoves(CurrentBoard)
		for move in nextValidMoves:
			var newSequence = sequence.duplicate(true)
			newSequence.append(move)
			var newCost = cost + 1 
			priority_queue.enqueue(newSequence, newCost)

	if WinningSequence:
		Play(WinningSequence[0].row, WinningSequence[0].col)
		Visualize(WinningSequence)
	elif TieSequence:
		Play(TieSequence[0].row, TieSequence[0].col)
		Visualize(TieSequence)
	else:
		RAND()

		
func Visualize(moves):
	ClearVisualization()
	var newBoard = self.duplicate()
	newBoard.set_script(null)
	for child in newBoard.get_children():
		child.get_node("CollisionShape2D").queue_free()
		child.set_script(null)
	newBoard.scale = Vector2(.3,.3)
	owner.get_node("Visualization").add_child(newBoard)
	newBoard.position = Vector2(0,0)
	
	
	var grid_size = Vector2(20, 20)
	var x = -40
	var y = 20
	var newnewBoard
	for Move in moves:
		if newnewBoard:
			newnewBoard = newnewBoard.duplicate()
		else:
			newnewBoard = newBoard.duplicate()
		owner.get_node("Visualization").add_child(newnewBoard)
		newnewBoard.position = Vector2(x, y)
		var slot = newnewBoard.get_node(str(Move.row, Move.col))
		var sprite = slot.get_node("Sprite2D")
		if Move.player == "O":
			sprite.texture = O
		else:
			sprite.texture = X
		sprite.modulate.a = 1
		x += grid_size.x
		if x >= grid_size.x * 3:
			x = 0
			y += grid_size.y

func ClearVisualization():
	for child in owner.get_node("Visualization").get_children():
		child.queue_free()
