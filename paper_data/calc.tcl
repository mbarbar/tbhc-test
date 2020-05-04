#!/usr/bin/tclsh8.6

if {$argc != 2} {
    puts "usage: $argv0 RESULTS_DIR #RUNS"
    exit 1
}

set results_dir [lindex $argv 0]
set runs [lindex $argv 1]
puts "$results_dir ($runs runs)"

set files [glob -directory $results_dir {*.svf}]

set times   [dict create]
set aliases [dict create]

foreach fname $files {
    set matched [regexp {([a-zA-Z0-9-]*\.bc)} $fname benchmark]
    dict set aliases $benchmark "alias data not found"
    if {!$matched} {
        puts "Unexpected filename: $fname"
        exit 1
    }

    set f [open $fname r]
    set lines [split [read $f] "\n"]
    close $f

    # We are only interested in the third TotalTime which is for
    # the flow-sensitive analysis
    set nth_totaltime 0
    foreach line $lines {
        set matched [regexp {TotalTime  *([0-9.]+)} $line full totaltime]
        if {$matched} {
            incr nth_totaltime
            if {$nth_totaltime == 3} {
                set old_time 0
                if {[dict exists $times $benchmark]} {
                    set old_time [dict get $times $benchmark]
                }

                dict set times $benchmark [expr $old_time + $totaltime]
            }
        }

        set matched [regexp {eval-ctir-aliases ([0-9]+) [0-9]+ ([0-9]+)} $line full queries no_aliases]
        if {$matched} {
            dict set aliases $benchmark [format "%d %d %5f" $queries $no_aliases [expr double($no_aliases) / $queries]]
        }
    }
}

dict for {benchmark t} $times {
    set alias_results [dict get $aliases $benchmark]
    puts [format "%20s : %12s - %s" $benchmark [format "%5f" [expr double($t) / $runs]] $alias_results]
}

