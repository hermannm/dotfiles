#!/usr/bin/env python3

import sys
import re


def make_order_dict() -> dict[str, int]:
    order = {"##": 0}
    statuses = ["M", "A", "C", "R", "D", "U"]
    status_len = len(statuses)

    for (i, s) in enumerate(statuses):
        order[f"{s} "] = i + 1
        order[f" {s}"] = i + 1 + status_len

        for (j, s2) in enumerate(statuses):
            order[f"{s2}{s}"] = (i + 2) * status_len + j + 1

    order["??"] = (2 + status_len) * status_len + 2

    return order


order = make_order_dict()
ansi_re = re.compile(r"\x1b[^m]*m")

print("".join(sorted(sys.stdin.readlines(), key=lambda line: order.get(ansi_re.sub("", line)[0:2], 0))), end="")
