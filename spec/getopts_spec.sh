setup() {
  TEMP_DIR="$(mktemp -d)" || exit
  cd $TEMP_DIR
}

teardown() {
  rm -rf $TEMP_DIR
}

Describe 'getopts use'

  Before setup
  After teardown

  It 'can get a help long option'

    cat <<-"EOL" > ./foobar.sh
		#!/usr/bin/env bash
		args="$(echo ${@})"
		echo $args
		EOL

		chmod +x ./foobar.sh

		When call ./foobar.sh --foo

		The output should eq '--foo'

  End

End

Describe 'getopt use'

  Before setup
  After teardown

  It 'can parse options'
    cat <<-"EOL" > ./foobar.sh
		#!/usr/bin/env bash
		OPTS=$(getopt -l name: -n 'parse-options' -- "$@")

		echo $OPTS

		if [ $? -ne 0 ]; then
		  echo "Failed parsing options." >&2
		  exit 1
		fi

		eval set -- "$OPTS"

		while true; do
		  case "$1" in
		    --name) NAME="$2"; shift ;;
		    *) echo "Error: unknown option $1" >&2; exit 1 ;;
		  esac
		done

		echo ${NAME:+is not set}

		EOL

		chmod +x ./foobar.sh

		When call ./foobar.sh --name

		# The output should eq "false"
		The stderr should eq 'Failed parsing options.'

  End

End

Describe 'embeeded text'
  It 'outputs texts'

    output() {
      echo 'start'
      %text
      #|aaa
		  #|bbb
		  #|ccc
      echo 'end'
    }

    result() { %text
      #|start
      #|aaa
      #|bbb
      #|ccc
      #|end
    }

    When call output

    The output should eq "$(result)"
    The line 3 of output should eq 'bbb'
  End
End
