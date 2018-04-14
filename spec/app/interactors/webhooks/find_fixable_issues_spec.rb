require 'spec_helper'

module Webhooks
  RSpec.describe FindFixableIssues do
    describe '#call' do
      specify do
        expect(described_class.call!(body: 'Fixes #123').ids).to eq(['123'])

        expect(described_class.call!(
          body: 'Fixes #123, Closes #1231, Resolve #1232'
        ).ids).to eq(%w[123 1231 1232])

        expect(described_class.call!(
          body: 'Fixes #123, Closes #123, Resolve #123'
        ).ids).to eq(['123'])
      end
    end
  end
end
