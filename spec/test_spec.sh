Describe 'test.sh'
  It  'just testing'
    When call echo foo bar
    The output should eq 'foo bar'
  End
End

