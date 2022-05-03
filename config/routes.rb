Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :applications, param: :token do
        resources :chats, param: :number do
          resources :messages, param: :number do
            collection do
              get :search
            end
          end
        end
      end
    end
  end
end
