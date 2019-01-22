# frozen_string_literal: true

RSpec.describe 'Administrative access routing', type: :routing do
  it 'should route GET /admin to admin/page#draw' do
    expect(get('/admin')).to route_to(controller: 'admin/page', action: 'draw')
  end
end
