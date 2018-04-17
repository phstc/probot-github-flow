require 'rails_helper'

RSpec.describe AddLabelsToAnIssue do
  let(:number) { 'number' }
  let(:repo_full_name) { 'octocat/Hello-World' }
  let(:access_token) { 'token' }
  let(:client) { double 'Octokit' }
  let(:label) { Constants::IN_PROGRESS }

  before do
    allow_any_instance_of(described_class).to receive(:client).and_return(client)
  end

  describe '#call' do
    specify do
      expect(client).to receive(:add_labels_to_an_issue).with(repo_full_name, number, [label])

      described_class.call!(
        number: number,
        repo_full_name: repo_full_name,
        access_token: access_token,
        labels: [label]
      )
    end
  end
end
