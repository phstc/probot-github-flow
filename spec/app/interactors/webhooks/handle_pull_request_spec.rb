require 'rails_helper'

module Webhooks
  RSpec.describe HandlePullRequest do
    let(:repo_full_name) { 'octocat/Hello-World' }
    let(:payload) { { 'action' => action } }
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

          expect(HandlePullRequestActionClosed).to receive(:call!) do |interactor_context|
            expect(interactor_context.to_h).to eq(context)
          end

          described_class.call!(context)
        end
      end

      context 'when action review_requested' do
        let(:action) { 'review_requested' }

        specify do
          context = {
            payload: payload,
            repo_full_name: repo_full_name,
            access_token: access_token
          }

          expect(HandlePullRequestActionReviewRequested).to receive(:call!) do |interactor_context|
            expect(interactor_context.to_h).to eq(context)
          end

          described_class.call!(context)
        end
      end
    end
  end
end
