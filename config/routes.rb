resources :projects, only: [] do
  resources :doodles, shallow: true do
    post 'lock', on: :member
    match 'preview', on: :collection, via: [:post, :put]
    resources :doodle_answers, shallow: true, only: [:create, :update]
  end
end
