TttServer
====================

[Elixir](http://elixir-lang.org/) / [Phoenix](http://www.phoenixframework.org/) implementation of Gerd Aschemanns TicTacToe server

Original implementation (Groovy / Groovlet) [TicTacToe](https://github.com/ascheman/tictactoe)

Runtime environments
--------------------
You need a working Erlang / Elixir installation. Consult the [Elixir homepage](http://elixir-lang.org/install.html) for installation instructions.

Start
-----
After checking out the source code, get dependencies and compile with:

`mix deps.get`
`mix compile`

Then start the web application with:

`mix phoenix.start`

HTTP Get Requests
-----------------
Now you can connect your browser to [http://localhost:4000/tictactoe](http://localhost:4000/tictactoe) and see what happens.

The application understands a number of commands as HTTP Get Requests. Simply use the URL encoded `CMD` parameter, e.g. [http://localhost:4000/tictactoe?CMD=HELP](http://localhost:4000/tictactoe?CMD=HELP)

* `HELP`: Print the help text
* `RESET`: Start new Board
* `DESTROY`: Start new Session
* `SHOW`: Show the current Board
* `SET`: Set a stone to a field given by two additional parameters

* `coordinate`: One of A1, A2, A3, B1, B2, B3, C1, C2, C3
* `value`: Either x or o

e.g., [http://localhost:4000/tictactoe?CMD=SET&coordinate=A2&value=x](http://localhost:4000/tictactoe?CMD=SET&coordinate=A2&value=x)

Output formats
--------------
Per default the simple implementation returns a single line with the Board (only used fields with their contents) or an error or other status. Only for the `HELP` command you will see some more lines. If the optional parameter `FORMAT` is set to `HTML` the result is sent in very simple HTML code (please, don't validate!).

Session handling/Cookies
------------------------
The implementation makes use of a `_ttt_session` cookie to allow for multiple users to play a game on their own.

