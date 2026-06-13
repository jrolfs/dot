def main(args):
    # Runs in an overlay window, so it can read interactive input.
    try:
        return input("z ")
    except (EOFError, KeyboardInterrupt):
        return ""


def handle_result(args, answer, target_window_id, boss):
    query = answer.strip()
    if not query:
        return

    window = boss.window_id_map.get(target_window_id)
    boss.call_remote_control(
        window,
        (
            "launch",
            "--type=tab",
            "--add-to-session",
            ".",
            "--cwd=~",
            "/run/current-system/sw/bin/zsh",
            "--login",
            "-i",
            "-c",
            f"__zoxide_z {query}; exec zsh --login -i",
        ),
    )
