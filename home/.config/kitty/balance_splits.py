#!/usr/bin/env python


def main(args):
    pass


def _count_leaves(node):
    from kitty.layout.splits import Pair

    if isinstance(node, Pair):
        return _count_leaves(node.one) + _count_leaves(node.two)
    return 1


def _equalize(pair):
    from kitty.layout.splits import Pair

    left = _count_leaves(pair.one)
    right = _count_leaves(pair.two)
    pair.bias = left / (left + right)

    if isinstance(pair.one, Pair):
        _equalize(pair.one)
    if isinstance(pair.two, Pair):
        _equalize(pair.two)


def handle_result(args, answer, target_window_id, boss):
    tab = boss.active_tab
    if tab is None:
        return
    if tab.current_layout.name != "splits":
        return
    root = tab.current_layout.pairs_root
    _equalize(root)
    tab.relayout()


handle_result.no_ui = True
