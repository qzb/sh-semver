describe 'Command output (printing)'
    RET=$(./semver.sh -r '^4.0.0' 4.0.0 4.2.1 | tail -1)
    assert "$RET" "4.2.1" '"\\n" should be printed as newlines'
