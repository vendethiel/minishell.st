Object subclass: Shell [
  ls: args [ CommandLs new run: args ]
]

Object subclass: Command [
]

"TODO move to another directory"
Command subclass: CommandLs [
  run: args [
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
