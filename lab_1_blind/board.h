#pragma once
#include <cstdint>
#include <vector>
#include <unordered_map>

// representes game board
struct board {
	// storage of unique nodes
	static std::unordered_map<uint64_t, board> unique_nodes;
	// chips matrix
	uint8_t cells[3][3];
	// empty cell position
	struct cell {
		uint8_t x, y;
	} empty_cell;
	size_t depth;

	// constructor
	board(const uint8_t initial_state[3][3], size_t initial_depth);
	// board(const board& rhs) = default;
	// board& operator=(const board& rhs) = default;
	// makes board in new state by moving empty cell on dx or dy
	board move(int8_t dx, int8_t dy) const;

	// used as a key in unique_nodes
	uint64_t hash_code() const;

	// constructs all possible successors
	std::vector<board> get_successors() const;

	// comparison of two boards
	bool operator==(const board& rhs) const;

	// returns true if node is unique (and inserts it), otherwise returns false
	bool is_unique() const {
		return unique_nodes.insert_or_assign(hash_code(), *this).second;
	}

	// prints cells matrix in stdout
	void print_board() const;
};
