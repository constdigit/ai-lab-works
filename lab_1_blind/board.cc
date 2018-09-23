#include "board.h"
#include <iostream>

// initializer for unique_nodes
std::unordered_map<uint64_t, board> board::unique_nodes{};

// constructor
board::board(const uint8_t initial_state[3][3]) {
	for (uint8_t x{0}; x < 3; x++) {
		for (uint8_t y{0}; y < 3; y++) {
			cells[x][y] = initial_state[x][y];
			if (cells[x][y] == 0) {
				empty_cell.x = x;
				empty_cell.y = y;
			}
		}
	}
}

// makes board in new state by moving empty cell on dx or dy
board board::move(int8_t dx, int8_t dy) const{
	board new_board(cells);
	auto ex = empty_cell.x;
	auto ey = empty_cell.y;
	std::swap(new_board.cells[ex][ey],
		 new_board.cells[ex + dx][ey + dy]);
	new_board.empty_cell.x += dx;
	new_board.empty_cell.y += dy;
	return new_board;
}

// used as a key in unique_nodes
uint64_t board::hash_code() const {
  uint64_t hash = 5381;

	for (uint8_t x{0}; x < 3; x++) {
		for (uint8_t y{0}; y < 3; y++) {
			hash = ((hash << 5) + hash) + cells[x][y];
		}
	}

  return hash;
}


// constructs all possible successors
std::vector<board> board::get_successors() const {
	std::vector<board> successors;
	if (empty_cell.y > 0) {
		successors.push_back(move(0, -1));
	}
	if (empty_cell.y < 2) {
		successors.push_back(move(0, 1));
	}
	if (empty_cell.x > 0) {
		successors.push_back(move(-1, 0));
	}
	if (empty_cell.x < 2) {
		successors.push_back(move(1, 0));
	}

	return successors;
}

// comparison of two boards
bool board::operator==(const board& rhs) const {
	for (uint8_t x{0}; x < 3; x++) {
		for (uint8_t y{0}; y < 3; y++) {
			if (cells[x][y] != rhs.cells[x][y]) {
				return false;
			}
		}
	}
	return true;
}

// board& operator=(const board& rhs) {
// 	for (uint8_t x{0}; x < 3; x++) {
// 		for (uint8_t y{0}; y < 3; y++) {
// 			cells[x][y] = rhs.cells[x][y];
// 		}
// 	}
// 	empty_cell = rhs.empty_cell;
// 	return *this;
// }

void board::print_board() const {
	for (uint8_t x{0}; x < 3; x++) {
		for (uint8_t y{0}; y < 3; y++) {
			if (cells[x][y] == 0) {
				std::cout << "  ";
			} else {
				std::cout << static_cast<int>(cells[x][y]) << ' ';
			}
		}
		std::cout << '\n';
	}
}
