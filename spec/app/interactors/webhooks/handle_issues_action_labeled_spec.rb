require 'spec_helper'

module Webhooks
  RSpec.describe HandleIssuesActionLabeled do
    let(:issue) { File.read('./spec/fixtures/github/issue.json') }
    let(:id) { issue['number'] }
    let(:repo_full_name) { 'octocat/Hello-World' }
    let(:payload) { { 'issue' => issue, 'label' => { 'name' => label } } }
    let(:access_token) { 'token' }

    describe '#call' do
      context 'when ready for review' do
        let(:label) { Constants::READY_FOR_REVIEW }

        specify do
          expect(RemoveLabel).to receive(:call!).with(
            id: id,
            label: Constants::IN_PROGRESS,
            repo_full_name: repo_full_name,
            access_token: access_token
          )

          described_class.call!(payload: payload, repo_full_name: repo_full_name, access_token: access_token)
        end
      end

      context 'when review requested' do
        let(:label) { Constants::REVIEW_REQUESTED }

        specify do
          expect(RemoveLabel).to receive(:call!).with(
            id: id,
            label: Constants::IN_PROGRESS,
            repo_full_name: repo_full_name,
            access_token: access_token
          )

          expect(AddLabelToAnIssue).to receive(:call!).with(
            id: id,
            label: Constants::READY_FOR_REVIEW,
            repo_full_name: repo_full_name,
            access_token: access_token
          )

          described_class.call!(payload: payload, repo_full_name: repo_full_name, access_token: access_token)
        end
      end

      context 'when rejected' do
        let(:label) { Constants::REJECTED }

        specify do
          expect(RemoveLabel).to receive(:call!).with(
            id: id,
            label: [Constants::IN_PROGRESS, Constants::READY_FOR_REVIEW],
            repo_full_name: repo_full_name,
            access_token: access_token
          )

          described_class.call!(payload: payload, repo_full_name: repo_full_name, access_token: access_token)
        end
      end
    end
  end
end
