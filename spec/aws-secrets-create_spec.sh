Describe 'aws-secrets-create.sh'

  # INFO: Prevent risky function execution
  DRY_RUN=1

  Include './aws-secrets-create.sh'

  xIt 'returns error without --name parameter'
    When call create_ghcr_secret

    # WARN: Beware the Heredoc indentation. It's using tabs instead spaces,
    # otherwise it should break the string
    The stderr should equal "`cat <<-EOL
		aws: [ERROR]: An error occurred (ParamValidation): the following arguments are required: --name
		
		usage: aws [options] <command> <subcommand> [<subcommand> ...] [parameters]
		To see help text, you can run:
		
		  aws help
		  aws <command> help
		  aws <command> <subcommand> help
		EOL`"

		The status should be failure
	End

  xIt 'test execution with expired login'
    export AWS_STUB_EXPIRED=1
    When call create_ghcr_secret

    # INFO: Below line with `<<-EOL`, it's using tabs instead spaces
    The stderr should equal "`cat <<-EOL

		Your session has expired. Please reauthenticate using 'aws login'.
		EOL
    `"

    The status should be failure
  End
End

Describe 'aws stub'

  It 'can run stub list secrets'
    When call aws --region sa-east-1 secretsmanager list-secrets

    expected() { %text
      #|{
      #|    "SecretList": []
      #|}
    }

    The output should eq "`expected`"
  End
End

