# shellcheck shell=bash

Describe 'providers.sh pi support'
  Include "$LIB_DIR/providers.sh"

  Describe 'get_provider_info()'
    It 'returns info for pi'
      When call get_provider_info "pi"
      The output should include "Pi Coding Agent"
    End

    It 'returns info for pi with model'
      When call get_provider_info "pi:openai-codex/gpt-5.5:high"
      The output should include "Pi Coding Agent"
      The output should include "model: openai-codex/gpt-5.5:high"
    End
  End

  Describe 'execute_pi() - prompt via stdin, never argv'
    # Mock pi: print the argv it received, then whatever arrived on stdin.
    pi() {
      printf 'ARGS:[%s]\n' "$*"
      printf 'STDIN:[%s]\n' "$(cat)"
    }

    It 'sends the prompt on stdin and keeps it out of argv (with model)'
      When call execute_pi "openai-codex/gpt-5.5:high" "REVIEW_NEEDLE diff body"
      The line 1 of output should equal 'ARGS:[--model openai-codex/gpt-5.5:high -p]'
      The output should include 'STDIN:[REVIEW_NEEDLE diff body]'
    End

    It 'sends the prompt on stdin with no model'
      When call execute_pi "" "REVIEW_NEEDLE diff body"
      The line 1 of output should equal 'ARGS:[-p]'
      The output should include 'STDIN:[REVIEW_NEEDLE diff body]'
    End

    It 'delivers a large prompt fully via stdin (the E2BIG regression)'
      large_prompt="$(printf 'x%.0s' {1..50000})ENDNEEDLE"
      When call execute_pi "m" "$large_prompt"
      The line 1 of output should equal 'ARGS:[--model m -p]'
      The output should include 'ENDNEEDLE'
    End
  End

  Describe 'execute_provider_with_timeout() - pi never passes the prompt via argv'
    # Mock the timeout wrapper to capture exactly the argv it would exec.
    execute_with_timeout() {
      printf 'TWARGS:[%s]\n' "$*"
    }

    It 'routes the prompt through a temp file, not the command line (avoids E2BIG)'
      When call execute_provider_with_timeout "pi:openai-codex/gpt-5.5:high" "BIG_NEEDLE_PROMPT" 5
      The output should not include "BIG_NEEDLE_PROMPT"
      The output should include "gga_pi_prompt"
      The output should include "openai-codex/gpt-5.5:high"
    End

    It 'works with no model'
      When call execute_provider_with_timeout "pi" "BIG_NEEDLE_PROMPT" 5
      The output should not include "BIG_NEEDLE_PROMPT"
      The output should include "gga_pi_prompt"
    End
  End

  Describe 'validate_provider() - pi'
    It 'succeeds when pi CLI is available'
      pi() { return 0; }
      When call validate_provider "pi"
      The status should be success
    End
  End
End
