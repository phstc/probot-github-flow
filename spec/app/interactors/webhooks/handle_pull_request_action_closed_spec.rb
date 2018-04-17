require 'rails_helper'

module Webhooks
  RSpec.describe HandlePullRequestActionClosed do
    let(:payload) { { 'pull_request' => { 'body' => body } } }
    let(:body) { 'Closes #123' }
    let(:number) { 'number' }
    let(:repo_full_name) { 'octocat/Hello-World' }
    let(:access_token) { 'token' }

    describe '#call' do
      it 'test me'
    end
  end
end
