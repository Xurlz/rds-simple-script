Describe 'getopts use'
  setup() {
    TEMP_DIR="$(mktemp -d)" || exit
  }

  teardown() {
    rm -rf $TEMP_DIR
  }

  Before setup
  After teardown

  It 'can get a help long option'
    cd $TEMP_DIR

    cat <<-"EOL" > ./foobar.sh
		#!/usr/bin/env bash
		args="$(echo ${@})"
		echo $args
		echo self inducing error -- Ive stopped here
		EOL

		chmod +x ./foobar.sh

		When call ./foobar.sh --foo

		The output should eq '--foo'
    
  End
End
