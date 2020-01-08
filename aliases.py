#!/usr/bin/python3

import sys
import statistics as stats

def process_aliases(aliases_argv, name):
    aliases_d = { }

    aliases_d["total"] = int(aliases_argv.split()[1])
    aliases_d["may-aliases"] = int(aliases_argv.split()[2])
    aliases_d["may-percent"] = aliases_d["may-aliases"] / aliases_d["total"]
    aliases_d["no-aliases"] = int(aliases_argv.split()[3])
    aliases_d["no-percent"] = aliases_d["no-aliases"] / aliases_d["total"]

    aliases_out = [ str(n) for n in [ aliases_d["total"],
                                      aliases_d["may-aliases"],
                                      aliases_d["may-percent"],
                                      aliases_d["no-aliases"],
                                      aliases_d["no-percent"] ]
             ]

    print("""\
    == {} ==
    total       = {}
    may-aliases = {}
    may-percent = {}
    no-aliases  = {}
    no-percent  = {}
    aliases_out = {}
    """.format(name, *(aliases_out + [" ".join(aliases_out)])))

if len(sys.argv) != 4:
    print("usage: {} fspta-aliases fstf-noreuse fstf-reuse".format(sys.argv[0]))
    sys.exit(1)

process_aliases(sys.argv[1], "FSPTA-ALIASES")
process_aliases(sys.argv[2], "FSTF-NOREUSE")
process_aliases(sys.argv[3], "FSTF-REUSE")
