require 'rails_helper'

describe "GET all applications route", :type => :request do
  let!(:applications) {FactoryBot.create_list(:application, 20)}
  
  before {get '/api/v1/applications'}
  
  it 'returns all questions' do
    expect(JSON.parse(response.body).size).to eq(20)
  end

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end
end

describe "post an app route", :type => :request do 
    

    app = FactoryBot.build(:application)
      before do
        post '/api/v1/applications', params: { :app_name => app.app_name, :app_token => app.app_token }
      end
      it 'returns app name' do
        expect(JSON.parse(response.body)['app_name']).to eq(app.app_name)
      end
    
      it 'returns app token' do
      expect(JSON.parse(response.body)['app_token']).to eq(app.app_token)
      end
    
      it 'returns a created status' do
      expect(response).to have_http_status(:created)
      end

end