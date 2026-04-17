Describe 'aws-rds-create-instance.sh'

  # INFO: Prevent the external resources execution
  DRY_RUN=1

  Include './aws-rds-create-instance.sh'

  It 'test secrets fetch with expired login'
    export AWS_STUB_EXPIRED=1
    When call rds_master_username
    The stderr should equal "
Your session has expired. Please reauthenticate using 'aws login'."
    
    The status should be failure
  End

  It 'can get secret username'
    export AWS_STUB_SECRET='{\"username\":\"Foobar\", \"password\":\"T3aP07\" }'
		
    When call rds_master_username
    The output should equal "Foobar"
    The status should be success
    The stderr should eq ''
  End

  It 'can get secret password'
    export AWS_STUB_SECRET='{\"username\":\"Foobar\", \"password\":\"T3aP07\" }'
		
    When call rds_master_password
    The output should equal "T3aP07"
    The status should be success
    The stderr should eq ''
  End

End

Describe 'aws stub'
  # TODO: Made this work on bash (Only works on Zsh)
  It 'should return expected output'
    When call aws --region sa-east-1 secretsmanager get-secret-value --secret-id foo/bar/barz

    # INFO: Weird indentation by doesnt know how to "prettify this" without
    # broken the real value (Heredoc strings doesnt work on this with bash
    # cases)
    The output should equal '{
  "SecretString": "{\"username\":\"foo\", \"password\":\"teapot\" }"
}'

    The status should be success
  End

  It 'should executes jq correctly'

    # Necessary for not fail
    testing_command() {
      echo '{"foo": "bar"}' | jq .
    }

    When call testing_command

    The output should eq "`cat <<-EOL
		{
		  "foo": "bar"
		}
		EOL
    `"

    The status should be success

  End

  It 'should have a specific treatment using `jq`'
  
    aws_command_with_jq() {
      aws --region sa-east-1 secretsmanager get-secret-value --secret-id iam/a/teapot | jq .SecretString
    }

    When call aws_command_with_jq

    The output should eq '"{\"username\":\"foo\", \"password\":\"teapot\" }"'
  End
End

