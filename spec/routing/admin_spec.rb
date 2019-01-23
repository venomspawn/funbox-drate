# frozen_string_literal: true

RSpec.describe 'Administrative access routing', type: :routing do
  it 'should route GET /admin to admin/page#draw' do
    expect(get('/admin')).to route_to(controller: 'admin/page', action: 'draw')
  end

  it 'should route POST /admin to admin/rate#save' do
    expect(post('/admin'))
      .to route_to(controller: 'admin/rate', action: 'save')
  end
end
