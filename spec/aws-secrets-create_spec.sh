Describe 'aws-secrets-create.sh'

  # INFO: Prevent risky function execution
  DRY_RUN=1

  Include './aws-secrets-create.sh'

  It 'test execution with expired login'
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
