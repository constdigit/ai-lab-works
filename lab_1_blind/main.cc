#include <iostream>
#include <cstring>

#include "board.h"
#include "search.h"

constexpr uint8_t BFS_SEARCH = 1;
constexpr uint8_t DFS_SEARCH = 2;

int main(int argc, char* argv[]) {
	// obtaion search method
	uint8_t search_method{0};
	size_t max_depth{0};
	if (strcmp(argv[1], "bfs") == 0) {
		search_method = BFS_SEARCH;
	} else if (std::strcmp(argv[1], "dfs") == 0) {
		search_method = DFS_SEARCH;
		max_depth = std::stoul(argv[2]);
	}

	uint8_t begin[3][3] =
		{{5, 8, 3},
		{4, 0, 2},
		{7, 6, 1}};
		// uint8_t begin[3][3] =
		// 	{{7, 4, 2},
		// 	{3, 5, 8},
		// 	{6, 0, 1}};
	board begin_board(begin, 0);

	uint8_t goal[3][3] =
		{{1, 2, 3},
		{4, 5, 6},
		{7, 8, 0}};
	// uint8_t goal[3][3] =
	// 	{{1, 2, 3},
	// 	{4, 0, 5},
	// 	{6, 7, 8}};
	board goal_board(goal, 0);

	switch (search_method) {
		case BFS_SEARCH :
			breadth_first_search(begin_board, goal_board);
			break;
		case DFS_SEARCH :
			depth_first_search(begin_board, goal_board, max_depth);
			break;
		default:
			std::cerr << "unknown methond" << std::endl;
	}
	return 0;
}
