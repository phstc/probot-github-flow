require 'spec_helper'

module Webhooks
  RSpec.describe HandleIssuesActionLabeled do
    let(:issue) { File.read('./spec/fixtures/github/issue.json') }
    let(:number) { issue['number'] }
    let(:repo_full_name) { 'octocat/Hello-World' }
    let(:payload) { { 'issue' => issue, 'label' => { 'name' => label } } }
    let(:access_token) { 'token' }

    describe '#call' do
      context 'when ready for review' do
        let(:label) { Constants::READY_FOR_REVIEW }

        specify do
          expect(RemoveLabel).to receive(:call!).with(
            number: number,
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
            number: number,
            label: Constants::IN_PROGRESS,
            repo_full_name: repo_full_name,
            access_token: access_token
          )

          expect(AddLabelsToAnIssue).to receive(:call!).with(
            number: number,
            labels: [Constants::READY_FOR_REVIEW],
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
            number: number,
            label: Constants::IN_PROGRESS,
            repo_full_name: repo_full_name,
            access_token: access_token
          )

          expect(RemoveLabel).to receive(:call!).with(
            number: number,
            label: Constants::READY_FOR_REVIEW,
            repo_full_name: repo_full_name,
            access_token: access_token
          )

          described_class.call!(payload: payload, repo_full_name: repo_full_name, access_token: access_token)
        end
      end
    end
  end
end
