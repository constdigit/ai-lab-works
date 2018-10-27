#pragma once

#include "board.h"

uint16_t wrong_placed(const board& node);
uint16_t manhattan_distance(const board& node);
void a_star_search(const board& begin);
