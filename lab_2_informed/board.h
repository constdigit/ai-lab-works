#pragma once
#include <cstdint>
#include <functional>
#include <vector>
#include <unordered_map>

// representes game board
struct board {
	// storage of unique nodes
	static std::unordered_map<uint64_t, board> unique_nodes;
	// used for calculating h(n) for each node
	static std::function<uint16_t(board&)> heuristic_function;
	// goal state
	static board goal;
	// chips matrix
	uint8_t cells[3][3];
	// empty cell position
	struct cell {
		uint8_t x, y;
	} empty_cell;
	// current node depth
	size_t depth;
	// result of calling heuristic_function()
	uint16_t h;

	// constructor
	board(const uint8_t initial_state[3][3], size_t initial_depth);
	board() = default;

	// makes board in new state by moving empty cell on dx or dy
	board move(int8_t dx, int8_t dy) const;

	// used as a key in unique_nodes
	uint64_t hash_code() const;

	// constructs all possible successors
	// and sorts them in ascending by heuristic function value
	std::vector<board> get_successors() const;

	// comparison of two boards
	bool operator==(const board& rhs) const;

	// returns true if node is unique (and inserts it), otherwise returns false
	bool is_unique() const {
		return unique_nodes.insert_or_assign(hash_code(), *this).second;
	}

	// better way than full comparison
	bool is_goal() const {
		return h == 0;
	}

	// prints cells matrix in stdout
	void print_board() const;
};
