Object subclass: Minishell [
  | input |

  Minishell class >> input: anInput [
    ^self new input: anInput; yourself
  ]

  input [ ^input ]
  input: anInput [ input := anInput ]

  start [
    true while: [
      input nextLine displayNl
    ]
  ]
]
