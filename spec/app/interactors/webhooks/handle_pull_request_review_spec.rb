require 'rails_helper'

module Webhooks
  RSpec.describe HandlePullRequestReview do
    let(:repo_full_name) { 'octocat/Hello-World' }
    let(:payload) { { 'review' => { 'state' => state } } }
    let(:access_token) { 'token' }

    describe '#call' do
      context 'when state is changes_requested' do
        let(:state) { 'changes_requested' }

        specify do
          context = {
            payload: payload,
            repo_full_name: repo_full_name,
            access_token: access_token
          }

          expect(HandlePullRequestReviewStateChangesRequested).to receive(:call!) do |interactor_context|
            expect(interactor_context.to_h).to eq(context)
          end

          described_class.call!(context)
        end
      end

      context 'when state is approved' do
        let(:state) { 'approved' }

        specify do
          context = {
            payload: payload,
            repo_full_name: repo_full_name,
            access_token: access_token
          }

          expect(HandlePullRequestReviewStateApproved).to receive(:call!) do |interactor_context|
            expect(interactor_context.to_h).to eq(context)
          end

          described_class.call!(context)
        end
      end
    end
  end
end
