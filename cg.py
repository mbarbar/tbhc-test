#!/usr/bin/python3

import sys
import statistics as stats

def process_cg(cg_argv, name):
    cgd = { }

    # Unique functions targeted.
    cgd["unique"] = int(cg_argv.split()[1])

    # Get eval line as a list of numbers.
    # [2:] to ignore leading "eval-indirect-calls" and unique count.
    cg = [int(n) for n in cg_argv.split()[2:]]

    # Calculate mean.
    cgd["mean"] = stats.mean(cg)

    # Calculate median.
    cgd["median"] = stats.median(cg)

    # Calculate number of single targets.
    cgd["single"] = cg.count(1)

    # Total number of call edges
    cgd["total"] = sum(cg)

    cg_out = [ str(n) for n in [ cgd["unique"],
                                 cgd["mean"],
                                 cgd["median"],
                                 cgd["single"],
                                 cgd["total"] ]
             ]

    print("""\
    == {} ==
    unique  = {}
    mean    = {}
    median  = {}
    single  = {}
    total   = {}
    cg_out  = {}
    """.format(name, *(cg_out + [" ".join(cg_out)])))

if len(sys.argv) != 3:
    print("usage: {} callgraph-1 callgraph-2", sys.argv[0])

process_cg(sys.argv[1], "CALL GRAPH 1")
process_cg(sys.argv[2], "CALL GRAPH 2")

