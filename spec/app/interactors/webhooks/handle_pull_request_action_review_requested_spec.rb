require 'spec_helper'

module Webhooks
  RSpec.describe HandlePullRequestReviewStateChangeRequested do
    let(:payload) { { 'pull_request' => { 'body' => body } } }
    let(:body) { 'Closes #123' }
    let(:number) { 'number' }
    let(:repo_full_name) { 'octocat/Hello-World' }
    let(:access_token) { 'token' }

    describe '#call' do
      specify do
        allow(Webhooks::FindFixableIssues).to receive(:call!).with(body: body).and_return(double(numbers: [number]))

        expect(AddLabelToAnIssue).to receive(:call!).with(
          repo_full_name: repo_full_name,
          number: number,
          label: Constants::REVIEW_REQUESTED,
          access_token: access_token
        )

        described_class.call!(payload: payload, repo_full_name: repo_full_name, access_token: access_token)
      end
    end
  end
end
