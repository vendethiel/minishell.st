Object subclass: Shell [
  ls: args [ CommandLs new run: args ]
  pwd: args [ CommandPwd new run: args ]
  cd: args [ CommandCd new run: args ]
]

Object subclass: Command [
]

Command subclass: CommandCd [
  run: args [
    "TODO: 'assertSize'0..1??"
    "TODO `cd -`... But maybe `command` instances need to be stored/registered so they can store instance variables. how many commands need that anyway?"
    Directory working: (args at: 1)
  ]
]

Command subclass: CommandPwd [
  run: args [
    "TODO: assertSize'0'?"
    "TODO check dir exists"
    Directory working displayNl
  ]
]

"TODO move to another directory"
Command subclass: CommandLs [
  run: args [
    "TODO I'd really like better a switch-like thing (like satyr's original `match` proposed for prelude-ls)"
    (args isEmpty
      ifTrue: [ self listDirectory: Directory working ]
      ifFalse: [
        args size = 1
          ifTrue: [ self listDirectory: (File path: args first) ]
          ifFalse: [ self listDirectories: args ]
      ])
  ]

  listDirectory: dir [
    "TODO: check if directory exists"
    | entry |

    dir name displayNl.
    dir namesDo: [ :f |
      (f startsWith: '.') ifFalse: [ f displayNl ]
    ].
  ]

  listDirectories: dirs [
    "TODO write this as doc:"
    "Prints a list of directories, each with their name prior"
    "XXX: might need to check here that the dir exists as well..."
    dirs do: [ :dir |
      (dir, ':') displayNl.
      self listDirectory: (File path: dir)
    ] separatedBy: [ '' displayNl ]
  ]
]
