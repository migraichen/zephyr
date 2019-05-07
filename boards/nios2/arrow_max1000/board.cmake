# SPDX-License-Identifier: Apache-2.0

board_runner_args(nios2 "--cpu-sof=${ZEPHYR_BASE}/soc/nios2/nios2e-zephyr/cpu/nios2e_zephyr.sof")
include(${ZEPHYR_BASE}/boards/common/nios2.board.cmake)
