PackageLoader fileInPackage: #Minishell.

Exception subclass: InterruptException [
]

[
  (Minishell.LineReader input: stdin dispatcher: Minishell.Shell new)
    start.
] on: SystemExceptions.UserInterrupt do: [ '' displayNl ]
  on: InterruptException do: []
