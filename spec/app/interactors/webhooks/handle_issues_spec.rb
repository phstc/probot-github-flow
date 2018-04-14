require 'spec_helper'

module Webhooks
  RSpec.describe HandleIssues do
    let(:issue) { File.read('./spec/fixtures/github/issue.json') }
    let(:number) { issue['number'] }
    let(:repo_full_name) { 'octocat/Hello-World' }
    let(:payload) { { 'issue' => issue, 'action' => action } }
    let(:access_token) { 'token' }

    describe '#call' do
      context 'when action closed' do
        let(:action) { 'closed' }

        specify do
          context = {
            payload: payload,
            repo_full_name: repo_full_name,
            access_token: access_token
          }

          expect(HandleIssuesActionClosed).to receive(:call!) do |interactor_context|
            expect(interactor_context.to_h).to eq(context)
          end

          described_class.call!(context)
        end
      end

      context 'when action labeled' do
        let(:action) { 'labeled' }

        specify do
          context = {
            payload: payload,
            repo_full_name: repo_full_name,
            access_token: access_token
          }

          expect(HandleIssuesActionLabeled).to receive(:call!) do |interactor_context|
            expect(interactor_context.to_h).to eq(context)
          end

          described_class.call!(context)
        end
      end
    end
  end
end
