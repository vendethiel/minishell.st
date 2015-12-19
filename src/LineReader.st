Object subclass: LineReader [
  | input dispatcher prompt |

  LineReader class >> input: input dispatcher: dispatcher [
    ^self new input: input; 
              dispatcher: dispatcher;
              prompt: '> ';
              yourself
  ]

  input [ ^input ]
  input: anInput [ input := anInput ]

  prompt [ ^prompt ]
  prompt: aPrompt [ prompt := aPrompt ]

  dispatcher [ ^dispatcher ]
  dispatcher: aDispatcher [ dispatcher := aDispatcher ]

  start [
    [ |line|
      prompt display.
      line := input nextLine.
      line isNil ifTrue: [ ^nil ].
      self runCommand: line
    ] repeat.
  ]

  runCommand: aCommand [
    | commandParts commandName |

    "TODO use our own 'substrings' that does shell-like splitting, redirections, and variables"
    commandParts := aCommand subStrings: ' '.
    commandName := ((commandParts at: 1), ':') asSymbol.
    (self dispatcher respondsTo: commandName)
      ifTrue: [
        ^[self dispatcher
          perform: commandName
          with: (commandParts copyFrom: 2 "skip the command name")
        ] on: CommandError do: [ :sig |
          ('Error: ', sig messageText) displayNl
        ]
      ]
      ifFalse: [
        'command not recognized' displayNl
      ]
  ]
]
