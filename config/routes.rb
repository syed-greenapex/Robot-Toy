Rails.application.routes.draw do
  namespace :api do
    get 'orders/create'
    scope "robot/:id" do
      constraints(id: /0/) do
        post "orders", to: "orders#create"
      end
    end
  end
end
