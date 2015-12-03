tmux-safekill
=============

### Installation

Clone the repo:

    $ git clone https://github.com/Wildog/tmux-safekill ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    bind k run-shell ~/clone/path/safekill_session.tmux
    bind K run-shell ~/clone/path/safekill_server.tmux

Reload TMUX environment:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

### Usage

In tmux, use the command to kill a session:

    <prefix> k

And this command will kill the server safely:

    <prefix> K

The plugin will attempt to recursively end processes it knows about (right now: vim, man, less, mc, htop, bash, zsh, and ssh). It defaults to `Ctrl-C` for processes it doesn't know about. Ultimately, the session should have exited on its own after all child processes are gone.

Warning: this is kind of a big hammer. If you have any sensitive processes, make sure they are dealt with before running this :-)

### Changes made to the original tmux-safekill

1. Original tmux-safekill may kill other sessions you do not want to kill, this kills current session only.
2. Fix situations where panes of Vim and htop cannot be closed completely.
3. Add script to safely kill the server.

### License

[Apache 2](LICENSE)
