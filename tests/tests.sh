describe 'get_number'
    RET=$(get_number '1.2.3-a-b-3.2.1+meta')
    assert "$RET" "1.2.3"

    RET=$(get_number '1-1.2.3')
    assert "$RET" "1"

describe 'get_prerelease'
    RET=$(get_prerelease '1.2.3-a-b-3.2.1+meta')
    assert "$RET" "a-b-3.2.1"

describe 'strip_metadata'
    RET=$(strip_metadata '1.2.3-a-b-3.2.1+meta')
    assert "$RET" "1.2.3-a-b-3.2.1"

describe 'get_major'
    RET=$(get_major 1.2.3)
    assert "$RET" "1"

describe 'get_minor'
    RET=$(get_minor 1.2.3)
    assert "$RET" "2"

    RET=$(get_minor 1)
    assert "$RET" ""

describe 'get_bugfix'
    RET=$(get_bugfix 1.2.3)
    assert "$RET" "3"

    RET=$(get_bugfix 1.2)
    assert "$RET" ""

    RET=$(get_bugfix 1)
    assert "$RET" ""

describe 'semver_eq'
    semver_eq 1.2.3 1.2.3
    assert $? 0

    semver_eq 1.2.3 1.2.4
    assert $? 1

    semver_eq 1.2.3 1.2
    assert $? 0

    semver_eq 1.2.3 1
    assert $? 0

    semver_eq 2.2 1
    assert $? 1

describe 'semver_lt'
    assert_lt()
    {
        local msg="$1 < $2 => $3"
        semver_lt $1 $2
        assert $? $3 "$msg"
    }

    assert_lt 1.2.2 1.2.3 0
    assert_lt 1.2.3 1.2.3 1
    assert_lt 1.2.4 1.2.3 1
    assert_lt 1.0.0-alpha 1.0.0-alpha.1 0
    assert_lt 1.0.0-alpha.1 1.0.0-alpha 1
    assert_lt 1.0.0-alpha.1 1.0.0-alpha.beta 0
    assert_lt 1.0.0-alpha.beta 1.0.0-alpha.1 1
    assert_lt 1.0.0-alpha.beta 1.0.0-beta 0
    assert_lt 1.0.0-beta 1.0.0-alpha.beta 1
    assert_lt 1.0.0-beta 1.0.0-beta.2 0
    assert_lt 1.0.0-beta.2 1.0.0-beta 1
    assert_lt 1.0.0-beta.2 1.0.0-beta.11 0
    assert_lt 1.0.0-beta.11 1.0.0-beta.2 1
    assert_lt 1.0.0-beta.11 1.0.0-rc.1 0
    assert_lt 1.0.0-rc.1 1.0.0-beta.11 1
    assert_lt 1.0.0-rc.1 1.0.0 0
    assert_lt 1.0.0 1.0.0-rc.1 1

describe 'semver_le'
    semver_le 1.2.2 1.2.3
    assert $? 0

    semver_le 1.2.3 1.2.3
    assert $? 0

    semver_le 1.2.4 1.2.3
    assert $? 1

describe 'semver_gt'
    semver_gt 1.2.2 1.2.3
    assert $? 1

    semver_gt 1.2.3 1.2.3
    assert $? 1

    semver_gt 1.2.4 1.2.3
    assert $? 0

describe 'semver_ge'
    semver_ge 1.2.2 1.2.3
    assert $? 1

    semver_ge 1.2.3 1.2.3
    assert $? 0

    semver_ge 1.2.4 1.2.3
    assert $? 0

describe 'semver_sort'
    RET=$(semver_sort)
    assert "$RET" "" "should return nothing when no arguments passed"

    RET=$(semver_sort 1.2.3)
    assert "$RET" "1.2.3" "should sort input - 1.2.3"

    RET=$(semver_sort 1.2.3 4.5.6 7.8.9)
    assert "$RET" "1.2.3 4.5.6 7.8.9" "should sort input - 1.2.3 4.5.6 7.8.9"

    RET=$(semver_sort 7.8.9 4.5.6 1.2.3)
    assert "$RET" "1.2.3 4.5.6 7.8.9" "should sort input - 1.2.3 4.5.6 7.8.9"

    RET=$(semver_sort 1 2 8 5 2 4 9 5 2 6 4 1 2 0 4 2 5 8 7 4 3)
    assert "$RET" "0 1 1 2 2 2 2 2 3 4 4 4 4 5 5 5 6 7 8 8 9" "should sort input - long input"

    RET=$(semver_sort v1.2.3)
    assert "$RET" "1.2.3" "should sort input - v1.2.3"

    RET=$(semver_sort v1.2.3 v4.5.6 v7.8.9)
    assert "$RET" "1.2.3 4.5.6 7.8.9" "should sort input - v1.2.3 v4.5.6 v7.8.9"

    RET=$(semver_sort v7.8.9 v4.5.6 v1.2.3)
    assert "$RET" "1.2.3 4.5.6 7.8.9" "should sort input - v1.2.3 v4.5.6 v7.8.9"

    RET=$(semver_sort 1 2 8 v5 2 4 9 5 v2 6 4 v1 2 0 4 v2 5 8 7 4 3)
    assert "$RET" "0 1 1 2 2 2 2 2 3 4 4 4 4 5 5 5 6 7 8 8 9" "should sort input - long input with some 'v' prefix"

describe 'regex_match'
    regex_match "1.22.333 - 1.2.3-3.2.1-a.b.c-def+011.a.1" "$RE_VER - $RE_VER"
    assert $? 0                                             "Exit code should be 0 when match"
    assert "$MATCHED_VER_1" "1.22.333"                      "Should set MATCHED_VER_1"
    assert "$MATCHED_VER_2" "1.2.3-3.2.1-a.b.c-def+011.a.1" "Should set MATCHED_VER_2"
    assert "$MATCHED_NUM_1" "1.22.333"                      "Should set MATCHED_NUM_1"
    assert "$MATCHED_NUM_2" "1.2.3"                         "Should set MATCHED_NUM_2"

    regex_match '1.2.3 - 5.6.7' '5.6.7'
    assert $? 1                                             "Exit code should be 1 when don't match"
    assert "$MATCHED_VER_1" ""                              "When don't match MATCHED_VER_x should be empty"
    assert "$MATCHED_VER_1" ""                              "When don't match MATCHED_NUM_x should be empty"

describe 'resolve_rules'
    RET=$(resolve_rules 'v1.2.3')
    assert "$RET" "eq 1.2.3"                                "Specific (v1.2.3)"

    RET=$(resolve_rules '=1.2.3')
    assert "$RET" "eq 1.2.3"                                "Specific (=1.2.3)"

    RET=$(resolve_rules '1')
    assert "$RET" "eq 1"                                    "Specific (1)"

    RET=$(resolve_rules '=1.2.3-a.2-c')
    assert "$RET" "eq 1.2.3-a.2-c"                          "Specific (=1.2.3-a.2-c)"

    RET=$(resolve_rules '=1.2.3-a.2+meta')
    assert "$RET" "eq 1.2.3-a.2+meta"                       "Specific (=1.2.3-a.2+meta)"

    RET=$(resolve_rules '=1.2.3-a.2+meta.data')
    assert "$RET" "eq 1.2.3-a.2+meta.data"                  "Specific (=1.2.3-a.2+meta.data)"

    RET=$(resolve_rules '>1.2.3')
    assert "$RET" "gt 1.2.3"                                "Greater than (>1.2.3)"

    RET=$(resolve_rules '<1.2.3')
    assert "$RET" "lt 1.2.3"                                "Less than (<1.2.3)"

    RET=$(resolve_rules '>=1.2.3')
    assert "$RET" "ge 1.2.3"                                "Greater than or equal to (>=1.2.3)"

    RET=$(resolve_rules '<=1.2.3')
    assert "$RET" "le 1.2.3"                                "Less than or equal to (<=1.2.3)"

    RET=$(resolve_rules '1.2.3 - 4.5.6')
    assert "$RET" "ge 1.2.3\nle 4.5.6"                      "Range (1.2.3 - 4.5.6)"

    RET=$(resolve_rules '>1.2.3 <4.5.6')
    assert "$RET" "gt 1.2.3\nlt 4.5.6"                      "Range (>1.2.3 <4.5.6)"

    RET=$(resolve_rules '>1.2.3 <=4.5.6')
    assert "$RET" "gt 1.2.3\nle 4.5.6"                      "Range (>1.2.3 <=4.5.6)"

    RET=$(resolve_rules '>=1.2.3 <4.5.6')
    assert "$RET" "ge 1.2.3\nlt 4.5.6"                      "Range (>=1.2.3 <4.5.6)"

    RET=$(resolve_rules '>=1.2.3 <=4.5.6')
    assert "$RET" "ge 1.2.3\nle 4.5.6"                      "Range (>=1.2.3 <=4.5.6)"

    RET=$(resolve_rules '~1.2.3')
    assert "$RET" "tilde 1.2.3"                             "Tilde (~1.2.3)"

    RET=$(resolve_rules '*')
    assert "$RET" "all"                                     "Wildcard (*)"

    RET=$(resolve_rules 'x')
    assert "$RET" "all"                                     "Wildcard (x)"

    RET=$(resolve_rules 'X')
    assert "$RET" "all"                                     "Wildcard (X)"

    RET=$(resolve_rules '1.2.x')
    assert "$RET" "eq 1.2"                                  "Wildcard (1.2.x)"

    RET=$(resolve_rules '1.2.*')
    assert "$RET" "eq 1.2"                                  "Wildcard (1.2.*)"

    RET=$(resolve_rules '1.*.*')
    assert "$RET" "eq 1"                                    "Wildcard (1.*.*)"

    RET=$(resolve_rules '=1.2.x')
    assert "$RET" "eq 1.2"                                  "Wildcard (=1.2.x)"

    RET=$(resolve_rules '=1.2.X')
    assert "$RET" "eq 1.2"                                  "Wildcard (=1.2.X)"

    RET=$(resolve_rules '=1.2.*')
    assert "$RET" "eq 1.2"                                  "Wildcard (=1.2.*)"

    RET=$(resolve_rules '=1.*.*')
    assert "$RET" "eq 1"                                    "Wildcard (=1.*.*)"

    RET=$(resolve_rules '*.*.*')
    assert "$RET" "all"                                     "Wildcard (*.*.*)"

    RET=$(resolve_rules '^1.2.3')
    assert "$RET" "caret 1.2.3"                             "Caret (^1.2.3)"

    RET=$(resolve_rules '~1.2.3 4.5.6_-_7.8.9 *')
    assert "$RET" "tilde 1.2.3
ge 4.5.6
le 7.8.9
all"                                                        "Tilde (~1.2.3) and Range (4.5.6 - 7.8.9) and Wildcard (*)"

describe 'normalize_rules'
    RET="$(normalize_rules '  \t  >	\t1.2.3.4-abc.def+a   \t	123.123   -\t\t\t  v5.3.2  ~ \tv5.5.* x ')"
    assert "$RET" '>1.2.3.4-abc.def+a 123.123_-_5.3.2 ~5.5 *'
