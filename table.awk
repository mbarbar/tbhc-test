#!/usr/bin/nawk -f

# Round to two decimal places.
function f2(n) {
    return sprintf("%.2f", n)
}

# Calculate nth root of x.
function nthroot(x, n) {
    return x ** (1.0 / n)
}

# Splits xs on "," and calculates their geometric mean
function geomean(xs) {
    n = split(xs, x, ",")
    prod = 1
    for (i in x) {
        if (!x[i]) continue
        prod *= x[i]
    }

    return nthroot(prod, n)
}

# Calculates percentage improvement from f to t.
function pcimprov(f, t) {
    return ((t - f) / f) * 100
}

BEGIN {
    # Because time differs for fspta alias/time but not for
    # fstbhc since alias testing requires full SVFG. fspta
    # does not require full SVFG for normal solving whereas
    # fstbhc does.
    Fspta_time = "fspta-time"
    Fspta_alias = "fspta-alias"
    Fstbhc = "fstbhc"
    Fstbhc_reuse = "fstbhc-reuse"

    Time = "time"
    Obj = "obj"
    Alias_total = "alias-total"
    Alias_no = "alias-no"

    # Same order as in paper.
    Benchmarks_n = split("du.bc date.bc touch.bc ptx.bc csplit.bc expr.bc "\
                         "tac.bc nl.bc mv.bc ls.bc ginstall.bc sort.bc", Benchmarks, " ")

    output_type = "none"
}

FNR == 1 {
    time_field_count = 0
    obj_field_count = 0

    matches = match(FILENAME, /[a-z]+\.bc\.svf/)
    if (!matches) {
        nextfile
    }

    benchmark = substr(FILENAME, RSTART, RLENGTH-4)

    type = $1
}

# For all analysis types.
/TotalTime/ {
    time_field_count++
    # First two "TotalTime" fields are not for flow-sensitive analysis.
    if (time_field_count != 3) {
        next
    }

    stats[benchmark,type,Time] = $2
}

# For all analysis types, but will be overwritten by fstbhc ("Total:").
/TotalObjects/ {
    obj_field_count++;
    # First obj_field_count is for the pre-analysis.
    if (obj_field_count != 2) {
        next
    }

    # No clones for FSPTA.
    stats[benchmark,type,Obj] = $2
}

# Only available in fstbhc.
/Total:/ {
    # $3 has an opening parenthesis already.
    stats[benchmark,type,Obj] = $2 " " $3 ")"
}

# Total number of alias queries.
/TOTAL +:/ {
    stats[benchmark,type,Alias_total] = $3
}

# Total number of no-alias results.
/NO +:/ {
    stats[benchmark,type,Alias_no] = $3
}

function output_time_line() {
    print " + ----------- + ---------------- + --------------------------------- + --------------------------------- +"
}

function output_time() {
    print "    Table 3: TIME"
    output_time_line()
    printf " | %11s | %16s | %33s | %33s |\n",
           "Bench.", "Sparse", "TypeClone", "TypeClone (reuse)"
    print " |             |           ------ |                         --------- |                 ----------------- |"
    printf " | %11s | %10s %5s | %10s %9s %12s | %10s %9s %12s |\n",
           "",
           "Time", "Obj.",
           "Time", "Diff.", "Obj. (cln)",
           "Time", "Diff.", "Obj. (cln)"
    output_time_line()

    fstbhc_diffs = ""
    fstbhc_reuse_diffs = ""
    for (i = 1; i <= Benchmarks_n; i++) {
        bench = Benchmarks[i]

        fspta_time = stats[bench,Fspta_time,Time]
        fstbhc_time = stats[bench,Fstbhc,Time]
        fstbhc_reuse_time = stats[bench,Fstbhc_reuse,Time]

        fstbhc_diff = fstbhc_time / fspta_time
        fstbhc_reuse_diff = fstbhc_reuse_time / fspta_time

        fstbhc_diffs = fstbhc_diffs "," fstbhc_diff
        fstbhc_reuse_diffs = fstbhc_reuse_diffs "," fstbhc_reuse_diff

        printf " | %11s | %10s %5s | %10s %9s %12s | %10s %9s %12s |\n",
               bench,
               f2(fspta_time) "s", stats[bench,Fspta_time,Obj],
               f2(fstbhc_time) "s", f2(fstbhc_diff) "x", stats[bench,Fstbhc,Obj],
               f2(fstbhc_reuse_time) "s", f2(fstbhc_reuse_diff) "x", stats[bench,Fstbhc_reuse,Obj]
    }

    # There's an extra "," in diffs at the start ("" "," "first_diff").
    fstbhc_diffs = substr(fstbhc_diffs, 2)
    fstbhc_reuse_diffs = substr(fstbhc_reuse_diffs, 2)

    output_time_line()
    printf " | %11s | %10s %5s | %10s %9s %12s | %10s %9s %12s |\n",
           "Average",
           "", "",
           "", f2(geomean(fstbhc_diffs)) "x", "",
           "", f2(geomean(fstbhc_reuse_diffs)) "x", ""
    output_time_line()
}

function output_alias_line() {
    print " + ----------- + ----------- + ----------- + -------------------- + -------------------- +"
}

function output_alias() {
    print "    Table 4: ALIASES"
    output_alias_line()
    printf " | %11s | %11s | %11s | %20s | %20s |\n",
           "Bench.", "Queries", "Sparse", "TypeClone", "TypeClone (reuse)"
    print " |             |             |      ------ |            --------- |    ----------------- |"
    printf " | %11s | %11s | %11s | %11s %8s | %11s %8s |\n",
           "",
           "",
           "No-alias",
           "No-alias", "Improv.",
           "No-alias", "Improv."
    output_alias_line()
    for (i = 1; i <= Benchmarks_n; i++) {
        bench = Benchmarks[i]

        total = stats[bench,Fspta_alias,Alias_total]

        fspta_no_alias = stats[bench,Fspta_alias,Alias_no]
        fstbhc_no_alias = stats[bench,Fstbhc,Alias_no]
        fstbhc_reuse_no_alias = stats[bench,Fstbhc_reuse,Alias_no]

        fstbhc_improv = pcimprov(fspta_no_alias, fstbhc_no_alias)
        fstbhc_reuse_improv = pcimprov(fspta_no_alias, fstbhc_reuse_no_alias)

        fstbhc_improvs = fstbhc_improvs "," fstbhc_improv
        fstbhc_reuse_improvs = fstbhc_reuse_improvs "," fstbhc_reuse_improv

        printf " | %11s | %11s | %11s | %11s %8s | %11s %8s |\n",
               bench,
               total,
               fspta_no_alias,
               fstbhc_no_alias, f2(fstbhc_improv) "%",
               fstbhc_reuse_no_alias, f2(fstbhc_reuse_improv) "%"
    }

    fstbhc_improvs = substr(fstbhc_improvs, 2)
    fstbhc_reuse_improvs = substr(fstbhc_reuse_improvs, 2)

    output_alias_line()
    printf " | %11s | %11s | %11s | %11s %8s | %11s %8s |\n",
           "Average",
           "",
           "",
           "", f2(geomean(fstbhc_improvs)) "%",
           "", f2(geomean(fstbhc_reuse_improvs)) "%"
    output_alias_line()
}

END {
    output_time()
    print ""
    output_alias()
}
