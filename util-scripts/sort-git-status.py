#!/usr/bin/env python3

import sys
import re


def make_order_dict() -> dict[str, int]:
    order = {"##": 0}
    statuses = ["M", "A", "C", "R", "D", "U"]

    for (i, s) in enumerate(statuses):
        order[f"{s} "] = i + 1
        order[f" {s}"] = i + 1 + len(statuses)

    for s1 in statuses:
        for s2 in statuses:
            order[f"{s2}{s1}"] = len(order)

    order["??"] = len(order)

    return order


order = make_order_dict()
ansi_re = re.compile(r"\x1b[^m]*m")

print(
    "".join(
        sorted(
            sys.stdin.readlines(),
            key=lambda line: order.get(
                ansi_re.sub("", line)[0:2],
                0,
            ),
        )
    )
)
