require 'spec_helper'

module Webhooks
  RSpec.describe HandleIssuesActionClosed do
    let(:issue) { File.read('./spec/fixtures/github/issue.json') }
    let(:id) { issue['number'] }
    let(:repo_full_name) { 'octocat/Hello-World' }
    let(:payload) { { 'issue' => issue } }
    let(:access_token) { 'token' }

    describe '#call' do
      specify do
        expect(RemoveLabel).to receive(:call!).with(
          id: id,
          label: [Constants::IN_PROGRESS, Constants::READY_FOR_REVIEW, Constants::REVIEW_REQUESTED],
          repo_full_name: repo_full_name,
          access_token: access_token
        )

        described_class.call!(payload: payload, repo_full_name: repo_full_name, access_token: access_token)
      end
    end
  end
end
