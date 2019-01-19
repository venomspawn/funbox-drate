# frozen_string_literal: true

RSpec.describe 'Default access routing', type: :routing do
  it 'should route GET / to default/page#draw' do
    expect(get('/')).to route_to(controller: 'default/page', action: 'draw')
  end
end
