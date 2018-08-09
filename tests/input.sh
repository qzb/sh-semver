describe 'Command input'
    RET=$(echo 4.0.0 4.2.1 5.0.0 | ./semver.sh -r '^4.0.0')
    assert "$RET" "4.0.0\\n4.2.1" 'should accept versions on STDIN'

describe 'When not given a rule'
    RET=$(./semver.sh 4.2.1 4.0.0 3.1.2 5.0.0)
    assert "$RET" "3.1.2\\n4.0.0\\n4.2.1\\n5.0.0" 'should sort versions'

    RET=$(echo 4.2.1 4.0.0 3.1.2 5.0.0 | ./semver.sh)
    assert "$RET" "3.1.2\\n4.0.0\\n4.2.1\\n5.0.0" 'should sort versions from STDIN'
