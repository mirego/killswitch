Killswitch::Application.routes.draw do
  root to: 'web/home#show'
  devise_for :users, controllers: { sessions: 'web/sessions', passwords: 'web/passwords' }

  get '/ping', to: ->(_env) do
    response = { status: 'ok', version: Killswitch::Application::VERSION }
    [200, { 'Content-Type' => 'application/json' }, [response.to_json]]
  end

  namespace :web, path: '' do
    resources :users, only: [:edit, :update]

    resources :organizations, only: [:index, :new, :edit, :create, :update, :destroy] do
      resources :applications, only: [:index, :new, :edit, :create, :update, :destroy, :show] do
        resources :projects, only: [:new, :edit, :create, :update, :destroy, :show] do
          resources :behaviors, only: [:new, :edit, :create, :update, :destroy] do
            put :order, on: :collection, as: :order
          end
        end
      end

      resources :memberships
    end
  end

  namespace :api, path: 'killswitch' do
    get '', to: 'behaviors#show'
  end
end
