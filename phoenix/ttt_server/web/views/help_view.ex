defmodule TttServer.HelpView do
  def helptext do
    """
    CMD=DESTROY                       -   Invalidate Session
    CMD=HELP                          -   Show this help text
    CMD=SET&coordinate=c&value=[xo]   -   Set 'value' ('x' or 'o') to field with coordinates [A-C][1-3]
    CMD=SHOW                          -   Show board
    CMD=BOARD                         -   Show a nice ASCII board
    CMD=RESET                         -   Reset board
    """
  end
end
